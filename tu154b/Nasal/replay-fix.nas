var time = getprop("/sim/replay/time");
time = 0; 
var alt = getprop("/position/altitude-ft");
var lat = getprop("/position/latitude-deg");
var lon = getprop("/position/longitude-deg");
var vdown = getprop("/velocities/speed-down-fps");
var veast = getprop("/velocities/speed-east-fps");
var vnorth = getprop("/velocities/speed-north-fps");
var hdg = getprop("/orientation/heading-deg");
var pitch = getprop("/orientation/pitch-deg");
var roll = getprop("/orientation/roll-deg");
var yr = getprop("/orientation/yaw-rate-degps");
var pr = getprop("/orientation/pitch-rate-degps");
var rr = getprop("/orientation/roll-rate-degps");
var flag = 0;

replay_fix = func{

      if( getprop("/sim/replay/time") == 0 and time != 0 and getprop("sim/model/replay-fix/save_state") == 1 ) {
            flag = 1;
            setprop("/position/altitude-ft", alt + 5);
            setprop("/position/latitude-deg", lat);
            setprop("/position/longitude-deg", lon);
            setprop("/velocities/speed-down-fps", vdown);
            setprop("/velocities/speed-east-fps", veast);
            setprop("/velocities/speed-north-fps", vnorth);
            setprop("/orientation/heading-deg", hdg);
            setprop("/orientation/pitch-deg", pitch);
            setprop("/orientation/roll-deg", roll);
            setprop("orientation/yaw-rate-degps", yr);
            setprop("orientation/pitch-rate-degps", pr);
            setprop("orientation/roll-rate-degps", rr);
            settimer(func(){
            setprop("/position/latitude-deg", lat);
            setprop("/position/longitude-deg", lon);
            setprop("/velocities/speed-down-fps", vdown);
            setprop("/velocities/speed-east-fps", veast);
            setprop("/velocities/speed-north-fps", vnorth);
            setprop("/orientation/heading-deg", hdg);
            setprop("/orientation/pitch-deg", pitch);
            setprop("/orientation/roll-deg", roll);
            setprop("orientation/yaw-rate-degps", yr);
            setprop("orientation/pitch-rate-degps", pr);
            setprop("orientation/roll-rate-degps", rr);
            }, 0.2);
            settimer(func(){
            setprop("/position/latitude-deg", lat);
            setprop("/position/longitude-deg", lon);
            setprop("/velocities/speed-down-fps", vdown);
            setprop("/velocities/speed-east-fps", veast);
            setprop("/velocities/speed-north-fps", vnorth);
            setprop("/orientation/heading-deg", hdg);
            setprop("/orientation/pitch-deg", pitch);
            setprop("/orientation/roll-deg", roll);
            setprop("orientation/yaw-rate-degps", yr);
            setprop("orientation/pitch-rate-degps", pr);
            setprop("orientation/roll-rate-degps", rr);
            }, 0.4);
            settimer(func(){
            setprop("/position/latitude-deg", lat);
            setprop("/position/longitude-deg", lon);
            setprop("/velocities/speed-down-fps", vdown);
            setprop("/velocities/speed-east-fps", veast);
            setprop("/velocities/speed-north-fps", vnorth);
            setprop("/orientation/heading-deg", hdg);
            setprop("/orientation/pitch-deg", pitch);
            setprop("/orientation/roll-deg", roll);
            setprop("orientation/yaw-rate-degps", yr);
            setprop("orientation/pitch-rate-degps", pr);
            setprop("orientation/roll-rate-degps", rr);
            }, 0.6);
            settimer(func(){
            setprop("/position/latitude-deg", lat);
            setprop("/position/longitude-deg", lon);
            setprop("/velocities/speed-down-fps", vdown);
            setprop("/velocities/speed-east-fps", veast);
            setprop("/velocities/speed-north-fps", vnorth);
            setprop("/orientation/heading-deg", hdg);
            setprop("/orientation/pitch-deg", pitch);
            setprop("/orientation/roll-deg", roll);
            setprop("orientation/yaw-rate-degps", yr);
            setprop("orientation/pitch-rate-degps", pr);
            setprop("orientation/roll-rate-degps", rr);
            }, 0.8);
            settimer(func(){
            setprop("/position/latitude-deg", lat);
            setprop("/position/longitude-deg", lon);
            setprop("/velocities/speed-down-fps", vdown);
            setprop("/velocities/speed-east-fps", veast);
            setprop("/velocities/speed-north-fps", vnorth);
            setprop("/orientation/heading-deg", hdg);
            setprop("/orientation/pitch-deg", pitch);
            setprop("/orientation/roll-deg", roll);
            setprop("orientation/yaw-rate-degps", yr);
            setprop("orientation/pitch-rate-degps", pr);
            setprop("orientation/roll-rate-degps", rr);
            flag = 0;
            }, 1.0);
      }
      if( getprop("/sim/replay/time") == 0 and time == 0 and flag == 0 ) {
            alt = getprop("/position/altitude-ft");
            lat = getprop("/position/latitude-deg");
            lon = getprop("/position/longitude-deg");
            vdown = getprop("/velocities/speed-down-fps");
            veast = getprop("/velocities/speed-east-fps");
            vnorth = getprop("/velocities/speed-north-fps");
            hdg = getprop("/orientation/heading-deg");
            pitch = getprop("/orientation/pitch-deg");
            roll = getprop("/orientation/roll-deg");
            yr = getprop("/orientation/yaw-rate-degps");
            pr = getprop("/orientation/pitch-rate-degps");
            rr = getprop("/orientation/roll-rate-degps");
      }

      time = getprop("/sim/replay/time");
      settimer(replay_fix, 0.001);
} replay_fix();