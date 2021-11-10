################################################## External lights ###################################################
# provides relative vectors from eye-point to aircraft lights
# in east/north/up coordinates the renderer uses
# Thanks to BAWV12 / Thorsten


var als_on = props.globals.getNode("/sim/rendering/shaders/skydome");
var alt_agl = props.globals.getNode("position/gear-agl-ft");
var cur_alt = 0;

var light_manager = {

      run: 1,
      
      lat_to_m: 110952.0,
      lon_to_m: 0.0,

      light1_xpos: 0.0,
      light1_ypos: 0.0,
      light1_zpos: 0.0,
      light1_r: 0.0,
      light1_g: 0.0,
      light1_b: 0.0,
      light1_size: 0.0,
      light1_stretch: 0.0,
      light1_is_on: 0,

      light2_xpos: 0.0,
      light2_ypos: 0.0,
      light2_zpos: 0.0,
      light2_r: 0.0,
      light2_g: 0.0,
      light2_b: 0.0,
      light2_size: 0.0,
      light2_stretch: 0.0,
      light2_is_on: 0,
      
      light3_xpos: 0.0,
      light3_ypos: 0.0,
      light3_zpos: 0.0,
      light3_r: 0.0,
      light3_g: 0.0,
      light3_b: 0.0,
      light3_size: 0.0,
      light3_stretch: 0.0,
      light3_is_on: 0,
      
      light4_xpos: 0.0,
      light4_ypos: 0.0,
      light4_zpos: 0.0,
      light4_r: 0.0,
      light4_g: 0.0,
      light4_b: 0.0,
      light4_size: 0.0,
      light4_stretch: 0.0,
      light4_is_on: 0,
      
      light5_xpos: 0.0,
      light5_ypos: 0.0,
      light5_zpos: 0.0,
      light5_r: 0.0,
      light5_g: 0.0,
      light5_b: 0.0,
      light5_size: 0.0,
      light5_stretch: 0.0,
      light5_is_on: 0,
      
      flcpt: 0,
      prev_view : 1,
      
      nd_ref_light1_x:  props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/eyerel-x-m", 1),
      nd_ref_light1_y:  props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/eyerel-y-m", 1),
      nd_ref_light1_z: props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/eyerel-z-m", 1),
      nd_ref_light1_dir: props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/dir", 1),

      nd_ref_light2_x: props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/eyerel-x-m[1]", 1),
      nd_ref_light2_y: props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/eyerel-y-m[1]", 1),
      nd_ref_light2_z: props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/eyerel-z-m[1]", 1),
      nd_ref_light2_dir: props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/dir[1]", 1),

      nd_ref_light3_x: props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/eyerel-x-m[2]", 1),
      nd_ref_light3_y: props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/eyerel-y-m[2]", 1),
      nd_ref_light3_z: props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/eyerel-z-m[2]", 1),
      nd_ref_light3_dir: props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/dir[2]", 1),

      nd_ref_light4_x: props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/eyerel-x-m[3]", 1),
      nd_ref_light4_y: props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/eyerel-y-m[3]", 1),
      nd_ref_light4_z: props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/eyerel-z-m[3]", 1),
      nd_ref_light4_dir: props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/dir[3]", 1),
      
      nd_ref_light5_x: props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/eyerel-x-m[4]", 1),
      nd_ref_light5_y: props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/eyerel-y-m[4]", 1),
      nd_ref_light5_z: props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/eyerel-z-m[4]", 1),
      nd_ref_light5_dir: props.globals.getNode("/sim/rendering/als-secondary-lights/lightspot/dir[4]", 1),
      
      init: func {
            # define your lights here

            # lights ########
            # offsets to aircraft center
 
            me.light1_xpos =  80.0;
            me.light1_ypos =  0.0;
            me.light1_zpos =  2.0;
            
            me.light2_xpos =  55.0;
            me.light2_ypos =  0.0;
            me.light2_zpos =  2.0;
            
            me.light3_xpos =  -6.85;
            me.light3_ypos =  18.75;
            me.light3_zpos =  2.0;
            
            me.light4_xpos =  -6.85;
            me.light4_ypos =  -18.75;
            me.light4_zpos =  2.0;
            
            me.light5_xpos =  -10.0;
            me.light5_ypos =  0.0;
            me.light5_zpos =  2.0;
            
 
            # color values
            me.light1_r = 0.8;
            me.light1_g = 0.8;
            me.light1_b = 0.8;
            me.light2_r = 0.3;
            me.light2_g = 0.3;
            me.light2_b = 0.3;
            me.light3_r = 0.05;
            me.light3_g = 0.0;
            me.light3_b = 0.0;
            me.light4_r = 0.0;
            me.light4_g = 0.05;
            me.light4_b = 0.0;
            me.light5_r = 0.1;
            me.light5_g = 0.0;
            me.light5_b = 0.0;

            # spot size
            me.light1_size = 17;
            me.light1_stretch = 4;
            me.light2_size = 20;
            me.light2_stretch = 1;
            me.light3_size = 5;
            me.light4_size = 5;
            me.light5_size = 7;
            
            
            setprop("/sim/rendering/als-secondary-lights/flash-radius", 13);

            me.start();
      },

      start: func {
            setprop("/sim/rendering/als-secondary-lights/num-lightspots", 5);
 
            setprop("/sim/rendering/als-secondary-lights/lightspot/size", me.light1_size);
            setprop("/sim/rendering/als-secondary-lights/lightspot/size[1]", me.light2_size);
            setprop("/sim/rendering/als-secondary-lights/lightspot/size[2]", me.light3_size);
            setprop("/sim/rendering/als-secondary-lights/lightspot/size[3]", me.light4_size);
            setprop("/sim/rendering/als-secondary-lights/lightspot/size[4]", me.light5_size);
 
            setprop("/sim/rendering/als-secondary-lights/lightspot/stretch", me.light1_stretch);
            setprop("/sim/rendering/als-secondary-lights/lightspot/stretch[1]", me.light2_stretch);
 
            me.run = 1;       
            me.update();
      },

      stop: func {
            me.run = 0;
      },

      update: func {
            if (me.run == 0) {
                  return;
            }

            setprop("/position/gear-agl-ft", getprop("/position/altitude-agl-ft"));
            
            cur_alt = alt_agl.getValue();
            if (als_on.getValue() == 1 and alt_agl.getValue() < 100.0) {
                  hl = getprop("/tu154/light/headlight-selector");
                  rt = getprop("/tu154/light/retract");
                  bcn = getprop("/tu154/light/strobe/strobe_2");
                  nav = getprop("/tu154/light/nav/blue");
                  
                  var apos = geo.aircraft_position();
                  var vpos = geo.viewer_position();

                  me.lon_to_m = math.cos(apos.lat()*math.pi/180.0) * me.lat_to_m;

                  var heading = getprop("orientation/heading-deg") * math.pi/180.0;

                  var lat = apos.lat();
                  var lon = apos.lon();
                  var alt = apos.alt();

                  var sh = math.sin(heading);
                  var ch = math.cos(heading);
                  
                  if ((hl == 1) and (rt == 1)) {
                        me.light1_on();
                  } else {
                        me.light1_off();
                  }
                  
                  if (hl == 0.8) {
                        me.light2_on();
                  } else {
                        me.light2_off();
                  }
                  
                  if (bcn == 1) {
                        me.light5_on();
                  } else {
                        me.light5_off();
                  }
                  
                  if (nav == 1) {
                        me.light3_on();
                        me.light4_on();
                  } else {
                        me.light3_off();
                        me.light4_off();
                  }
                  

                  # light 1 position
                  var proj_x = cur_alt;
                  var proj_z = cur_alt/10.0;
       
                  apos.set_lat(lat + ((me.light1_xpos + proj_x) * ch + me.light1_ypos * sh) / me.lat_to_m);
                  apos.set_lon(lon + ((me.light1_xpos + proj_x)* sh - me.light1_ypos * ch) / me.lon_to_m);
       
                  delta_x = (apos.lat() - vpos.lat()) * me.lat_to_m;
                  delta_y = -(apos.lon() - vpos.lon()) * me.lon_to_m;
                  var delta_z = apos.alt()- proj_z - vpos.alt();
       
                  me.nd_ref_light1_x.setValue(delta_x);
                  me.nd_ref_light1_y.setValue(delta_y);
                  me.nd_ref_light1_z.setValue(delta_z);
                  me.nd_ref_light1_dir.setValue(heading);               


       
                  # light 2 position
       
                  apos.set_lat(lat + (me.light2_xpos * ch + me.light2_ypos * sh) / me.lat_to_m);
                  apos.set_lon(lon + (me.light2_xpos * sh - me.light2_ypos * ch) / me.lon_to_m);
       
                  delta_x = (apos.lat() - vpos.lat()) * me.lat_to_m;
                  delta_y = -(apos.lon() - vpos.lon()) * me.lon_to_m;
                  delta_z = apos.alt() - vpos.alt();
       
                  me.nd_ref_light2_x.setValue(delta_x);
                  me.nd_ref_light2_y.setValue(delta_y);
                  me.nd_ref_light2_z.setValue(delta_z);
                  me.nd_ref_light2_dir.setValue(heading);

       
                  # light 3 position
       
                  apos.set_lat(lat + (me.light3_xpos * ch + me.light3_ypos * sh) / me.lat_to_m);
                  apos.set_lon(lon + (me.light3_xpos * sh - me.light3_ypos * ch) / me.lon_to_m);
       
                  delta_x = (apos.lat() - vpos.lat()) * me.lat_to_m;
                  delta_y = -(apos.lon() - vpos.lon()) * me.lon_to_m;
                  delta_z = apos.alt() - vpos.alt();
       
                  me.nd_ref_light3_x.setValue(delta_x);
                  me.nd_ref_light3_y.setValue(delta_y);
                  me.nd_ref_light3_z.setValue(delta_z);
                  me.nd_ref_light3_dir.setValue(heading);   
            

                  # light 4 position
       
                  apos.set_lat(lat + (me.light4_xpos * ch + me.light4_ypos * sh) / me.lat_to_m);
                  apos.set_lon(lon + (me.light4_xpos * sh - me.light4_ypos * ch) / me.lon_to_m);
       
                  delta_x = (apos.lat() - vpos.lat()) * me.lat_to_m;
                  delta_y = -(apos.lon() - vpos.lon()) * me.lon_to_m;
                  delta_z = apos.alt() - vpos.alt();
       
                  me.nd_ref_light4_x.setValue(delta_x);
                  me.nd_ref_light4_y.setValue(delta_y);
                  me.nd_ref_light4_z.setValue(delta_z);
                  me.nd_ref_light4_dir.setValue(heading);
                  
                  # light 5 position
       
                  apos.set_lat(lat + (me.light5_xpos * ch + me.light5_ypos * sh) / me.lat_to_m);
                  apos.set_lon(lon + (me.light5_xpos * sh - me.light5_ypos * ch) / me.lon_to_m);
       
                  delta_x = (apos.lat() - vpos.lat()) * me.lat_to_m;
                  delta_y = -(apos.lon() - vpos.lon()) * me.lon_to_m;
                  delta_z = apos.alt() - vpos.alt();
       
                  me.nd_ref_light5_x.setValue(delta_x);
                  me.nd_ref_light5_y.setValue(delta_y);
                  me.nd_ref_light5_z.setValue(delta_z);
                  me.nd_ref_light5_dir.setValue(heading);
            }
            
            settimer ( func me.update(), 0.00);
      },

      light1_on : func {
            if (me.light1_is_on == 1) {return;}
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-r", me.light1_r);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-g", me.light1_g);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-b", me.light1_b);
            me.light1_is_on = 1;
            },
 
      light1_off : func {
            if (me.light1_is_on == 0) {return;}
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-r", 0.0);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-g", 0.0);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-b", 0.0);
            me.light1_is_on = 0;
            },
      
      light1_setSize : func(size) {
            setprop("/sim/rendering/als-secondary-lights/lightspot/size[0]", size);
      },
 
      light2_on : func {
            if (me.light2_is_on == 1) {return;}
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-r[1]", me.light2_r);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-g[1]", me.light2_g);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-b[1]", me.light2_b);
            me.light2_is_on = 1;
            },
 
      light2_off : func {
            if (me.light2_is_on == 0) {return;}
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-r[1]", 0.0);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-g[1]", 0.0);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-b[1]", 0.0);
            me.light2_is_on = 0;
            },
            
      light2_setSize : func(size) {
            setprop("/sim/rendering/als-secondary-lights/lightspot/size[1]", size);
      },
      
      light3_on : func {
            if (me.light3_is_on == 1) {return;}
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-r[2]", me.light3_r);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-g[2]", me.light3_g);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-b[2]", me.light3_b);
            me.light3_is_on = 1;
            },
 
      light3_off : func {
            if (me.light3_is_on == 0) {return;}
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-r[2]", 0.0);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-g[2]", 0.0);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-b[2]", 0.0);
            me.light3_is_on = 0;
            },

      light4_on : func {
            if (me.light4_is_on == 1) {return;}
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-r[3]", me.light4_r);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-g[3]", me.light4_g);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-b[3]", me.light4_b);
            me.light4_is_on = 1;
            },
 
      light4_off : func {
            if (me.light4_is_on == 0) {return;}
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-r[3]", 0.0);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-g[3]", 0.0);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-b[3]", 0.0);
            me.light4_is_on = 0;
            },
            
      light5_on : func {
            if (me.light5_is_on == 1) {return;}
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-r[4]", me.light5_r);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-g[4]", me.light5_g);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-b[4]", me.light5_b);
            me.light5_is_on = 1;
            },
 
      light5_off : func {
            if (me.light5_is_on == 0) {return;}
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-r[4]", 0.0);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-g[4]", 0.0);
            setprop("/sim/rendering/als-secondary-lights/lightspot/lightspot-b[4]", 0.0);
            me.light5_is_on = 0;
            },
};

light_manager.init();


############################################# Model lights ############################################
light_rework = func{
      blue = getprop("tu154/light/panel/amb-blue");
      green = getprop("tu154/light/panel/amb-green");
      red = getprop("tu154/light/panel/amb-red");
      if( blue == nil ) { return; }
      if( green == nil ) { return; }
      if( red == nil ) { return; }

      podsvetka_osn = (blue + green + red) / 3;
      podsvetka_lamps = podsvetka_osn * 1.25;
      podsvetka_prib = podsvetka_osn * 1.2;
      podsvetka_osn /= 3;

      setprop("sim/model/cabin-lighting/vnesh", podsvetka_osn);
      setprop("sim/model/cabin-lighting/vnesh-2", podsvetka_osn / 1.5);
      setprop("sim/model/cabin-lighting/lamps", podsvetka_lamps);
      setprop("sim/model/cabin-lighting/lamps-2", podsvetka_lamps / 1.5);
      setprop("sim/model/cabin-lighting/prib", podsvetka_prib);
      setprop("sim/model/cabin-lighting/prib-2", podsvetka_prib / 1.5);
}
setlistener("tu154/light/panel/amb-blue", light_rework);
setlistener("tu154/light/panel/amb-green", light_rework);
setlistener("tu154/light/panel/amb-red", light_rework);

#light_switcher = func{
#      mode = getprop("/tu154/light/headlight-selector");
#      voltage1 = getprop("tu154/systems/electrical/buses/AC3x200-bus-1L/volts");
#      voltage2 = getprop("tu154/systems/electrical/buses/AC3x200-bus-2/volts");
#      voltage3 = getprop("tu154/systems/electrical/buses/AC3x200-bus-3L/volts");
#      viewNumber = getprop("/sim/current-view/view-number");
#      if( mode == nil ) { return; }
#      if( voltage1 == nil ) { return; }
#      if( voltage2 == nil ) { return; }
#      if( voltage3 == nil ) { return; }
#      if( viewNumber == nil ) { return; }
#
#      voltage = voltage1 + voltage2 + voltage3;
#
#      if( mode > 0.7 and voltage > 0 and ( viewNumber == 0 or viewNumber == 8 ) ) {
#            setprop("/sim/rendering/als-secondary-lights/use-searchlight", 1);
#      }
#      else {
#            setprop("/sim/rendering/als-secondary-lights/use-searchlight", 0);
#      }
#
#      if( mode > 0.9 and voltage > 0 and ( viewNumber == 0 or viewNumber == 8 ) ) {
#            setprop("/sim/rendering/als-secondary-lights/use-landing-light", 1);
#            setprop("/sim/rendering/als-secondary-lights/use-alt-landing-light", 1);
#      }
#      else {
#            setprop("/sim/rendering/als-secondary-lights/use-landing-light", 0);
#            setprop("/sim/rendering/als-secondary-lights/use-alt-landing-light", 0);
#      }
#}
#setlistener("/tu154/light/headlight-selector", light_switcher);
#setlistener("/tu154/systems/electrical/buses/AC3x200-bus-1L/volts", light_switcher);
#setlistener("/tu154/systems/electrical/buses/AC3x200-bus-2/volts", light_switcher);
#setlistener("/tu154/systems/electrical/buses/AC3x200-bus-3L/volts", light_switcher);
#setlistener("/sim/current-view/view-number", light_switcher);
#
#lnd_lt_angle = func{
#      main = getprop("/tu154/light/retract");
#      if( main == nil ) { return; }
#
#      position = 95 - main * 90;
#
#      setprop("/sim/rendering/als-secondary-lights/landing-light3-offset-deg", position)
#}
#setlistener("/tu154/light/retract", lnd_lt_angle);