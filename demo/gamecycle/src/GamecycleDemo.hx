package;

import fu.Serializable;
import persistent.State;
import al.core.DataView;
import shell.MenuView;
import dkit.Dkit.BaseDkit;
import a2d.Placeholder2D;
import al.ec.WidgetSwitcher;
import al.layouts.PortionLayout;
import bootstrap.BootstrapMain;
import bootstrap.OneButtonActivity;
import bootstrap.SelfClosingScreen;
import bootstrap.SequenceRun;
import ec.CtxWatcher;
import ec.Entity;
import ec.Signal;
import gameapi.GameRun;
import gameapi.GameRunBinder;
import shell.MenuItem.MenuData;
import utils.MacroGenericAliasConverter as MGA;

using al.Builder;
using a2d.transform.LiquidTransformer;
using a2d.transform.LiquidTransformer;

class GamecycleDemo extends BootstrapMain {
    public function new() {
        super();

        var e = new Entity("run");
        var view = new GameView(Builder.widget());
        var run = new Gameplay(e, view.ph);
        run.entity.addComponent(view);
        var state = new DemoState();
        run.entity.addComponentByType(State, state);
        run.entity.addComponent(state);

        fui.makeClickInput(rootEntity.getComponent(WidgetSwitcher).ph);
        var full = new shell.FullGame(new Entity(), Builder.widget(), rootEntity.getComponent(WidgetSwitcher), run);
        full.menu.entity.addComponentByName(MGA.toAlias(DataView, MenuData), new MenuView(full.menu));
        runSwitcher.switchTo(full);
        full.reset();
        full.startGame();
    }
}

class WelcomeWidget extends BaseDkit implements SelfClosingScreen {
    public var onDone:Signal<Void->Void> = new Signal();

    static var SRC = <welcome-widget vl={PortionLayout.instance}>
        <label(b().v(pfr, .2).b()) id="lbl"  text={ "Lets play!1" }  >
        </label>
        <button(b().v(pfr, .1).b())   text={ "Go!1" } onClick={onOkClick}  />
    </welcome-widget>

    function onOkClick() {
        onDone.dispatch();
    }
}

class GameoverWidget extends BaseDkit implements SelfClosingScreen {
    public var onDone:Signal<Void->Void> = new Signal();

    static var SRC = <gameover-widget vl={PortionLayout.instance}>
        <label(b().v(pfr, .2).b()) id="lbl"  text={ "Game Over" }  >
        </label>
        <button(b().v(pfr, .1).b())   text={ "again" } onClick={onOkClick}  />
    </gameover-widget>

    function onOkClick() {
        onDone.dispatch();
    }
}
