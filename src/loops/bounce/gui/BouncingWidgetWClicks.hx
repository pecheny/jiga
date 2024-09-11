package loops.bounce.gui;

import haxe.ds.ReadOnlyArray;
import a2d.Widget2DContainer;
import al.layouts.data.LayoutData.FractionSize;
import ec.Signal;
import ecbind.ClickInputBinder;
import gl.sets.ColorSet;
import graphics.ShapesColorAssigner;
import graphics.shapes.QuadGraphicElement;
import shimp.ClicksInputSystem;
import fu.ui.ButtonBase;
import fu.graphics.ColouredQuad;
import fu.graphics.ShapeWidget;
import a2d.Widget;

using al.Builder;
using a2d.transform.LiquidTransformer;
using a2d.transform.LiquidTransformer;

class BouncingWidget extends Widget {
    var region:RegionButton;
    var cont:Widget2DContainer;
    var regions:Array<RegionButton> = [];
    var poiter:SlidingTriPointer<ColorSet>;
    var inited = false;

    @:once public var fui:FuiBuilder;
    public var action(default, null):Signal<Int->Void> = new Signal();

    // public function setRegion(pos:Float, size:Float) {}
    // var weights = [0.3, 0.2, 0.5];
    // todo avoid nandlers, just return index of region // view lack o data

    override function init() {
        if (inited)
            return;
        inited = true;
        cont = Builder.createContainer(w, horizontal, Center);
        for (w in 0...3) {
            var size = new FractionSize(0);
            region = new RegionButton(Builder.widget(size).withLiquidTransform(fui.ar.getAspectRatio()), regionHandler, w, size);
            Builder.addWidget(cont, region.widget());
            regions.push(region);
        }
        // rndReroll();
        poiter = createPointer();
        initRegioViews();
    }

    function createPointer() {
        var poinWdg = Builder.widget().withLiquidTransform(fui.ar.getAspectRatio());
        for (a in Axis2D)
            w.axisStates[a].addSibling(poinWdg.axisStates[a]);
        var attrs = ColorSet.instance;
        var shw = new ShapeWidget(attrs, poinWdg);
        var poin = new SlidingTriPointer(attrs);
        shw.addChild(poin);
        w.entity.addChild(poinWdg.entity);
        var colors = new ShapesColorAssigner(attrs, 0, shw.getBuffer());
        return poin;
    }

    public function setT(t:Float) {
        poiter.t = t;
    }

    function regionHandler(index) {
        action.dispatch(index);
    }

    var weights:ReadOnlyArray<Float> = [];

    public function initRegions(weights:ReadOnlyArray<Float>) {
        this.weights = weights;
        if(inited)
            initRegioViews();
    }

    public function initRegioViews() {
        if (weights.length > regions.length)
            throw "Not enaugh regions inited";
        for (i in 0...weights.length) {
            var w = weights[i];
            var r = regions[i];
            r.setType(i % 2 == 0 ? miss : hit);
            @:privateAccess r.size.value = w;
        }
        cont.refresh();
        invalidateInput();
    }

    public function rerolls(splits:Array<Float>) {
        var lastSplit = 0.;
        inline function initRegion(i, w) {
            var r = regions[i];
            r.setType(i % 2 == 0 ? miss : hit);
            @:privateAccess r.size.value = w;
        }
        for (i in 0...splits.length) {
            var w = splits[i] - lastSplit;
            lastSplit = splits[i];
            initRegion(i, w);
        }
        initRegion(splits.length, 1 - lastSplit);
        cont.refresh();
        invalidateInput();
    }

    function rndReroll() {
        var total = 1.;
        var isHit = false;
        for (r in regions) {
            var roll = Math.random() * total;
            total -= roll;
            r.setType(cast isHit);
            isHit = !isHit;
            @:privateAccess r.size.value = roll;
        }
        cont.refresh();
        invalidateInput();
    }

    function invalidateInput() {
        var clcks = w.entity.getComponentUpward(ClickInputBinder);
        if(clcks == null)
            return;
        var sys = @:privateAccess clcks.system;
        if (Std.isOfType(sys, ClicksInputSystem))
            @:privateAccess cast(sys, ClicksInputSystem<Dynamic>).processPosition();
    }
}

class RegionButton extends ButtonBase {
    public var size:FractionSize;

    var colors:ShapesColorAssigner<ColorSet>;
    var index:Int;

    public function new(w, h, index, s) {
        this.myhandl = h;
        this.index = index;
        this.size = s;
        super(w, _handler);
        var attrs = ColorSet.instance;
        var shw = new ShapeWidget(attrs, w);
        shw.addChild(new QuadGraphicElement(attrs));
        colors = new ShapesColorAssigner(attrs, 0, shw.getBuffer());
        // @:privateAccess colors.cp.setAlpha(155);
        var viewProc:ClickViewProcessor = w.entity.getComponent(ClickViewProcessor);
        if (viewProc != null) {
            // viewProc.addHandler(new InteractiveColors(colors.setColor).viewHandler);
            // viewProc.addHandler(new InteractiveTransform(w).viewHandler);
        }
    }

    dynamic function myhandl(index:Int) {}

    function _handler() {
        myhandl(index);
    }

    public function setType(t:BouncingResult) {
        colors.setColor(switch t {
            case hit: 0xff0000;
            case miss: 0xc0c0c0;
        });
    }
}

enum abstract BouncingResult(Bool) {
    var hit = true;
    var miss = false;
}
