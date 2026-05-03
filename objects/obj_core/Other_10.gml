/// @description 도화 코어 상호작용 (User Event 0)

var bloom_str = string(floor(global.bloom_percent * 10) / 10);
var core_str = string(floor(global.core_power));

// 코어 상태에 따라 다른 대사
if (global.bloom_percent >= 100) {
    global.ShowDialogue([
        { name: "시스템", text: "[개화 프로토콜] 100%\n[상태] DOHWA BLOOM: COMPLETE" },
        { name: "", text: "돔 전체가 빛난다.\n외부의 빛이 아니라 내부에서 솟아나는 빛이다." },
        { name: "", text: "도화 코어의 외피가 천천히 열리며\n꽃잎처럼 갈라진다." }
    ]);
} else if (global.bloom_percent >= 83) {
    global.ShowDialogue([
        { name: "", text: "금속 꽃봉오리 같은 구조물이\n낮게 숨을 쉰다." },
        { name: "시스템", text: "[개화 프로토콜] " + bloom_str + "%\n[코어 전력] " + core_str + "%" },
        { name: "", text: "코어의 외피가 미세하게 진동한다.\n무언가가 내부에서 자라고 있다." }
    ]);
} else if (global.core_power >= 100) {
    global.ShowDialogue([
        { name: "", text: "축전조의 불빛이 안정적으로 빛난다." },
        { name: "시스템", text: "[코어 전력] 100%\n[개화 진행] " + bloom_str + "%" },
        { name: "", text: "전력이 꽉 찼다. 오늘 밤은 안전하게 버틸 수 있을 것이다." }
    ]);
} else {
    global.ShowDialogue([
        { name: "", text: "금속 꽃봉오리 같은 구조물이\n낮게 숨을 쉰다. 도화 코어." },
        { name: "시스템", text: "[코어 전력] " + core_str + "%\n[개화 진행] " + bloom_str + "%" },
        { name: "", text: "축전조에 전력을 채워야 한다.\n정제기에서 별사리풀을 변환하자." }
    ]);
}
