/// @description 대화창 종료 및 진행 로직
// 대화창이 떠 있을 때 Z키를 누르면 다음 대사로 넘어갑니다.
if (global.dialogue_active == true) {
    if (keyboard_check_pressed(ord("Z"))) {
        global.dialogue_index += 1; // 다음 대사로
        
        // 더 이상 대사가 없다면 창 닫기
        if (global.dialogue_index >= array_length(global.dialogue_data)) {
            global.dialogue_active = false;
        }
        
        keyboard_clear(ord("Z"));
    }
}

// 가방(인벤토리) 창 껐다 켜기 (대화창이 안 켜져있을 때만 가능)
if (global.dialogue_active == false) {
    if (keyboard_check_pressed(ord("I"))) {
        if (global.inv_state == 0) {
            global.inv_state = 1;
            global.inv_cursor = 0;
            global.inv_action_cursor = 0;
            global.inventory_active = true;
        } else {
            global.inv_state = 0;
            global.inventory_active = false;
        }
    }
}

// 가방 메뉴가 열려있을 때의 내부 조작키
if (global.inv_state > 0) {
    var inv_len = array_length(global.inventory);
    
    if (global.inv_state == 1) {
        // --- State 1: 아이템 목록 선택 ---
        
        // 인벤토리 닫기 (X키)
        if (keyboard_check_pressed(ord("X"))) {
            global.inv_state = 0;
            global.inventory_active = false;
        }
        
        // 화살표 위/아래 이동
        if (keyboard_check_pressed(vk_up)) {
            global.inv_cursor -= 1;
            if (global.inv_cursor < 0) global.inv_cursor = 0;
        }
        if (keyboard_check_pressed(vk_down)) {
            global.inv_cursor += 1;
            if (global.inv_cursor >= inv_len && inv_len > 0) global.inv_cursor = inv_len - 1;
            if (inv_len <= 0) global.inv_cursor = 0;
        }
        
        // Z키로 아이템 선택 (State 2로 진입)
        if (keyboard_check_pressed(ord("Z")) && inv_len > 0) {
            global.inv_state = 2;
            global.inv_action_cursor = 0; // 커서를 '사용'으로 초기화
            keyboard_clear(ord("Z"));
        }
    } 
    else if (global.inv_state == 2) {
        // --- State 2: 행동 선택 (사용, 정보, 버리기) ---
        
        // 취소 (X키)로 State 1로 돌아감
        if (keyboard_check_pressed(ord("X"))) {
            global.inv_state = 1;
            keyboard_clear(ord("X"));
        }
        
        // 좌/우 (또는 위/아래) 방향키로 행동 메뉴 이동
        if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_up)) {
            global.inv_action_cursor -= 1;
            if (global.inv_action_cursor < 0) global.inv_action_cursor = 2; // 3개 메뉴 루프
        }
        if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_down)) {
            global.inv_action_cursor += 1;
            if (global.inv_action_cursor > 2) global.inv_action_cursor = 0;
        }
        
        // Z키로 행동 실행!
        if (keyboard_check_pressed(ord("Z"))) {
            var selected_item = global.inventory[global.inv_cursor];
            
            if (global.inv_action_cursor == 0) {
                // [사용]
                var msg = "";
                if (selected_item.type == "heal") {
                    global.hp += selected_item.val; // 체력 회복 효과!
                    if (global.hp > global.max_hp) global.hp = global.max_hp; // 풀피 넘기기 방지
                    msg = selected_item.name + "을(를) 먹었다!\n체력이 " + string(selected_item.val) + " 회복됐다!";
                } 
                else if (selected_item.type == "speed") {
                    Obj_char.walk_spd += selected_item.val; // 영구 이동속도 부스터!
                    msg = selected_item.name + " 장착!\n속도가 " + string(selected_item.val) + "만큼 더 빨라졌다!";
                }
                else {
                    msg = selected_item.name + "을(를) 사용했다...\n딱히 쓸모는 없었다.";
                }
                
                // 사용했으므로 가방에서 삭제
                array_delete(global.inventory, global.inv_cursor, 1);
                global.ShowDialogue([{name: "시스템", text: msg}]);
            }
            else if (global.inv_action_cursor == 1) {
                // [정보]
                global.ShowDialogue([{name: "시스템", text: selected_item.name + ":\n" + selected_item.desc}]);
            }
            else if (global.inv_action_cursor == 2) {
                // [버리기]
                global.ShowDialogue([{name: "시스템", text: selected_item.name + "을(를) 버렸다."}]);
                array_delete(global.inventory, global.inv_cursor, 1);
            }
            
            // 공통 처리: 커서 위치 재조정 (마지막 칸 지워졌을 때 에러 방지)
            if (global.inv_cursor >= array_length(global.inventory)) {
                global.inv_cursor = array_length(global.inventory) - 1;
                if (global.inv_cursor < 0) global.inv_cursor = 0;
            }
            
            // 행동을 실행했으면 인벤토리를 닫음
            global.inv_state = 0;
            global.inventory_active = false;
        }
    }
}
