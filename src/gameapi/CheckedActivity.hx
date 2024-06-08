package gameapi;

interface CheckedActivity extends GameRun {
    public function shouldActivate():Bool;
}
