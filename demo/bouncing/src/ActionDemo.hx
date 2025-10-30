package;

import BouncingDemoGui.ControlPanel;
import bootstrap.OneButtonActivity;
import utils.RGBA;
import loops.bounce.BouncingTimeline;
import loops.bounce.gui.BouncingWidget;
import loops.bounce.BouncingTimeline.RegionPreset;
import loops.bounce.BouncingLoop;
import bootstrap.BootstrapMain;
import ec.Entity;

using a2d.transform.LiquidTransformer;
using al.Builder;

class ActionDemo extends BootstrapMain {
    public function new() {
        super();

        rootEntity.addChild(createClickEmulator(new Entity("click emulator")));

        var e = new Entity("run");
        var wdg = new BouncingWidget(Builder.widget());
        var run = new BouncingLoop(e, wdg.ph, wdg);
        var timeline = new BouncingTimeline();
        e.addComponent(timeline);
        wdg.entity.addComponentByType(RegionStateProvider, timeline);
        wdg.entity.addComponentByType(RegionColorMap, new RegionColors());

        rootEntity.addChild(e);

        run.initDescr({
            numOfBounces: -1,
            // how many times player can trigger pointer action
            numOfHits: 3,
            // reinit all regions after each players tap
            hitReroll: true,
            periodDuration: () -> 1, // more customization -> replace with PeriodDuration
            // linear activity t -> pointer pos t transformer. kinda easing
            // timeFunction: (t:Float) -> (t*0.25*t) + 0.5,
            // Float normalized values of 'hit' regions, order refered to id of each region and doesnt affect visual representation order
            regions: [new RegionPreset(0.1, {})],
            //
            onMiss: null,
            // For presenting results of hit, before pointer starts move again or the activity ends
            afterHitDelay: 0.3,
        });

        var gui = new ControlPanel(Builder.widget());
        fui.makeClickInput(gui.ph);
        var oneButton = new OneButtonActivity(new Entity(), gui);
        run.gameOvered.listen(() -> runSwitcher.switchTo(oneButton));
        oneButton.gameOvered.listen(() -> {
            runSwitcher.switchTo(run);
            run.reset();
            run.startGame();
        });

        runSwitcher.switchTo(run);
        run.reset();
        run.startGame();
    }
}

class RegionColors implements RegionColorMap {
    public function new() {}

    // public var colorMap:Map<RegionType, Int> = [gap => 0x7E393939, hit => 0xff0000, parry => 0x40b020];
    // public var colorMapInac:Map<RegionType, Int> = [gap => 0x393939, hit => 0x740000, parry => 0x1d520f];

    public function getColor(def:Dynamic, isActive:Bool) {
        var color:RGBA = 0;
        if (def == null) {
            color = 0x7E393939;
        } else if (Std.isOfType(def.color, Int)) {
            color = def.color;
        } else {
            color = 0xff0059;
        }
        if (!isActive)
            color.a = 128;
        else
            color.a = 255;

        return color;
    }
}
