package stset;

import haxe.macro.Context;
import haxe.macro.Type;
import haxe.macro.Expr;

using haxe.macro.TypeTools;
using haxe.macro.ComplexTypeTools;
using StringTools;

class StatsMacro {
    #if macro
    public static function build() {
        var t = Context.getLocalType();
        var statNames = null;
        var underValTPath = null;
        var underValType = null;
        switch t {
            case TInst(_.get() => {superClass: {t: _.get() => {name: "Stats"}, params: [stEnumTp, tp2]}}, prm):
                statNames = extrFields(stEnumTp);
                underValType = tp2;
                underValTPath = switch tp2.toComplexType() {
                    case TPath(p): p;
                    case _: throw tp2;
                };
            case _:
        }
        // var ct:ComplexType = t.toComplexType();
        // trace(ct  + " " + t.);
        var basisName:String;

        var fields:Array<Field> = Context.getBuildFields();
        addField(fields, "_keys", macro :Array<String>, macro $a{statNames.map(n -> macro $v{n})}, [APublic, AStatic]);
        addMethod(fields, "keys", [macro return _keys]);
        addMethod(fields, "createValues", genConstructorExprs(statNames, underValTPath));
        for (key in statNames)
            addGetSet(fields, key, underValType);
        return fields;
    }

    static function addGetSet(fields:Array<Field>, name, underValType:Type) {
        addMethod(fields, "get_" + name, [macro return stats.get($v{name}).getVal()]);
        addMethod(fields, "set_" + name, [macro stats.get($v{name}).setVal(v), macro return v], [{name:"v"}]);
        var ct :ComplexType = underValType.toComplexType();
        var fld:Field = {
            pos: Context.currentPos(),
            name: name,
            kind: FieldType.FProp("get" , "set", macro:Int),
            access: [APublic]
        };
        fields.push(fld);
    }

    static function genConstructorExprs(keys:Array<String>, underValTPath) {
        var exprs = [];
        for (k in keys) {
            exprs.push(macro if (!stats.exists($v{k}) ||stats.get($v{k}) == null ) stats.set($v{k}, new $underValTPath(0)));
        }
        return exprs;
    }

    static function extrFields(enumT:Type) {
        switch enumT {
            case TAbstract(_.get() => at, params):
                // trace(at.);
                var valueExprs = [];
                for (field in at.impl.get().statics.get()) {
                    if (field.meta.has(":enum") && field.meta.has(":impl")) {
                        var fieldName = field.name;
                        valueExprs.push(fieldName);
                    }
                }
                return valueExprs;
            case _:
                throw enumT;
        }
    }

    static function hasField(ct:ClassType, name) {
        for (f in ct.fields.get())
            if (f.name == name) {
                return true;
            }
        if (ct.superClass != null) {
            var r = hasField(ct.superClass.t.get(), name);
            return r;
        }
        return false;
    }

    static function addField(fields:Array<Field>, name, type, ?e, ?a) {
        if (!hasField(Context.getLocalClass().get(), name))
            fields.push({
                pos: Context.currentPos(),
                name: name,
                kind: FieldType.FVar(type, e),
                access: a,
            });
    }

    static function addMethod(fields:Array<Field>, name, exprs:Array<Expr>, ?args ) {
        var access = [APublic];
        if (hasField(Context.getLocalClass().get(), name)) {
            access.push(AOverride);
            // exprs.unshift(macro $p{["super", name]}());
        }
        fields.push({
            pos: Context.currentPos(),
            name: name,
            access: access,
            kind: FieldType.FFun({args: args!=null?args:[], expr: {expr: EBlock(exprs), pos: Context.currentPos()}}),
        });
    }
    #end
}
