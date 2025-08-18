package persistent;

import haxe.Json;
import fu.Signal;
import storage.Storage;
import ec.Component;
import persistent.State;

class StorageStateManager implements StateLoader extends Component {
    public var onLoaded(default, null):Signal<Void->Void> = new Signal();

    @:once var storage:Storage;
    @:once var state:State;

    public function load(name = "save.json") {
        var stdata = storage.getValue(name, null);
        var data = Json.parse(stdata);
        state.load(data);
        onLoaded.dispatch();
    }
}
