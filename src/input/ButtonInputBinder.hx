package input;

import ginp.api.GameButtonsListener;
import ec.CtxWatcher.CtxBinder;
import ec.Entity;
import ginp.GameButtonsImpl;

class ButtonInputBinder<TButtons:Axis<TButtons>> implements CtxBinder {
    var input:GameButtonsListener<TButtons>;
    var dispatcherAlias:String;

    public function new(tbuttonAlias:String, input:GameButtonsListener<TButtons>) {
        this.input = input;
        dispatcherAlias = "GameButtonDispatcher_" + tbuttonAlias;
    }

    public function bind(e:Entity) {
        var dispatcher:GameButtonDispatcher<TButtons> = e.getComponentByName(dispatcherAlias);
        dispatcher.setButtonListener(input);
    }

    public function unbind(e:Entity) {
        var dispatcher:GameButtonDispatcher<TButtons> = e.getComponentByName(dispatcherAlias);
        dispatcher.setButtonListener(null);
    }
}

interface GameButtonDispatcher<T:Axis<T>> {
    function setButtonListener(l:GameButtonsListener<T>):Void;
}
