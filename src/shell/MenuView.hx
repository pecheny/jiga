package shell;

import fu.ui.Properties.EnabledProp;
import fu.input.FocusManager.LinearFocusManager;
import fu.Signal;
import fu.input.FocusInputRoot.ClickDispatcher;
import fu.input.WidgetFocus;
import shell.MenuItem;
import fu.ui.ButtonEnabled;
import dkit.Dkit.BaseDkit;
import al.core.DataView;
import utils.MacroGenericAliasConverter as MGA;

class MenuView extends BaseDkit implements DataView<MenuData> {
    static var SRC = <menu-view>
        <data-container(b().v(pfr, 1).b()) public  id="cardsContainer"   itemFactory={cardFactory} layouts={GuiStyles.L_VERT_BUTTONS }/>
    </menu-view>
    
    override function initDkit() {
        super.initDkit();
        new LinearFocusManager(entity);
        fui.createVerticalNavigationSignals(entity);
        entity.addComponentByName(MGA.toAlias(DataView, MenuData),this);
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
    public var focus(default, null):WidgetFocus;

    static var SRC = <menu-button >
        ${focus = new WidgetFocus(__this__.ph)}
        <button(b().b()) enabled={false} public id="btn" />
    </menu-button>

    public function initData(descr:MenuItem) {
        btn.text = descr.caption;
        btn.onClick = descr.handler;
        EnabledProp.getOrCreate(btn.entity).value =
        if (descr.enabled!=null)
            descr.enabled()
        else
            true;
    }
}
