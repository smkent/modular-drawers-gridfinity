use <../third_party/Chamfers-for-OpenSCAD/Chamfer.scad>;

include <constants.scad>


module prism(l, w, h){
    // https://en.wikibooks.org/wiki/OpenSCAD_User_Manual/Primitive_Solids
    polyhedron(points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]], faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]);
}

module hex_grid(x, y, h, separation, hex_size, chamfer_amount, partial=true) {
    hex_width = hex_size * sin(360 / 6);
    slop = 0.05;

    module hex_grid_conditional_hexagon(x_offset, y_offset) {
        if(
            partial || (
                x_offset > -x / 2 + (hex_width + separation) / 2
                && x_offset < x / 2 - (hex_width + separation) / 2
                && y_offset > -y / 2 + (hex_width + separation) / 2
                && y_offset < y / 2 - (hex_width + separation) / 2
            )
        ) {
            translate([x_offset, y_offset, -slop])
            rotate([0, 0, 30])
            cylinder(h + 2 * slop, hex_size / 2, hex_size / 2, $fn=6);
        }
    }

    if (x >= 1.25 * hex_size && y >= 1.25 * hex_size) {
        difference() {
            union() {
                for (y_offset = [-y / (1.5 * hex_size) : 2 : y / (1.5 * hex_size)]) {
                    for (x_offset = [-x / (1.5 * hex_size) : x / (1.5 * hex_size)]) {
                        hex_grid_conditional_hexagon(
                            x_offset * (hex_width + separation),
                            y_offset * hex_width
                        );
                        hex_grid_conditional_hexagon(
                            x_offset * (hex_width + separation) + (hex_width + separation) / 2,
                            (y_offset + 1) * hex_width
                        );
                    }
                }
            }
            difference() {
                translate([0, 0,h/2])
                cube([2*x,2*y,h+4*slop], true);
                translate([-x/2,-y/2,0])
                chamferCube([x,y,h], [0,0,[1,1,1,1]], chamfer_amount-1);
            }
        }
    }
}

module wall_honeycomb(x, y, h, sideways=false, partial=true) {
    hex_size = 14.0;
    separation = 3.0;
    if (sideways) {
        rotate([90,90,90])
        hex_grid(y, x, h, separation, hex_size, chamfer_amount, partial=partial);
    } else {
        rotate([90,0,90])
        hex_grid(x, y, h, separation, hex_size, chamfer_amount, partial=partial);
    }
}
