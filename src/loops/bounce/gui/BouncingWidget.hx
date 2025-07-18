package loops.bounce.gui;

import fu.graphics.ShapeWidget;
import loops.bounce.BouncingLoop;
import widgets.Label;
import loops.bounce.BouncingTimeline.RegionStateProvider;
import a2d.Widget2DContainer;
import al.layouts.data.LayoutData.FractionSize;
import gl.sets.ColorSet;
import graphics.ShapesColorAssigner;
import graphics.shapes.QuadGraphicElement;
import haxe.ds.ReadOnlyArray;
import a2d.Widget;

using al.Builder;
using a2d.transform.LiquidTransformer;
using a2d.transform.LiquidTransformer;

class BouncingWidget extends Widget implements BouncingGui {
    var weights:ReadOnlyArray<Float> = [];
    var cont:Widget2DContainer;
    var regions:Array<RegionButton> = [];
    var poiter:SlidingTriPointer<ColorSet>;
    var inited = false;
    var maxRegions = 15;
    var hitRemains:Label;
    var colors:ShapesColorAssigner<ColorSet>;

    @:once public var regionsData:RegionStateProvider;
    @:once public var fui:FuiBuilder;

    override function init() {
        if (inited)
            return;
        inited = true;
        cont = Builder.createContainer(ph, horizontal, Center);
        for (w in 0...maxRegions) {
            var size = new FractionSize(0);
            var region = new RegionButton(Builder.widget(size).withLiquidTransform(fui.ar.getAspectRatio()), w, size);
            Builder.addWidget(cont, region.ph);
            regions.push(region);
        }
        // rndReroll();
        poiter = createPointer();
        var b = fui.placeholderBuilder;
        hitRemains = new Label(b.v(pfr, 0.2).b(), fui.textStyles.defaultStyle());
        Builder.createContainer(ph.sibling(), vertical, Backward).withChildren([Builder.widget(), hitRemains.ph]);

        initRegioViews();
        regionsData.onChange.listen(initRegioViews);
    }

    function createPointer() {
        var poinWdg = Builder.widget().withLiquidTransform(fui.ar.getAspectRatio());
        for (a in Axis2D)
            ph.axisStates[a].addSibling(poinWdg.axisStates[a]);
        var attrs = ColorSet.instance;
        var shw = new ShapeWidget(attrs, poinWdg);
        var poin = new SlidingTriPointer(attrs);
        shw.addChild(poin);
        ph.entity.addChild(poinWdg.entity);
        colors = new ShapesColorAssigner(attrs, 0, shw.getBuffer());
        return poin;
    }

    public function setT(t:Float) {
        poiter.t = t;
    }
    
    public function setState(state:BouncingWidgetState) {
        colors.setColor(
        switch state {
            case bouncing: 0;
            case presenting: 0xffffff;
        });
    }

    public function initRegions(weights:ReadOnlyArray<Float>) {
        this.weights = weights;
        if (inited)
            initRegioViews();
    }

    public function setHitsRemain(n:Int) {
        hitRemains.withText("" + n);
    }

    public function initRegioViews() {
        if (weights.length > regions.length)
            throw "Not enaugh regions inited";
        for (i in 0...regions.length) {
            var w = weights.length > i ? weights[i] : 0;
            var r = regions[i];
            @:privateAccess r.size.value = w;
            var def = regionsData.getRegionDef(i);
            if (def != null) {
                var active = regionsData.getRegionExecCount(i) < def.activationsNumber;
                r.setType(def.regionDef, active);
            } else {
                r.setType(null, true);
            }
        }
        cont.refresh();
    }
}


interface RegionColorMap {
    function getColor(def:Dynamic, isActive:Bool):Int;
}

class RegionButton extends ShapeWidget<ColorSet> {
    public var size:FractionSize;

    @:once var c:RegionColorMap;

    var colors:ShapesColorAssigner<ColorSet>;
    var index:Int;

    public function new(ph, index, s) {
        this.index = index;
        this.size = s;
        super(ColorSet.instance, ph);
        addChild(new QuadGraphicElement(attrs));
        colors = new ShapesColorAssigner(attrs, 0, getBuffer());
    }

    public function setType(t:Dynamic, isActive:Bool) {
        colors.setColor(c.getColor(t, isActive));
    }
}
