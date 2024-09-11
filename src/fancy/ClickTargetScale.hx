package fancy;

import al.prop.ScaleComponent;
import shimp.ClicksInputSystem.ClickTargetViewState;
import fu.ui.ButtonBase.ClickViewProcessor;
import bootstrap.Component;
import macros.AVConstructor;

class ClickTargetScale extends Component {
    @:once var scale:ScaleComponent;
    @:once var viewProc:ClickViewProcessor;
    var scaleVals = AVConstructor.create(ClickTargetViewState, 1., 1.05, 1.02, 0.95);

    override function init() {
        super.init();
        viewProc.addHandler(viewStateChange);
    }

    function viewStateChange(st:ClickTargetViewState) {
        this.scale.value = scaleVals[st];
    }
}
