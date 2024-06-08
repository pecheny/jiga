package;

import haxe.io.Bytes;
import Gameplay.Joe;
import data.IndexCollection;
import data.aliases.AttribAliases;
import ec.CtxWatcher;
import ecbind.RenderableBinder;
import ecbind.RenderablesComponent;
import gl.RenderTarget;
import gl.Renderable;
import gl.sets.ColorSet;

class Render {
    public function new(gp:Gameplay) {
        var rend = new JoeRender(gp.joe);
        var bg = new BgRender(gp);
        var drawcallsData = RenderablesComponent.get(ColorSet.instance, gp.getView().entity);
        drawcallsData.views.push(bg);
        drawcallsData.views.push(rend);
        new CtxWatcher(RenderableBinder, gp.getView().entity);
    }
}

class BgRender implements Renderable<ColorSet> {
    public var buffer(default, null):Bytes;

    var attrs = ColorSet.instance;

    public function new(gplay:Gameplay) {
        buffer = Bytes.alloc(4 * attrs.stride);
        attrs.writeColor(buffer, 0x563988, 0, 4, 60);
        
        var wr = attrs.getWriter(AttribAliases.NAME_POSITION);
        var a = 0;
        var o = 0.0;
        var xp = [gplay.F_BRD[a]+o, gplay.L_BRD[a]-o, gplay.L_BRD[a]-o, gplay.F_BRD[a]+o];
        var a = 1;
        var yp = [gplay.F_BRD[a]+o, gplay.F_BRD[a]+o, gplay.L_BRD[a]-o, gplay.L_BRD[a]-o];
        for (i in 0...4) {
            wr[0].setValue(buffer, i, xp[i]);
            wr[1].setValue(buffer, i, yp[i]);
        }
        var r = "";
        
    }

    public function render(targets:RenderTarget<ColorSet>) {
        targets.blitIndices(IndexCollections.QUAD,IndexCollections.QUAD.length);
        targets.blitVerts(buffer, 4);
    }
}

class JoeRender implements Renderable<ColorSet> {
    var joe:Joe;

    public function new(j) {
        this.joe = j;
    }

    public function render(targets:RenderTarget<ColorSet>) {
        targets.grantCapacity(4);
        ColorSet.instance.writeColor(targets.verts.getBytes(), 0xB85A5A, targets.verts.pos, 4);
        targets.blitIndices(IndexCollections.QUAD, 6);
        targets.writeValue(AttribAliases.NAME_POSITION, 0, joe.pos[0] - joe.R);
        targets.writeValue(AttribAliases.NAME_POSITION, 1, joe.pos[1] - joe.R);
        targets.commitVertices();
        targets.writeValue(AttribAliases.NAME_POSITION, 0, joe.pos[0] + joe.R);
        targets.writeValue(AttribAliases.NAME_POSITION, 1, joe.pos[1] - joe.R);
        targets.commitVertices();
        targets.writeValue(AttribAliases.NAME_POSITION, 0, joe.pos[0] + joe.R);
        targets.writeValue(AttribAliases.NAME_POSITION, 1, joe.pos[1] + joe.R);
        targets.commitVertices();
        targets.writeValue(AttribAliases.NAME_POSITION, 0, joe.pos[0] - joe.R);
        targets.writeValue(AttribAliases.NAME_POSITION, 1, joe.pos[1] + joe.R);
        targets.commitVertices();
    }
}
