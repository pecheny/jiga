package;

import bootstrap.SelfClosingScreen;
import ec.Signal;
import dkit.Dkit;
import al.layouts.PortionLayout;

class ControlPanel extends BaseDkit implements SelfClosingScreen {
    public var onDone:Signal<Void->Void> = new Signal();

    static var SRC = <control-panel vl={PortionLayout.instance}>
        <button(b().b()) text={"Launch!"} autoFocus={true} onClick={()->onDone.dispatch()}/>
    </control-panel>
}
