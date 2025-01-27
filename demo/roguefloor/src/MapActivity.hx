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
        var rooms = [for (i in 0...10) new DummyRoom(i, i%2==0?green:red)];
        level.initLevel(rooms);
        rooms[2].visited.value = true;
    }
}
