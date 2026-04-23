/// @description 대화 입력 및 인벤토리 조작 (UI 입력 전용)

// 화면 전환 중에는 모든 UI 입력 차단
if (global.transition_active) exit;

// ========================== 대화창 진행 로직 ==========================
if (global.dialogue_active == true) {
    // 타이핑 이펙트 진행
    if (!global.typing_done) {
        global.typing_timer += 1;
        if (global.typing_timer >= 2) {
            global.typing_timer = 0;
            global.typing_pos += global.typing_speed;
            
            var cur_text = global.dialogue_data[global.dialogue_index].text;
            if (global.typing_pos >= string_length(cur_text)) {
                global.typing_pos = string_length(cur_text);
                global.typing_done = true;
            }
        }
    }
    
    if (keyboard_check_pressed(ord("Z"))) {
        if (!global.typing_done) {
            // 타이핑 중 Z키 → 즉시 전문 보기
            var cur_text = global.dialogue_data[global.dialogue_index].text;
            global.typing_pos = string_length(cur_text);
            global.typing_done = true;
        } else {
            // 타이핑 완료 후 Z키 → 다음 대사
            global.dialogue_index += 1;
            
            if (global.dialogue_index >= array_length(global.dialogue_data)) {
                global.dialogue_active = false;
            } else {
                global.typing_pos = 0;
                global.typing_done = false;
                global.typing_timer = 0;
            }
        }
        keyboard_clear(ord("Z"));
    }
}

// ========================== 인벤토리 토글 ==========================
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

// ========================== 인벤토리 내부 조작 ==========================
if (global.inv_state > 0) {
    var inv_len = array_length(global.inventory);
    
    if (global.inv_state == 1) {
        if (keyboard_check_pressed(ord("X"))) {
            global.inv_state = 0;
            global.inventory_active = false;
        }
        
        if (keyboard_check_pressed(vk_up)) {
            global.inv_cursor -= 1;
            if (global.inv_cursor < 0) global.inv_cursor = 0;
        }
        if (keyboard_check_pressed(vk_down)) {
            global.inv_cursor += 1;
            if (global.inv_cursor >= inv_len && inv_len > 0) global.inv_cursor = inv_len - 1;
            if (inv_len <= 0) global.inv_cursor = 0;
        }
        
        if (keyboard_check_pressed(ord("Z")) && inv_len > 0) {
            global.inv_state = 2;
            global.inv_action_cursor = 0;
            keyboard_clear(ord("Z"));
        }
    } 
    else if (global.inv_state == 2) {
        if (keyboard_check_pressed(ord("X"))) {
            global.inv_state = 1;
            keyboard_clear(ord("X"));
        }
        
        if (keyboard_check_pressed(vk_left) || keyboard_check_pressed(vk_up)) {
            global.inv_action_cursor -= 1;
            if (global.inv_action_cursor < 0) global.inv_action_cursor = 2;
        }
        if (keyboard_check_pressed(vk_right) || keyboard_check_pressed(vk_down)) {
            global.inv_action_cursor += 1;
            if (global.inv_action_cursor > 2) global.inv_action_cursor = 0;
        }
        
        if (keyboard_check_pressed(ord("Z"))) {
            var selected_item = global.inventory[global.inv_cursor];
            
            if (global.inv_action_cursor == 0) {
                var msg = "";
                if (selected_item.type == "heal") {
                    global.hp += selected_item.val;
                    if (global.hp > global.max_hp) global.hp = global.max_hp;
                    msg = selected_item.name + "을(를) 먹었다!\n체력이 " + string(selected_item.val) + " 회복됐다!";
                } 
                else if (selected_item.type == "speed") {
                    Obj_char.walk_spd += selected_item.val;
                    msg = selected_item.name + " 장착!\n속도가 " + string(selected_item.val) + "만큼 더 빨라졌다!";
                }
                else {
                    msg = selected_item.name + "을(를) 사용했다...\n딱히 쓸모는 없었다.";
                }
                
                array_delete(global.inventory, global.inv_cursor, 1);
                global.ShowDialogue([{name: "시스템", text: msg}]);
            }
            else if (global.inv_action_cursor == 1) {
                global.ShowDialogue([{name: "시스템", text: selected_item.name + ":\n" + selected_item.desc}]);
            }
            else if (global.inv_action_cursor == 2) {
                global.ShowDialogue([{name: "시스템", text: selected_item.name + "을(를) 버렸다."}]);
                array_delete(global.inventory, global.inv_cursor, 1);
            }
            
            if (global.inv_cursor >= array_length(global.inventory)) {
                global.inv_cursor = array_length(global.inventory) - 1;
                if (global.inv_cursor < 0) global.inv_cursor = 0;
            }
            
            global.inv_state = 0;
            global.inventory_active = false;
        }
    }
}
