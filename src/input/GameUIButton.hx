package input;

import shimp.ClicksInputSystem.ClickTargetViewState;
import fu.ui.ButtonBase.ClickViewProcessor;
import a2d.Placeholder2D;
import al2d.WidgetHitTester2D;
import ec.CtxWatcher;
import ecbind.InputBinder;
import ginp.api.GameButtonsListener;
import ginp.api.GameButtonsDispatcher;
import shimp.InputSystem.InputSystemTarget;
import shimp.Point;

class GameUIButton<TB:Axis<TB>> implements GameButtonsDispatcher<TB> implements InputSystemTarget<Point> implements ClickViewProcessor {
    var hittester:WidgetHitTester2D;
    var l:GameButtonsListener<TB>;
    var b:TB;

    var interactives:Array<ClickTargetViewState->Void> = [];

    public function new(w:Placeholder2D, b:TB, basisName) {
        this.b = b;
        hittester = new WidgetHitTester2D(w); // share with possible view processor
        w.entity.addComponentByType(InputSystemTarget, this);
        w.entity.addComponentByName("GameButtonDispatcher_" + basisName, this);
        new CtxWatcherBase("ButtonInputBinder_" + basisName, w.entity);
        new CtxWatcher(InputBinder, w.entity);
    }

    public function setListener(l:GameButtonsListener<TB>) {
        if (this.l != null && pressed)
            this.l.onButtonUp(b);
        this.l = l;
        if (this.l != null && pressed)
            this.l.onButtonDown(b);
    }

    public function setPos(pos:Point) {}

    var pressed = false;

    public function press() {
        pressed = true;
        l?.onButtonDown(b);
    }

    public function release() {
        pressed = false;
        l?.onButtonUp(b);
    }

    public function setActive(val:Bool) {
        if (!val && pressed)
            release();
        var state = val ? Hovered:Idle;
        changeViewState(state);
    }

    public function isUnder(pos:Point):Bool {
        return hittester.isUnder(pos);
    }

    public function addHandler(h:ClickTargetViewState->Void):Void {
        interactives.push(h);
    }
    
    public function changeViewState(st:ClickTargetViewState):Void {
        for (iv in interactives)
            iv(st);
    }

}
