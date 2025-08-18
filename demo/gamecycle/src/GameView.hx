package;

import fu.Signal;
import dkit.Dkit.BaseDkit;
import al.layouts.PortionLayout;

class GameView extends BaseDkit {
    public var onDone:Signal<Void->Void> = new Signal();

    static var SRC = <game-view vl={PortionLayout.instance}>
        <label(b().v(pfr, .2).b()) public id="lbl"  text={ "Lets play!1" }  />
        <button(b().v(pfr, .1).b())   text={ "Go!1" } onClick={onOkClick}  />
    </game-view>

    function onOkClick() {
        onDone.dispatch();
    }
}
