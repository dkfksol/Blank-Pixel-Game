/// @description 별사리풀 채집 상호작용 (User Event 0)

if (!harvestable || minigame_active) exit;

// 에너지 부족 체크 (수동 채집은 항상 에너지가 소모됨)
if (global.energy < harvest_cost) {
    global.ShowDialogue([
        { name: "", text: "숨이 차다. 더 이상은 무리다." },
        { name: "시스템", text: "에너지가 부족합니다. (" + string(global.energy) + "/" + string(harvest_cost) + ")" }
    ]);
    exit;
}

// 미니게임 시작 (드론의 유무와 상관없이 내가 직접 캐면 미니게임 실행)
minigame_active = true;
minigame_delay = 10; // Z키 즉시 눌림 방지
cursor_pos = 0;
global.SetFlag("daily_action_done", true); // 행동 완료

