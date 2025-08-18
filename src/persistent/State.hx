package persistent;

import fu.Signal;

interface State {
    public function load(state:Dynamic):Void;
    public function dump():Dynamic;
}

interface StateLoader {
    public var onLoaded (default, null):Signal<Void->Void>;
}
