package;

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

using al.Builder;
using a2d.transform.LiquidTransformer;
using a2d.transform.LiquidTransformer;


class GamecycleDemo extends BootstrapMain {
    public function new() {
        super();

        var ph = Builder.widget();
        fui.makeClickInput(ph);

        var e = new Entity("run");
        var sw = new WidgetSwitcher(ph);
        var run = new SequenceRun(e, sw.widget(), sw);
        run.addActivity(new OneButtonActivity(new Entity("wlc"), new WelcomeWidget(Builder.widget()))) ;
        run.addActivity(new OneButtonActivity(new Entity("go"), new GameoverWidget(Builder.widget()))) ;
        run.entity.addComponentByType(GameRun, run);
        new CtxWatcher(GameRunBinder, run.entity);
        rootEntity.addChild(run.entity);
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