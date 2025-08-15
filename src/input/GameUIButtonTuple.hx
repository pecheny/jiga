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
    var targets:GameButtonsListeners<TB> = new GameButtonsListeners();
    var bts:Array<TB>;

    public function new(w:Placeholder2D, b:Array<TB>, basisName) {
        this.bts = b;
        hittester = new WidgetHitTester2D(w); // share with possible view processor
        w.entity.addComponentByType(InputSystemTarget, this);
        w.entity.addComponentByName("GameButtonDispatcher_" + basisName, this);
        new CtxWatcherBase("ButtonInputBinder_" + basisName, w.entity);
        new CtxWatcher(InputBinder, w.entity);
    }

    public function addListener(l:GameButtonsListener<TB>) {
        targets.push(l);
        if (pressed)
            onButtonDown(l);
    }

    public function removeListener(l:GameButtonsListener<TB>) {
        targets.remove(l);
        if (pressed)
            onButtonUp(l);
    }

    inline function onButtonUp(l) {
        for (b in bts)
            targets.onButtonUp(b);
    }

    inline function onButtonDown(l) {
        for (b in bts)
            targets.onButtonDown(b);
    }

    public function setPos(pos:Point) {}

    var pressed = false;

    public function press() {
        pressed = true;
        for (l in targets.asArray())
            onButtonDown(l);
    }

    public function release() {
        pressed = false;
        for (l in targets.asArray())
            onButtonUp(l);
    }

    public function setActive(val:Bool) {
        if (!val && pressed)
            release();
    }

    public function isUnder(pos:Point):Bool {
        return hittester.isUnder(pos);
    }
}
