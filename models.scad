/*
Gridfinity Modular Interlocking Drawers

Attribution:

- This is a near-complete redesign of Grant Emsley's Customizable Bigger Mini Drawers Ultimate (https://www.printables.com/model/293400)
- Grant's model is a redesign of Karkovski's Modular Storage - Bigger Mini Drawers Ultimate (https://www.thingiverse.com/thing:2420368)
- Original design by zeropage (https://www.thingiverse.com/thing:1889761)
*/

use <third_party/Chamfers-for-OpenSCAD/Chamfer.scad>;
include <third_party/gridfinity-rebuilt-openscad/standard.scad>;

include <modules/constants.scad>
use <modules/components.scad>
use <modules/gridfinity.scad>
use <modules/shapes.scad>

/* [Rendering] */
// Select Print Orientation to render models for export. You may wish to enable only the housing or drawer using the options after this one to export them separately.
Render_Position = 0 ; // [0: Print Orientation, 1: Drawer Closed, 2: Drawer Open, 3: Stacked]

Create_Housing = true;
Create_Drawer = true;
Create_Top_or_Bottom_Plate = true;

/* [Size] */
// 3 or greater is recommended. 2 may fit a Gridfinity base, drawer walls will automatically be removed. 1 is available but will not work properly for Gridfinity bases.
Width_Units = 3; // [1:10]
Depth_Units = 3; // [1:10]
// In 6u Gridfinity height increments (e.g. 1.0 = 6u). 0.5 is available but is not tall enough for a Gridfinity bin.
Height_Units = 1.0; // [0.5:0.5:4]

/* [Housing Settings] */
Housing_Back_Wall_Fill = 3; // [-1: None, 0: Solid, 3: Honeycomb]
Housing_Top_Fill = 0; // [0: Solid, 1: Diamond, 3: Honeycomb]
Housing_Bottom_Fill = 0; // [0: Solid, 1: Diamond, 3: Honeycomb]
Housing_Left_Wall_Fill = 0; // [0: Solid, 1: Diamond, 3: Honeycomb]
Housing_Right_Wall_Fill = 0; // [0: Solid, 1: Diamond, 3: Honeycomb]

// Drawer catch(es) are placed on the top inner housing near the front
Enable_Drawer_Catch = true;

/* [Drawer Settings] */
Drawer_Bottom_Type = 0; // [-1: None, 0: Gridfinity without magnets, 2: Gridfinity with magnets]

// Applies if one of the Gridfinity options are selected for Drawer Bottom Type
Gridfinity_Base_Fill = -1; // [-1: None, 0: Solid, 3: Honeycomb]

Drawer_Back_Wall_Fill = 3; // [0: Solid, 3: Honeycomb]
Drawer_Side_Wall_Fill = 3; // [0: Solid, 3: Honeycomb]
// Reduce this value to reduce the drawer sides height
Drawer_Sides_Height_Ratio = 0.55; // [0.0:0.05:1.0]

Pull_Type = 3; // [-1: None, 0: Screw Holes, 1: Conical Top Pull, 2: Cup Top Pull, 3: Triangular Pull variant 1, 4: Triangular Pull variant 2]
// Applies when Pull Type is set to one of the integrated pull types
Enable_Drawer_Face_Behind_Pull = true;
// In millimeters. Applies when Pull Type is set to Screw Holes
Pull_Screw_Hole_Diameter = 3.0; // [1.0:0.1:15.0]
// In millimeters. Set to 0 for a single hole instead of two. Applies when Pull Type is set to Screw Holes
Pull_Screw_Hole_Separation = 10.0; // [0.0:0.5:50.0]

/* [Top or Bottom Plate Settings] */
Plate_Model_Type = 1; // [0: Bottom Plate, 1: Top Plate]

// Fills other than Solid are not recommended with Top Plate Gridfinity base types
Plate_Fill = 0; // [0: Solid, 1: Diamond, 3: Honeycomb]

// Applies when Model Type is set to Top Plate
Top_Plate_Type = 1; // [0: Plate, 1: Shelf]
Top_Plate_Base_Type = 0; // [-1: None, 0: Gridfinity without magnets, 2: Gridfinity with magnets]
Enable_Top_Plate_Left_Side = true;
Enable_Top_Plate_Right_Side = true;
Enable_Top_Plate_Back = true;
Top_Plate_Back_Wall_Fill = 0; // [0: Solid, 3: Honeycomb]

/* [Advanced Housing Settings] */
// Reduce this to reduce the thickness of the wall faces
Housing_Wall_Thickness_Ratio = 0.25; // [0.2:0.05:1.0]

// Drawer catch sizing on the top interior of the housing
Catch_Size = 2.5;
// Drawer catch placement distance from the front of the housing
Catch_Setback = 2;

/* [Advanced Drawer Settings] */
// All units in mm unless otherwise specified. Changing these may make your boxes incompatible with other ones.

// Make drawer this much smaller than the inner measurements of the housing on 4 sides. (Default 0.5mm)
Drawer_Tolerance = 0.5; // [0:.1:1]

// Options other than Solid may not print properly and are not recommended
Drawer_Face_Fill = 0; // [0: Solid, 3: Honeycomb]

// Reduce base thickness when possible
Thinner_Base = true;

/* [Compatibility-Altering Settings] */
// Changing any of these options will break the interlocking compatibility with other units.

Add_Connectors = true;

/* [Development Toggles] */

Preview_Full_Render = false;

// Only generate housing cross-section to print for fit testing
Housing_Cross_Section = false;

module __end_customizer_options__() { }

/* Computed values */

// Full housing exterior size
housing_outer_width = base_unit_width + (Width_Units - 1)*extra_unit_width;
housing_outer_height = base_unit_height + (Height_Units -1)*extra_unit_height;
// Depth excluding handle
housing_outer_depth = housing_wall_thickness + back_wall_thickness + base_unit_depth * Depth_Units + 2;

// Full drawer exterior size
drawer_outer_width = housing_outer_width - 2*housing_wall_thickness - 2*Drawer_Tolerance;
drawer_outer_height = housing_outer_height - 2*housing_wall_thickness - 2*Drawer_Tolerance;
drawer_outer_depth = housing_outer_depth - back_wall_thickness;

// Full drawer interior size
drawer_inner_width = drawer_outer_width - 2 * drawer_wall_thickness;
drawer_inner_height = drawer_outer_height - 2 * drawer_wall_thickness;
drawer_inner_depth = drawer_outer_depth - 2 * drawer_wall_thickness;

// Full plate exterior size
plate_outer_width = base_unit_width + (Width_Units - 1)*extra_unit_width;
plate_outer_height = base_unit_height + (Height_Units -1)*extra_unit_height;
plate_outer_depth = housing_wall_thickness + back_wall_thickness + base_unit_depth * Depth_Units + 2;


module housing_back_opening(lip_increment) {
    translate([
        housing_outer_depth-back_wall_thickness,
        lip_increment / 2 * housing_wall_thickness,
        lip_increment / 2 * housing_wall_thickness
        ])
    chamferCube(
        [
            back_wall_thickness,
            housing_outer_width-lip_increment*housing_wall_thickness,
            housing_outer_height-lip_increment*housing_wall_thickness
        ],
        [[1, 1, 1, 1], [0, 0, 0, 0], [0, 0, 0, 0]], chamfer_amount-0.5
    );
}

module housing_back_honeycomb(lip_increment) {
    // Rear
    translate([
        housing_outer_depth-back_wall_thickness,
        housing_outer_width/2,
        housing_outer_height/2,
    ])
    wall_honeycomb(
        housing_outer_width-2*housing_wall_thickness-2*lip_increment,
        housing_outer_height-2*housing_wall_thickness-2*lip_increment,
        back_wall_thickness,
        sideways=true
    );
}

module housing_top_diamond(lip_increment) {
    if (Width_Units > 1) for (unit = [1:Width_Units-1]) {
        translate([
            housing_outer_depth - (housing_wall_thickness + lip_increment),
            base_unit_width * unit,
            housing_outer_height - housing_wall_thickness
        ])
        wall_diamonds(Depth_Units, housing_wall_thickness, lip_increment);
    }
}

module housing_bottom_diamond(lip_increment) {
    if (Width_Units > 1) for (unit = [1:Width_Units-1]) {
        translate([
            housing_outer_depth - (housing_wall_thickness + lip_increment),
            base_unit_width * unit,
            0,
        ])
        wall_diamonds(Depth_Units, housing_wall_thickness, lip_increment);
    }
}

module housing_left_wall_diamond(lip_increment) {
    if (Height_Units > 0.5) for (unit = [1:Height_Units*2-1]) {
        rotate([270,0,0])
        translate([
            housing_outer_depth - (housing_wall_thickness + lip_increment),
            -base_unit_height/2 * unit,
            (housing_outer_width - housing_wall_thickness)
        ])
        wall_diamonds(Depth_Units, housing_wall_thickness, lip_increment);
    }
}

module housing_right_wall_diamond(lip_increment) {
    if (Height_Units > 0.5) for (unit = [1:Height_Units*2-1]) {
        rotate([270,0,0])
        translate([
            housing_outer_depth - (housing_wall_thickness + lip_increment),
            -base_unit_height/2 * unit,
            0
        ])
        wall_diamonds(Depth_Units, housing_wall_thickness, lip_increment);
    }
}

module housing_top_honeycomb(lip_increment) {
    translate([
        housing_outer_depth/2,
        housing_outer_width/2,
        housing_outer_height,
    ])
    rotate([0,90,0])
    wall_honeycomb(
        housing_outer_width-2*housing_wall_thickness-2*lip_increment,
        housing_outer_depth-2*housing_wall_thickness-2*lip_increment,
        back_wall_thickness,
        sideways=true,
        partial=false
    );
}

module housing_bottom_honeycomb(lip_increment) {
    translate([
        housing_outer_depth/2,
        housing_outer_width/2,
        housing_wall_thickness,
    ])
    rotate([0,90,0])
    wall_honeycomb(
        housing_outer_width-2*housing_wall_thickness-2*lip_increment,
        housing_outer_depth-2*housing_wall_thickness-2*lip_increment,
        back_wall_thickness,
        sideways=true,
        partial=false
    );
}

module housing_right_wall_honeycomb(lip_increment) {
    translate([
        housing_outer_depth/2,
        0,
        housing_outer_height/2,
    ])
    rotate([0,0,90])
    wall_honeycomb(
        housing_outer_depth-2*housing_wall_thickness-2*lip_increment,
        housing_outer_height-2*housing_wall_thickness-2*lip_increment,
        housing_wall_thickness,
        sideways=false,
        partial=false
    );
}

module housing_left_wall_honeycomb(lip_increment) {
    translate([
        housing_outer_depth/2,
        housing_outer_width - housing_wall_thickness,
        housing_outer_height/2,
    ])
    rotate([0,0,90])
    wall_honeycomb(
        housing_outer_depth-2*housing_wall_thickness-2*lip_increment,
        housing_outer_height-2*housing_wall_thickness-2*lip_increment,
        housing_wall_thickness,
        sideways=false,
        partial=false
    );
}

module housing_box() {
    // thickness reduction factor
    trf = 2 * Housing_Wall_Thickness_Ratio;
    difference() {
        // Create box and remove the interior
        chamferCube(
            [
                housing_outer_depth,
                housing_outer_width,
                housing_outer_height
            ],
            [[1, 1, 1, 1], 0, 0],
            chamfer_amount
        );
        translate([-(back_wall_thickness - Drawer_Tolerance), housing_wall_thickness, housing_wall_thickness])
        chamferCube([
                housing_outer_depth,
                housing_outer_width - 2 * housing_wall_thickness,
                housing_outer_height - 2 * housing_wall_thickness
            ], [[1, 1, 1, 1], 0, 0],
            chamfer_amount - 0.5
        );
        // Reduce interior wall thickness
        translate([
            housing_wall_thickness * 2,
            housing_wall_thickness / 2 * trf,
            housing_wall_thickness / 2 * (Width_Units <= 1 ? (4 - trf) : trf)
        ])
        chamferCube([
                (
                    housing_outer_depth - (back_wall_thickness - Drawer_Tolerance)
                ) - housing_wall_thickness * 4,
                housing_outer_width - housing_wall_thickness * trf,
                housing_outer_height - housing_wall_thickness * (Width_Units <= 1 ? 2 : trf)
            ], [[1, 1, 1, 1], [1, 1, 1, 1], [1, 1, 1, 1]],
            chamfer_amount - 0.5
        );
        // Render walls
        if (Housing_Back_Wall_Fill == -1) housing_back_opening(3);
        else if (Housing_Back_Wall_Fill == 3) housing_back_honeycomb(3);

        if (Housing_Top_Fill == 1) housing_top_diamond(2);
        else if (Housing_Top_Fill == 3) housing_top_honeycomb(3);

        if (Housing_Bottom_Fill == 1) housing_bottom_diamond(2);
        else if (Housing_Bottom_Fill == 3) housing_bottom_honeycomb(3);

        if (Housing_Left_Wall_Fill == 1) housing_left_wall_diamond(2);
        else if (Housing_Left_Wall_Fill == 3) housing_left_wall_honeycomb(3);

        if (Housing_Right_Wall_Fill == 1) housing_right_wall_diamond(2);
        else if (Housing_Right_Wall_Fill == 3) housing_right_wall_honeycomb(3);
    }
}

module housing_connector_add() {
    // Top
    for (unit = [1:Width_Units]) {
        translate([0,(unit-1)*extra_unit_width+base_unit_width/2,housing_outer_height])
        union() {
            dovetail_connector(housing_outer_depth);
            dovetail_connector_support(housing_outer_depth, channel=false);
        }
    }
    // Right
    for (unit = [0:0.5:Height_Units-0.5]) {
        rotate([90,0,0])
        translate([0,unit*extra_unit_height+base_unit_height/4,0])
        union() {
            dovetail_connector(housing_outer_depth);
            dovetail_connector_support(housing_outer_depth, channel=false);
        }
    }
    // Left
    for (unit = [0:0.5:Height_Units-0.5]) {
        rotate([90,0,0])
        translate([
            0,
            unit*extra_unit_height+base_unit_height/4,
            -housing_outer_width+housing_wall_thickness
        ])
        dovetail_connector_support(housing_outer_depth, channel=true);
    }
    // Bottom
    for(unit = [1:Width_Units]) {
        translate([0, (unit-1)*extra_unit_width, housing_wall_thickness])
        translate([0, base_unit_width/2, 0])
        dovetail_connector_support(housing_outer_depth, channel=true);
    }
}

module housing_connector_subtract() {
    // Left
    for (unit = [0:0.5:Height_Units-0.5]) {
        rotate([90,0,0])
        translate([
            0,
            unit*extra_unit_height+base_unit_height/4,
            -housing_outer_width
        ])
        dovetail_channel(housing_outer_depth);
    }
    // Bottom
    for(unit = [1:Width_Units]) {
        translate([0,(unit-1)*extra_unit_width,0])
        translate([0,base_unit_width/2])
        dovetail_channel(housing_outer_depth);
    }
}

module housing() {
    union() {
        difference() {
            union() {
                housing_box();
                if (Add_Connectors) {
                    housing_connector_add();
                }
            }
            if (Add_Connectors) {
                housing_connector_subtract();
            }
        }
        if (Enable_Drawer_Catch) {
            // Create drawer catches
            for (unit = [1:Width_Units]) {
                translate([Catch_Setback,(unit-1)*extra_unit_width,housing_outer_height-housing_wall_thickness]) drawer_catch();
            }
        }
    }
}

module housing_render() {
    color("aliceblue")
    if (Preview_Full_Render) {
        render()
        housing();
    } else {
        housing();
    }
}

module drawer_catch() {
    cw = dovetail_size * 3;
    cs = Catch_Size;
    translate([cs,base_unit_width / 2 + cw/2,-cs])
    rotate([90,0,0])
    linear_extrude(height=cw)
    polygon(
        points=[
            [-cs/4, 0],
            [cs/4, 0],
            [cs, cs],
            [-cs, cs]
        ]
    );
}

module drawer_front_honeycomb(lip_increment) {
    // Front
    translate([
        0,
        drawer_outer_width/2,
        drawer_outer_height/2,
    ])
    wall_honeycomb(
        drawer_inner_width-2*lip_increment,
        drawer_inner_height-2*lip_increment,
        drawer_wall_thickness,
        sideways=true,
        partial=false
    );
}

module drawer_back_honeycomb(lip_increment) {
    // Back
    translate([
        drawer_outer_depth - drawer_wall_thickness,
        drawer_outer_width/2,
        drawer_outer_height/2,
    ])
    wall_honeycomb(
        drawer_inner_width-2*lip_increment,
        drawer_inner_height-2*lip_increment,
        drawer_wall_thickness,
        sideways=true,
        partial=false
    );
}

module drawer_side_honeycomb(lip_increment, height_ratio=1.0) {
    // Left
    translate([
        drawer_outer_depth/2,
        drawer_outer_width - drawer_wall_thickness,
        drawer_outer_height/2 * height_ratio,
    ])
    rotate([0,0,90])
    wall_honeycomb(
        drawer_inner_depth-2*lip_increment,
        (drawer_inner_height-2*lip_increment) * height_ratio,
        drawer_wall_thickness,
        sideways=true,
        partial=false
    );

    // Right
    translate([
        drawer_outer_depth/2,
        0,
        drawer_outer_height/2 * height_ratio,
    ])
    rotate([0,0,90])
    wall_honeycomb(
        drawer_inner_depth-2*lip_increment,
        (drawer_inner_height-2*lip_increment) * height_ratio,
        drawer_wall_thickness,
        sideways=true,
        partial=false
    );
}

module drawer_box(base_height_reduction=0) {
    height_ratio_auto_min = (Drawer_Bottom_Type == 0 ? Thinner_Base ? 0.02 : 0.055 : 0.1);
    height_ratio = (Drawer_Bottom_Type >= 0 && Width_Units <= 2) ? height_ratio_auto_min : Drawer_Sides_Height_Ratio;
    if (Drawer_Sides_Height_Ratio > 0 && Drawer_Bottom_Type >= 0 && Width_Units <= 2) {
        echo("Automatically removing drawer sides with this configuration");
    }
    difference() {
        chamferCube([drawer_outer_depth, drawer_outer_width, drawer_outer_height], [[1, 1, 1, 1], 0, 0], chamfer_amount-0.5);
        translate([
            drawer_wall_thickness,
            drawer_wall_thickness,
            (
                Drawer_Bottom_Type >= 0
                    ? (
                        Drawer_Bottom_Type >= 1 ? h_base * 2 : h_base * 2
                        ) - 0.7
                    : drawer_wall_thickness
            ) - base_height_reduction
        ])
            chamferCube([
                    drawer_outer_depth - 2 * drawer_wall_thickness,
                    drawer_outer_width - 2 * drawer_wall_thickness,
                    drawer_outer_height
                ],
                [(Drawer_Bottom_Type >= 0) ? 0 : [1, 1, 0, 0], 0, 0],
                chamfer_amount - 0.5 * 2
            );
        // Reduce or remove drawer sides
        translate([0, 0, drawer_outer_height * height_ratio + 2 * drawer_wall_thickness])
        union() {
            translate([drawer_wall_thickness, 0, 0])
            cube([
                drawer_outer_depth - 2 * drawer_wall_thickness,
                drawer_wall_thickness,
                (
                    drawer_outer_height - drawer_wall_thickness * 2
                ) * (1 - height_ratio)
            ]);
            translate([drawer_wall_thickness, drawer_outer_width - drawer_wall_thickness, 0])
            cube([
                drawer_outer_depth - 2 * drawer_wall_thickness,
                drawer_wall_thickness,
                (
                    drawer_outer_height - drawer_wall_thickness * 2
                ) * (1 - height_ratio)
            ]);
        }
        // Remove drawer pull interior
        if (Pull_Type >= 1) {
            if (!Enable_Drawer_Face_Behind_Pull) {
                translate([drawer_wall_thickness,drawer_outer_width*0.5,drawer_outer_height+drawer_wall_thickness])
                rotate([270,0,90])
                linear_extrude(height=drawer_wall_thickness)
                drawer_pull_handle_interior();
            }
        } else if (Pull_Type == 0) {
            drawer_pull_screw_holes(diameter=Pull_Screw_Hole_Diameter, separation=Pull_Screw_Hole_Separation);
        }
        // Apply back and wall fills
        if (Drawer_Face_Fill == 3 && Height_Units > 0.5) {
            drawer_front_honeycomb(1);
        }
        if (Drawer_Back_Wall_Fill == 3 && Height_Units > 0.5) {
            drawer_back_honeycomb(1);
        }
        if (Drawer_Side_Wall_Fill == 3 && Height_Units > 0.5) {
            drawer_side_honeycomb(1, height_ratio);
        }
    }
}

module drawer_pull_handle_shape_triangular_pull(width_units, scale_factor, variant=1) {
    module half_circle_cylinder(size) {
        linear_extrude(height=size)
        difference() {
            circle(size, $fn=20);
            translate([-size, -size])
            square([size*2, size]);
        }
    }

    base_height = drawer_handle_base_size * scale_factor;

    width_offset = base_height / 2 + (width_units - 1) * (base_unit_width / 8);
    angle_offset = 12 / (3 - scale_factor);
    height = base_height * 0.75;
    depth = base_height / 2;
    cyl_point_size = 2.0;

    translate([0, 0, -(height)])
    rotate([90,0,0])
    hull()
    union() {
        for(x = [0:1:1]) {
            mirror([x,0,0])
            translate([width_units * 2, 0, 0])
            rotate([90,0,0])
            union() {
                translate([width_offset - angle_offset, depth, -height])
                half_circle_cylinder(cyl_point_size);
                translate([width_offset, 0, -height])
                half_circle_cylinder(cyl_point_size);
                translate([variant == 1 ? width_offset / 2 : width_offset, 0, 0])
                half_circle_cylinder(cyl_point_size);
            }
        }
    }
}

module drawer_pull_handle_shape_cup_pull(width_units, scale_factor) {
    base_height = drawer_handle_base_size * 1.4 * scale_factor;
    hw = base_height;
    width_offset = max(0, (width_units - 2)) * (base_unit_width / 4);
    module circle_quarter(size) {
        intersection() {
            circle(d=size);
            square(size);
        }
    }

    module sphere_eighth(size) {
        rotate_extrude(angle=90, $fn=100)
        circle_quarter(size);
    }

    union() {
        translate([width_offset, 0, 0])
        rotate([90,90,0])
        sphere_eighth(hw);

        translate([width_offset, 0, 0])
        rotate([180,90,0])
        linear_extrude(height=width_offset* 2, $fn=100)
        circle_quarter(hw);

        translate([-width_offset, 0, 0])
        rotate([90,90,270])
        sphere_eighth(hw);
    }
}

module drawer_pull_handle_shape_conical_pull(width_units, scale_factor) {
    base_height = drawer_handle_base_size * 1.4 * scale_factor;
    hw = base_height *0.65;
    width_offset = max(0, (width_units - 2)) * (base_unit_width / 4);
    hh = base_height / 2;
    rotate([0,180,0])
    difference() {
        union() {
            translate([-width_offset,0,0])
            cylinder(hw, hh, $fn=100);

            translate([width_offset,0,0])
            cylinder(hw, hh, $fn=100);

            translate([width_offset,0,0])
            rotate([-90,0,90])
            linear_extrude(height=2 * width_offset)
            projection()
            rotate([90,0,0])
            cylinder(hw, hh);
        }
        translate([-hw * 2 * Width_Units, 0, -1])
        cube([hw * 4 * Width_Units, hh, hw * 1.1]);
    }
}

module drawer_pull_handle_shape() {
    scale_factor = (Height_Units <= 0.5 || Width_Units <= 1 ? 1 : 2);
    if (Pull_Type == 1) {
        drawer_pull_handle_shape_conical_pull(Width_Units, scale_factor);
    } else if (Pull_Type == 2) {
        drawer_pull_handle_shape_cup_pull(Width_Units, scale_factor);
    } else if (Pull_Type == 3) {
        drawer_pull_handle_shape_triangular_pull(Width_Units, scale_factor);
    } else if (Pull_Type == 4) {
        drawer_pull_handle_shape_triangular_pull(Width_Units, scale_factor, variant=2);
    }
}

module drawer_pull_handle_interior() {
    projection(cut=true)
    translate([0,0,drawer_wall_thickness])
    rotate([90,0,0])
    drawer_pull_handle_shape();
}

module drawer_pull_handle() {
    cut_scale_adjust = (Pull_Type >= 2) ? (1.0 - 0.03 / Width_Units * 3) : 1.0;
    cut_height_adjust = (Pull_Type >= 2) ? 1.5 : 1.0;
    translate([0, drawer_wall_thickness, 0])
    difference() {
        drawer_pull_handle_shape();
        scale([cut_scale_adjust, 1.0, 1.0])
        translate([0, drawer_handle_base_size / 18, drawer_wall_thickness * cut_height_adjust])
        drawer_pull_handle_shape();
    }
}

module drawer_handle() {
    if (Pull_Type >= 1) {
        translate([0,drawer_outer_width*0.5,drawer_outer_height])
        rotate([0,0,270])
        drawer_pull_handle();
    }
}

module drawer_pull_screw_holes(diameter=3.0, separation=10.0) {
    for(i = [-1:2:1]) {
        translate([0, drawer_outer_width / 2 + i * separation / 2, drawer_outer_height / 2])
        rotate([90,0,90])
        linear_extrude(height=drawer_wall_thickness)
        circle(d=diameter, $fn=20);
    }
}

module drawer_gridfinity_baseplate_cut() {
    if (Drawer_Bottom_Type >= 0) {
        translate([drawer_inner_depth/2 + drawer_wall_thickness, drawer_inner_width/2 + drawer_wall_thickness, 0])
        gridfinity_baseplate_cut(Width_Units, Depth_Units, Drawer_Bottom_Type, Gridfinity_Base_Fill, extrude=(Drawer_Bottom_Type == 0), deep=true);
    }
}

module drawer() {
    base_height_reduction = (Thinner_Base == true
        ? (Drawer_Bottom_Type == 0
            ? h_base - (Width_Units <= 1 ? 0.6 : drawer_wall_thickness)
            : 0)
        : 0);
    union() {
        difference() {
            union() {
                drawer_box(base_height_reduction);
                drawer_handle();
            }
            translate([0, 0, -base_height_reduction])
            drawer_gridfinity_baseplate_cut();
        }
    }
}

module drawer_render() {
    color("darkseagreen")
    if (Preview_Full_Render) {
        render()
        drawer();
    } else {
        drawer();
    }
}

module plate_back_honeycomb(lip_increment) {
    // Rear
    translate([
        0,
        plate_outer_width/2,
        plate_outer_height/2,
    ])
    wall_honeycomb(
        plate_outer_width-2*housing_wall_thickness-2*lip_increment,
        plate_outer_height-2*housing_wall_thickness-2*lip_increment,
        back_wall_thickness,
        sideways=true
    );
}


module plate_bottom_diamond(lip_increment) {
    if (Width_Units > 1) for (unit = [1:Width_Units-1]) {
        translate([
            plate_outer_depth - (housing_wall_thickness + lip_increment),
            base_unit_width * unit,
            0,
        ])
        wall_diamonds(Depth_Units, housing_wall_thickness, lip_increment);
    }
}

module plate_bottom_honeycomb(lip_increment) {
    translate([
        plate_outer_depth/2,
        plate_outer_width/2,
        housing_wall_thickness,
    ])
    rotate([0,90,0])
    wall_honeycomb(
        plate_outer_width-2*housing_wall_thickness-2*lip_increment,
        plate_outer_depth-2*housing_wall_thickness-2*lip_increment,
        housing_wall_thickness,
        sideways=true,
        partial=false
    );
}

module baseplate_bottom_box() {
    render()
    difference() {
        translate([0,0,-housing_wall_thickness])
        chamferCube(
            [
                plate_outer_depth,
                plate_outer_width,
                housing_wall_thickness * 2,
            ],
            [[1, 1, 1, 1], 0, 0],
            chamfer_amount
        );
        translate([0,0,-housing_wall_thickness])
        cube([
            plate_outer_depth,
            plate_outer_width,
            housing_wall_thickness
        ]);
    }
}

module baseplate_top_box() {
    enable_back = Top_Plate_Type == 1 && Enable_Top_Plate_Back;
    enabled_side_count = (Enable_Top_Plate_Left_Side ? 1 : 0) + (Enable_Top_Plate_Right_Side ? 1 : 0);
    enable_sides = Top_Plate_Type == 1 && enabled_side_count;
    render()
    difference() {
        chamferCube(
            [
                plate_outer_depth,
                plate_outer_width,
                plate_outer_height,
            ],
            [[1, 1, 1, 1], 0, 0],
            chamfer_amount
        );
        translate([
            enable_back ? back_wall_thickness : 0,
            Enable_Top_Plate_Left_Side ? housing_wall_thickness : 0,
            housing_wall_thickness + (
                Top_Plate_Base_Type >= 0
                    ? (Top_Plate_Base_Type == 0 ? h_base : h_base * 1.5)
                    : 0
            )
        ])
        chamferCube(
            [
                plate_outer_depth + (enable_back ? 0 : back_wall_thickness * 2),
                plate_outer_width - housing_wall_thickness * enabled_side_count,
                plate_outer_height,
            ],
            [
                Top_Plate_Base_Type < 0
                    ? [Enable_Top_Plate_Left_Side ? 1 : 0, Enable_Top_Plate_Right_Side ? 1 : 0, 0, 0]
                    : 0,
                (enable_back && Top_Plate_Base_Type < 0) ? [1, 0, 0, 0] : 0,
                0
            ],
            chamfer_amount
        );
    }
}

module baseplate_shelf_walls_cut() {
    for (side = [0:1:1]) {
        sz = (
            min(Height_Units * base_unit_height, Depth_Units * base_unit_depth)
            - housing_wall_thickness - h_base * 1.5
        );
        rotate([90,180,0])
        translate([
            -plate_outer_depth,
            -plate_outer_height,
            -(side ? housing_wall_thickness : plate_outer_width)
        ])
        linear_extrude(height=housing_wall_thickness)
        polygon([
            [0, 0],
            [0, sz],
            [sz, 0],
        ]);
    }
}

module plate_gridfinity_baseplate_cut(gf_type) {
    translate([
        plate_outer_depth / 2,
        plate_outer_width / 2,
        Top_Plate_Base_Type > 0 ? h_base / 2 : 0
    ])
    difference() {
        gridfinity_baseplate_cut(Width_Units, Depth_Units, gf_type, extrude=false, deep=false);
        translate([0,0,-h_base*.5])
        cube([plate_outer_depth, plate_outer_width, h_base * 2], center=true);
    }
}

module plate_box() {
    difference() {
        // Create baseplate
        if (Plate_Model_Type == 0) baseplate_bottom_box(); else baseplate_top_box();
        // Create Gridfinity baseplate
        if (Plate_Model_Type == 1 && Top_Plate_Base_Type >= 0) plate_gridfinity_baseplate_cut(Top_Plate_Base_Type);
        // Render walls

        if (Plate_Fill == 1) plate_bottom_diamond(2);
        else if (Plate_Fill == 3) plate_bottom_honeycomb(3);

        if (Plate_Model_Type == 1 && Enable_Top_Plate_Back) {
            if (Top_Plate_Back_Wall_Fill == 3) plate_back_honeycomb(3);
        }
    }
}

module plate_connector_add() {
    if (Plate_Model_Type == 1) {
        // Top plate dovetail channel supports
        for(unit = [1:Width_Units]) {
            translate([0, (unit-1)*extra_unit_width, housing_wall_thickness])
            translate([0, base_unit_width/2, 0])
            dovetail_connector_support(plate_outer_depth, channel=true);
        }
    } else {
        // Bottom plate dovetail connectors
        for (unit = [1:Width_Units]) {
            translate([
                plate_outer_depth,
                (unit - 1) * extra_unit_width+base_unit_width / 2,
                housing_wall_thickness
            ])
            rotate([0,0,180])
            union() {
                dovetail_connector(plate_outer_depth);
                dovetail_connector_support(plate_outer_depth, channel=false);
            }
        }
    }
}

module plate_connector_subtract() {
    if (Plate_Model_Type == 1) {
        // Top plate dovetail channels
        for(unit = [1:Width_Units]) {
            translate([0,(unit-1)*extra_unit_width,0])
            translate([0,base_unit_width/2])
            dovetail_channel(plate_outer_depth);
        }
    }
}

module plate() {
    union() {
        difference() {
            union() {
                plate_box();
                if (Add_Connectors) {
                    plate_connector_add();
                }
            }
            if (Add_Connectors) {
                plate_connector_subtract();
            }
            baseplate_shelf_walls_cut();
        }
    }
}

module plate_render() {
    color("powderblue")
    if (Preview_Full_Render) {
        render()
        plate();
    } else {
        plate();
    }
}

module housing_cross_section(slice_depth=1) {
    translate([
        0, -housing_wall_thickness, -housing_wall_thickness
    ])
    difference() {
        cube([
            housing_outer_depth + 2 * housing_wall_thickness,
            housing_outer_width + 2 * housing_wall_thickness,
            housing_outer_height + 2 * housing_wall_thickness
        ]);
        translate([
            Catch_Size / 2, 0, 0
        ])
        cube([
            slice_depth,
            housing_outer_width + 2 * housing_wall_thickness,
            housing_outer_height + 2 * housing_wall_thickness
        ]);
    }
}

module main_render() {
    if (Render_Position == 0) {
        // Print Orientation
        if (Create_Drawer) {
            translate([drawer_outer_width / 2, -housing_outer_depth, 0])
            rotate([0,0,90])
            drawer_render();
        }
        if (Create_Housing) {
            translate([housing_outer_width/2, 0, housing_outer_depth])
            rotate([0,90,90])
            housing_render();
        }
        if (Create_Top_or_Bottom_Plate) {
            rotate([0,0, !(Create_Housing || Create_Drawer) ? 180 : 0])
            translate([plate_outer_width/2, (Create_Housing ? housing_outer_height + 5 : 0), 0])
            rotate([0,0,90])
            plate_render();
        }
    } else {
        rotate([0,0,90])
        union() {
            if (Create_Housing) {
                translate([0, -housing_outer_width / 2, 0])
                housing_render();
            }
            if (Create_Drawer) {
                translate([
                    (Render_Position == 2
                        ? (Catch_Setback + 5 * Catch_Size) - housing_outer_depth
                        : 0),
                    -drawer_outer_width / 2,
                    (
                        -(drawer_outer_height - housing_outer_height) / 2
                        + (Render_Position == 3
                            ? housing_outer_height
                            : 0)
                    )
                ])
                drawer_render();
            }
            if (Create_Top_or_Bottom_Plate) {
                translate([
                    plate_outer_depth,
                    plate_outer_width / 2,
                    Render_Position == 3
                        ? -(5 + plate_outer_height)
                        : housing_outer_height + 5
                    ])
                rotate([0,0,180])
                plate_render();
            }
        }
    }
}

if (Housing_Cross_Section) {
    slice_depth = Catch_Setback + 1.8 * Catch_Size;
    translate([housing_outer_width/2, 0, slice_depth])
    rotate([0,90,90])
    difference() {
        housing();
        if (Housing_Cross_Section) housing_cross_section(slice_depth=slice_depth);
    }
} else {
    main_render();
}
