package;

import shimp.ClicksInputSystem.ClickTargetViewState;
import gl.passes.ImagePass;
import gl.DrawcallTypes;
import dkit.Dkit;
import gl.aspects.ExtractionUtils.TextureAspectFactory;
import htext.FontAspectsFactory;
import gl.passes.CmsdfPass;
import gl.passes.FlatColorPass;
import a2d.Stage;
import a2d.ContainerStyler;
import al.layouts.Padding;
import al.layouts.PortionLayout;
import al.layouts.WholefillLayout;
import al.layouts.data.LayoutData;
import ec.Entity;
import fu.UikitBase;
import gl.RenderingPipeline;
import gl.passes.CirclePass;
import macros.AVConstructor;

class JiUikit extends FlatUikit {
    public static var INACTIVE_COLORS(default, null):AVector<shimp.ClicksInputSystem.ClickTargetViewState, Int> = AVConstructor.create( //    Idle =>
        0xBB121212, 0xBB121212, 0xBB121212, 0xBB121212,);

    public static var INTERACTIVE_COLORS(default, null):AVector<ClickTargetViewState, Int> = AVConstructor.create( //    Idle =>
        0xff000000, //    Hovered =>
        0xffd46e00, //    Pressed =>
        0xFFd46e00, //    PressedOutside =>
        0xff000000);

   
    override function regStyles(e:Entity) {
        super.regStyles(e);
        textStyles.newStyle("")
            .withSize(sfr, .1)
            .withPadding(horizontal, sfr, 0.1)
            .withAlign(vertical, Center)
            .build();
        textStyles.newStyle("small-text").build();
        textStyles.newStyle("small-text-center").withAlign(horizontal, Center).build();
        
        textStyles.newStyle("nfit")
            .withSize(pfr, .5)
            .withAlign(horizontal, Center)
            .withAlign(vertical, Backward) // .withPadding(horizontal, pfr, 0.33)
            .withPadding(vertical, pfr, 0.33)
            .build();
        textStyles.resetToDefaults();


        // textStyles.newStyle(DS.small_text).withAlign(horizontal, Center).build();
        // textStyles.newStyle(DS.small_text_right).withAlign(horizontal, Backward).build();
        // textStyles.newStyle(DS.micro_text)
        //     .withAlign(horizontal, Center)
        //     .withAlign(vertical, Forward)
        //     .withSize(sfr, .05)
        //     .build();

        textStyles.resetToDefaults();
        textStyles.newStyle("center").withAlign(horizontal, Center).build();
        textStyles.newStyle("fit")
            .withSize(pfr, .5)
            .withAlign(horizontal, Forward)
            .withAlign(vertical, Backward)
            .withPadding(horizontal, pfr, 0.33)
            .withPadding(vertical, pfr, 0.33)
            .build();

        textStyles.resetToDefaults();
        // textStyles.newStyle(DS.heading).withSize(sfr, .14).build();
        properties.setInt(Dkit.TEXT_COLOR, 0xC8A3A3);
        properties.setString(Dkit.TEXT_STYLE, "small-text");
    }


    override function regLayouts(e) {
        super.regLayouts(e);
        // var distributer = new al.layouts.Padding(new FractionSize(.25), new PortionLayout(Center, new FixedSize(0.1)));
        var distributer = new PortionLayout(Center, new FixedSize(0.1));
        containers.reg(GuiStyles.L_HOR_CARDS, distributer, WholefillLayout.instance);
        containers.reg(GuiStyles.L_VERT_BUTTONS, WholefillLayout.instance, distributer);
    }
}
