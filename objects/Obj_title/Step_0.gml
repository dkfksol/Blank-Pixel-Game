/// @description 타이틀 메뉴 입력 처리

// 페이드인 로직 제거 (즉시 입력 가능)

// 커서 이동 (위/아래)
if (!global.sys_active) {
    if (keyboard_check_pressed(vk_up)) {
        cursor -= 1;
        if (cursor < 0) cursor = array_length(menu_items) - 1;
        // 비활성 항목 건너뛰기
        if (!menu_enabled[cursor]) {
            cursor -= 1;
            if (cursor < 0) cursor = array_length(menu_items) - 1;
        }
    }
    if (keyboard_check_pressed(vk_down)) {
        cursor += 1;
        if (cursor >= array_length(menu_items)) cursor = 0;
        // 비활성 항목 건너뛰기
        if (!menu_enabled[cursor]) {
            cursor += 1;
            if (cursor >= array_length(menu_items)) cursor = 0;
        }
    }
}

// 선택 (Z키)
if (!global.sys_active) {
    if (keyboard_check_pressed(ord("Z"))) {
        if (menu_enabled[cursor]) {
            if (cursor == 0) {
                // NEW GAME
                global.NewGame();
                room_goto(Room1);
            }
            else if (cursor == 1) {
                // CONTINUE (로드 메뉴 열기)
                global.sys_active = true;
                global.sys_state = 2; // LOAD
                global.sys_cursor = 0;
            }
        }
        keyboard_clear(ord("Z"));
    }
}
