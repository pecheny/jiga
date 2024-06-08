package loops.talk;

import loops.talk.TalkGui;
import bootstrap.Activitor.ActHandler;
import bootstrap.Executor;
import bootstrap.GameRunBase;
import loops.talk.TalkData;

class TalkingActivity extends GameRunBase implements ActHandler<DialogDesc> {
    var gui:TalkingWidget;
    @:once var executor:Executor;
    var currentDescr:DialogDesc;

    override function init() {
        super.init();
        gui = new TalkingWidget(getView());
        gui.choosen.listen(clickHandler);
    }

    function clickHandler(n:Int) {
        var resp = currentDescr.responces[n];
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