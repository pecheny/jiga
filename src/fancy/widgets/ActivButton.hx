package fancy.widgets;

import al.al2d.Placeholder2D;
import fancy.GuiApi.ToggleComponent;
import shimp.ClicksInputSystem.ClickTargetViewState;
import widgets.ButtonBase;

class ActivButton extends ButtonBase {
    var toggle:ToggleComponent;

    public function new(w:Placeholder2D, h) {
        super(w, h);
        toggle = ToggleComponent.getOrCreate(w.entity);
        toggle.onChange.listen(set_active);
        set_active();
    }

    override function handler() {
        if (!toggle.enabled)
            return;
        super.handler();
    }

    var st:ClickTargetViewState;

    override function changeViewState(st:ClickTargetViewState) {
        this.st = st;
        super.changeViewState(toggle.enabled ? st : Idle);
    }

    function set_active() {
        changeViewState(st);
    }
}
