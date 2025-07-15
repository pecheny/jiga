package loops.bounce;

import utils.Signal;
import utils.Random;
import haxe.ds.ReadOnlyArray;
import loops.bounce.Data;
import bootstrap.Data;

class MyWeaponFac {
    public function new() {}

    public function createDummyTracer() {
        var preset = new RegionPreset(0.2, (v) -> trace("onhit " + v), 1);
        var weapon = new BouncingTimeline();
        weapon.init([preset]);
        return weapon;
    }

    public function createWeapon(onHit, onMiss) {
        var preset = new RegionPreset(0.2, onHit, 1);
        var weapon = new BouncingTimeline();
        weapon.init([preset]);
        weapon.onGap = onMiss;
        return weapon;
    }
}

class RegionPreset {
    public var size:NormVal;
    // public var regionType:Int = 1;
    public var regionDef(default, null):Dynamic;
    // how much times this region can be executed in a run
    public var activationsNumber:Int = 1;

    public function new(size, ?onHit, type:Dynamic) {
        this.size = size;
        this.regionDef = type;
        if (onHit != null)
            this.onHit = onHit;
    }

    public dynamic function onHit(v:NormVal):Void {}
}

typedef PresetId = Int;

class BouncingTimeline implements RegionStateProvider {
    public var onChange:Signal<Void->Void> = new Signal();

    var presets:Array<RegionPreset>;
    var weights:Array<Weight>;
    // number of region executions
    var execCounts:Array<Int>;
    // visual and weight ordered number of region to id in presets array
    var idMap:Array<PresetId>;

    inline static var GAP_ID = -1;

    public function new() {}

    public function init(presets) {
        this.presets = presets;
        weights = [for (i in 0...presets.length * 2 + 1) 0.];
        execCounts = [for (i in 0...presets.length) 0];
        idMap = [for (i in 0...presets.length * 2 + 1) 0];
    }

    public function reroll() {
        for (i in 0...execCounts.length)
            execCounts[i] = 0;
        var indsPoll = [for (i in 0...presets.length) i];
        Random.shuffle(indsPoll);
        var totalHitRegionsWeight = 0.;

        for (r in presets)
            totalHitRegionsWeight += r.size;
        if (totalHitRegionsWeight > 1)
            throw "wrong";
        var totalGapWeights = 1 - totalHitRegionsWeight;
        var gapWg = totalGapWeights / (presets.length + 1);
        var i = 0;
        var gapMutators = genMutators(presets.length + 1);
        var gapId = 0;

        inline function procReg(i, defId) {
            var size = defId == -1 ? totalGapWeights * gapMutators[gapId++] : presets[defId].size;
            weights[i] = size;
            idMap[i] = defId;
        }
        procReg(i++, GAP_ID);

        for (j in 0...presets.length) {
            var presetId = indsPoll.shift();
            procReg(i++, presetId);
            procReg(i++, GAP_ID);
        }
        if (Math.abs(sum(weights) - 1) > 0.000001)
            throw "wrong";
        onChange.dispatch();
    }

    function genMutators(n) {
        var muts = [for (i in 0...n) Math.random()];
        var s = sum(muts);
        var mp = 1 / s;
        for (i in 0...muts.length)
            muts[i] = mp * muts[i];
        return muts;
    }

    function sum(muts:Array<Float>) {
        var sum = 0.;
        for (m in muts)
            sum += m;
        return sum;
    }

    public function getWeights():ReadOnlyArray<Weight> {
        return weights;
    }

    public function execRegionHit(id:RegionId) {
        var defId = idMap[id];
        if (defId == GAP_ID) {
            if (onGap != null)
                onGap();
        } else {
            var execCount = execCounts[defId];
            var preset = presets[defId];
            if (execCount < preset.activationsNumber) {
                execCounts[defId]++;
                preset.onHit(1.);
            } else {
                if (onGap != null)
                    onGap();
            }
        }
        onChange.dispatch();
    }

    public function getRegionExecCount(id:RegionId) {
        var defId = idMap[id];
        if (defId == GAP_ID)
            return 0;
        var execCount = execCounts[defId];
        return execCount;
    }

    public function getRegionDef(id:RegionId) {
        var defId = idMap[id];
        if (defId == GAP_ID)
            return null;
        var preset = presets[defId];
        return preset;
    }

    public dynamic function onGap() {
        // trace("gap");
    }
}

interface RegionStateProvider {
    var onChange:Signal<Void->Void>;
    public function getRegionDef(id:RegionId):RegionPreset;
    public function getRegionExecCount(id:RegionId):Int;
}

// class RegionProcessor {
//     var regions:Array<Float>;
//     // r = array of "edges", splitting [0,1] into regions
//     // values should be in [0,1] and ordered
//     public function setRegions(r:Array<Float>) {}
//     // or keep state: update, last region and regionChanged
//     public function getRegion(t:Float):Int {
//         return -1;
//     }
// }
// class RegionRoller {
//     public function roll(def:Array<RegionDef>) {
//         /*
//             стопка регион-дефов, тянем рандомный, чередуем с дырами рандомного размера (вынимаем из общего объема дырявостей)
//              array [0...def.len]
//             shuffle
//             total gap size / num gaps
//             mutate gap size
//             pick gap-r-gap...
//          */
//     }
//     // function shuffle(array) {
//     //     var m = array.length, t, i;
//     //     // While there remain elements to shuffle…
//     //     while (m) {
//     //       // Pick a remaining element…
//     //       i = Math.floor(Math.random() * m--);
//     //       // And swap it with the current element.
//     //       t = array[m];
//     //       array[m] = array[i];
//     //       array[i] = t;
//     //     }
//     //     return array;
//     //   }
// }
