package bootstrap;

import loops.talk.TalkData.TalkDesc;

// идея такая корлупная механика имеет свой генератор активитей,
// но условный квест с диалогами может напихивать сцен, которые должны будут выполниться, перед тем как вернуться в корлуп
class SceneManager<T> {
    var scenes:Array<T> = [];

    public var currentTalk:TalkDesc;

    public function new() {}

    public function pullScene():T {
        return scenes.pop();
    }

    public function pushScene(s:T) {
        scenes.push(s);
    }

    public function reset() {
        scenes.resize(0);
        currentTalk = null;
    }
}
