import rgfl.RogueLevelData.Doorways;
import rgfl.RgflLinear;
import rgfl.RogueLevelData.Level;
import bootstrap.GameRunBase;

class MapActivity extends GameRunBase {
    @:once var level:DummyLevel;

    public function new(e, ph) {
        super(e, ph);
        new LinearMapView(ph).watch(e);
    }

    override function startGame() {
        super.startGame();
        var rooms = [];
        var doors = [];
        for (i in 0...10) {
            rooms.push(new DummyRoom(i, i % 2 == 0 ? green : red));
            var dw = new Doorways();
            dw[forward] = i + 1;
            doors.push(dw);
        }

        level.initLevel(rooms, doors);
        level.enter(2);
        level.move(DummyMove.forward);
    }
}
