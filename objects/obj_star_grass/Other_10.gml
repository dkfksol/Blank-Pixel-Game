/// @description 별사리풀 채집 상호작용 (User Event 0)

if (!harvestable || minigame_active) exit;

// LP-138 (드론 정상 작동일) - 수동으로 캐도 즉시 채집 & 에너지 소모 0
if (global.day == 138) {
    global.inventory_grass += 1;
    harvestable = false;
    global.SetFlag("daily_action_done", true); // 행동 완료
    global.ShowDialogue([
        { name: "", text: "드론의 채집 보조를 받아\n손쉽게 별사리풀을 갈무리했다." },
        { name: "시스템", text: "별사리풀 +1\n(LP-138 보조 모드: 에너지 소모 0)" }
    ]);
    instance_destroy();
    exit;
}

// LP-139 이후 - 드론 고장. 내 힘으로 타이밍 맞춰 캐야 함
if (global.energy < harvest_cost) {
    global.ShowDialogue([
        { name: "", text: "숨이 차다. 더 이상은 무리다." },
        { name: "시스템", text: "에너지가 부족합니다. (" + string(global.energy) + "/" + string(harvest_cost) + ")" }
    ]);
    exit;
}

// 미니게임 시작
minigame_active = true;
minigame_delay = 10; // Z키 즉시 눌림 방지
cursor_pos = 0;
global.SetFlag("daily_action_done", true); // 행동 완료

