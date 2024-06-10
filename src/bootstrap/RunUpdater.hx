package bootstrap;

import ginp.GameInput.GameInputUpdater;
import update.Updatable;
import update.Updater;

class RunUpdater implements Updater implements Updatable {
    var input:GameInputUpdater;

    public function new(i) {
        this.input = i;
    }

    var updatables:Array<Updatable> = [];

    public function update(dt) {
        input.beforeUpdate(dt);
        for (u in updatables)
            u.update(dt);
        input.afterUpdate();
    }

    public function addUpdatable(e:Updatable):Void {
        updatables.push(e);
    }

    public function removeUpdatable(e:Updatable):Void {
        updatables.remove(e);
    }
}
