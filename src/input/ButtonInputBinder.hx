package input;

import ec.CtxWatcher.CtxBinder;
import ec.Entity;
import ginp.GameButtonsImpl;
import ginp.api.GameButtonsDispatcher;
import ginp.api.GameButtonsListener;

class ButtonInputBinder<TButtons:Axis<TButtons>> implements CtxBinder {
    var input:GameButtonsListener<TButtons>;
    var dispatcherAlias:String;

    public function new(tbuttonAlias:String, input:GameButtonsListener<TButtons>) {
        this.input = input;
        dispatcherAlias = "GameButtonDispatcher_" + tbuttonAlias;
    }

    public function bind(e:Entity) {
        var dispatcher:GameButtonsDispatcher<TButtons> = e.getComponentByName(dispatcherAlias);
        dispatcher.setListener(input);
    }

    public function unbind(e:Entity) {
        var dispatcher:GameButtonsDispatcher<TButtons> = e.getComponentByName(dispatcherAlias);
        dispatcher.setListener(null);
    }
}
