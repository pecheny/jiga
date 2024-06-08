package gameapi;

import al.al2d.Placeholder2D;
import ec.IComponent;
import ec.Entity;
import ec.Signal;
import update.Updatable;

interface GameRun extends Updatable {
    public var gameOvered(default, null):Signal<Void->Void>;
    public var entity(get, set):Entity;
    public function startGame():Void;
    public function reset():Void;
    public function getView():Placeholder2D;
}
