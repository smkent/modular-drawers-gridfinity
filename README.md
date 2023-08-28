# Gridfinity Modular Interlocking Drawers, OpenSCAD customizable

This is an [OpenSCAD][openscad]-configurable parametric model for modular
interlocking drawers with (optional) [Gridfinity][gridfinity] baseplates.

![Sizing examples](/images/animation_size.gif)
![Configuration examples](/images/animation_options.gif)

An optional top plate / shelf model is included.

![Top plate examples](/images/animation_top_plate.gif)

## Why?

There are a number of other Gridfinity-compatible modular drawer systems, such
as [Modular Gridfinity Drawers][modular-gridfinity-drawers] and
[Gridfinity Modular Workbench Drawers][gridfinity-modular-workbench-drawers].

However, I liked the interlocking look of the drawer housings on models like
[Modular Drawers 2.0 by O3D][o3d-modular-drawers-2], [Modular Small Parts
Drawers by Rich Dionne][modular-small-parts-drawers], and [Interlocking Small
Parts Storage System by JamesThePrinter][interlocking-small-parts-storage], and
[Spiralize/Vase Mode Modular Drawers by RetromanIE][vase-mode-drawers].

I wanted Gridfinity-compatible customizable drawers where the housings interlock
directly without additional parts. In particular, I liked the chamfered look of
O3D's modular drawers.

## Configurable Features

* Arbitrary drawer sizes in Gridfinity increments
* Gridfinity baseplates with or without magnets, or plain drawers
* Wall, base, and back fill for both the drawer and housing
* Drawer catch on housing
* Drawer side height (or none at all)
* Integrated drawer pull or screw holes for a separate pull

## Setup

This model depends on additional submodules.

To set everything up, first clone this repository. Then, in the repository
directory, run:

```console
git submodule init
git submodule update
```

Now the repository's `models.scad` can be opened in OpenSCAD.

## Customizing

The model options appear in OpenSCAD's Customizer:

![Customizer screenshot](/images/customizer.png)

## Model export

When rendering your customized model to export for printing, select "Print
Orientation" for "Render Position" within the top section, Rendering:

![Rendering options](/images/render_options.png)

You may wish to enable the housing or drawer individually for printing.

## Attribution

I used the code for [Grant Emsley's Customizable Bigger Mini Drawers
Ultimate](https://www.printables.com/model/293400) as the starting point for
this model, although the code has been completely rewritten.

This model depends on these components:

* [Chamfers for OpenSCAD][chamfers-for-openscad]
* [Gridfinity Rebuilt in OpenSCAD][gridfinity-rebuilt-openscad]

## Licensing

[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC
BY-NC-SA 4.0)][license]

Third party components have their own licenses.


[chamfers-for-openscad]: https://github.com/SebiTimeWaster/Chamfers-for-OpenSCAD
[gridfinity-modular-workbench-drawers]: https://www.printables.com/model/282728-gridfinity-modular-workbench-drawers
[gridfinity-rebuilt-openscad]: https://github.com/kennetek/gridfinity-rebuilt-openscad
[gridfinity]: https://www.youtube.com/watch?v=ra_9zU-mnl8
[interlocking-small-parts-storage]: https://www.printables.com/model/359558-interlocking-small-parts-storage-system
[license]: https://creativecommons.org/licenses/by-nc-sa/4.0/
[modular-gridfinity-drawers]: https://www.printables.com/model/402298-modular-gridfinity-drawers
[modular-small-parts-drawers]: https://www.printables.com/model/51468-modular-small-parts-drawers
[o3d-modular-drawers-2]: https://www.thingiverse.com/thing:2539830
[openscad]: https://openscad.org/
[vase-mode-drawers]: https://www.printables.com/model/1558-spiralizevase-mode-modular-drawers
