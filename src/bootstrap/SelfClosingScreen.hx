package bootstrap;

import al.al2d.Placeholder2D;
import ec.Signal;

interface SelfClosingScreen {
    public var onDone:Signal<Void->Void>;
    public var ph(get, null):Placeholder2D;
}