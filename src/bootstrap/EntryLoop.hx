package bootstrap;

import ginp.GameButtons.GameButtonsImpl;
import Axis2D;
import al.al2d.Placeholder2D;
import al.core.Align;
import al.ec.WidgetSwitcher;
import ec.Entity;
import gameapi.GameRun;
import ginp.GameInput.GameInputUpdater;
import states.States;
import ui.GameplayUIMock;
import update.RealtimeUpdater;
import widgets.Button;
import widgets.Label;

using al.Builder;
using transform.LiquidTransformer;
using widgets.utils.Utils;

class EntryLoop {
    var machine:StateMachine;

    public function new(rootEntity) {
        machine = new StateMachine();
        rootEntity.addComponent(machine);
        machine.addState(new IntroState(Builder.widget(), rootEntity));
        machine.addState(new GameOverState(Builder.widget(), rootEntity));
        machine.addState(new GameplayState(Builder.widget(), rootEntity));
        machine.changeState(GameplayState);
    }
}

class GameOverState extends StateBase {
    var score:Label;

    public function new(w:Placeholder2D, root:Entity) {
        super(w, root);

        var fui = root.getComponentUpward(FuiBuilder);
        var b = fui.placeholderBuilder;
        root.getComponent(FuiBuilder).makeClickInput(w);

        var shViewSz = 0.33;

        var stw = b.h(pfr, 1).v(sfr, 0.2).b().withLiquidTransform(fui.ar.getAspectRatio());
        new Label(stw, fui.s("fit")).withText("GAME OVER");

        var splWdg = b.h(sfr, shViewSz)
            .v(sfr, shViewSz)
            .b()
            .withLiquidTransform(fui.ar.getAspectRatio());
        var bg = new Button(splWdg, startGame, "go!", fui.s("fit"));
        // bg.setColor();

        // var refCrcles = Builder.createContainer( horizontal, Align.Center).withChildren([]);
        var mwdg = b.v(sfr, shViewSz).b();
        score = cast new Label(mwdg, fui.s("score")).withText("your score");

        var splittingCrcle = Builder.createContainer(b.v(sfr, shViewSz).b(), horizontal, Align.Center).withChildren([splWdg]);
        Builder.createContainer(w, vertical, Align.Center).withChildren([stw, mwdg, splittingCrcle]);
    }

    function welcomeScreen(w) {
        var fui = root.getComponentUpward(FuiBuilder);
        var b = fui.placeholderBuilder;
        var pnl = Builder.createContainer(w, vertical, Align.Center).withChildren([
            new Button(b.h(sfr, 1).v(px, 60).b().withLiquidTransform(fui.ar.getAspectRatio()), startGame, "Button caption", fui.s("fit")).ph,
        ]);
        fui.makeClickInput(pnl);
        return pnl;
    }

    function startGame() {
        // () -> rootEntity.getComponent(WidgetSwitcher).switchTo(null)
        root.getComponentUpward(StateMachine).changeState(GameplayState);
    }

    function sty(name) {
        var fui = root.getComponentUpward(FuiBuilder);
        return fui.textStyles.getStyle(name);
    }

    override function onEnter() {
        super.onEnter();
        // var loop = root.getComponent(SplitGameLoop);
        // score.withText("Your score " + loop.score);
    }
}

class IntroState extends StateBase {
    public function new(w:Placeholder2D, root:Entity) {
        super(w, root);

        var fui = root.getComponentUpward(FuiBuilder);
        var b = fui.placeholderBuilder;
        root.getComponent(FuiBuilder).makeClickInput(w);

        var shViewSz = 0.33;

        var stw = b.h(pfr, 1).v(sfr, 0.2).b().withLiquidTransform(fui.ar.getAspectRatio());
        new Label(stw, fui.s("fit")).withText("SPLIT the disc");

        var splWdg = b.h(sfr, shViewSz)
            .v(sfr, shViewSz)
            .b()
            .withLiquidTransform(fui.ar.getAspectRatio());

        var bg = new Button(splWdg, startGame, "go!", fui.s("fit"));
        // bg.setColor();

        var refCrcles = Builder.createContainer(b.v(sfr, shViewSz).b(), horizontal, Align.Center).withChildren([]);

        var splittingCrcle = Builder.createContainer(b.v(sfr, shViewSz).b(), horizontal, Align.Center).withChildren([splWdg]);
        Builder.createContainer(w, vertical, Align.Center).withChildren([stw, refCrcles, splittingCrcle]);
    }

    function welcomeScreen(w) {
        var fui = root.getComponentUpward(FuiBuilder);
        var b = fui.placeholderBuilder;
        var pnl = Builder.createContainer(w, vertical, Align.Center).withChildren([
            new Button(b.h(sfr, 1).v(px, 60).b().withLiquidTransform(fui.ar.getAspectRatio()), startGame, "Button caption", fui.s("fit")).ph,
        ]);
        fui.makeClickInput(pnl);
        return pnl;
    }

    function startGame() {
        // () -> rootEntity.getComponent(WidgetSwitcher).switchTo(null)
        root.getComponentUpward(StateMachine).changeState(GameplayState);
    }

    function sty(name) {
        var fui = root.getComponentUpward(FuiBuilder);
        return fui.textStyles.getStyle(name);
    }
}

class GameplayState extends StateBase implements ui.GameplayUIMock.GameMock {
    var input:GameInputUpdater;
    var switcher:WidgetSwitcher<Axis2D>;
    var gpScreen:Placeholder2D;
    var pauseScreen:Placeholder2D;
    // var game:RealtimeUpdater;
    var loop:GameRun;
    var _pause = false;

    public function new(w:Placeholder2D, root:Entity) {
        super(w, root);

        input = root.getComponent(GameInputUpdater);
        if (input == null)
            throw "There is no game input";
        var fui = root.getComponentUpward(FuiBuilder);
        var b = fui.placeholderBuilder;
        // this.game = new RealtimeUpdater();
        switcher = new WidgetSwitcher(w);
        root.getComponent(FuiBuilder).makeClickInput(w);
        initScreens();

        loop = root.findFirstInside(GameRun);
        // game.addUpdatable(loop);

        var fsm = root.getComponentUpward(StateMachine);
        loop.gameOvered.listen(() -> fsm.changeState(GameOverState));
        // root.addComponent(loop);

        Builder.createContainer(gpScreen, vertical, Align.Center).withChildren([loop.getView()]);
    }

    function initScreens() {
        gpScreen = Builder.widget(); // new GameplayScreen(, root, this).widget();
        pauseScreen = new GameplayPauseScreen(Builder.widget(), this).ph;
    }

    override function update(t:Float) {
        if (_pause)
            return;
        input.beforeUpdate(t);
        // game.update();
        loop.update(t);
        input.afterUpdate();
    }

    public function pause(v) {
        _pause = v;
        if (v)
            switcher.switchTo(pauseScreen);
        else
            switcher.switchTo(gpScreen);
    }

    override function onEnter() {
        super.onEnter();
        switcher.switchTo(gpScreen);
        loop.reset();
        loop.startGame();
    }
}

class StateBase extends State {
    var w:Placeholder2D;
    var root:Entity;

    public function new(w:Placeholder2D, root:Entity) {
        this.w = w;
        this.root = root;
    }

    override function onExit() {
        super.onExit();
        var sw = root.getComponentUpward(WidgetSwitcher);
        if (sw == null)
            throw 'WThere is no WigetSwitcher';
        sw.switchTo(null);
    }

    override function onEnter() {
        var sw = root.getComponentUpward(WidgetSwitcher);
        if (sw == null)
            throw 'WThere is no WigetSwitcher';
        sw.switchTo(w);
    }
}
