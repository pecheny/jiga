package fancy.widgets;

import al.al2d.ChildrenPool;
import algl.Builder.PlaceholderBuilderGl;
import fancy.widgets.NumButton;
import htext.style.TextStyleContext;
import score.Signal;
import widgets.ColouredQuad;
import widgets.Label;

class NumChoisesWidget extends DataViewContainer<String, ChoiseButton> implements OptionPickerGui<String> {
    var b:PlaceholderBuilderGl;

    public var onChoice(default, null) = new IntSignal();

    public function new(ph) {
        super(ph, addButton);
    }

    override function init() {
        b = new PlaceholderBuilderGl(fui.ar, true);
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
