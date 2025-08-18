package shell;

import a2d.Placeholder2D;
import shell.MenuItem.MenuData;
import al.core.DataView;
import bootstrap.GameRunBase;

class MenuActivity extends GameRunBase {
    @:once(gen) var view:DataView<MenuData>;
    @:once var fui:FuiBuilder;
    var data:MenuData;
    
    public function new(ctx, w:Placeholder2D) {
        super(ctx, w);
        watch(w.entity);
    }

    override function init() {
        super.init();
        fui.makeClickInput(w);
        if (data != null)
            initData(data);
    }

    public function initData(descr:Array<MenuItem>) {
        this.data = descr;
        view?.initData(descr);
    }
}
