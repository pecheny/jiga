package input;

import ec.Entity;
import ginp.ButtonInputBinder;
import ginp.api.GameButtonsListener;
import ginp.presets.BasicGamepad;

class EscGameButton implements GameButtonsListener<BasicGamepadButtons> {
    var handler:Void->Void;

    public function new(e:Entity, handler) {
        this.handler = handler;
        ButtonInputBinder.addListener(BasicGamepadButtons, e, this);
    }

    public function reset() {}

    public function onButtonUp(b:BasicGamepadButtons) {}

    public function onButtonDown(b:BasicGamepadButtons) {
        switch b {
            case start:
                handler();
            case _:
        }
    }
}
