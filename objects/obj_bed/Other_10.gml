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

// 오늘 아무것도 안 하고 잠드는 것 방지
if (!global.GetFlag("daily_action_done")) {
    global.ShowDialogue([
        { name: "", text: "오늘 하루는 너무 무의미하게 지나갔다.\n이대로 잘 수는 없다. 최소한 들판에 나가보거나 정제기를 돌리자." }
    ]);
    exit;
}

// 화면 전환 효과 (페이드아웃 → 같은 룸으로 다시 → 페이드인)
// 이 전환 과정에서 하루가 넘어감
slept_today = true;

// 잠들기 대사
global.ShowDialogue([
    { name: "", text: "쉴 수 있는 시간은 길지 않다.\n그래도 지금은 눈을 감는다." },
    { name: "시스템", text: "하루가 지나갑니다..." }
]);

// 화면 전환으로 하루 마감 연출
// TransitionToRoom 자체가 같은 룸으로 이동 → 별사리풀 리스폰
global.EndDay();

// 게임 오버 체크
global.CheckGameOver();

// 별사리풀 리스폰을 위해 같은 룸으로 재진입 (전환 효과 포함)
// 들판의 풀은 Room Start에서 리스폰되므로, 집에서 자면 다음 외출시 리셋됨
slept_today = false; // 다음 날에는 다시 잘 수 있음
