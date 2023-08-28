include <../third_party/gridfinity-rebuilt-openscad/standard.scad>;
use <../third_party/gridfinity-rebuilt-openscad/gridfinity-rebuilt-utility.scad>;
use <../third_party/gridfinity-rebuilt-openscad/gridfinity-rebuilt-baseplate.scad>;

use <shapes.scad>

module gridfinity_baseplate_extruded_bottom(w, d, gf_type, extrude=true) {
    union() {
        translate([0,0,0*h_base])
        gridfinityBaseplate(d, w, l_grid, 0, 0, gf_type, true, 0, 0, 0);
        if (extrude) {
            if (gf_type == 0) {
                translate([0,0,-bp_h_bot])
                linear_extrude(height=bp_h_bot)
                projection(cut=true)
                gridfinityBaseplate(d, w, l_grid, 0, 0, gf_type, true, 0, 0, 0);
            }
        }
    }
}

module gridfinity_baseplate_cut(w, d, gf_type, base_fill, extrude=true, deep=true) {
    xx = d * l_grid - 0.5;
    yy = w * l_grid - 0.5;
    base_cut_extra_factor = (gf_type > 0 ? 0.5 : 0);
    no_magnet_thin = (gf_type == 0 && !deep);
    translate([0,0,no_magnet_thin ? h_base : 0])
    difference() {
        rounded_rectangle(xx, yy, h_base * (no_magnet_thin ? 1 : 2), r_fo1 / 2);
        if (base_fill == 0) {
            translate([0, 0, -h_base * base_cut_extra_factor])
            rounded_rectangle(xx, yy, h_base, r_fo1 / 2);
        }
        translate([0, 0, no_magnet_thin ? 0 : h_base])
        gridfinity_baseplate_extruded_bottom(w, d, gf_type, extrude=extrude);
        if (base_fill == 3) {
            difference() {
                translate([0, 0, -h_base * (1 + base_cut_extra_factor)])
                rounded_rectangle(xx, yy, h_base * 2, r_fo1 / 2);
                rotate([-90,-90,0])
                wall_honeycomb(xx, yy, h_base * 2, partial=true);
            }
        }
    }
}


