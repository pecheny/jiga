package bootstrap;

import a2d.Placeholder2D;
import ec.Entity;
import ec.Signal;
import gameapi.GameRun;

@:autoBuild(ec.macros.InitMacro.build())
class GameRunBase implements GameRun {
    @:isVar public var entity(get, set):Entity;
    public var gameOvered(default, null):Signal<() -> Void> = new Signal();

    var w:Placeholder2D;

    public function new(ctx, w:Placeholder2D) {
        this.w = w;
        entity = ctx;
        // entity.addComponentByType(GameRun, this);
        entity.addComponent(this);
    }

    public function reset() {}

    public function init() {
    }

    public function startGame():Void {}

    function _init(e:Entity) {}
    
    public function injectFrom(e:Entity) {
        _init(e);
    }

    public function get_entity():Entity {
        return entity;
    }

    public function set_entity(entity:Entity):Entity {
        if (this.entity != null)
            this.entity.onContext.remove(_init);
        this.entity = entity;
        entity.onContext.listen(_init);
        _init(entity);
        return entity;
    }

    public function getView():Placeholder2D {
        return w;
    }

	public function update(dt:Float) {}
}
