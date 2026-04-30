/// @description 대화 입력, 시스템 메뉴, 인벤토리 조작 (UI 입력 전용)

// 화면 전환 중에는 모든 UI 입력 차단
if (global.transition_active) exit;

// ========================== 시스템 메뉴 (ESC) ==========================
// 타이틀 화면에서는 ESC 열지 않음 (CONTINUE에서 직접 로드 메뉴를 연다)
if (room != Room_title) {
    if (keyboard_check_pressed(vk_escape)) {
        if (!global.sys_active && !global.dialogue_active) {
            global.sys_active = true;
            global.sys_state = 0;
            global.sys_cursor = 0;
            global.inv_state = 0;
            global.inventory_active = false;
        } else if (global.sys_active) {
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
    var max_items = 0;
    var enabled_list = [];
    
    if (global.sys_state == 0) {
        // 메인: RESUME(0), SAVE(1), LOAD(2), DELETE(3), TITLE(4)
        max_items = 5;
        var any_save = global.AnySaveExists();
        // 타이틀 화면에서는 SAVE, TITLE 비활성
        if (room == Room_title) {
            enabled_list = [false, false, any_save, any_save, false];
        } else {
            enabled_list = [true, true, any_save, any_save, true];
        }
    } else {
        // 슬롯 메뉴: 슬롯들 + BACK
        max_items = global.sys_slots + 1;
        for (var i = 0; i < global.sys_slots; i++) {
            if (global.sys_state == 1) {
                array_push(enabled_list, true); // 세이브는 항상 가능
            } else {
                array_push(enabled_list, global.SaveExists(i));
            }
        }
        array_push(enabled_list, true); // BACK은 항상 활성
    }
    
    // 커서 이동 (비활성 항목 건너뛰기)
    if (keyboard_check_pressed(vk_up)) {
        var attempts = 0;
        do {
            global.sys_cursor -= 1;
            if (global.sys_cursor < 0) global.sys_cursor = max_items - 1;
            attempts++;
        } until (enabled_list[global.sys_cursor] || attempts >= max_items);
    }
    if (keyboard_check_pressed(vk_down)) {
        var attempts = 0;
        do {
            global.sys_cursor += 1;
            if (global.sys_cursor >= max_items) global.sys_cursor = 0;
            attempts++;
        } until (enabled_list[global.sys_cursor] || attempts >= max_items);
    }
    
    // X키로 뒤로가기
    if (keyboard_check_pressed(ord("X"))) {
        if (global.sys_state == 0) {
            global.sys_active = false;
        } else {
            global.sys_state = 0;
            global.sys_cursor = 0;
        }
        keyboard_clear(ord("X"));
    }
    
    // Z키로 선택
    if (keyboard_check_pressed(ord("Z"))) {
        if (!enabled_list[global.sys_cursor]) {
            // 비활성 항목 → 무시
        } else if (global.sys_state == 0) {
            // 메인 메뉴
            switch (global.sys_cursor) {
                case 0: global.sys_active = false; break; // RESUME
                case 1: global.sys_state = 1; global.sys_cursor = 0; break; // SAVE
                case 2: global.sys_state = 2; global.sys_cursor = 0; break; // LOAD
                case 3: global.sys_state = 3; global.sys_cursor = 0; break; // DELETE
                case 4: global.GoToTitle(); break; // TITLE
            }
        } else {
            // 슬롯 메뉴
            if (global.sys_cursor >= global.sys_slots) {
                // BACK
                global.sys_state = 0;
                global.sys_cursor = 0;
            } else {
                var slot = global.sys_cursor;
                switch (global.sys_state) {
                    case 1: // SAVE
                        global.SaveGame(slot);
                        global.sys_active = false;
                        break;
                    case 2: // LOAD
                        global.LoadGame(slot);
                        break;
                    case 3: // DELETE
                        global.DeleteSave(slot);
                        break;
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
            var cur_text = global.dialogue_data[global.dialogue_index].text;
            global.typing_pos = string_length(cur_text);
            global.typing_done = true;
        } else {
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
