package loops.talk;

import utils.Signal.IntSignal;
import loops.talk.TalkGui;
import bootstrap.Activitor.ActHandler;
import bootstrap.Executor;
import bootstrap.GameRunBase;
import loops.talk.TalkData;

class TalkingActivity extends GameRunBase implements ActHandler<DialogDesc> {
    @:once var gui:ITalkingWidget;
    @:once var executor:Executor;
    var currentDescr:DialogDesc;

    override function init() {
        super.init();
        gui.onChoice.listen(clickHandler);
    }

    function clickHandler(n:Int) {
        var resp = currentDescr.responces[n];
        if (resp.actions != null)
            for (a in resp.actions)
                executor.run(a);
        if (!resp.stay)
            gameOvered.dispatch();
    }

    public function initDescr(d:DialogDesc):ActHandler<DialogDesc> {
        currentDescr = d;
        gui.initDescr(d);
        return this;
    }
}
interface ITalkingWidget {
    public var onChoice(default, null) :IntSignal;
    public function initDescr(d:DialogDesc):Void;
}