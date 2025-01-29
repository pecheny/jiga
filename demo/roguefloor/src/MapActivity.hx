import ginp.Keyboard;
import gl.sets.ColorSet;
import loops.levelmap.PosMarker;
import loops.levelmap.RogueLevelData.Doorways;
import levelmap.RgflLinear;
import loops.levelmap.RogueLevelData.Level;
import bootstrap.GameRunBase;

class MapActivity extends GameRunBase {
    @:once var level:DummyLevel;
    var marker:PosMarker;
    var map:LinearMapView;
    @:once var fui:FuiBuilder;

    public function new(e, ph) {
        super(e, ph);
        map = new LinearMapView(ph);
        map.watch(e);
        marker = new PosMarker(ColorSet.instance, ph);
        new utils.KeyBinder().addCommand(Keyboard.SPACE, () -> level.move(DummyMove.forward));
    }

    override function init() {
        super.init();
        fui.lqtr(getView());
        level.onRoomEntered.listen(onMove);
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

    function onMove() {
        marker.setTo(map.ph, map.getCellView(level.current).ph);
    }
}
