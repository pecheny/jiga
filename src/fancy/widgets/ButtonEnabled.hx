package fancy.widgets;

import a2d.Placeholder2D;
import fu.ui.ButtonBase;
import fu.ui.Properties;
import shimp.ClicksInputSystem.ClickTargetViewState;

class ButtonEnabled extends ButtonBase {
    var toggle:EnabledProp;

    public function new(w:Placeholder2D, h) {
        super(w, h);
        toggle = EnabledProp.getOrCreate(w.entity);
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
