/// @description 여우 상호작용 (User Event 0)

// 친밀도에 따른 대사 변화
if (global.fox_trust < 30) {
    // 경계 상태: 다가가면 도망감
    global.ShowDialogue([
        { name: "", text: "작은 생명체가 나를 경계하며 바라본다.\n다가가자 재빨리 몸을 돌린다." },
        { name: "", text: "가까이 오지 않는다.\n가까이 오면 상처가 될까 봐,\n스스로를 조심하는 눈이다." }
    ]);
} else if (global.fox_trust < 50) {
    global.ShowDialogue([
        { name: "", text: "여전히 경계하지만,\n이전보다 거리가 가까워졌다." },
        { name: "", text: "내 장갑 끝을 한 번 냄새 맡고,\n다시 멀어진다." }
    ]);
    global.fox_trust += 3; // 상호작용하면 친밀도 소폭 증가
} else if (global.fox_trust < 70) {
    global.ShowDialogue([
        { name: "", text: "\"너는 여기서 무엇을 먹고 사니.\"" },
        { name: "", text: "여우는 대답하지 않는다.\n대신 내 장갑 끝을 한 번 냄새 맡고,\n다시 따뜻한 곳으로 올라간다." },
        { name: "", text: "그게 지금 우리 사이에서\n가능한 모든 대답이다." }
    ]);
    global.fox_trust += 5;
} else if (global.fox_trust < 90) {
    global.ShowDialogue([
        { name: "", text: "여우가 내 발치에 앉아 있다.\n도망가지 않는다." },
        { name: "", text: "나는 장갑 낀 손으로\n여우의 머리 옆을 아주 살짝 쓸어 본다." },
        { name: "", text: "따뜻하다.\n누군가의 표준이 아니라,\n살아 있는 것의 체온이다." }
    ]);
    global.fox_trust += 5;
} else {
    global.ShowDialogue([
        { name: "", text: "여우가 내 손등에 이마를 댄다." },
        { name: "", text: "\"그래… 너도 길들어버렸네.\"" },
        { name: "", text: "나도, 너도, 남았구나." }
    ]);
}
