package shell;

import al.Builder;
import bootstrap.GameRunBase;
import bootstrap.RunSwitcher;
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
        initMainMenu();
        initGameMenu();
        new EscGameButton(gameplay.entity, gameMenu.show);
    }

    public function addStateLoader(loader:StateLoader) {
        loader.onLoaded.listen(launch);
    }

    override function startGame() {
        mainMenu.show();
    }

    public dynamic function newGame() {
        launch();
    }

    function initMainMenu() {
        mainMenu = new MenuBuilder(this, new MenuActivity(new Entity("main menu"), Builder.widget()));
        mainMenu.addButton({caption: "new game", handler: newGame});
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

    function launch() {
        switchTo(gameplay);
    }
}
