package fancy.widgets;

import fu.ui.ButtonBase;

class NumButton extends ButtonBase {
	var numHandler:Int->Void;
	var n:Int;

	public function new(w, n, hndl) {
		super(w, null);
		this.n = n;
		this.numHandler = hndl;
	}

	override function handler() {
		super.handler();
		numHandler(n);
	}
}
