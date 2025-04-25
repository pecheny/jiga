package bootstrap;

import haxe.ds.ReadOnlyArray;
import gameapi.GameRun;
import ec.Entity;

class Activitor {
    var entity:Entity;
    var handlers:Array<GameRun> = [];

    public function new(e) {
        this.entity = e;
    }

    public function regHandler<T:DescWrap<D>, D, TH:ActHandler<D>>(h:TH, descrType:Class<T>):TH {
        this.entity.addComponentByName(getHandleName(descrType), h);
        handlers.push(h);
        return h;
    }

    // а нужен ли енум, может просто по типу хэндлить
    public inline function getHandler<T:DescWrap<D>, D>(descType:Class<T>):ActHandler<D> {
        return this.entity.getComponentByName(getHandleName(descType));
    }

    public function getAllActivities():ReadOnlyArray<GameRun> {
        return handlers;
    }

    public inline function getHandleName<T>(descType:Class<T>):String {
        return Type.getClassName(ActHandler) + " " + Type.getClassName(descType);
    }

    inline function getTypeName<T>(descrType:Class<T>) {
        return Type.getClassName(descrType);
    }
}

interface StatefullActHandler {
    var onChange:fu.Signal<Void->Void>;
    function dump():Dynamic;
}

interface ActHandler<T> extends GameRun {
    public function initDescr(d:T):ActHandler<T>;
}

typedef IJsonParser<T> = {
    function fromJson(s:String, ?file:String):T;
}
