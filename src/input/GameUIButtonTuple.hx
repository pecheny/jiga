package input;

import a2d.Placeholder2D;
import al2d.WidgetHitTester2D;
import ec.CtxWatcher;
import ecbind.InputBinder;
import ginp.api.GameButtonsDispatcher;
import ginp.api.GameButtonsListener;
import shimp.InputSystem.InputSystemTarget;
import shimp.Point;

class GameUIButtonTuple<TB:Axis<TB>> implements GameButtonsDispatcher<TB> implements InputSystemTarget<Point> {
    var hittester:WidgetHitTester2D;
    var l:GameButtonsListener<TB>;
    var bts:Array<TB>;

    public function new(w:Placeholder2D, b:Array<TB>, basisName) {
        this.bts = b;
        hittester = new WidgetHitTester2D(w); // share with possible view processor
        w.entity.addComponentByType(InputSystemTarget, this);
        w.entity.addComponentByName("GameButtonDispatcher_" + basisName, this);
        new CtxWatcherBase("ButtonInputBinder_" + basisName, w.entity);
        new CtxWatcher(InputBinder, w.entity);
    }

    public function setListener(l:GameButtonsListener<TB>) {
        if (this.l != null && pressed)
            onChange(false);
        this.l = l;
        if (this.l != null && pressed)
            onChange(true);
    }

    inline function onChange(v) {
        if (this.l == null)
            return;
        for (b in bts)
            if (v)
                l.onButtonDown(b);
            else
                l.onButtonUp(b);
    }

    public function setPos(pos:Point) {}

    var pressed = false;

    public function press() {
        pressed = true;
        onChange(pressed);
    }

    public function release() {
        pressed = false;
        onChange(pressed);
    }

    public function setActive(val:Bool) {
        if (!val && pressed)
            release();
    }

    public function isUnder(pos:Point):Bool {
        return hittester.isUnder(pos);
    }
}
