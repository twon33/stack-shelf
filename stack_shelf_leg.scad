units_per_inch=1;

sixteenth_inch = units_per_inch / 16.0;
eighth_inch = units_per_inch / 8.0;
quarter_inch = units_per_inch / 4.0;
half_inch = units_per_inch / 2.0;
inch = units_per_inch / 1.0;

leg_wd = half_inch;
leg_thickness = sixteenth_inch;
leg_hole_wd = leg_wd-(2*leg_thickness);

table_height = 3*inch;
table_thickness = quarter_inch;

total_height = table_height + table_thickness + (3*eighth_inch);

leg_hole_height = table_height-quarter_inch;

tab_overhang = 3*(inch/64.0);
table_hole_w = leg_wd-(2*leg_thickness);
table_hole_d = leg_wd-(2*leg_thickness)-(2*tab_overhang);

tab_band_w = leg_wd/2-table_hole_w/2;
tab_band_d = leg_wd/2-table_hole_d/2;
tab_band_h = table_thickness + (.01*inch);

tab_squeeze_cutout_w = eighth_inch+sixteenth_inch;
tab_squeeze_h = total_height-table_height;
tab_squeeze_foot_h = 1.5*eighth_inch;
tab_squeeze_angle_start_h = table_height+tab_band_h+tab_squeeze_foot_h;
tab_squeeze_angle = 75.0; // degrees

difference() { 
	cube([leg_wd,leg_wd,total_height]);

	translate([leg_thickness,leg_thickness,0])
		cube([leg_hole_wd,leg_hole_wd,leg_hole_height]);

	// tab band
	translate([0,0,table_height]) cube([tab_band_w,leg_wd,tab_band_h]);
	translate([leg_wd-tab_band_w,0,table_height]) cube([tab_band_w,leg_wd,tab_band_h]);

	translate([0,0,table_height]) 
		cube([leg_wd,tab_band_d,tab_band_h]);

	translate([0,leg_wd-tab_band_d,table_height])
		cube([leg_wd,tab_band_d,tab_band_h]);

	translate([0,0,table_height])
		cube([leg_wd,leg_thickness,tab_squeeze_h]);

	translate([0,leg_wd-leg_thickness,table_height])
		cube([leg_wd,leg_thickness,tab_squeeze_h]);
	

	// tab squeeze cutout
	translate([0,(leg_wd/2.0)-(tab_squeeze_cutout_w/2.0),table_height]) 
		cube([leg_wd,tab_squeeze_cutout_w,total_height-table_height]);

	// ensure tabs nest with hole in stacking leg
	translate([0,0,table_height]) cube([leg_thickness,leg_wd,tab_squeeze_h]);
	translate([leg_wd-leg_thickness,0,table_height]) cube([leg_thickness,leg_wd,tab_squeeze_h]);


	// angle cutouts for squeeze
	translate([0,leg_thickness,tab_squeeze_angle_start_h]) 
		rotate([tab_squeeze_angle,0,0])
			cube([leg_wd,leg_wd,tab_squeeze_h]);

	translate([0,leg_wd-leg_thickness,tab_squeeze_angle_start_h])
		rotate([90-tab_squeeze_angle,0,0])
			cube([leg_wd,leg_wd,tab_squeeze_h]);
}
