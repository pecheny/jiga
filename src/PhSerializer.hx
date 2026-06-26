import a2d.Placeholder2D;
import a2d.ProxyTransformInterpolator;
import al.core.AxisState;

typedef PhDump = Array<{pos:Float, size:Float}>;

class PhSerializer {
    public static function dump(ph:Placeholder2D):PhDump {
        return [for (a in Axis2D) dumpAxis(ph.axisStates[a])];
    }

    public static function dumpAxis(as:AxisState) {
        return {
            pos: as.getPos(),
            size: as.getSize()
        };
    }

    public static function loadFrom(target:ProxyTransformInterpolator, dump:PhDump) {
        for (a in Axis2D) {
            target.setFromState(a, dump[a].pos, dump[a].size);
        }
    }

    public static function loadTo(target:ProxyTransformInterpolator, dump:PhDump) {
        for (a in Axis2D) {
            target.setToState(a, dump[a].pos, dump[a].size);
        }
    }
}
