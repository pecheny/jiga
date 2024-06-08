package fancy.widgets;

import al.Builder;
import al.al2d.ChildrenPool;
import al.al2d.Widget2DContainer;
import algl.Builder.PlaceholderBuilderGl;
import fancy.widgets.NumButton;
import htext.style.TextStyleContext;
import utils.Signal;
import widgets.ColouredQuad;
import widgets.Label;
import widgets.Widget;

class NumChoisesWidget extends Widget {
    // var buttonsPools:Array<ChoiseButton> = [];
    var buttons:ChildrenPool<ChoiseButton>;
    @:once var fui:FuiBuilder;
    var b:PlaceholderBuilderGl;
    var captions:Array<String>; // stores before init only

    public var onChoise(default, null) = new IntSignal();

    override function init() {
        var wc = Builder.createContainer(ph, vertical, Center);
        b = new PlaceholderBuilderGl(fui.ar, true);
        b.keepStateAfterBuild = true;
        b.v(sfr, 0.15).h(sfr, 0.7);
        buttons = new ChildrenPool(wc, addButton);
        if (captions != null) {
            initChoises(captions);
            captions = null;
        }
    }

    public function initChoises(captions:Array<String>) {
        if (_inited) {
            buttons.setActiveNum(captions.length);
            for (i in 0...captions.length)
                buttons.pool[i].lbl.withText(captions[i]);
        } else {
            this.captions = captions;
        }
    }

    function addButton() {
        return new ChoiseButton(b.b(), buttons.pool.length, clickHandler);
    }

    function clickHandler(n) {
        onChoise.dispatch(n);
    }
}

class ChoiseButton extends NumButton {
    public var lbl(default, null):Label;

    @:once var style:TextStyleContext;

    override function init() {
        ColouredQuad.flatClolorQuad(ph);
        lbl = new Label(ph, style);
    }
}
