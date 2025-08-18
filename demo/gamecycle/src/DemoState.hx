package;

import fu.Serializable;
import persistent.State;

class DemoState implements State implements Serializable {
    @:serialize public var number:Int;

    public function new() {}
}
