units_per_inch=25.4; // Cura takes millimeters

sixteenth_inch = units_per_inch / 16.0;
eighth_inch = units_per_inch / 8.0;
quarter_inch = units_per_inch / 4.0;
half_inch = units_per_inch / 2.0;
inch = units_per_inch / 1.0;

render_slop = .1; // Slop to make up for lack of precision in the renderer (unitless)
print_slop = 0.02*inch; // Slop to make up for oddities/meltiness during printing

leg_wd = half_inch;
leg_thickness = sixteenth_inch;
leg_hole_wd = leg_wd-(2*leg_thickness);

table_height = 3*inch;
table_thickness = quarter_inch;

total_height = table_height + table_thickness + (3*eighth_inch);

leg_cylinder_support_radius = leg_hole_wd/2;
leg_hole_height = table_height-quarter_inch-leg_cylinder_support_radius;

tab_overhang = 3*(inch/64.0);
table_hole_w = leg_wd-(2*leg_thickness);
table_hole_d = leg_wd-(2*leg_thickness)-(2*tab_overhang);

tab_band_w = leg_wd/2-table_hole_w/2;
tab_band_d = leg_wd/2-table_hole_d/2;
tab_band_h = table_thickness + print_slop;

tab_squeeze_cutout_w = 3*sixteenth_inch;
tab_squeeze_cylinder_support_radius = tab_squeeze_cutout_w/2;
tab_squeeze_total_h = total_height-table_height;
tab_squeeze_inner_h = tab_squeeze_total_h - tab_squeeze_cylinder_support_radius;

tab_squeeze_foot_h = 3*sixteenth_inch;
tab_squeeze_angle_start_h = table_height+tab_band_h+tab_squeeze_foot_h;
tab_squeeze_angle = 75.0; // degrees

module tab_band() {
  translate([-render_slop/2,-render_slop/2,table_height])
    cube([tab_band_w+render_slop,leg_wd+render_slop,tab_band_h+print_slop]);
    
  translate([leg_wd-tab_band_w-render_slop/2,-render_slop/2,table_height])
    cube([tab_band_w+render_slop,leg_wd+render_slop,tab_band_h+print_slop]);

  translate([-render_slop/2,-render_slop/2,table_height]) 
    cube([leg_wd+render_slop,tab_band_d+render_slop,tab_band_h+print_slop]);

  translate([-render_slop/2,leg_wd-tab_band_d-render_slop/2,table_height])
    cube([leg_wd+render_slop,tab_band_d+render_slop,tab_band_h+print_slop]);
}

module tab_squeeze_cutout() {
  translate([0,(leg_wd/2.0)-(tab_squeeze_cutout_w/2.0),table_height + tab_squeeze_cylinder_support_radius + render_slop]) 
    cube([leg_wd,tab_squeeze_cutout_w,tab_squeeze_inner_h]);
  
  translate([leg_wd/2,leg_wd/2,table_height + tab_squeeze_cylinder_support_radius + sixteenth_inch/4]) 
    rotate(a=[0,90,0])
    cylinder(h=leg_wd, r=tab_squeeze_cylinder_support_radius, center=true, $fn=16);
}

module tab_angle_cutouts() {
  translate([0,leg_thickness,tab_squeeze_angle_start_h]) 
    rotate([tab_squeeze_angle,0,0])
    cube([leg_wd,leg_wd,tab_squeeze_total_h]);

  translate([0,leg_wd-leg_thickness,tab_squeeze_angle_start_h])
    rotate([90-tab_squeeze_angle,0,0])
    cube([leg_wd,leg_wd,tab_squeeze_total_h]);
}

module leg_difference_tube_with_height(h) {
  translate([-render_slop/2, -render_slop/2, 0])
    difference() {
      cube([leg_wd+render_slop,leg_wd+render_slop,h]);
      
      translate([leg_thickness+print_slop/2,leg_thickness+print_slop/2,-render_slop/2])
        cube([leg_hole_wd-print_slop,leg_hole_wd-print_slop,h+render_slop]);
    }
}

module leg() {
  difference() { 
    cube([leg_wd,leg_wd,total_height]);

    // punch the hole in the leg
    translate([leg_thickness,leg_thickness,0])
      cube([leg_hole_wd,leg_hole_wd,leg_hole_height]);

    // carve the support cylinder on top so we don't need supports the whole way up
    translate([leg_wd/2, leg_wd/2, leg_hole_height])
      rotate(a=[90,11.25,0]) // 11.25 sets a vertex at the top rather than a side
      cylinder(h=leg_hole_wd, r=leg_cylinder_support_radius, center=true);

    tab_band();
    tab_squeeze_cutout();  
    translate([0,0,table_height]) leg_difference_tube_with_height(tab_squeeze_total_h+render_slop);
    tab_angle_cutouts();
  }
}

space_between_models = inch;
translate_between_models = space_between_models + leg_wd;

leg();
translate([translate_between_models, 0, 0]) leg();
translate([0, translate_between_models, 0]) leg();
translate([translate_between_models, translate_between_models, 0]) leg();