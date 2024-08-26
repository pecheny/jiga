import ec.Entity;
import gl.GLDisplayObject;
import data.aliases.AttribAliases;
import shaderbuilder.ShaderElement;
import gl.aspects.TextureBinder;
import gl.sets.CMSDFSet;
import shaderbuilder.SnaderBuilder;
import shaderbuilder.MSDFShader;
import gl.sets.MSDFSet;

class CmsdfPass extends PassBase<CMSDFSet> {
    static var smoothShaderEl = new GeneralPassthrough(MSDFSet.NAME_DPI, MSDFShader.smoothness);

    public function new(fui) {
        super(CMSDFSet.instance, fui, "cmsdf", "text");
        vertElems.push(ColorPassthroughVert.instance,);
        vertElems.push(Uv0Passthrough.instance,);
        vertElems.push(PosPassthrough.instance,);
        vertElems.push(smoothShaderEl);

        fragElems.push(MSDFFrag.instance);
        fragElems.push(ApplyVertColorFrag.instance);
    }

    override function createGldo(e:Entity, xml:Xml) {
        var fontName = xml.get("font");
        var font = fui.fonts.getFont(fontName);
        if (font == null)
            throw 'there is no font $fontName';
        return fui.createGldo(CMSDFSet.instance, e, shaderType, new TextureBinder(fui.textureStorage, font.texturePath), font.getId());
    }
}
