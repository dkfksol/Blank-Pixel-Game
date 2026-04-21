/// @description 대화창 강제 종료 로직
// 대화창이 떠 있는 상태에 누군가 'Z'키를 누른다면 즉각 창을 닫아줍니다.
if (global.dialogue_active == true) {
    if (keyboard_check_pressed(ord("Z"))) {
        global.dialogue_active = false;
        
        // Z키 눌림 이벤트를 강제 증발시킵니다!
        // 이걸 안 하면 대화가 꺼지는 순간 주인공이 바로 NPC한테 또 말을 거는 무한 지옥 버그가 생깁니다.
        keyboard_clear(ord("Z"));
    }
}

// 가방(인벤토리) 창 껐다 켜기 (대화창이 안 켜져있을 때만 가능)
if (global.dialogue_active == false) {
    if (keyboard_check_pressed(ord("I"))) {
        // I를 누르면 현재 켜져있는 여부를 홱닥 반대로 뒤집습니다! (true<->false)
        global.inventory_active = !global.inventory_active;
        global.inv_cursor = 0; // 가방 켤 때마다 커서 초기화
    }
}

// 가방 메뉴가 열려있을 때의 내부 조작키 (위, 아래, 사용!)
if (global.inventory_active == true) {
    var inv_len = array_length(global.inventory);
    
    // 화살표 위쪽 키 누를 때 (맨 위로 가면 안 올라감)
    if (keyboard_check_pressed(vk_up)) {
        global.inv_cursor -= 1;
        if (global.inv_cursor < 0) global.inv_cursor = 0;
    }
    
    // 화살표 아래쪽 키 누를 때 (배열 끝까지만 내려감)
    if (keyboard_check_pressed(vk_down)) {
        global.inv_cursor += 1;
        if (global.inv_cursor >= inv_len && inv_len > 0) global.inv_cursor = inv_len - 1;
        if (inv_len <= 0) global.inv_cursor = 0;
    }
    
    // Z키를 눌러 아이템 사용(먹기)!
    if (keyboard_check_pressed(ord("Z")) && inv_len > 0) {
        var selected_item = global.inventory[global.inv_cursor];
        
        // 아이템의 종류(type)에 따라 서로 다른 능력이 터집니다!
        if (selected_item.type == "heal") {
            global.hp += selected_item.val; // 체력 회복 효과!
            if (global.hp > global.max_hp) global.hp = global.max_hp; // 풀피 넘기기 방지
            
            global.dialogue_text = selected_item.name + "을(를) 먹었다! 체력이 " + string(selected_item.val) + " 회복됐다!";
        } 
        else if (selected_item.type == "speed") {
            Obj_char.walk_spd += selected_item.val; // 영구 이동속도 부스터!
            global.dialogue_text = selected_item.name + " 장착! 속도가 " + string(selected_item.val) + "만큼 더 빨라졌다!";
        }
        else {
            // 딱히 효과 없는 장비류
            global.dialogue_text = selected_item.name + "을(를) 품에 조심스레 안았다. 마음이 든든하다.";
        }
        
        // ------------------
        // 공통 사용 후 잔여 처리
        // ------------------
        array_delete(global.inventory, global.inv_cursor, 1); // 사용한 건 가방(배열)에서 즉시 파기!
        
        // 커서 위치 재조정 (마지막 칸에 있던 거 먹어서 지워지면 커서 에러나는 버그 차단)
        if (global.inv_cursor >= array_length(global.inventory)) {
            global.inv_cursor = array_length(global.inventory) - 1;
            if (global.inv_cursor < 0) global.inv_cursor = 0;
        }
        
        global.dialogue_active = true; // 대화창 띄우고
        global.inventory_active = false; // 곧장 가방은 꺼버림
        keyboard_clear(ord("Z"));
    }
}
