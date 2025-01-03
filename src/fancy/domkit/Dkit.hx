package fancy.domkit;

import fu.bootstrap.ButtonScale;
import a2d.Placeholder2D;
import a2d.Widget2DContainer;
import a2d.Widget;
import al.appliers.ContainerRefresher;
import al.core.TWidget.IWidget;
import al.layouts.AxisLayout;
import al.layouts.WholefillLayout;
import ec.Entity;
import a2d.ContainerStyler;
import fu.PropStorage;
import fu.graphics.ColouredQuad;
import fu.ui.ButtonBase;
import fu.ui.CMSDFLabel;
import graphics.ShapesColorAssigner;
import htext.style.TextContextBuilder.TextContextStorage;
using a2d.ProxyWidgetTransform;

class Dkit {
    public static inline var TEXT_COLOR = "TEXT_COLOR";
    public static inline var TEXT_STYLE = "TEXT_STYLE";
}

@:uiComp("base")
@:postInit(initDkit)
@:autoBuild(fancy.domkit.Macros.DefaultConstructorBuilder.build())
class BaseDkit implements domkit.Model<BaseDkit> implements domkit.Object implements IWidget<Axis2D> {
    public var ph(get, null):Placeholder2D;
    public var entity(get, null):Entity;
    public var c:Widget2DContainer;
    public var fui(get, null):FuiBuilder;
    public var onConstruct:(Placeholder2D)->Void;

    var hl:AxisLayout = WholefillLayout.instance;
    var vl:AxisLayout = WholefillLayout.instance;
    @:isVar var layouts(default, set):String = "";

    static var _fui:FuiBuilder;

    @:once var containerStyler:ContainerStyler;

    public static function inject(fui) {
        _fui = fui;
    }

    var children:Array<BaseDkit> = [];

    public var dom:domkit.Properties<BaseDkit>;
    public var parent:BaseDkit;

    public function getChildren()
        return children;

    public function new(p:Placeholder2D, ?parent:BaseDkit) {
        if (p == null)
            this.ph = b().b();
        else
            this.ph = p;

        if (parent != null) {
            this.fui = parent.fui;
            this.parent = parent;
            parent.children.push(this);
        } else if (fui != null)
            this.fui = fui;

        initComponent();
        watch(entity);
    }

    function _init(e:Entity) {}

    inline function containerRequired() {
        if (children.length > 0)
            return true;
        if (layouts != "")
            return true;
        if (vl != WholefillLayout.instance)
            return true;
        if (hl != WholefillLayout.instance)
            return true;
        return false;
    }

    public function initDkit() {
        if (onConstruct!=null)
            onConstruct(ph);
        if (containerRequired()) {
            c = new Widget2DContainer(ph.getInnerPh(), 2);
            for (a in Axis2D) {
                ph.getInnerPh().axisStates[a].addSibling(new ContainerRefresher(c));
            }
            setLayouts();
            ph.entity.addComponent(c);
            for (ch in children) {
                c.addChild(ch.ph);
                c.entity.addChild(ch.ph.entity);
            }
        }
        entity.dispatchContext();
    }

    function setLayouts() {
        if (c == null)
            return;
        if (containerStyler != null && layouts != "") {
            containerStyler.stylize(c, layouts);
        } else {
            c.setLayout(horizontal, hl);
            c.setLayout(vertical, vl);
        }
        c.refresh();
    }

    public function init() {
        if (layouts != "")
            setLayouts();
    }

    function b() {
        return fui.placeholderBuilder;
    }

    function get_fui():FuiBuilder {
        return _fui;
    }

    function get_ph():Placeholder2D {
        return ph;
    }

    function get_entity():Entity {
        return ph.entity;
    }

    function set_layouts(value:String):String {
        layouts = value;
        setLayouts();
        return value;
    }
}

@:uiComp("button")
class ButtonDkit extends BaseDkit {
    public var label:CMSDFLabel;
    public var text(default, set):String = "";
    public var onClick:Void->Void;
    public var style(default, default):String = "";

    @:once var styles:TextContextStorage;
    @:once var props:PropStorage<Dynamic>;

    public function new(p:Placeholder2D, ?parent) {
        super(p, parent);
        initComponent();
    }

    override function init() {
        super.init();
        var btn = new ButtonBase(ph, _onClick);
        ProxyWidgetTransform.grantInnerTransformPh(ph);
        fui.quad(ph.getInnerPh(), 0);
        btn.addHandler(new InteractiveColors(entity.getComponent(ShapesColorAssigner).setColor).viewHandler);
        if (style == "")
            style = props.get(Dkit.TEXT_STYLE);
        label = new CMSDFLabel(ph.getInnerPh(), fui.s(style));
        new ButtonScale(ph.entity);
        text = text;
    }
    
    function _onClick() {
        if (onClick!=null)
            onClick();
    }

    function set_text(value:String):String {
        text = value;
        label?.withText(value);
        return value;
    }
}

@:uiComp("label")
class LabelDkit extends BaseDkit {
    public var color(default, set):Int = 0xffffff;
    public var label:CMSDFLabel;
    public var text(default, set):String = "";
    public var style(default, default):String = "";

    @:once var styles:TextContextStorage;
    @:once var props:PropStorage<Dynamic>;

    public function new(p:Placeholder2D, ?parent) {
        super(p, parent);
        initComponent();
    }

    override function init() {
        super.init();
        if (style == "")
            style = props.get(Dkit.TEXT_STYLE);
        label = new CMSDFLabel(ph, fui.s(style));
        color = color;
        text = text;
    }

    function set_color(value:Int):Int {
        color = value;
        label?.setColor(value);
        return value;
    }

    function set_text(value:String):String {
        text = value;
        label?.withText(value);
        return value;
    }
}
