package loops.bounce;

import bootstrap.DescWrap;
import loops.bounce.BouncingTimeline.RegionPreset;

//ordered number of weights dealed by loop
typedef RegionId = Int;

typedef LoopConfig = {
    // how many times pointer flows forth and back. -1 = infinity
    var numOfBounces:Int;
    // how many times player can trigger pointer action
    var numOfHits:Int;
    // reinit all regions after each players tap
    var hitReroll:Bool;
    var periodDuration:Void->Float;// more customization -> replace with PeriodDuration
    // linear activity t -> pointer pos t transformer. kinda easing
    var timeFunction:String;
    // Float normalized values of 'hit' regions, order refered to id of each region and doesnt affect visual representation order
    var regions:Array<RegionPreset>;
}


class LoopData extends DescWrap<LoopConfig> {}