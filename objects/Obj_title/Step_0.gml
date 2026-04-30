/// @description 타이틀 메뉴 입력 처리

// 시스템 메뉴(로드)가 열려있으면 타이틀 입력 무시
if (global.sys_active) exit;

// 커서 이동 (위/아래, 비활성 건너뛰기)
if (keyboard_check_pressed(vk_up)) {
    var attempts = 0;
    do {
        cursor -= 1;
        if (cursor < 0) cursor = array_length(menu_items) - 1;
        attempts++;
    } until (menu_enabled[cursor] || attempts >= array_length(menu_items));
}
if (keyboard_check_pressed(vk_down)) {
    var attempts = 0;
    do {
        cursor += 1;
        if (cursor >= array_length(menu_items)) cursor = 0;
        attempts++;
    } until (menu_enabled[cursor] || attempts >= array_length(menu_items));
}

// 선택 (Z키)
if (keyboard_check_pressed(ord("Z"))) {
    if (menu_enabled[cursor]) {
        if (cursor == 0) {
            // NEW GAME
            global.NewGame();
            room_goto(Room1);
            // 첫 날(LP-138) 스토리 이벤트 예약
            global.SetFlag("trigger_first_story", true);
        }
        else if (cursor == 1) {
            // CONTINUE → 로드 슬롯 선택 메뉴 열기
            global.sys_active = true;
            global.sys_state = 2; // LOAD
            global.sys_cursor = 0;
        }
    }
    keyboard_clear(ord("Z"));
}
