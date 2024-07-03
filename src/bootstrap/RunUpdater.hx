package bootstrap;

import ec.Entity;
import ginp.GameInput.GameInputUpdater;
import ginp.api.GameInputUpdaterBinder;
import update.Updatable;
import update.Updater;

class RunUpdater implements Updater implements Updatable implements GameInputUpdaterBinder {
    var inputs:Array<GameInputUpdater> = [];

    public function new() {}

    var updatables:Array<Updatable> = [];

    public function update(dt) {
        for (input in inputs)
            input.beforeUpdate(dt);
        for (u in updatables)
            u.update(dt);
        for (input in inputs)
            input.afterUpdate();
    }

    public function addUpdatable(e:Updatable):Void {
        updatables.push(e);
    }

    public function removeUpdatable(e:Updatable):Void {
        updatables.remove(e);
    }

    public function bind(e:Entity) {
        var input = e.getComponent(GameInputUpdater);
        if (input != null)
            inputs.push(input);
    }

    public function unbind(e:Entity) {
        var input = e.getComponent(GameInputUpdater);
        if (input != null)
            inputs.remove(input);
    }
}

