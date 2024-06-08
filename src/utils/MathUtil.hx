package utils;


class MathUtil {
    // Standard epsilon value
    public static inline var eps = 1e-6;

    public static inline function max<T:Float>(a:T, b:T):T {
        return b > a ? b : a;
    }

    public static inline function min<T:Float>(a:T, b:T):T {
        return b < a ? b : a;
    }

    public inline static function clamp<T:Float>(value:T, min:T, max:T):T {
        if (value < min) {
            return min;
        } else if (value > max) {
            return max;
        } else {
            return value;
        }
    }
}
