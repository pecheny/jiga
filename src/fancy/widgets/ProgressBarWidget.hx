package fancy.widgets;

import gl.sets.ColorSet;
import graphics.ShapesColorAssigner;
import graphics.shapes.ProgressBar;
import widgets.ShapeWidget;

using al.Builder;
using transform.LiquidTransformer;
using widgets.utils.Utils;


class ProgressBarWidget extends ShapeWidget<ColorSet> {
    var pb = new ProgressBar(ColorSet.instance);

    public function new(w, color=0xffffff) {
        super(ColorSet.instance, w);
        addChild(pb);
        var colors = new ShapesColorAssigner(ColorSet.instance, color, getBuffer());
    }

    public function setPtogress(v) {
        pb.setVal(horizontal, v);
        pb.setVal(vertical, 1);
    }
}