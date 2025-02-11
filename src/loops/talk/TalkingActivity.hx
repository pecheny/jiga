package loops.talk;

import fu.Signal.IntSignal;
import loops.talk.TalkGui;
import bootstrap.Activitor.ActHandler;
import bootstrap.Executor;
import bootstrap.GameRunBase;
import loops.talk.TalkData;

class TalkingActivity extends GameRunBase implements ActHandler<DialogUri> {
    @:once var gui:ITalkingWidget;
    @:once var defs:TalksDefNode;
    @:once var executor:Executor;
    var currentDescr:DialogDesc;
    var talk:TalkDesc;
    
    public function new(ctx, ph) {
        super(ctx, ph);
        watch(ph.entity);
    }

    override function init() {
        super.init();
        gui.onChoice.listen(clickHandler);
    }

    function clickHandler(n:Int) {
        var resp = currentDescr.responces[n];
        if (resp.actions != null)
            for (a in resp.actions)
                executor.run(a);
        switch resp.onDone {
            case end, null:
                gameOvered.dispatch();
            case next:
                goto(Index(currentDescr.index + 1));
            case stay:
            case _.goto() => did if (did != null):
                goto(did);
            case _:
                trace('Unexpected onDone value ${resp.onDone}');
        }
    }

    function goto(did:DialogId) {
        currentDescr = talk.getDialog(did);
        gui.initDescr(currentDescr);
    }

    public function initDescr(d:DialogUri):ActHandler<DialogUri> {
        talk = defs.get(d.getTalkId());
        goto(d.getDialogId());
        return this;
    }
}

interface ITalkingWidget {
    public var onChoice(default, null):IntSignal;
    public function initDescr(d:DialogDesc):Void;
}
