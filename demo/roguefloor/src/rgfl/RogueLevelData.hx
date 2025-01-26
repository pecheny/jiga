package rgfl;

import fu.Signal;

class Room {}

class Level<TMove, TRoom:Room> {
    public var rooms(default, null):Array<TRoom>;
    public var onChange:Signal<Void->Void> = new Signal();

    var current:Int;

    public function new() {}

    public function move(direction:TMove):TRoom {
        return null;
    }

    public function canMove(current:TRoom, dir:TMove) {
        return false;
    }

    public function initLevel(rooms) {
        this.rooms = rooms;
        onChange.dispatch();
    }

    public function save() {}

    public function load(state) {}
}
