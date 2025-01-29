package loops.levelmap;

import ec.PropertyComponent.FlagComponent;
import fu.Signal;

class Room {
    public var visited:FlagComponent = @:privateAccess new FlagComponent();
}

abstract Doorways<TMove>({}) {
    inline public function new() {
        this = {};
    }
    @:arrayAccess inline public function get(k:TMove):Int {
        return Reflect.field(this, "" + k);
    }

    inline public function exists(k:TMove):Bool {
        return Reflect.hasField(this, "" + k);
    }

    @:arrayAccess inline public function set(k:TMove, room:Int) {
        return Reflect.setField(this, "" + k, room);
    }
}

class Level<TMove, TRoom:Room> {
    public var rooms(default, null):Array<TRoom>;
    public var doors(default, null):Array<Doorways<TMove>>;
    public var onChange:Signal<Void->Void> = new Signal();
    public var onRoomEntered:Signal<Void->Void> = new Signal();

    public var current (default, null):Int = -1;

    public function new() {}

    public function move(direction:TMove):TRoom {
        if (!canMove(direction))
            throw "wrong";
        var newId = doors[current][direction];
        return enter(newId);
    }

    public function enter(id) {
        var newRoom = rooms[id];
        newRoom.visited.value = true;
        current = id;
        onRoomEntered.dispatch();
        return newRoom;
    }

    public function currentRoom() {
        return rooms[current];
    }

    public function canMove(dir:TMove) {
        return doors[current].exists(dir);
    }

    public function initLevel(rooms, doors) {
        this.rooms = rooms;
        this.doors = doors;
        current = -1;
        onChange.dispatch();
    }

    public function save() {}

    public function load(state) {}
}
