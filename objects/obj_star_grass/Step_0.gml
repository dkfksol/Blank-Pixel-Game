/// @description 타이밍 미니게임 로직

if (minigame_active) {
    if (minigame_result_timer > 0) {
        // 결과 표시 중 (커서 멈춤 & 깜빡임)
        minigame_result_timer--;
        if (minigame_result_timer <= 0) {
            // 대기가 끝나면 보상 및 파괴 처리
            minigame_active = false;
            global.energy -= harvest_cost; // 에너지는 결과와 무관하게 소모
            
            var p_width = global.GetFlag("drone_scavenged") ? 20 : 12; 
            var g_width = global.GetFlag("drone_scavenged") ? 40 : 30; 
            
            if (minigame_result_dist <= p_width / 2) {
                global.inventory_grass += 2;
                global.ShowDialogue([
                    { name: "", text: "온전한 형태로 채집했다.\n장갑에 전해지는 묵직한 감각." },
                    { name: "시스템", text: "별사리풀 +2 (Perfect!)\n에너지 -" + string(harvest_cost) }
                ]);
            } else if (minigame_result_dist <= g_width / 2) {
                global.inventory_grass += 1;
                global.ShowDialogue([
                    { name: "", text: "조심했지만 절반이 가루로 흩어졌다.\n아쉽지만 챙겨야 한다." },
                    { name: "시스템", text: "별사리풀 +1 (Good)\n에너지 -" + string(harvest_cost) }
                ]);
            } else {
                global.ShowDialogue([
                    { name: "", text: "결정이 완전히 바스라져\n보라색 먼지가 되어 사라졌다..." },
                    { name: "시스템", text: "채집 실패... (Miss)\n에너지 -" + string(harvest_cost) }
                ]);
            }
            instance_destroy();
        }
        exit; // 결과 표시 중엔 아래(커서 이동) 무시
    }

    if (minigame_delay > 0) {
        minigame_delay--;
    } else {
        // 커서 왕복 이동
        cursor_pos += cursor_spd;
        if (cursor_pos > 100 || cursor_pos < 0) {
            cursor_spd *= -1;
            cursor_pos = clamp(cursor_pos, 0, 100);
        }
        
        // Z키 입력으로 채집 판정 시점 기록
        if (keyboard_check_pressed(ord("Z"))) {
            minigame_result_timer = 40; // 약 0.6초간 결과 멈춤/깜빡임
            minigame_result_dist = abs(cursor_pos - 50); // 정지된 시점의 거리 저장
        }
    }
}
