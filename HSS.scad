$fn = 64;
grid = 1.27;

diode_gauge_mm = 0.508;
wire_gauge_mm = 0.559;

pin2 = [0, 5.9, 1.4];
pin1 = [5, 3.8, 1.7];

stem = [0, 0, 3.5];
peg1 = [-5.5, 0, 1.9];
peg2 = [5.5, 0, 1.9];
base = [11*grid, 11*grid, 3.5];

diode_dia = diode_gauge_mm * 0.98;
wire_dia = wire_gauge_mm * 1.1;

diode_angle = -6;

slot_size = 1.75;

// diode_mock();

rotate([0,180, 0])
    mirror([1,0,0])
        difference(){
            make_body();
            left_pin_wire_slots();
            right_pin_wire_slots();
            diode_slot();
        }

module make_body(){
    difference(){
        translate([0, 0, 0]){
            cube([base.x, base.y, base.z], center = true);
        }

        // Side Slots for removal
        translate([7.75, 0, 0])
            rotate([0, 45, 0])
                cube([slot_size, 20, slot_size], center = true);

        translate([-7.75, 0, 0])
            rotate([0, 45, 0])
                cube([slot_size, 20, slot_size], center = true);

        translate([0, 7.75, 0])
            rotate([45, 0, 0])
                cube([20, slot_size, slot_size], center = true);

        translate([0, -7.75, 0])
            rotate([45, 0, 0])
                cube([20, slot_size, slot_size], center = true);

        // Main Stem Clamp
        translate([stem.x, stem.y, 0]){
            cylinder(h=base.z*2, d=stem[2], center = true);
        }

        translate([0, -5, 0]){
            cube([3, 10, base.z*2], center = true);
        }

        // PCB Mount Pegs
        translate([peg1.x, peg1.y, 0]){
            cylinder(h=base.z*2, d=peg1[2], center = true);
        }

        translate([peg2.x, peg2.y, 0]){
            cylinder(h=base.z*2, d=peg2[2], center = true);
        }

        // Switch Pins
        translate([pin2.x, pin2.y, 0]){
            cylinder(h=base.z*2, d=pin2[2], center = true);
        }

        translate([pin1.x, pin1.y, 0]){
            cylinder(h=base.z*2, d=pin1[2], center = true);
        }

    }
}

module left_pin_wire_slots(){
    // Diode Pin Wire Channels
    translate([pin2.x, 5*grid, 0])
        cube([1.5*diode_dia, 2, base.z*2], center = true);

    translate([-4, 4.5*grid, -base.z/2])
        cube([8, 1.25*diode_dia, 3*diode_dia], center = true);

    translate([-5.25*grid, 4.5*grid, 0])
        cube([1, 1.25*diode_dia, base.z*2], center = true);

    translate([0, -4*grid, base.z/2])
        cube([20, wire_dia, base.z], center = true);
    
    translate([-5.25*grid, -4*grid, 0])
        cube([1, wire_dia, base.z*2], center = true);
    
    translate([-4*grid, -4*grid, -base.z/2])
        cube([4, wire_dia, 3*diode_dia], center = true);

}

module right_pin_wire_slots(){
    translate([pin1.x, 4*grid, base.z/2])
        cube([1.2*wire_dia, pin1.y, 3*wire_dia], center = true);
    translate([pin1.x, -1.5, -base.z/2])
        cube([2*wire_dia, (base.y-pin1.y+1), 3*wire_dia], center = true);
    translate([6.9, 3.8, -base.z/2])
        cube([pin1.y, 1.2*wire_dia, 3*wire_dia], center = true);
    translate([peg2.x, peg2.y, -base.z/2])
        difference() {
            d = peg2.z*2.5;
            cylinder(h=3*wire_dia, d=d, center = true);
            translate([0,-0.5*d,0]) cube([d, d, 3*wire_dia]);
        }
}

module diode_slot(){
    union(){
        // Diode Body + Other Leg
        translate([-2.45*grid, -1.5*grid, -0.75])
            rotate([0, 0, diode_angle]){
                cube([2.1, 3.8, 2.1], center = true);
            }
        translate([-2.45*grid, -1.5*grid, -base.z/2])
            rotate([0, 0, diode_angle]){
                translate([0, 0, 0])
                    cube([diode_dia, 8, 2.5], center = true);
                translate([1.3, 6, 0]) rotate([0, 0, -25])
                    cube([diode_dia, 5, 2.5], center = true);
                translate([0, -3.25, 0])
                    cylinder(h=2.5, d=1.75, center = true);
                translate([0, 3.25, 0])
                    cylinder(h=2.5, d=1.75, center = true);
            }
    }
}

module diode_mock(){
    translate([-2.45*grid, -1.5*grid, -0.75])
        rotate([0, 0, diode_angle])
            rotate([90, 0, 0]){
                cylinder(h=3.2, d=2, center = true);
                cylinder(h=100, d=diode_dia, center = true);
            }
}
