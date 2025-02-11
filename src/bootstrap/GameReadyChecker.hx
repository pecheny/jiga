package bootstrap;

import a2d.Placeholder2D;
import ec.Entity;
import ec.PropertyComponent;
import ec.Signal;
import gameapi.GameRun;

class GameReadyChecker implements GameRun {
    public var gameOvered(default, null):Signal<Void->Void> = new Signal();
    public var entity(get, set):Entity;

    var target:GameRunBase;
    var running = false;
    var isReady:GameIsReady;

    public function new(target:GameRunBase) {
        this.target = target;
        isReady = GameIsReady.getOrCreate(target.entity);
        target.gameOvered.listen(onGameOver);
    }

    public function startGame() {
        if (isReady.value)
            start();
        else
            isReady.onChange.listen(onReady);
    }

    function onReady() {
        if (!isReady.value)
            return;
        isReady.onChange.remove(onReady);
        start();
    }

    function start() {
        trace(isReady.value);
        target.reset();
        running = true;
        target.startGame();
    }

    public function update(dt:Float) {
        if (running)
            target.update(dt);
    }

    public function reset() {
        running = false;
        if (isReady.value)
            target.reset();
    }

    function onGameOver() {
        reset();
        gameOvered.dispatch();
    }

    public function set_entity(value:Entity):Entity {
        throw new haxe.exceptions.NotImplementedException();
    }

    public function get_entity():Entity {
        return target.entity;
    }

    public function getView():Placeholder2D {
        return target.getView();
    }
    
    public function injectFrom(e:Entity) {
        throw "na";
    }
}

class GameIsReady extends PropertyComponent<Bool> {}
