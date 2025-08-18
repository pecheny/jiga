package persistent;

import haxe.Json;
import fu.Signal;
import ec.Component;
import persistent.State;

class AssetStateLoader implements StateLoader extends Component {
    public var onLoaded(default, null):Signal<Void->Void> = new Signal();

    @:once var state:State;

    public function load(name = "state.json") {
        var data = Json.parse(openfl.utils.Assets.getText(name));
        state.load(data);
        onLoaded.dispatch();
    }
}
