package;

import ec.PropertyComponent;
import storage.Storage;
import ec.Component;

class PersistentProperty<T> extends Component {
    @:once var storage:Storage;
    var property:PropertyComponent<T>;
    var key:String;

    public function new(e, prop:PropertyComponent<T>, key) {
        super(e);
        this.property = prop;
        this.key = key;
    }

    override function init() {
        var val = storage.getValue(key, null);
        if (val != null)
            property.value = val;
        else
            storage.saveValue(key, property.value);
        property.onChange.listen(() -> storage.saveValue(key, property.value));
    }
}
