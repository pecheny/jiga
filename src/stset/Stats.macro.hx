package stset;

import haxe.ds.ReadOnlyArray;
import haxe.macro.Context;
import haxe.macro.Expr;
import haxe.macro.ExprTools;
import haxe.macro.Type;

using StringTools;
using haxe.macro.ComplexTypeTools;
using haxe.macro.TypeTools;
using haxe.macro.Context;

typedef StatDesc = {?isStat:Bool, ?bType:Type, ?mainTPath:TypePath, ?mainType:Type, ?name:String, ?skipInit:Bool}

class StatsMacro {
    public static function build() {
        var t = Context.getLocalType();
        var lc = Context.getLocalClass().get();
        lc.meta.add(":keep", [], Context.currentPos());

        var fields:Array<Field> = Context.getBuildFields();
        var statNames:Array<StatDesc> = [];
        var ctxExprs = null;
        for (f in fields) {
            switch f {
                case {name: 'new', kind: FFun({expr: {expr: EBlock(ie)}})}:
                    ctxExprs = ie;
                    continue;
                case _:
            }
            var statDesc = isStat(f);
            statDesc.name = f.name;
            if (Lambda.exists(f.meta, m -> m.name == ":skipInit")) {
                trace("skip");
                statDesc.skipInit = true;
            }
            if (statDesc.isStat)
                statNames.push(statDesc);
        }
        fields.push({
            pos: Context.currentPos(),
            name: "keys",
            kind: FieldType.FProp("default", "null", macro :haxe.ds.ReadOnlyArray<String>, macro $a{statNames.map(n -> macro $v{n.name})}),
            access: [APublic],
        });

        if (ctxExprs == null) {
            ctxExprs = [];
            fields.push({
                pos: Context.currentPos(),
                name: 'new',
                kind: FFun({
                    args: [
                        {
                            name: "data",
                            type: macro :{}
                        }
                    ],
                    expr: {expr: EBlock(ctxExprs), pos: Context.currentPos()}
                }),
                access: [APublic]
            });
        }

        fields.push({
            pos: Context.currentPos(),
            name: 'get',
            kind: FFun({
                args: [
                    {
                        name: "id",
                        type: macro :String,
                    }
                ],
                ret: macro :GameStat<Float>,
                expr: macro return Reflect.field(this, id)
            }),
            access: [APublic]
        });

        #if display
        return fields;
        #end
        for (s in statNames) {
            if (s.skipInit)
                continue;
            var tp = s.mainTPath;
            var sTypeName = tp.sub ?? tp.name;
            ctxExprs.push(macro {
                var k = $v{s.name};
                var f:Dynamic = Reflect.field(data, k);
                if (Std.isOfType(f, $i{sTypeName}))
                    Reflect.setField(this, k, f);
                else if (Std.isOfType(f, Float)) {
                    var stat = new $tp(f);
                    Reflect.setField(this, k, stat);
                    if (data != null)
                        Reflect.setField(data, k, stat);
                } else if (f == null) {
                    var stat = new $tp(f);
                    Reflect.setField(this, k, stat);
                    if (data != null)
                        Reflect.setField(data, k, stat);
                } else
                    throw 'Wrong value for stat $k: $f';
            });
        }

        return fields;
    }

    static function isStat(f:Field):StatDesc {
        function isStatClType(clt:ClassType):Bool {
            if (clt == null)
                return false;
            switch clt {
                case {module: "stset.Stats", name: "GameStat"}:
                    return true;
                case {superClass: sc}:
                    return isStatClType(sc?.t?.get());
                case _:
                    throw "wrong";
            }
        }
        function isStatType(t:ComplexType):StatDesc {
            switch t.toType() {
                case TInst(_.get() => t, [utype]):
                    return if (isStatClType(t)) {isStat: true, bType: utype}; else {};
                case _:
                    return {};
            }
        }
        switch f.kind {
            case FVar(t, e):
                var r = isStatType(t);
                if (r?.isStat && e != null)
                    throw 'StatSet field "${f.name}" should not have init expression.';
                r.mainType = t.toType();
                r.mainTPath = switch t {
                    case TPath(p): p;
                    case _: throw "wrong";
                };
                return r;
            case FProp(get, set, t, e):
                var r = isStatType(t);
                if (r?.isStat && e != null)
                    throw 'StatSet field "${f.name}" should not have init expression.';
                r.mainType = t.toType();
                r.mainTPath = switch t {
                    case TPath(p): p;
                    case _: throw "wrong";
                };

                return r;
            case _:
                return {};
        }
    }
}
