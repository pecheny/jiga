package shell;

import fu.input.FocusInputRoot;
import ec.CtxWatcher;
import fu.Signal;
import fu.input.FocusInputRoot.ClickDispatcher;
import ginp.presets.NavigationButtons;
import ginp.ButtonSignals;
import a2d.Placeholder2D;
import shell.MenuItem.MenuData;
import al.core.DataView;
import bootstrap.GameRunBase;

class MenuActivity extends GameRunBase implements ClickDispatcher {
    @:once(gen) var view:DataView<MenuData>;
    @:once(gen) var input:ButtonSignals<NavigationButtons>;
    @:once var fui:FuiBuilder;
    var data:MenuData;

    public var press(default, null):Signal<Void->Void> = new Signal();
    public var release(default, null):Signal<Void->Void> = new Signal();

    public function new(ctx, w:Placeholder2D) {
        super(ctx, w);
        ctx.addComponentByType(ClickDispatcher, this);
        new CtxWatcher(FocusInputRoot, ctx);
        watch(w.entity);
    }

    override function init() {
        super.init();
        fui.makeClickInput(w);
        input.onPress.listen(buttonHandler);
        input.onRelease.listen(releaseHandler);
        if (data != null)
            initData(data);
    }

    function releaseHandler(b) {
        switch b {
            case confirm:
                if(!pressed)
                    return;
                pressed = false;
                release.dispatch();
            case _:
        }
    }
    
    var pressed = false;

    function buttonHandler(b) {
        switch b {
            case backward:
                gotoButton(-1);
            case forward:
                gotoButton(1);
            case confirm:
                if (pressed)
                    return;
                pressed = true;
                press.dispatch();
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
