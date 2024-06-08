package utils;

abstract WeightedRandomProvider<T:{ > Weighting,}>(Array<T>) {
    public inline function new(weightingOptions:Array<T>):Void {
        this = weightingOptions;
    }

    public inline function get():T {
        var total = 0.;
        for (w in this) {
            total += w.weight;
        }
        // select a random value between 0 and our total
        var random = Math.random() * total;

        // loop thru our weightings until we arrive at the correct one
        var current = 0.;
        var ww = null;
        for (w in this) {
            current += w.weight;
            ww = w;
            if (random < current)
                break;
        }
        return ww;
        // throw "Magic";
    }
}

typedef Weighting = {
    var weight:Float;
}
