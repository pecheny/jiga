package bootstrap;

import fu.ui.Properties.EnabledProp;
import dkit.Dkit.BaseDkit;
import al.layouts.PortionLayout;
import bootstrap.Lifecycle;

class Menu extends BaseDkit {
    @:once var l:Lifecycle;

    static var SRC = <menu layouts={GuiStyles.L_VERT_BUTTONS}>
    <button(b().v(sfr, 0.1).b()) text={"new game"} onClick={()->l.newGame()} />
    <button(b().v(sfr, 0.1).b()) id="save" enabled={false} text={"save game"} onClick={()->l.saveGame()} />
    <button(b().v(sfr, 0.1).b()) text={"load game"} onClick={()->l.loadGame()} />
    <button(b().v(sfr, 0.1).b()) id="backToGame" enabled={false} text={"continue"} onClick={()->l.toggleMenu()} />
 </menu>

    override function init() {
        super.init();
        var ep1 = EnabledProp.getOrCreate(backToGame.entity);
        var ep2 = EnabledProp.getOrCreate(save.entity);
        var has = l.hasActiveSession;
        has.onChange.listen(() -> {
            ep1.value = has.value;
            ep2.value = has.value;
        });
    }
}
