/// @description 침대 상호작용 — 하루 마감 (User Event 0)

// 게임 오버 상태면 무시
if (global.GetFlag("game_over")) {
    exit;
}

// 이미 오늘 잤으면
if (slept_today) {
    global.ShowDialogue([
        { name: "", text: "아직 쉴 때가 아니다.\n해야 할 일이 남았다." }
    ]);
    exit;
}

// 수면 조건: 도화 코어 100% 충전 강제
if (global.core_power < 100) {
    // 에너지가 남았거나 정제할 풀이 있다면 잠들지 못함
    if (global.energy >= 10 || global.inventory_grass > 0) {
        global.ShowDialogue([
            { name: "", text: "축전조가 아직 가득 차지 않았다.\n이대로 잠들면 불안해서 견딜 수 없을 것이다." },
            { name: "", text: "남은 힘을 쥐어짜서라도 코어 전력을 100%까지 채워야 한다." }
        ]);
        exit;
    } else {
        // 더 이상 채울 수 있는 수단이 전혀 없을 때만 예외적 수면 허용
        global.ShowDialogue([
            { name: "", text: "축전조가 가득 차지 않았지만...\n더 이상 움직일 힘도, 정제할 풀도 없다." },
            { name: "", text: "불안함을 안고 눈을 감을 수밖에 없다." }
        ]);
    }
}

// 화면 전환 효과 (페이드아웃 → 같은 룸으로 다시 → 페이드인)
// 이 전환 과정에서 하루가 넘어감
slept_today = true;

// 하루 마감 처리 및 스토리 이벤트 트리거
var story_triggered = global.EndDay();

if (!story_triggered) {
    // 잠들기 대사 (스토리 이벤트가 없을 때만 출력)
    global.ShowDialogue([
        { name: "", text: "쉴 수 있는 시간은 길지 않다.\n그래도 지금은 눈을 감는다." },
        { name: "시스템", text: "하루가 지나갑니다..." }
    ]);
}

// 게임 오버 체크
global.CheckGameOver();

// 별사리풀 리스폰을 위해 같은 룸으로 재진입 (전환 효과 포함)
// 들판의 풀은 Room Start에서 리스폰되므로, 집에서 자면 다음 외출시 리셋됨
slept_today = false; // 다음 날에는 다시 잘 수 있음
