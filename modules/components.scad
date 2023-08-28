include <constants.scad>
include <shapes.scad>

module dovetail_cut(height) {
    dt_base_size = dovetail_size * 4;
    dt_base_depth = height * dovetail_depth_percent;
    rotate([0,90,0])
    union() {
        translate([-dt_base_size,-dt_base_size/2,dt_base_depth-dt_base_size])
            rotate([90,0,90])
            prism(dt_base_size, dt_base_size, dt_base_size);
        translate([-dt_base_size,dt_base_size/2,dt_base_depth-dt_base_size/2])
            rotate([90,0,0])
            prism(dt_base_size, dt_base_size, dt_base_size);
        translate([-dt_base_size,dt_base_size/2,dt_base_depth+dt_base_size/2])
            rotate([180,0,0])
            prism(dt_base_size, dt_base_size, dt_base_size);
    }
}


module dovetail_connector(height, dt_scale=1.0, channel=false, cut=true) {
    // Create a dovetail connector
    dt_size = dovetail_size * dt_scale;
    dt_x_size = dt_size * (channel ? 0.75 : 0.75);
    difference() {
        rotate([90,0,90])
        linear_extrude(height=height * (cut ? dovetail_depth_percent : 1.0))
        polygon(
            points=[
                [-dt_size, 0],
                [dt_size, 0],
                [dt_x_size * 2, dt_size],
                [-dt_x_size * 2, dt_size]
            ]
        );
        if (cut) dovetail_cut(height);
    }
}

module dovetail_channel(height) {
    dovetail_connector(height, dt_scale=1.15, channel=true, cut=false);
}

module dovetail_connector_support(height, channel=true) {
    sw = housing_wall_thickness;
    sh = dovetail_size * 4.5 + (channel ? 4 : 2) * connector_support_tolerance - 3;
    rotate([0,90,0])
    translate([housing_wall_thickness/2,0,height/2])
    translate([-sw/2,-sh/2,-height/2])
    chamferCube([
            sw,
            sh,
            height
        ],
        [0,0,channel ? [1,0,0,1] : [0,1,1,0]],
        chamfer_amount * 0.25
    );
}

module wall_diamonds(depth_units, wall_thickness, lip_increment) {
    ww = base_unit_depth - 2 * lip_increment;

    rotate([0,0,180])
    for (unit = [0:depth_units - 1]) {
        translate([unit * base_unit_depth,0,0])
        linear_extrude(height=wall_thickness)
        polygon(
            [
                [0, 0],
                [ww * 0.5, -ww * 0.5],
                [ww, 0],
                [ww * 0.5, ww * 0.5],
            ]
        );
    }
}
