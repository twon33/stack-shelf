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

shelf_perimeter_thickness = eighth_inch;
shelf_center_thickness = sixteenth_inch;

leg_thickness = sixteenth_inch;
leg_width_depth = half_inch;

corner_slop=0.15 * units_per_inch;
corner_notch_wd=(2*leg_width_depth) + corner_slop;
corner_notch_h=shelf_perimeter_thickness-sixteenth_inch; // center=true below makes this half-height

perimeter_width=quarter_inch;

rotate([0,180,0])
difference() { 
// main solid
cube([width,depth,height]);

// carve around legs
translate([leg_width_depth,0,0]) cube([width-(2*leg_width_depth),depth,height-shelf_perimeter_thickness]);
translate([0,leg_width_depth,0]) cube([width,depth-(2*leg_width_depth),height-shelf_perimeter_thickness]);

// notch inside of legs
translate([leg_thickness,leg_thickness,0]) cube([width-(2*leg_thickness),depth-(2*leg_thickness),height-shelf_perimeter_thickness]);

// corners for stacking
translate([0,0,height]) cube(size=[corner_notch_wd,corner_notch_wd,corner_notch_h],center=true);
translate([width,0,height]) cube(size=[corner_notch_wd,corner_notch_wd,corner_notch_h],center=true);
translate([0,depth,height]) cube(size=[corner_notch_wd,corner_notch_wd,corner_notch_h],center=true);
translate([width,depth,height]) cube(size=[corner_notch_wd,corner_notch_wd,corner_notch_h],center=true);

translate([perimeter_width,perimeter_width,0]) cube([width-(2*perimeter_width),depth-(2*perimeter_width),height-shelf_center_thickness]);
// vents?
}