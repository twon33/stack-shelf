// x, z, y

units_per_inch=1;


//full size version
//width=12*units_per_inch; // units (2 per inch)
//height=3*units_per_inch;
//depth=11*units_per_inch;

//small version (reduced width, depth, height, preserved leg dimensions and thicknesses)
width=6*units_per_inch;
height=1.5*units_per_inch;
depth=5.5*units_per_inch;

shelf_perimeter_thickness=.125*units_per_inch;
shelf_center_thickness=.0625*units_per_inch;

leg_thickness=.0625*units_per_inch;
leg_width_depth=.5*units_per_inch;

corner_slop=0.15 * units_per_inch;
corner_notch_wd=(2*leg_width_depth) + corner_slop;
corner_notch_h=shelf_perimeter_thickness-(.0625*units_per_inch); // center=true below makes this half-height

perimeter_width=.25*units_per_inch;

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