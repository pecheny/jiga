package fancy;

import ec.PropertyComponent.FlagComponent;
import ec.Entity;

interface ActiveToggle {
    var enabled(get, set):Bool;
}

class ToggleComponent extends FlagComponent {}

interface Label {
    var text(get, set):String;
}

interface Colored {
    function setColor(val:Int):Void;
}
