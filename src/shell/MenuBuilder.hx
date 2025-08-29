package shell;

import bootstrap.RunSwitcher;
import shell.MenuItem.MenuData;

class MenuBuilder {
    var switcher:RunSwitcher;
    var data:MenuData = [];

    public var activity:MenuActivity;

    public function new(switcher, run) {
        this.switcher = switcher;
        this.activity = run;
    }

    public function addButton(desc:MenuItem, at = -1) {
        if (at > -1)
            data.insert(at, desc);
        else
            data.push(desc);
    }

    function initMenu() {
        activity.initData(data);
    }

    public function show() {
        if (activity.view == null) {
            new MenuView(activity.getView());
        }
        initMenu();
        switcher.switchTo(activity);
    }
}
