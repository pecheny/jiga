package fancy.widgets;

import fui.graphics.ColouredQuad;
import al.al2d.ChildrenPool;
import al.al2d.PlaceholderBuilder2D;
import fancy.widgets.NumButton;
import htext.style.TextStyleContext;
import fu.Signal;
import widgets.Label;

class NumChoisesWidget extends DataViewContainer<String, ChoiseButton> implements OptionPickerGui<String> {
    var b:PlaceholderBuilder2D;

    public var onChoice(default, null) = new IntSignal();

    public function new(ph) {
        super(ph, addButton);
    }

    override function init() {
        b = new PlaceholderBuilder2D(fui.ar, true);
        b.keepStateAfterBuild = true;
        b.v(sfr, 0.15).h(sfr, 0.7);
        super.init();
    }

    function addButton(n) {
        return new ChoiseButton(b.b(), n, clickHandler);
    }

    public function clickHandler(n) {
        onChoice.dispatch(n);
    }
}

class ChoiseButton extends NumButton implements DataView<String> {
    public var lbl(default, null):Label;

    @:once var style:TextStyleContext;

    override function init() {
        ColouredQuad.flatClolorQuad(ph);
        lbl = new Label(ph, style);
    }

    public function initData(descr:String) {
        lbl.withText(descr);
    }
}
