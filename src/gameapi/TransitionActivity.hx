package gameapi;

import update.Updatable;
import bootstrap.GameRunBase;

class TransitionActivity extends GameRunBase implements Updatable {
    public var duration:Float = 0.5;
    public var interrupt:Bool = false;

    var time:Float = 0;

    override function reset() {
        super.reset();
        time = 1;
    }

    override function startGame() {
        super.startGame();
        time = 0;
    }

    override public function update(dt:Float) {
        if (time >= 1)
            return;
        time += dt / duration;
        if (time >= 1 || interrupt) {
            time = 1;
            setT(time);
            gameOvered.dispatch();
            return;
        }
        setT(time);
    }

    public dynamic function setT(t:Float) {}
}
