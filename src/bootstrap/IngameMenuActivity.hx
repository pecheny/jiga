package bootstrap;

import a2d.Placeholder2D;
import gameapi.GameRun;
import al.ec.WidgetSwitcher;

enum abstract IngameMenuState(Int) {
    var game;
    var menu;
}

class IngameMenuActivity extends GameRunBase {
    public var game(default, set):GameRun;
    public var menu:Placeholder2D;

    var state:IngameMenuState;

    var switcher:WidgetSwitcher<Axis2D>;

    public function new(e, ph) {
        super(e, ph);
        switcher = new WidgetSwitcher(ph);
    }

    override function startGame() {
        changeState(state);
        game.startGame();
    }

    public function changeState(trg:IngameMenuState) {
        state = trg;
        if (state == IngameMenuState.game)
            switcher.switchTo(game.getView());
        else
            switcher.switchTo(menu);
    }

    public function toggleState() {
        if (state == IngameMenuState.game)
            changeState(IngameMenuState.menu);
        else
            changeState(IngameMenuState.game);
    }

    override function update(dt:Float) {
        if (state == IngameMenuState.game)
            game.update(dt);
    }

    function set_game(value:GameRun):GameRun {
        if (this.game != null)
            entity.removeChild(this.game.entity);
        game = value;
        entity.addChild(value.entity);
        return game;
    }
    
}
