package persistent;

import fu.Signal;
import haxe.Json;
import persistent.State;

class AssetStateLoader implements StateLoader {
    public var onLoaded(default, null):Signal<Void->Void> = new Signal();

    var state:State;

    public function new(state) {
        this.state = state;
    }

    public dynamic function dataLoadedHook(data:Dynamic) {
        return data;
    }

    public dynamic function stateLoadedHook() {}

    public function load(name = "state.json") {
        var data = dataLoadedHook(Json.parse(openfl.utils.Assets.getText(name)));
        state.load(data);
        stateLoadedHook();
        onLoaded.dispatch();
    }
}
