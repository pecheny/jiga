package;

import bootstrap.GameRunBase;

class Gameplay extends GameRunBase {
    @:once var view:GameView;
    @:once var state:DemoState;

    override function init() {
        super.init();
        view.onDone.listen(onClick);
    }

    override function reset() {
        view?.lbl.text = "";
    }

    override function startGame() {
        super.startGame();
        view?.lbl.text = "" + state.number;
    }

    function onClick() {
        if (state.number < 10) {
            state.number++;
            view?.lbl.text = "" + state.number;
        } else {
            gameOvered.dispatch();
        }
    }
}
