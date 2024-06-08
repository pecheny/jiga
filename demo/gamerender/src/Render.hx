package;
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
        var drawcallsData = RenderablesComponent.get(ColorSet.instance, gp.getView().entity);
        drawcallsData.views.push(rend);
        new CtxWatcher(RenderableBinder, gp.getView().entity);
    }
}


class JoeRender implements Renderable<ColorSet> {
    var joe:Joe;

    public function new(j) {
        this.joe = j;
    }

    public function render(targets:RenderTarget<ColorSet>) {
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