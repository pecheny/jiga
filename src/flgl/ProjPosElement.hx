package flgl;
import data.aliases.AttribAliases;
import shaderbuilder.ShaderElement;
class ProjPosElement implements ShaderElement {
    public static var instance(default, null) = new ProjPosElement();

    function new() {}

    public function getDecls():String {
        return '
        uniform mat4 prj;
        ';

    }

    public function getExprs():String {
        return '
        gl_Position = prj * gl_Position;
        ';
        // gl_Position = prj * vec4(${AttribAliases.NAME_POSITION}.x, ${AttribAliases.NAME_POSITION}.y,  0., 1.);
    }
}