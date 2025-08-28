package shell;

import a2d.Placeholder2D;
import al.core.DataView;
import bootstrap.GameRunBase;
import ginp.ButtonSignals;
import ginp.presets.NavigationButtons;
import shell.MenuItem.MenuData;

class MenuActivity extends GameRunBase {
    @:once(gen) public var view:DataView<MenuData>;
    @:once var fui:FuiBuilder;
    var data:MenuData;

    public function new(ctx, w:Placeholder2D) {
        super(ctx, w);
        watch(w.entity);
    }

    override function init() {
        super.init();
        if (data != null)
            initData(data);
    }

    public function initData(descr:Array<MenuItem>) {
        this.data = descr;
        view?.initData(descr);
    }
}
