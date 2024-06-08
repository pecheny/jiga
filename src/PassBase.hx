package;

import ec.Entity;
import gl.AttribSet;
import shaderbuilder.ShaderElement;

class PassBase<TAtt:AttribSet> {
    var fui:FuiBuilder;
    var attr:TAtt;

    public var shaderType(default, null):String;
    public var drawcallType(default, null):String;

    public var vertElems(default, null):Array<ShaderElement> = [];
    public var fragElems(default, null):Array<ShaderElement> = [];
    public var uniforms(default, null):Array<String> = [];
    public var alias(default, null):Array<String> = [];

    public function new(att:TAtt, fui, shaderType, drawcallType) {
        this.fui = fui;
        this.attr = att;
        this.drawcallType = drawcallType;
        this.shaderType = shaderType;
    }

    function getShaderAlias() {
        if (alias.length > 0)
            return shaderType + "+" + alias.join("+");
        else
            return shaderType;
    }

    public function register() {
        fui.regDrawcallType(drawcallType, {
            type: getShaderAlias(),
            attrs: attr,
            vert: vertElems,
            frag: fragElems,
            uniforms: uniforms
        }, createGldo);
    }

    function createGldo(e:Entity, xml:Xml) {
        return fui.createGldo(attr, e, shaderType, createAspect(e, xml), "");
    }

    function createAspect(e:Entity, xml:Xml) {
        return null;
    }
}
