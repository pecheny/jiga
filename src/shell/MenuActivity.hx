package shell;

import ginp.presets.NavigationButtons;
import ginp.ButtonSignals;
import a2d.Placeholder2D;
import shell.MenuItem.MenuData;
import al.core.DataView;
import bootstrap.GameRunBase;

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
        trace(b);
    }

    public function initData(descr:Array<MenuItem>) {
        this.data = descr;
        view?.initData(descr);
    }
}
