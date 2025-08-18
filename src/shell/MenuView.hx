package shell;

import shell.MenuItem;
import fu.ui.ButtonEnabled;
import dkit.Dkit.BaseDkit;
import al.core.DataView;

class MenuView extends BaseDkit implements DataView<MenuData> {
    static var SRC = <menu-view>
        <data-container(b().v(pfr, 1).b())  id="cardsContainer"   itemFactory={cardFactory} layouts={GuiStyles.L_VERT_BUTTONS }/>
    </menu-view>

    public function initData(descr:Array<MenuItem>) {
        cardsContainer.initData(descr);
    }

    function cardFactory() {
        var mc = new MenuButton(b().v(pfr, 0.3).h(pfr, 0.3).b("button"));
        return mc;
    }
}

class MenuButton extends BaseDkit implements DataView<MenuItem> {
    static var SRC = <menu-button >
        <button(b().b()) public id="btn" />
    </menu-button>

    public function initData(descr:MenuItem) {
        btn.text = descr.caption;
        btn.onClick = descr.handler;
    }
}
