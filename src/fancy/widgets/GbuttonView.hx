package fancy.widgets;

import fu.ui.ButtonBase.ClickViewProcessor;
import al.al2d.Placeholder2D;
import al.al2d.Widget;
import ec.CtxWatcher;
import ginp.api.GameButtons;
import shimp.ClicksInputSystem.ClickTargetViewState;
import update.Updatable;
import update.UpdateBinder;

class GbuttonView<TB:Axis<TB>> extends Widget implements Updatable implements ClickViewProcessor {
    var interactives:Array<ClickTargetViewState->Void> = [];
    var lastState:Bool;
    var gameButton:TB;
    @:once var inp:GameButtons<TB>;

    public function new(ph:Placeholder2D, gb:TB) {
        super(ph);
        gameButton = gb;
    }

    public function addHandler(h:ClickTargetViewState->Void) {
        interactives.push(h);
    }

    public function update(dt:Float) {
        var val = (inp.pressed(gameButton));
        if (val == lastState)
            return;
        lastState = val;
        for (h in interactives)
            h(val ? Pressed : Idle);
    }

    override function init() {
        ph.entity.addComponentByType(Updatable, this);
        new CtxWatcher(UpdateBinder, entity);
        super.init();
    }
}
