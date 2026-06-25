package bootstrap;

class OneTickActivity extends GameRunBase {
    override function update(dt:Float) {
        gameOvered.dispatch();
    }
}
