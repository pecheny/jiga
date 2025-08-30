package persistent;

import fu.Signal;
import haxe.Json;
import persistent.State;
import storage.Storage;

class StorageStateManager implements StateLoader {
    public var onLoaded(default, null):Signal<Void->Void> = new Signal();

    var name = "save.json";
    var storage:Storage;
    var state:State;

    public function new(storage, state) {
        this.state = state;
        this.storage = storage;
    }

    public function save() {
        var data = state.dump();
        storage.saveValue(name, data);
    }
    
    public function delete() {
        storage.saveValue(name, null);
    }

    public function load() {
        var data = storage.getValue(name, null);
        state.load(data);
        onLoaded.dispatch();
    }

    public function hasValue() {
        var stdata = storage.getValue(name, null);
        return stdata != null;
    }
}
