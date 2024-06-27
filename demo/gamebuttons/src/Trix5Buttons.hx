package;

import ginp.Keyboard;
import ginp.GameKeys;
import ginp.GameInput.GameInputUpdater;
import ginp.api.KbdListener;
import ec.Entity;
import ginp.api.KbdDispatcher;
import ec.CtxWatcher;
import ginp.GameButtons;

@:build(macros.BuildMacro.buildAxes())
@:enum abstract TriButtons(Axis<TriButtons>) to Axis<TriButtons> to Int {
    var l;
    var r;
    var up;
}

class Trix5Buttons extends GameButtonsImpl<TriButtons> implements GameButtons<TriButtons> implements GameInputUpdater {
    public function new(e:Entity) {
        super(TriButtons.aliases.length);
        var map:Map<Int, TriButtons> = [Keyboard.LEFT => l, Keyboard.RIGHT => r, Keyboard.UP => up];
        var k = new GameKeys(this, map);
        e.addComponentByType(KbdListener, k);
        //TODO for now gupdater is put to run exec in bootstr.updater and take it from the root e.
        // e.addComponentByType(GameInputUpdater, this);
        e.addComponentByType(GameButtons, this);
        e.addComponent(this);
        new CtxWatcher(KbdDispatcher, e);
    }

	public function beforeUpdate(dt:Float) {}

	public function afterUpdate() {
        frameDone();
    }
}
