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

    public function onButtonUp(b:BasicGamepadButtons) {
        if (!pressed)
            return;
        pressed = false;
        #if android
        switch b {
            case start:
                handler();
            case _:
        }
        #end
    }

    var pressed = false;
    public function onButtonDown(b:BasicGamepadButtons) {
        pressed = true;
        #if !android
        switch b {
            case start:
                handler();
            case _:
        }
        #end
    }
}
