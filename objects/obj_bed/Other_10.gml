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

// 침대 상태 경고 (열화 시스템)
if (global.bed_quality < 30 && global.bed_quality > 0) {
    global.ShowDialogue([
        { name: "", text: "침대가 삐걱거린다.\n프레임이 휘어지기 시작했다.\n잠을 자도 개운하지 않을 것이다." },
        { name: "시스템", text: "⚠ 침대 상태 불량 — 에너지 회복 70%\n(침대 수리: Z키로 침대에 다시 상호작용)" }
    ]);
} else if (global.bed_quality <= 0) {
    // 침대가 완전히 망가짐 — 수리 분기
    if (global.energy >= repair_cost) {
        global.ShowDialogue([
            { name: "", text: "침대의 프레임이 부러졌다.\n이대로는 누울 수도 없다." },
            { name: "", text: "비틀어진 금속을 손으로 펴고,\n고정 볼트를 조여 본다." },
            { name: "시스템", text: "침대 수리 완료! 에너지 -" + string(repair_cost) }
        ]);
        global.energy -= repair_cost;
        global.bed_quality = 60;
        exit; // 수리만 하고 잠들지는 않음
    } else {
        // 에너지 부족: 바닥에서 잠
        global.ShowDialogue([
            { name: "", text: "침대는 부서졌고, 고칠 힘도 없다.\n바닥에 등을 대고 눕는다." },
            { name: "", text: "차갑다. 하지만 눈은 감긴다." }
        ]);
        // 바닥에서 자면 에너지 50%만 회복 (EndDay에서 bed_quality로 처리)
    }
}

// =============================================
// 수면 조건 1: 최소 채집량 강제
// 하루에 최소 5개의 별사리풀을 정제하거나 채집해야 잠들 수 있음
// (코어가 이미 100%여도, 노동 자체가 생존의 루틴이므로)
// =============================================
var daily_harvested = global.GetFlag("daily_harvest_count");
if (daily_harvested == false) daily_harvested = 0;

if (daily_harvested < 5) {
    // 에너지가 남아있으면 아직 일할 수 있다
    if (global.energy >= 10) {
        var remaining = 5 - daily_harvested;
        global.ShowDialogue([
            { name: "", text: "오늘 충분히 일하지 않았다.\n이대로 눈을 감으면 불안해서 견딜 수 없다." },
            { name: "시스템", text: "최소 " + string(remaining) + "개의 별사리풀을 더 채집하세요.\n(오늘 채집량: " + string(floor(daily_harvested)) + "/5)" }
        ]);
        exit;
    }
    // 에너지가 없으면 강제 수면 (불안 대사)
    global.ShowDialogue([
        { name: "", text: "충분히 일하지 못했다.\n몸은 이미 한계다." },
        { name: "", text: "불안함을 안고 눈을 감을 수밖에 없다." }
    ]);
}

// =============================================
// 수면 조건 2: 코어 전력 충전 강제
// 에너지와 풀이 남아있다면 코어를 100%로 만들어야 잠들 수 있음
// =============================================
if (global.core_power < 100) {
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
