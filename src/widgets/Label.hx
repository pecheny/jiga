package widgets;

import al.core.DataView;
import fu.ui.CMSDFLabel;

typedef Label = CMSDFLabel;

class DataLabel extends Label implements DataView<String> {
    public function initData(descr:String) {
        withText(descr);
    }
}
