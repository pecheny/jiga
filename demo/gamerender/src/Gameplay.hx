import bootstrap.GameRunBase;
import hxmath.math.Vector2;

class Gameplay extends GameRunBase {
    var F_BRD = new Vector2(-10, -10);
    var L_BRD = new Vector2(10, 10);
    var spdval = 1.;

    public var joe = new Joe();


    override function reset() {
        super.reset();
        joe.pos.set((F_BRD[0] + L_BRD[0]) / 2, (F_BRD[1] + L_BRD[1]) / 2);
        joe.spd.set(spdval, 0);
        joe.spd.angle = Math.random() * 2 * Math.PI;
    }

    override function update(dt:Float) {
        joe.pos += joe.spd * dt;
        // trace(joe.pos);
        for (i in 0...2)
            if (!inside(i))
                joe.spd[i] *= -1;
    }

    inline function inside(axis:Int) {
        return joe.pos[axis] > F_BRD[axis] + joe.R && joe.pos[axis] < L_BRD[axis] - joe.R;
    }
}

class Joe {
    public var R:Float = 0.5;
    public var pos:Vector2 = new Vector2(0, 0);
    public var spd:Vector2 = new Vector2(0, 0);

    public function new() {}
}
