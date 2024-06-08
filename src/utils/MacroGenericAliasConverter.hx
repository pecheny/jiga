package utils;

import haxe.macro.Context;
import haxe.macro.Expr;

class MacroGenericAliasConverter {
    macro public static function toAlias<T, TP>(e1:Expr, e2):ExprOf<String> {
        var s1 = checkType(e1);
        var s2 = checkType(e2);
        var name = s1 + "_" + s2;
        return macro $v{name};
    }

    macro public static function toString(e1:Expr):ExprOf<String> {
        var s1 = checkType(e1);
        return macro $v{s1};
    }

    // macro public static function extractTP(e, e2) {
    //     trace(e2);
    //     var t = Context.typeof(e);
    //     trace(t);
    //     var ts = "" + t;
    //     switch t {
    //         case TInst(t, params):
    //             var prms = t.get().params;
    //             trace(prms);
    //             if (prms.length > 0)
    //                 ts = "" + prms[0];
    //         case _:
    //     }
    //     // checkType(e);
    //     return macro $v{ts};
    // }

    #if macro
    static function checkType(e) {
        return switch e.expr {
            case EConst(CIdent(s)):
                var t = Context.getType(s); // check if there is a type with given name, typo guard
                s;
            case _:
                throw "Wrong type ";
        };
    }
    #end
}
