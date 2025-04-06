package levelmap;

import utils.RGBA;
import ec.PropertyComponent.FlagComponent;
import al.layouts.PortionLayout;
import al.layouts.WholefillLayout;
import al.layouts.data.LayoutData.FractionSize;
import al.layouts.Padding;
import al.InarrangableLayout;
import Axis2D;
import gl.sets.ColorSet;
import graphics.ShapesColorAssigner;
import a2d.Placeholder2D;
import a2d.Widget;
import loops.levelmap.RogueLevelData.Level;
import al.core.DataView;
import al.Builder;
import dkit.Dkit.BaseDkit;
import loops.levelmap.RogueLevelData.Room;

class DummyLevel extends Level<DummyMove, DummyRoom> {

    public function new() {
        function fac(data) {
            var r = new DummyRoom(data.pos, data.type);
            return r;
        }
        super(fac);
    }
}

class DummyRoom extends Room implements fu.Serializable {
    public var pos:Int;
    public var type:DummyRoomType;

    public function new(p, t) {
        this.pos = p;
        this.type = t;
    }
}

enum abstract DummyRoomType(Int) to Int {
    var red = 0xa03030;
    var green = 0x30a044;
}

enum abstract DummyMove(Int) {
    var forward = 1;
}

class LinearCellView extends BaseDkit implements DataView<DummyRoom> {
    static var SRC = <linear-cell-view > ${fui.quad(__this__.ph, 0x206020)} </linear-cell-view>

    @:once var colors:ShapesColorAssigner<ColorSet>;
    var data:DummyRoom;

    public function initData(descr:DummyRoom) {
        if (data!=null)
            data.visited.onChange.remove(onVisit);
        data = descr;
        data.visited.onChange.listen(onVisit);
        onVisit();

        // use cell coords
        // ph.axisStates[horizontal].position.value = descr.pos * 5;
    }
    
    function onVisit(){
        var color = new RGBA(data.type);
        color.a =  data.visited.value ?  255 :120 ;
        colors?.setColor(color);
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
        var c = Builder.createContainer(ph, horizontal, Center);

        var cellPh = () -> fui.placeholderBuilder.h(pfr, 1).v(pfr, 1).b();

        // use cell coords
        // var cellPh = () -> {
        //     var ph = fui.placeholderBuilder.h(pfr, 0.05).v(pfr, 1).b();
        //     // for (a in Axis2D)
        //         // ph.axisStates[a].position.type = percent;
        //     ph.axisStates[horizontal].position.type = percent;
        //     ph;
        // }
        // c.setLayout(horizontal,  InarrangableLayout.instance );

        c.setLayout(horizontal, new Padding(new FractionSize(0.05), new PortionLayout(Center, new FractionSize(0.5))));
        c.setLayout(vertical, new Padding(new FractionSize(0.3), WholefillLayout.instance));
        rooms = new fu.ui.InteractivePanelBuilder().withContainer(c).withWidget(() -> new LinearCellView(cellPh())).build();
    }

    override function init() {
        level.onChange.listen(() -> rooms.initData(level.rooms));
        if (level.rooms != null)
            rooms.initData(level.rooms);
    }
    
    public function getCellView(id) {
        return rooms.pool[id];
    }
}
