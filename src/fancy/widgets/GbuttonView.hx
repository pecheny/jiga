package fancy.widgets;

import a2d.Placeholder2D;
import a2d.Widget;
import shimp.ClicksInputSystem.ClickViewProcessor;
import ginp.ButtonInputBinder;
import ginp.api.GameButtonsListener;
import shimp.ClicksInputSystem.ClickTargetViewState;

class GbuttonView<TB:Axis<TB>> extends Widget implements GameButtonsListener<TB> implements ClickViewProcessor {
    var interactives:Array<ClickTargetViewState->Void> = [];
    var gameButton:TB;

    public function new(ph:Placeholder2D, gb:TB, buttonsAlias) {
        super(ph);
        ButtonInputBinder.addListenerByAlias(buttonsAlias, entity, this);
        gameButton = gb;
    }

    public function addHandler(h:ClickTargetViewState->Void) {
        interactives.push(h);
    }

    override function init() {
        super.init();
    }

    public function reset() {
        for (h in interactives)
            h(Idle);
    }

    public function onButtonUp(b:TB) {
        if (b != gameButton)
            return;
        for (h in interactives)
            h(Idle);
    }

    public function onButtonDown(b:TB) {
        if (b != gameButton)
            return;
        for (h in interactives)
            h(Pressed);
    }
}
