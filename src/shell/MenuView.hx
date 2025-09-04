package shell;

import al.core.DataView;
import dkit.Dkit.BaseDkit;
import fu.input.FocusManager.LinearFocusManager;
import fu.ui.Properties.EnabledProp;
import shell.MenuItem;
import utils.MacroGenericAliasConverter as MGA;

class MenuView extends BaseDkit implements DataView<MenuData> {
    static var SRC = <menu-view>
        <data-container(b().v(pfr, 1).b()) public  id="cardsContainer"   itemFactory={cardFactory} layouts={GuiStyles.L_VERT_BUTTONS }/>
    </menu-view>

    override function initDkit() {
        super.initDkit();
        new LinearFocusManager(entity);
        fui.createVerticalNavigationSignals(entity);
        entity.addComponentByName(MGA.toAlias(DataView, MenuData), this);
    }

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
        <button(b().b()) enabled={false} focus={true} public id="btn" />
    </menu-button>

    public function initData(descr:MenuItem) {
        btn.text = descr.caption;
        btn.onClick = descr.handler;
        var ep = EnabledProp.getOrCreate(btn.entity);
        ep.value = if (descr.enabled != null) descr.enabled() else true;
    }
}
