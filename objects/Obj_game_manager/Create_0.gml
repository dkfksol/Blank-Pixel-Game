/// @description 게임 시스템 전역 변수 초기화

// ========================== 대화 시스템 ==========================
global.dialogue_active = false;
global.dialogue_data = [];
global.dialogue_index = 0;

// 타이핑 이펙트 변수
global.typing_pos = 0;
global.typing_speed = 1;
global.typing_done = false;
global.typing_timer = 0;

global.ShowDialogue = function(_data_array) {
    global.dialogue_data = _data_array;
    global.dialogue_index = 0;
    global.dialogue_active = true;
    global.typing_pos = 0;
    global.typing_done = false;
    global.typing_timer = 0;
    keyboard_clear(ord("Z"));
}

// ========================== 화면 전환 시스템 ==========================
global.transition_active = false;
global.transition_alpha = 0;
global.transition_speed = 0.05;
global.transition_phase = 0;
global.transition_target = noone;
global.transition_target_x = -1;
global.transition_target_y = -1;

global.TransitionToRoom = function(_room, _x, _y) {
    if (global.transition_active) return;
    global.transition_active = true;
    global.transition_phase = 1;
    global.transition_alpha = 0;
    global.transition_target = _room;
    global.transition_target_x = _x;
    global.transition_target_y = _y;
}

// ========================== 인벤토리 시스템 ==========================
global.inventory = [];
global.inventory_active = false;
global.inv_state = 0;
global.inv_cursor = 0;
global.inv_action_cursor = 0;

// ========================== 플레이어 스탯 ==========================
global.hp = 50;
global.max_hp = 100;

// ========================== 이벤트 플래그 시스템 ==========================
global.flags = ds_map_create();

global.SetFlag = function(_key, _val) {
    ds_map_set(global.flags, _key, _val);
}

global.GetFlag = function(_key) {
    if (ds_map_exists(global.flags, _key)) {
        return ds_map_find_value(global.flags, _key);
    }
    return false;
}

// ========================== 유틸리티 함수 ==========================
global.HasItem = function(_target_name) {
    for (var i = 0; i < array_length(global.inventory); i++) {
        if (global.inventory[i].name == _target_name) {
            return true;
        }
    }
    return false;
}

global.RemoveItem = function(_target_name) {
    for (var i = 0; i < array_length(global.inventory); i++) {
        if (global.inventory[i].name == _target_name) {
            array_delete(global.inventory, i, 1);
            return true; 
        }
    }
    return false;
}
