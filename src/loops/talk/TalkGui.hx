package loops.talk;

import a2d.ChildrenPool;
import a2d.Placeholder2D;
import a2d.Widget2DContainer;
import al.core.DataView;
import al.layouts.PortionLayout;
import dkit.Dkit.BaseDkit;
import ec.Signal;
import fu.Signal.IntSignal;
import fu.input.WidgetFocus;
import fu.ui.InteractivePanelBuilder;
import loops.talk.TalkData;
import loops.talk.TalkingActivity.ITalkingWidget;
import shimp.ClicksInputSystem.ClickTargetViewState;
import shimp.ClicksInputSystem.ClickViewProcessor;

using a2d.transform.LiquidTransformer;
using al.Builder;


class TalkingWidget implements ITalkingWidget extends BaseDkit {
    public var onChoice(default, null):IntSignal = new IntSignal();

    var container:Widget2DContainer;
    var input:DataChildrenPool<String, ResponceButton>;
    var data:DialogDesc;
    @:once var wc:Widget2DContainer;

    static var SRC = <talking-widget vl={PortionLayout.instance}>
        <label(b().v(pfr, 6).b()) id="lbl"  style={"small-text"}  />
        <base(b().v(pfr, 6).b()) id="buttons" vl={PortionLayout.instance}   />
    </talking-widget>

    public function new(p:Placeholder2D, ?parent:BaseDkit) {
        super(p, parent);
        initComponent();
        initDkit();
        ph.entity.addComponentByType(ITalkingWidget, this);
    }

    public function initDescr(d:DialogDesc) {
        data = d;
        if (!_inited)
            return;
        lbl.text = d.caption;
        input.initData(d.responces.map(r -> r.caption));
    }

    override function init() {
        input = new InteractivePanelBuilder().withContainer(buttons.c).withWidget(() -> {
            var c = new ResponceButton(b().h(pfr, 0.1).v(sfr, 0.1).b());
            new WidgetFocus(c.ph);
            c;
        }).withSignal(onChoice).build();
        if (data != null)
            initDescr(data);
    }
}

class ResponceButton extends BaseDkit implements DataView<String> {
    public var onDone:Signal<Void->Void> = new Signal();

    @:once var bb:ClickViewProcessor;

    static var SRC = <responce-button vl={PortionLayout.instance}>
        <label(b().v(pfr, 6).b()) id="lbl"  style={"small-text"}  />
    </responce-button>

    override function init() {
        bb.addHandler(changeViewState);
    }

    public function initData(descr:String) {
        lbl.text = descr;
    }

    function changeViewState(st:ClickTargetViewState) {
        var c = switch st {
            case Hovered: 0xff0000;
            case Pressed: 0x900000;
            case Idle, PressedOutside: 0xffffff;
        }
        lbl.color = (c);
    }
}
