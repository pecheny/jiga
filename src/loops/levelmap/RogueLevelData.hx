package loops.levelmap;

import ec.PropertyComponent.FlagComponent;
import fu.Signal;

class Room {
    public var visited:FlagComponent = @:privateAccess new FlagComponent();
}

typedef Doorways<TMove:Int> = Map<TMove, Int>;

class Level<TMove:Int, TRoom:(Room & fu.Serializable)> implements fu.Serializable {
    public var rooms(default, null):Array<TRoom> = [];
    @:serialize public var doors(default, null):Array<Doorways<TMove>> = [];
    public var onChange:Signal<Void->Void> = new Signal();
    public var onRoomEntered:Signal<Void->Void> = new Signal();

    @:serialize public var current(default, null):Int = -1;

    var roomFactory:Dynamic->TRoom;

    public function new(roomFactory:Dynamic->TRoom) {
        this.roomFactory = roomFactory;
    }

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
        if (current < 0 || current > doors.length - 1)
            return false;
        return doors[current].exists(dir);
    }

    public function initLevel(rooms, doors) {
        this.rooms = rooms;
        this.doors = doors;
        current = -1;
        onChange.dispatch();
    }

    public function load(data:Dynamic) {
        rooms.resize(0);
        var len = data?.rooms?.length;
        if (len == null || len < 1)
            return;

        var roomsSerialized:Array<Dynamic> = data.rooms;
        for (r in roomsSerialized) {
            var ri = roomFactory(r);
            ri.visited.value = r.visited;
            rooms.push(ri);
        }
        onChange.dispatch();
    }

    public function isEmpty() {
        return rooms.length == 0;
    }

    public function dump():Dynamic {
        var roomsSerialized = [
            for (r in rooms) {
                var d = r.dump();
                d.visited = r.visited.value;
                d;
            }
        ];
        Reflect.setField(data, "rooms", roomsSerialized);
    }
}
