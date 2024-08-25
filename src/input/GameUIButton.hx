package input;

import ginp.api.GameButtonsListener;
import al.al2d.Placeholder2D;
import input.ButtonInputBinder.GameButtonDispatcher;
import ec.CtxWatcher;
import ecbind.InputBinder;
import shimp.InputSystem.InputSystemTarget;
import widgets.utils.WidgetHitTester2D;

class GameUIButton<TB:Axis<TB>> implements GameButtonDispatcher<TB> implements InputSystemTarget<Point> {
    var hittester:WidgetHitTester2D;
    var l:GameButtonsListener<TB>;
    var b:TB;

    public function new(w:Placeholder2D, b:TB, basisName) {
        this.b = b;
        hittester = new WidgetHitTester2D(w); // share with possible view processor
        w.entity.addComponentByType(InputSystemTarget, this);
        w.entity.addComponentByName("GameButtonDispatcher_" + basisName, this);
        new CtxWatcherBase("ButtonInputBinder_" + basisName, w.entity);
        new CtxWatcher(InputBinder, w.entity);
    }

    public function setButtonListener(l:GameButtonsListener<TB>) {
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
    }

    public function isUnder(pos:Point):Bool {
        return hittester.isUnder(pos);
    }
}
