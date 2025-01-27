package rgfl;

import a2d.Placeholder2D;
import fu.graphics.ShapeWidget;
import gl.sets.ColorSet;
import graphics.shapes.QuadGraphicElement;
import graphics.shapes.RectWeights;

class PosMarker extends ShapeWidget<ColorSet> {
    var quad:QuadGraphicElement<ColorSet>;

    override function createShapes() {
        quad = new QuadGraphicElement(attrs);
        addChild(quad);
        onShapesDone.listen(fillColor);
    }

    function fillColor() {
        var b = getBuffer().getBuffer();
        attrs.writeColor(b, 0xffb300, 0, getBuffer().getVertCount());
    }

    public function setTo(parent:Placeholder2D, target:Placeholder2D) {
        if (!inited)
            return;
        for (a in Axis2D) {
            var mgn = 0.01;
            var pa = parent.axisStates[a];
            var ta = target.axisStates[a];
            var lpos = (ta.getPos() - pa.getPos()) / pa.getSize() - mgn;

            var ref = RectWeights.weights;
            for (i in 0...ref[a].length) {
                quad.weights[a][i] = lpos + ref[a][i] * (ta.getSize() / pa.getSize() + mgn * 2);
            }
        }
    }
}
