package bootstrap;

import bootstrap.SelfClosingScreen;
import dkit.Dkit.BaseDkit;
import al.layouts.PortionLayout;
import ec.Signal;

class GameOverScreen extends BaseDkit implements SelfClosingScreen {

    public var onDone:Signal<Void->Void> = new Signal();

    static var SRC = <game-over-screen vl={PortionLayout.instance}>
        <label(b().v(pfr, 1).b()) text={"Game Over"} />
        <button(b().v(sfr, 0.1).b()) text={"Menu"} onClick={()->onDone.dispatch()}/>
    </game-over-screen>
}
