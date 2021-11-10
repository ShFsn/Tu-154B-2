#
# Help & advise subsystem for TU-154B
# Yurik V. Nikiforoff, yurik.nsk@gmail.com
# Novosibirsk, Russia
# dec 2007
#
# Modded by ShFsn, oct 2021
#

var help_win = screen.window.new( 0, 0, 1, 5 );
help_win.fg = [0,1,1,1];

var tks = func {
   var gpk_1 = getprop("fdm/jsbsim/instrumentation/ga3-corrected-1");
   var gpk_2 = getprop("fdm/jsbsim/instrumentation/ga3-corrected-2");
   var bgmk_1 = getprop("fdm/jsbsim/instrumentation/bgmk-1");
   var bgmk_2 = getprop("fdm/jsbsim/instrumentation/bgmk-2");
   if( gpk_1 == nil ) gpk_1 = 0.0;
   if( gpk_2 == nil ) gpk_2 = 0.0;
   if( bgmk_1 == nil ) bgmk_1 = 0.0;
   if( bgmk_2 == nil ) bgmk_2 = 0.0;

help_win.write(sprintf("GA-3-1: %.2f GA-3-2: %.2f BGMK-2-1: %.2f BGMK-2-2: %.2f", 
gpk_1, gpk_2, bgmk_1,  bgmk_2 ) );

}

var at = func {
   var at_speed = getprop("tu154/instrumentation/pn-6/at-kt");
   if( at_speed == nil ) at_speed = 0.0;
help_win.write(sprintf("Autothrottle speed: %.2f kmh", at_speed*1.852) );
}

var km = func {
   var km_deg_1 = getprop("fdm/jsbsim/instrumentation/km-5-magvar-1");
   if(  km_deg_1 == nil ) km_deg_1 = 0.0;
   var km_deg_2 = getprop("fdm/jsbsim/instrumentation/km-5-magvar-2");
   if(  km_deg_2 == nil ) km_deg_2 = 0.0;
   var magvar = getprop("environment/magnetic-variation-deg");
   if(  magvar == nil ) magvar = 0.0;
   
help_win.write(sprintf("Offset KM-5-1: %.2f deg,  KM-5-2: %.2f deg, magnetic variation %.2f deg", km_deg_1, km_deg_2, magvar ) );
}

var rsbn = func {
   var rsbn_freq = getprop("instrumentation/nav[2]/frequencies/selected-mhz");
   if(  rsbn_freq == nil ) rsbn_freq = 108.0;
help_win.write(sprintf("RSBN frequency: %.3f MHz", rsbn_freq) );
}

var advise = func {
   var v2 = getprop("fdm/jsbsim/instrumentation/v-r");
   var vr = getprop("fdm/jsbsim/instrumentation/v-ref");
   var mass = getprop("fdm/jsbsim/instrumentation/mass-kg");
   var cg = getprop("fdm/jsbsim/inertia/cg-x-in");
   if( v2 == nil ) v2 = 0.0;
   if( vr == nil ) vr = 0.0;
   if( mass == nil ) mass = 0.0;
   if( cg == nil ) cg = 0.0;
   
   cg = (cg * 0.0254 - 24.04) * (100/5.285);
   
help_win.write(sprintf("mass: %.0f kg CG: %.1f%% MAC Vrotate: %.0f kmh Vref: %.0f kmh", mass, cg, v2, vr) );

}

var messenger = func{
help_win.write(arg[0]);
}

# Sound volume helpers

var nav_0_vol = func{
  #help_win.write( sprintf( "NAV radio Kurs-MP #1 sound: %d%%", getprop("instrumentation/nav[0]/volume")*100 ) );
  help_win.write( sprintf( "NAV radio Kurs-MP #1 sound: %d%%", getprop("/tu154/instrumentation/nav[0]/volume")*100 ) );
}

var nav_1_vol = func{
  #help_win.write( sprintf( "NAV radio Kurs-MP #2 sound: %d%%", getprop("instrumentation/nav[1]/volume")*100 ) );
  help_win.write( sprintf( "NAV radio Kurs-MP #2 sound: %d%%", getprop("/tu154/instrumentation/nav[1]/volume")*100 ) );
}

var rsbn_vol = func{
  #help_win.write( sprintf( "RSBN sound: %d%%", getprop("instrumentation/nav[2]/volume")*100 ) );
  help_win.write( sprintf( "RSBN sound: %d%%", getprop("/tu154/instrumentation/rsbn/volume")*100 ) );
}

var adf_0_vol = func{
  #help_win.write( sprintf( "ADF ARK-15 #1 sound: %d%%", getprop("instrumentation/adf[0]/volume")*100 ) );
  help_win.write( sprintf( "ADF ARK-15 #1 sound: %d%%", getprop("/tu154/instrumentation/ark-15[0]/volume")*100 ) );
}

var adf_1_vol = func{
  #help_win.write( sprintf( "ADF ARK-15 #2 sound: %d%%", getprop("instrumentation/adf[1]/volume")*100 ) );
  help_win.write( sprintf( "ADF ARK-15 #2 sound: %d%%", getprop("/tu154/instrumentation/ark-15[1]/volume")*100 ) );
}

#setlistener( "instrumentation/nav[0]/volume", nav_0_vol, 0, 0 );
#setlistener( "instrumentation/nav[1]/volume", nav_1_vol, 0, 0 );
#setlistener( "instrumentation/nav[2]/volume", rsbn_vol, 0, 0 );
#setlistener( "instrumentation/adf[0]/volume", adf_0_vol, 0, 0 );
#setlistener( "instrumentation/adf[1]/volume", adf_1_vol, 0, 0 );
setlistener( "/tu154/instrumentation/nav[0]/volume", nav_0_vol, 0, 0 );
setlistener( "/tu154/instrumentation/nav[1]/volume", nav_1_vol, 0, 0 );
setlistener( "/tu154/instrumentation/rsbn/volume", rsbn_vol, 0, 0 );
setlistener( "/tu154/instrumentation/ark-15[0]/volume", adf_0_vol, 0, 0 );
setlistener( "/tu154/instrumentation/ark-15[1]/volume", adf_1_vol, 0, 0 );


print("Help subsystem started");


# Refueling
refuel = func{
      if (getprop("/fdm/jsbsim/fuel/sw-refuel") == 1 and getprop("/tu154/systems/electrical/buses/DC27-bus-L/volts") > 0 and getprop("/sim/model/ground-services/f-connect-r") == 1 and getprop("/sim/model/ground-services/chocks") == 1) {
            q_123 = getprop("/fdm/jsbsim/fuel/sel-refuel-123");
            q_4 = getprop("/fdm/jsbsim/fuel/sel-refuel-4");
            s_1 = getprop("/fdm/jsbsim/fuel/sw-refuel-1");
            s_2L = getprop("/fdm/jsbsim/fuel/sw-refuel-2L");
            s_2R = getprop("/fdm/jsbsim/fuel/sw-refuel-2R");
            s_3L = getprop("/fdm/jsbsim/fuel/sw-refuel-3L");
            s_3R = getprop("/fdm/jsbsim/fuel/sw-refuel-3R");
            s_4 = getprop("/fdm/jsbsim/fuel/sw-refuel-4");

            if (q_123 == 0) { q_123 = 15000; }
            if (q_123 == 1) { q_123 = 20000; }
            if (q_123 == 2) { q_123 = 25000; }
            if (q_123 == 3) { q_123 = 33150; }
            q__123 = q_123;
            if (q_4 == 0) { q_4 = 2000; }
            if (q_4 == 1) { q_4 = 4000; }
            if (q_4 == 2) { q_4 = 6600; }

            var t_1 = 0;
            var t_2L = 0;
            var t_2R = 0;
            var t_3L = 0;
            var t_3R = 0;
            var t_4 = q_4;

            # Requested amount for tank 1
            if (s_1 == 1 and q_123 > 3300) {
                  t_1 = 3300;
                  q_123 = q_123 - 3300;
            } else if (s_1 == 1) {
                  t_1 = q_123;
                  q_123 = 0;
            }

            # Requested amount for tanks 3
            if (s_3L == 1 and s_3R == 1) {     
                  if (q_123 > 10850) {
                        t_3L = 5425;
                        t_3R = 5425;
                        q_123 = q_123 - 10850;
                  } else {
                        t_3L = q_123 / 2;
                        t_3R = q_123 / 2;
                        q_123 = 0;
                  }
            } else if (s_3L == 1) {
                  if (q_123 > 5425) {
                        t_3L = 5425;
                        q_123 = q_123 - 5425;
                  } else {
                        t_3L = q_123;
                        q_123 = 0;
                  }
            } else if (s_3R == 1) {
                  if (q_123 > 5425) {
                        t_3R = 5425;
                        q_123 = q_123 - 5425;
                  } else {
                        t_3R = q_123;
                        q_123 = 0;
                  }
            }

            # Requested amount for tanks 2
            if (s_2L == 1 and s_2R == 1) {     
                  if (q_123 > 19000) {
                        t_2L = 9500;
                        t_2R = 9500;
                        q_123 = q_123 - 19000;
                  } else {
                        t_2L = q_123 / 2;
                        t_2R = q_123 / 2;
                        q_123 = 0;
                  }
            } else if (s_2L == 1) {
                  if (q_123 > 9500) {
                        t_2L = 9500;
                        q_123 = q_123 - 9500;
                  } else {
                        t_2L = q_123;
                        q_123 = 0;
                  }
            } else if (s_2R == 1) {
                  if (q_123 > 9500) {
                        t_2R = 9500;
                        q_123 = q_123 - 9500;
                  } else {
                        t_2R = q_123;
                        q_123 = 0;
                  }
            }

            var time = 60;
            if (s_1 == 0) { t_1 = -1; }
            if (s_2L == 0) { t_2L = -1; }
            if (s_2R == 0) { t_2R = -1; }
            if (s_3L == 0) { t_3L = -1; }
            if (s_3R == 0) { t_3R = -1; }
            if (s_4 == 0) { t_4 = -1; }

            help_win.write(sprintf("Refueling started. Main tanks %.0f kg; 1: %.0f kg; 2L: %.0f kg; 2R: %.0f kg; 3L: %.0f kg; 3R: %.0f kg. Ballast tank (4): %.0f kg. (-1 means not enabled.) Estimated time: %.2f min", q__123, t_1, t_2L, t_2R,  t_3L, t_3R, t_4, time / 60));
            settimer (func(){ help_win.write(sprintf("Refueling started. Main tanks %.0f kg; 1: %.0f kg; 2L: %.0f kg; 2R: %.0f kg; 3L: %.0f kg; 3R: %.0f kg. Ballast tank (4): %.0f kg. (-1 means not enabled.) Estimated time: %.2f min", q__123, t_1, t_2L, t_2R,  t_3L, t_3R, t_4, time / 60)); }, 5);
            settimer (func(){ help_win.write(sprintf("Refueling started. Main tanks %.0f kg; 1: %.0f kg; 2L: %.0f kg; 2R: %.0f kg; 3L: %.0f kg; 3R: %.0f kg. Ballast tank (4): %.0f kg. (-1 means not enabled.) Estimated time: %.2f min", q__123, t_1, t_2L, t_2R,  t_3L, t_3R, t_4, time / 60)); }, 10);
            settimer (func(){ help_win.write(sprintf("Refueling started. Main tanks %.0f kg; 1: %.0f kg; 2L: %.0f kg; 2R: %.0f kg; 3L: %.0f kg; 3R: %.0f kg. Ballast tank (4): %.0f kg. (-1 means not enabled.) Estimated time: %.2f min", q__123, t_1, t_2L, t_2R,  t_3L, t_3R, t_4, time / 60)); }, 15);
            settimer (func(){ help_win.write(sprintf("Refueling finised.")); }, time);
            settimer (func(){ help_win.write(sprintf("Refueling finised.")); }, time + 5);
      }
}
setlistener("/fdm/jsbsim/fuel/sw-refuel", refuel);

