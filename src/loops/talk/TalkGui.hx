package loops.talk;

import shimp.ClicksInputSystem.ClickTargetViewState;
import al.al2d.Widget2DContainer;
import loops.talk.TalkData;
import htext.style.TextStyleContext;
import utils.Signal.IntSignal;
import widgets.ButtonBase;
import widgets.Label;
import widgets.Widget;

using al.Builder;
using transform.LiquidTransformer;
using widgets.utils.Utils;

class TalkingWidget extends Widget {
    var bcont:Widget2DContainer;
    var currentDescr:DialogDesc;
    @:once var fui:FuiBuilder;
    @:once var style:TextStyleContext;

    public var buttons(default, null):Array<NumButton> = [];
    public var text(default, null):Label;
    public var choosen = new IntSignal();

    override function init() {
        super.init();
        var b = fui.placeholderBuilder;
        text = new Label(b.b(), style);
        bcont = Builder.createContainer(b.b(), vertical, Forward);
        Builder.createContainer(ph, vertical, Forward).withChildren([text.ph, bcont.widget()]);
        for (i in 0...4)
            addButton();
        if (currentDescr != null)
            initDescr(currentDescr);
        ph.entity.getComponent(Widget2DContainer).refresh();
    }

    public function initDescr(descr:DialogDesc) {
        currentDescr = descr;
        if (!_inited)
            return this;
        text.withText(descr.caption);
        for (i in 0...buttons.length) {
            var btn = buttons[i];

            if (i < descr.responces.length) {
                btn.setData(descr.responces[i].caption);
            } else {
                btn.hide();
            }
        }
        return this;
    }

    function addButton() {
        var b = fui.placeholderBuilder;
        var w = b.b();
        var lbl = new Label(w, style);
        var btn = new NumButton(w, buttons.length, buttonHandler, lbl);
        buttons.push(btn);
        Builder.addWidget(bcont, w);
    }

    function buttonHandler(n:Int) {
        choosen.dispatch(n);
    }
}

class NumButton extends ButtonBase {
    var numHandler:Int->Void;
    var lbl:Label;
    var n:Int;

    public function new(w, n, hnd, lbl) {
        this.lbl = lbl;
        super(w, null);
        this.n = n;
        this.numHandler = hnd;
    }

    public function setData(capt:String) {
        lbl.withText(capt);
    }

    override function handler() {
        super.handler();
        numHandler(n);
    }

    public function hide() {
        lbl.withText("");
        clickHandler = null;
    }
    override function changeViewState(st:ClickTargetViewState) {
        super.changeViewState(st);
        var c = switch st {
            case Hovered:0xff0000;
            case Pressed:0x900000;
            case Idle, PressedOutside: 0xffffff;
        }
        lbl.setColor(c);
    }
}
