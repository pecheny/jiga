package shell;

import a2d.Placeholder2D;
import al.core.DataView;
import bootstrap.GameRunBase;
import ginp.ButtonSignals;
import ginp.presets.NavigationButtons;
import shell.MenuItem.MenuData;

class MenuActivity extends GameRunBase {
    @:once(gen) var view:DataView<MenuData>;
    @:once(gen) var input:ButtonSignals<NavigationButtons>;
    @:once var fui:FuiBuilder;
    var data:MenuData;

    public function new(ctx, w:Placeholder2D) {
        super(ctx, w);
        watch(w.entity);
    }

    override function init() {
        super.init();
        fui.makeClickInput(w);
        input.onPress.listen(buttonHandler);
        if (data != null)
            initData(data);
    }

    function buttonHandler(b) {
        switch b {
            case backward:
                gotoButton(-1);
            case forward:
                gotoButton(1);
            case confirm:
            case cancel:
                gameOvered.dispatch();
        }
    }

    var activeButton:Int = -1;

    function gotoButton(delta:Int) {
        activeButton += delta;
        activeButton = utils.Mathu.clamp(activeButton, 0, data.length - 1);
        var mv:MenuView = cast view;
        mv.cardsContainer.getItems()[activeButton].focus.focus();
    }

    public function initData(descr:Array<MenuItem>) {
        activeButton = -1;
        this.data = descr;
        view?.initData(descr);
    }
}
