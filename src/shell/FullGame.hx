package shell;

import al.Builder;
import bootstrap.GameRunBase;
import bootstrap.RunSwitcher;
import ec.Component;
import ec.Entity;
import fu.Signal;
import gameapi.GameRun;
import input.EscButton.EscGameButton;
import openfl.system.System;
import persistent.AssetStateLoader;
import persistent.State;
import shell.MenuBuilder;

class FullGame extends RunSwitcher {
    public var onNewLoaded(default, null):Signal<Void->Void> = new Signal();
    public var gameMenu(default, null):MenuBuilder;
    public var mainMenu(default, null):MenuBuilder;
    public var gameplay(default, null):GameRun;

    var presets:AssetStateLoader;

    public function new(ctx, w, vtarg, gameplay:GameRunBase) {
        super(ctx, w, vtarg);
        this.gameplay = gameplay;
        initPersistentStorage();
        initMainMenu();
        initGameMenu();
        new EscGameButton(gameplay.entity, gameMenu.show);
    }

    override function startGame() {
        mainMenu.show();
    }

    function initPersistentStorage() {
        var state = gameplay.entity.getComponent(State);
        entity.addComponentByType(State, state);
        presets = new AssetStateLoader(entity);
        presets.onLoaded.listen(onNewStateLoaded);
    }

    function initMainMenu() {
        mainMenu = new MenuBuilder(this, new MenuActivity(new Entity("main menu"), Builder.widget()));
        mainMenu.addButton({caption: "new game", handler: () -> presets.load()});
        #if sys
        mainMenu.addButton({caption: "exit", handler: () -> System.exit(0)});
        #end
    }

    function initGameMenu() {
        gameMenu = new MenuBuilder(this, new MenuActivity(new Entity("main menu"), Builder.widget()));
        gameMenu.addButton({caption: "back to game", handler: () -> switchTo(gameplay)});
        gameMenu.addButton({caption: "exit to menu", handler: quitGameplay});
        new EscGameButton(gameMenu.activity.entity, () -> switchTo(gameplay));
    }

    function quitGameplay() {
        mainMenu.show();
    }

    function initSavesFacility() {}

    function onNewStateLoaded() {
        onNewLoaded.dispatch();
        launch();
    }

    function launch() {
        switchTo(gameplay);
    }
}
