package rgfl;

import gl.sets.ColorSet;
import graphics.ShapesColorAssigner;
import a2d.Placeholder2D;
import a2d.Widget;
import rgfl.RogueLevelData.Level;
import al.core.DataView;
import al.Builder;
import dkit.Dkit.BaseDkit;
import rgfl.RogueLevelData.Room;

class DummyLevel extends Level<DummyMove, DummyRoom> {}

class DummyRoom extends Room {
    public var pos:Int;
    public var type:DummyRoomType;

    public function new(p, t) {
        this.pos = p;
        this.type = t;
    }
}

enum abstract DummyRoomType(Int) {
    var red = 0xa03030;
    var green = 0x30a044;
}

enum abstract DummyMove(Int) {
    var forward = 1;
}

class LinearCellView extends BaseDkit implements DataView<Dynamic> {
    static var SRC = <linear-cell-view > ${fui.quad(__this__.ph, 0x206020)} </linear-cell-view>
    @:once var colors:ShapesColorAssigner<ColorSet>;


    public function initData(descr:Dynamic) {
        colors?.setColor(descr.type);
    }
}

class LinearMapView extends Widget {
    var rooms:a2d.ChildrenPool.DataChildrenPool<Dynamic, LinearCellView>;
    #if !display @:once #end
    var level:DummyLevel;
    #if !display @:once #end
    var fui:FuiBuilder;

    public function new(ph) {
        super(ph);
        var cellPh = () -> Builder.widget();
        var c = Builder.createContainer(ph, horizontal, Center);
        rooms = new fu.ui.InteractivePanelBuilder().withContainer(c).withWidget(() -> new LinearCellView(cellPh())).build();
    }
    
    override function init() {
        level.onChange.listen(() -> rooms.initData(level.rooms));
        if (level.rooms != null)
            rooms.initData(level.rooms);
    }

}
