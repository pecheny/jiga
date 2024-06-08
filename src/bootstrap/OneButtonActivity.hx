package bootstrap;

import ec.Entity;
import bootstrap.SelfClosingScreen;
class OneButtonActivity extends GameRunBase {
    public function new(ctx:Entity, gui:SelfClosingScreen) {
        super(ctx, gui.ph);
        gui.onDone.listen(() -> gameOvered.dispatch());
    }
}