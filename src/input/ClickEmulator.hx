package input;

import fu.input.FocusInputRoot;
import ec.CtxWatcher;
import ec.Entity;
import fu.Signal;
import ginp.api.GameButtonsListener;
import fu.input.FocusInputRoot.ClickDispatcher;

class ClickEmulator<T:Axis<T>> implements ClickDispatcher implements GameButtonsListener<T> {
    public var press(default, null):Signal<Void->Void> = new Signal();
    public var release(default, null):Signal<Void->Void> = new Signal();

    var button:T;

    public function new(ctx:Entity, b:T) {
        this.button = b;
        ctx.addComponentByType(ClickDispatcher, this);
        new CtxWatcher(FocusInputRoot, ctx);
    }

    public function reset() {}

    public function onButtonDown(b:T) {
        if (button == b)
            press.dispatch();
    }
    public function onButtonUp(b:T) {
        if (button == b)
            release.dispatch();
    }

}
