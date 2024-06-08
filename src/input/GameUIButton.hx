package input;

import al.al2d.Placeholder2D;
import input.ButtonInputBinder.GameButtonDispatcher;
import ec.CtxWatcher;
import ecbind.InputBinder;
import ginp.GameButtons.GameButtonsListener;
import shimp.InputSystem.InputSystemTarget;
import widgets.utils.WidgetHitTester;

class GameUIButton<TB:Axis<TB>> implements GameButtonDispatcher<TB> implements InputSystemTarget<Point> {
    var hittester:WidgetHitTester;
    var l:GameButtonsListener<TB>;
    var b:TB;

    public function new(w:Placeholder2D, b:TB, basisName) {
        hittester = new WidgetHitTester(w); // share with possible view processor
        w.entity.addComponentByType(InputSystemTarget, this);
        w.entity.addComponentByName("GameButtonDispatcher_" + basisName, this);
        new CtxWatcherBase("ButtonInputBinder_" + basisName, w.entity);
        new CtxWatcher(InputBinder, w.entity);
    }

    public function setButtonListener(l:GameButtonsListener<TB>) {
        this.l = l;
    }

    public function setPos(pos:Point) {}

    public function press() {
        l?.onButtonDown(b);
    }

    public function release() {
        l?.onButtonUp(b);
    }

    public function setActive(val:Bool) {}

    public function isUnder(pos:Point):Bool {
        return hittester.isUnder(pos);
    }
}
