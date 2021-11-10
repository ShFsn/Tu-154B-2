############################################
#
# Air conditioning system for Tu-154B-2
# by ShFsn
# oct 2021
#
############################################

######################################### Indicators work ##########################################

var indicators_func = func {
	settimer (indicators_func, 1);

	var power = getprop("tu154/systems/electrical/buses/DC27-bus-L/volts");
	#var scale = 1;

	# Cabin Vertical Speed
	var goal = getprop("/tu154/air-cond/variables/vs");
	interpolate("/tu154/air-cond/prib/delta-alt", goal, 1);

	# Delta pressure
	goal = getprop("/tu154/air-cond/variables/d-p");
	if (power == 0) goal = 0;
	interpolate("/tu154/air-cond/prib/d-p", goal, 1);

	# Cabin height
	goal = getprop("/tu154/air-cond/variables/alt-m");
	if (power == 0) goal = 0;
	interpolate("/tu154/air-cond/prib/alt-m", goal, 1);

	# Cabin temperature
	goal = getprop("/tu154/air-cond/variables/t-cab");
	if (power == 0) goal = 0;
	interpolate("/tu154/air-cond/prib/t-cab", goal, 1);

	# Passenger cabin temperature
	var state = getprop("tu154/air-cond/sw/sw-sal-12");
	if (state == 1) { goal = getprop("tu154/air-cond/variables/t-sal-1"); }
	else if (state == 0) { goal = getprop("tu154/air-cond/variables/t-sal-2"); }
	if (power == 0) goal = 0;
	interpolate("/tu154/air-cond/prib/t-sal", goal, 1);

	# Air pipeline temperature
	state = getprop("tu154/air-cond/sel/sel-trub");
	if (state == 0) { goal = getprop("tu154/air-cond/variables/tt-dver"); }
	else if (state == 1) { goal = getprop("tu154/air-cond/variables/tt-ekip"); }
	else if (state == 2) { goal = getprop("tu154/air-cond/variables/tt-sal-1"); }
	else if (state == 3) { goal = getprop("tu154/air-cond/variables/tt-sal-2"); }
	else if (state == 4) { goal = getprop("tu154/air-cond/variables/tt-mag-left"); }
	else if (state == 5) { goal = getprop("tu154/air-cond/variables/tt-mag-right"); }
	if (power == 0) goal = 0;
	interpolate("/tu154/air-cond/prib/t-trub", goal, 1);

	# Air consumption
	goal = getprop("tu154/air-cond/variables/air-cons-l");
	if (power == 0) goal = 0;
	interpolate("/tu154/air-cond/prib/p-left", goal, 1);
	goal = getprop("tu154/air-cond/variables/air-cons-r");
	if (power == 0) goal = 0;
	interpolate("/tu154/air-cond/prib/p-right", goal, 1);

}
indicators_func();


######################################## Air Consumption #########################################
var air_cons = func {
	settimer(air_cons, 0.1);

	var maint = 0;

	# By APU
	if (getprop("/engines/engine[3]/running") == 1 and getprop("/tu154/systems/APU/APU-bleed") == 5 and getprop("/tu154/switches/startpanel-start") != 1) { maint = 1; }

	# By engines
	if (getprop("/engines/engine[0]/running") == 1 and getprop("/tu154/air-cond/sw/sw-eng-1") == 1 and getprop("/engines/engine[1]/running") == 1 and getprop("/tu154/air-cond/sw/sw-eng-2") == 1) { maint = 1; }
	if (getprop("/engines/engine[1]/running") == 1 and getprop("/tu154/air-cond/sw/sw-eng-2") == 1 and getprop("/engines/engine[2]/running") == 1 and getprop("/tu154/air-cond/sw/sw-eng-3") == 1) { maint = 1; }
	if (getprop("/engines/engine[0]/running") == 1 and getprop("/tu154/air-cond/sw/sw-eng-1") == 1 and getprop("/engines/engine[2]/running") == 1 and getprop("/tu154/air-cond/sw/sw-eng-3") == 1) { maint = 1; }

	# "NADDUV" Switch
	if (getprop("tu154/air-cond/sw/sw-nadduv") == -1) { maint = 0; }
	if (getprop("tu154/air-cond/sw/sw-sbros") == 1) { maint = 0; }
	if (getprop("tu154/air-cond/sw/sw-psvp-l") == 0) { maint = 0; }
	if (maint == 1 and getprop("tu154/air-cond/sw/sw-nadduv") == 1 and getprop("tu154/air-cond/variables/air-cons-l") < 5.46) { setprop ("tu154/air-cond/variables/air-cons-l", getprop("tu154/air-cond/variables/air-cons-l") + 0.05); }
	if (maint == 0) { interpolate ("tu154/air-cond/variables/air-cons-l", 0, 1); }

	# By APU
	if (getprop("/engines/engine[3]/running") == 1 and getprop("/tu154/systems/APU/APU-bleed") == 5 and getprop("/tu154/switches/startpanel-start") != 1) { maint = 1; }

	# By engines
	if (getprop("/engines/engine[0]/running") == 1 and getprop("/tu154/air-cond/sw/sw-eng-1") == 1 and getprop("/engines/engine[1]/running") == 1 and getprop("/tu154/air-cond/sw/sw-eng-2") == 1) { maint = 1; }
	if (getprop("/engines/engine[1]/running") == 1 and getprop("/tu154/air-cond/sw/sw-eng-2") == 1 and getprop("/engines/engine[2]/running") == 1 and getprop("/tu154/air-cond/sw/sw-eng-3") == 1) { maint = 1; }
	if (getprop("/engines/engine[0]/running") == 1 and getprop("/tu154/air-cond/sw/sw-eng-1") == 1 and getprop("/engines/engine[2]/running") == 1 and getprop("/tu154/air-cond/sw/sw-eng-3") == 1) { maint = 1; }

	# "NADDUV" Switch
	if (getprop("tu154/air-cond/sw/sw-nadduv") == -1) { maint = 0; }
	if (getprop("tu154/air-cond/sw/sw-sbros") == 1) { maint = 0; }
	if (getprop("tu154/air-cond/sw/sw-psvp-r") == 0) { maint = 0; }
	if (maint == 1 and getprop("tu154/air-cond/sw/sw-nadduv") == 1 and getprop("tu154/air-cond/variables/air-cons-r") < 5.46) { setprop ("tu154/air-cond/variables/air-cons-r", getprop("tu154/air-cond/variables/air-cons-r") + 0.05); }
	if (maint == 0) { interpolate ("tu154/air-cond/variables/air-cons-r", 0, 1); }

}
air_cons();


########################################### Cabin pressure #############################################
var cab_press = func {
	settimer (cab_press, 0.1);

	# Aerodrome pressure. Need to be set separately, BUT...
	var zero = getprop("/tu154/instrumentation/altimeter[0]/mmhg");

	var outside = getprop("/environment/pressure-inhg") / 29.92 * 760;
	var goal = outside + 460;
	if (goal > zero) { goal = zero; }

	var cabin = zero - getprop("/tu154/air-cond/variables/alt-m") / 2000 * 160;
	var max_dh = ((getprop("/tu154/air-cond/variables/air-cons-l") + getprop("/tu154/air-cond/variables/air-cons-r")) / 2 - 2) / 3000 * 160;
	if (getprop("/tu154/door/passe") > 0 or getprop("/tu154/door/window-left") > 0 or getprop("/tu154/door/window-right") > 0) { 
		if (outside < cabin) { max_dh = -8; }
		if (outside > cabin) { max_dh = 8; }
		goal = outside;
	}

	if ((goal - cabin) < max_dh and max_dh > 0) { cabin = goal; }
	else if ((outside - cabin) > max_dh and max_dh < 0 ) { cabin = outside; }
	else { cabin = cabin + max_dh; }

	setprop("/tu154/air-cond/variables/vs", ((zero - cabin) / 160 * 2000 - getprop("/tu154/air-cond/variables/alt-m")) * 10);
	setprop("/tu154/air-cond/variables/d-p", (cabin - outside) / 760);
	setprop("/tu154/air-cond/variables/alt-m", (zero - cabin) / 160 * 2000);
}
cab_press();


############################################# Temperatures ################################################
var goal_cab = getprop("/tu154/air-cond/variables/t-cab");
var goal_sal_1 = getprop("/tu154/air-cond/variables/t-sal-1");
var goal_sal_2 = getprop("/tu154/air-cond/variables/t-sal-2");
var goal_th_left = getprop("/tu154/air-cond/variables/tt-mag-left") / 2;
var goal_vvr_left = getprop("/tu154/air-cond/variables/tt-mag-left") / 2;
var goal_th_right = getprop("/tu154/air-cond/variables/tt-mag-right") / 2;
var goal_vvr_right = getprop("/tu154/air-cond/variables/tt-mag-right") / 2;
settimer(func {
	var outside = getprop("/environment/temperature-degc");
	setprop("/tu154/air-cond/variables/t-cab", outside);
	setprop("/tu154/air-cond/variables/t-sal-1", outside);
	setprop("/tu154/air-cond/variables/t-sal-2", outside);
	setprop("/tu154/air-cond/variables/tt-dver", outside);
	setprop("/tu154/air-cond/variables/tt-ekip", outside);
	setprop("/tu154/air-cond/variables/tt-sal-1", outside);
	setprop("/tu154/air-cond/variables/tt-sal-2", outside);
	setprop("/tu154/air-cond/variables/tt-mag-left", outside);
	setprop("/tu154/air-cond/variables/tt-mag-right", outside);
	goal_cab = outside;
	goal_sal_1 = outside;
	goal_sal_2 = outside;
	goal_th_left = outside / 2;
	goal_vvr_left = outside / 2;
	goal_th_right = outside / 2;
	goal_vvr_right = outside / 2;
}, 5);

var temps = func {
	settimer (temps, 0.1);

	var outside = getprop("/environment/temperature-degc");


	if (getprop("/tu154/air-cond/swt/swt-cabin-aut") == 1) { goal_cab = getprop("/tu154/air-cond/sel/sel-cabin") * 2 - 10; }
	if (getprop("/tu154/air-cond/swt/swt-sal-1-aut") == 1) { goal_sal_1 = getprop("/tu154/air-cond/sel/sel-sal-1") * 2 - 10; }
	if (getprop("/tu154/air-cond/swt/swt-sal-2-aut") == 1) { goal_sal_2 = getprop("/tu154/air-cond/sel/sel-sal-2") * 2 - 10; }
	if (getprop("/tu154/air-cond/swt/swt-th-left-aut") == 1) { goal_th_left = (getprop("/tu154/air-cond/sel/sel-mag-left") * 2 - 10) / 2; }
	if (getprop("/tu154/air-cond/swt/swt-vvr-left-aut") == 1) { goal_vvr_left = (getprop("/tu154/air-cond/sel/sel-mag-left") * 2 - 10) / 2; }
	if (getprop("/tu154/air-cond/swt/swt-th-right-aut") == 1) { goal_th_right = (getprop("/tu154/air-cond/sel/sel-mag-right") * 2 - 10) / 2; }
	if (getprop("/tu154/air-cond/swt/swt-vvr-right-aut") == 1) { goal_vvr_right = (getprop("/tu154/air-cond/sel/sel-mag-right") * 2 - 10) / 2; }

	if (getprop("/tu154/air-cond/swt/swt-cabin-aut") == 0) { goal_cab = getprop("/tu154/air-cond/variables/t-cab"); }
	if (getprop("/tu154/air-cond/swt/swt-sal-1-aut") == 0) { goal_sal_1 = getprop("/tu154/air-cond/variables/t-sal-1"); }
	if (getprop("/tu154/air-cond/swt/swt-sal-2-aut") == 0) { goal_sal_2 = getprop("/tu154/air-cond/variables/t-sal-2"); }

	if (getprop("/tu154/air-cond/swt/swt-cabin-hol") == 1) { goal_cab = goal_cab - 0.01; }
	if (getprop("/tu154/air-cond/swt/swt-sal-1-hol") == 1) { goal_sal_1 = goal_sal_1 - 0.01; }
	if (getprop("/tu154/air-cond/swt/swt-sal-2-hol") == 1) { goal_sal_2 = goal_sal_2 - 0.01; }
	if (getprop("/tu154/air-cond/swt/swt-th-left-hol") == 1) { goal_th_left = goal_th_left - 0.05; }
	if (getprop("/tu154/air-cond/swt/swt-vvr-left-hol") == 1) { goal_vvr_left = goal_vvr_left - 0.05; }
	if (getprop("/tu154/air-cond/swt/swt-th-right-hol") == 1) { goal_th_right = goal_th_right - 0.05; }
	if (getprop("/tu154/air-cond/swt/swt-vvr-right-hol") == 1) { goal_vvr_right = goal_vvr_right - 0.05; }

	if (getprop("/tu154/air-cond/swt/swt-cabin-gor") == 1) { goal_cab = goal_cab + 0.01; }
	if (getprop("/tu154/air-cond/swt/swt-sal-1-gor") == 1) { goal_sal_1 = goal_sal_1 + 0.01; }
	if (getprop("/tu154/air-cond/swt/swt-sal-2-gor") == 1) { goal_sal_2 = goal_sal_2 + 0.01; }
	if (getprop("/tu154/air-cond/swt/swt-th-left-gor") == 1) { goal_th_left = goal_th_left + 0.05; }
	if (getprop("/tu154/air-cond/swt/swt-vvr-left-gor") == 1) { goal_vvr_left = goal_vvr_left + 0.05; }
	if (getprop("/tu154/air-cond/swt/swt-th-right-gor") == 1) { goal_th_right = goal_th_right + 0.05; }
	if (getprop("/tu154/air-cond/swt/swt-vvr-right-gor") == 1) { goal_vvr_right = goal_vvr_right + 0.05; }


	var curr_cab = (getprop("/tu154/air-cond/variables/t-cab") + 0.01 * (outside - getprop("/tu154/air-cond/variables/t-cab")) / 80);
	var curr_sal_1 = (getprop("/tu154/air-cond/variables/t-sal-1") + 0.01 * (outside - getprop("/tu154/air-cond/variables/t-sal-1")) / 80);
	var curr_sal_2 = (getprop("/tu154/air-cond/variables/t-sal-2") + 0.01 * (outside - getprop("/tu154/air-cond/variables/t-sal-2")) / 80);
	var curr_th_left = (getprop("/tu154/air-cond/variables/tt-mag-left") + 0.01 * (outside - getprop("/tu154/air-cond/variables/tt-mag-left")) / 80) / 2;
	var curr_vvr_left = (getprop("/tu154/air-cond/variables/tt-mag-left") + 0.01 * (outside - getprop("/tu154/air-cond/variables/tt-mag-left")) / 80) / 2;
	var curr_th_right = (getprop("/tu154/air-cond/variables/tt-mag-right") + 0.01 * (outside - getprop("/tu154/air-cond/variables/tt-mag-right")) / 80) / 2;
	var curr_vvr_right = (getprop("/tu154/air-cond/variables/tt-mag-right") + 0.01 * (outside - getprop("/tu154/air-cond/variables/tt-mag-right")) / 80) / 2;

	if (getprop("tu154/air-cond/variables/air-cons-l") > 1) { setprop("/tu154/air-cond/variables/tt-mag-left", goal_th_left + goal_vvr_left); }
	else { setprop("/tu154/air-cond/variables/tt-mag-left", curr_th_left + curr_vvr_left); }
	if (getprop("tu154/air-cond/variables/air-cons-r") > 1) { setprop("/tu154/air-cond/variables/tt-mag-right", goal_th_right + goal_vvr_right); }
	else { setprop("/tu154/air-cond/variables/tt-mag-right", curr_th_right + curr_vvr_right); }

	if (getprop("tu154/air-cond/variables/air-cons-l") > 1 and getprop("tu154/air-cond/variables/air-cons-r") > 1) {
		if (abs(goal_cab - curr_cab) < 0.02) { curr_cab = goal_cab; }
		else { curr_cab = curr_cab + 0.02 * (goal_cab - curr_cab) / abs(goal_cab - curr_cab); }
		if (abs(goal_sal_1 - curr_sal_1) < 0.02) { curr_sal_1 = goal_sal_1; }
		else { curr_sal_1 = curr_sal_1 + 0.02 * (goal_sal_1 - curr_sal_1) / abs(goal_sal_1 - curr_sal_1); }
		if (abs(goal_sal_2 - curr_sal_2) < 0.02) { curr_sal_2 = goal_sal_2; }
		else { curr_sal_2 = curr_sal_2 + 0.02 * (goal_sal_2 - curr_sal_2) / abs(goal_sal_2 - curr_sal_2); }
	}
	else if (getprop("tu154/air-cond/variables/air-cons-l") > 1 or getprop("tu154/air-cond/variables/air-cons-r") > 1) {
		if (abs(goal_cab - curr_cab) < 0.015) { curr_cab = goal_cab; }
		else { curr_cab = curr_cab + 0.015 * (goal_cab - curr_cab) / abs(goal_cab - curr_cab); }
		if (abs(goal_sal_1 - curr_sal_1) < 0.015) { curr_sal_1 = goal_sal_1; }
		else { curr_sal_1 = curr_sal_1 + 0.015 * (goal_sal_1 - curr_sal_1) / abs(goal_sal_1 - curr_sal_1); }
		if (abs(goal_sal_2 - curr_sal_2) < 0.015) { curr_sal_2 = goal_sal_2; }
		else { curr_sal_2 = curr_sal_2 + 0.015 * (goal_sal_2 - curr_sal_2) / abs(goal_sal_2 - curr_sal_2); }
	}
	setprop("/tu154/air-cond/variables/t-cab", curr_cab);
	setprop("/tu154/air-cond/variables/t-sal-1", curr_sal_1);
	setprop("/tu154/air-cond/variables/t-sal-2", curr_sal_2);
	setprop("/tu154/air-cond/variables/tt-dver", (curr_th_left + curr_vvr_left + curr_th_right + curr_vvr_right) / 2);
	setprop("/tu154/air-cond/variables/tt-ekip", goal_cab);
	setprop("/tu154/air-cond/variables/tt-sal-1", goal_sal_1);
	setprop("/tu154/air-cond/variables/tt-sal-2", goal_sal_2);

}
temps();