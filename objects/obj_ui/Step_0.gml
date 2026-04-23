/// @description 대화 입력 및 인벤토리 조작 (UI 입력 전용)

// 화면 전환 중에는 모든 UI 입력 차단
if (global.transition_active) exit;

// ========================== 시스템 메뉴 (ESC) ==========================
// 타이틀 화면이 아닐 때만 열기
if (room != Room_title) {
    if (keyboard_check_pressed(vk_escape)) {
        if (!global.sys_active && !global.dialogue_active) {
            global.sys_active = true;
            global.sys_state = 0; // 메인
            global.sys_cursor = 0;
            // 인벤토리 강제 닫기
            global.inv_state = 0;
            global.inventory_active = false;
        } else if (global.sys_active) {
            // ESC로 닫거나 뒤로 가기
            if (global.sys_state == 0) {
                global.sys_active = false;
            } else {
                global.sys_state = 0;
                global.sys_cursor = 0;
            }
        }
        keyboard_clear(vk_escape);
    }
}

// 시스템 메뉴 조작
if (global.sys_active) {
    var max_cursor = 0;
    if (global.sys_state == 0) max_cursor = 4; // RESUME, SAVE, LOAD, DELETE, TITLE
    else max_cursor = global.sys_slots; // 슬롯 0,1,2 + BACK(3)

    if (keyboard_check_pressed(vk_up)) {
        global.sys_cursor -= 1;
        if (global.sys_cursor < 0) global.sys_cursor = max_cursor;
    }
    if (keyboard_check_pressed(vk_down)) {
        global.sys_cursor += 1;
        if (global.sys_cursor > max_cursor) global.sys_cursor = 0;
    }
    
    if (keyboard_check_pressed(ord("Z"))) {
        if (global.sys_state == 0) {
            // 메인 메뉴 선택
            if (global.sys_cursor == 0) { global.sys_active = false; } // RESUME
            else if (global.sys_cursor == 1) { global.sys_state = 1; global.sys_cursor = 0; } // SAVE
            else if (global.sys_cursor == 2) { global.sys_state = 2; global.sys_cursor = 0; } // LOAD
            else if (global.sys_cursor == 3) { global.sys_state = 3; global.sys_cursor = 0; } // DELETE
            else if (global.sys_cursor == 4) { 
                // TITLE 화면으로
                global.sys_active = false;
                room_goto(Room_title); 
            }
        } else {
            // 슬롯 선택 메뉴 (SAVE/LOAD/DELETE)
            if (global.sys_cursor == global.sys_slots) {
                // BACK 선택
                global.sys_state = 0;
                global.sys_cursor = 0;
            } else {
                // 특정 슬롯 선택
                var slot = global.sys_cursor;
                if (global.sys_state == 1) { // SAVE
                    global.SaveGame(slot);
                    global.sys_state = 0;
                    global.sys_cursor = 0;
                    global.sys_active = false;
                } else if (global.sys_state == 2) { // LOAD
                    if (global.SaveExists(slot)) {
                        global.LoadGame(slot);
                        global.sys_active = false;
                    }
                } else if (global.sys_state == 3) { // DELETE
                    global.DeleteSave(slot);
                    // 삭제 후 그대로 둠 (화면 갱신)
                }
            }
        }
        keyboard_clear(ord("Z"));
    }
    exit; // 시스템 메뉴 열려있으면 다른 UI 조작 막음
}

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
