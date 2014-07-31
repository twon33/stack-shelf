// x, z, y

units_per_inch=1;

sixteenth_inch = units_per_inch / 16.0;
eighth_inch = units_per_inch / 8.0;
quarter_inch = units_per_inch / 4.0;
half_inch = units_per_inch / 2.0;
inch = units_per_inch / 1.0;

//full size version
width=12*inch; // units (2 per inch)
height=3*inch;
depth=11*inch;

//small version (reduced width, depth, height, preserved leg dimensions and thicknesses)
//width=6*inch;
//height=1.5*inch;
//depth=5.5*inch;

perimeter_thickness = eighth_inch;
center_thickness = sixteenth_inch;

leg_thickness = sixteenth_inch;
leg_wd = half_inch;

corner_slop = sixteenth_inch/4;
corner_notch_wd = leg_wd;
corner_notch_h = (perimeter_thickness-sixteenth_inch);

corner_post_wd = leg_wd-(leg_thickness*2)-corner_slop;

perimeter_width=quarter_inch;

module leg_punch(offset_w,offset_d) {
	punch_wd = leg_wd-(2*leg_thickness);
	translate([leg_thickness + offset_w, leg_thickness + offset_d, 0])
		cube([punch_wd,punch_wd,height-perimeter_thickness]);
}

module corner_notch(offset_w,offset_d) {
	epsilon = .01; // slop to prevent simple: no
	offset_h = height-corner_notch_h + epsilon;
	subtract_h = corner_notch_h+epsilon;
	subtract_long = corner_notch_wd;
	subtract_short = corner_notch_wd-corner_post_wd;

	translate([offset_w,offset_d,offset_h])
		cube([subtract_short,subtract_long,subtract_h]);

	translate([offset_w+corner_post_wd,offset_d,offset_h])
		cube([subtract_short,subtract_long,subtract_h]);

	translate([offset_w,offset_d,offset_h])
		cube([subtract_long,subtract_short,subtract_h]);

	translate([offset_w,offset_d+corner_post_wd,offset_h])
		cube([subtract_long,subtract_short,subtract_h]);

}

rotate([0,180,0]) // for plating
difference() { 
// main solid
cube([width,depth,height]);

// carve around legs
translate([leg_wd,-inch,0]) cube([width-(2*leg_wd),depth+(2*inch),height-perimeter_thickness]);
translate([-inch,leg_wd,0]) cube([width+(2*inch),depth-(2*leg_wd),height-perimeter_thickness]);

// L-shaped legs
//translate([leg_thickness,leg_thickness,0]) cube([width-(2*leg_thickness),depth-(2*leg_thickness),height-perimeter_thickness]);

// square legs (hollow)
leg_punch(0,0);
leg_punch(width-leg_wd,0);
leg_punch(0,depth-leg_wd);
leg_punch(width-leg_wd,depth-leg_wd);

// corners for stacking
corner_notch(0,0);
corner_notch(width-leg_wd,0);
corner_notch(0,depth-leg_wd);
corner_notch(width-leg_wd,depth-leg_wd);

// thin out center of shelf
translate([leg_wd,perimeter_width,0]) cube([width-(2*leg_wd),depth-(2*perimeter_width),height-center_thickness]);
translate([perimeter_width,leg_wd,0]) cube([width-(2*perimeter_width),depth-(2*leg_wd),height-center_thickness]);

// vents?
}