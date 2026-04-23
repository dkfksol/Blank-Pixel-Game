/// @description 게임 시스템 전역 변수 초기화

// 중복 생성 방지 (싱글톤 패턴)
if (instance_number(object_index) > 1) {
    instance_destroy();
    exit;
}
// ========================== 대화 시스템 ==========================
global.dialogue_active = false;
global.dialogue_data = [];
global.dialogue_index = 0;

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

// ========================== UI 원자 컴포넌트 ==========================
// 스프라이트가 존재하면 스프라이트 사용, 없으면 코드로 폴백
// UI 디자이너가 해당 이름의 스프라이트를 만들면 자동으로 적용됨
//
// [스프라이트 슬롯 목록]
//   spr_ui_box       → DrawBox에서 사용 (9-slice 권장, 대화창/메뉴 배경)
//   spr_ui_namebox   → 이름표 박스 전용
//   spr_ui_cursor    → 메뉴 커서 아이콘 (하트, 화살표 등)
//   spr_ui_prompt    → 대사 넘기기 프롬프트 (▼ 대체)
//   spr_title_logo   → 타이틀 화면 로고 이미지

/// UI 박스 그리기 (스프라이트 spr_ui_box가 있으면 9-slice, 없으면 코드)
global.DrawBox = function(_x, _y, _w, _h, _alpha) {
    var spr = asset_get_index("spr_ui_box");
    if (spr != -1) {
        draw_set_alpha(_alpha);
        draw_sprite_stretched(spr, 0, _x, _y, _w, _h);
        draw_set_alpha(1.0);
    } else {
        // 코드 폴백: 검은 배경 + 흰 테두리
        draw_set_color(c_black);
        draw_set_alpha(_alpha);
        draw_roundrect(_x, _y, _x + _w, _y + _h, false);
        draw_set_color(c_white);
        draw_set_alpha(1.0);
        draw_roundrect(_x, _y, _x + _w, _y + _h, true);
    }
}

/// 이름표 박스 그리기 (spr_ui_namebox 우선, 없으면 DrawBox 폴백)
global.DrawNameBox = function(_x, _y, _w, _h, _alpha) {
    var spr = asset_get_index("spr_ui_namebox");
    if (spr != -1) {
        draw_set_alpha(_alpha);
        draw_sprite_stretched(spr, 0, _x, _y, _w, _h);
        draw_set_alpha(1.0);
    } else {
        global.DrawBox(_x, _y, _w, _h, _alpha);
    }
}

/// 메뉴 커서+리스트 그리기 (spr_ui_cursor가 있으면 아이콘, 없으면 "->")
global.DrawMenuList = function(_x, _y, _items, _cursor, _spacing, _enabled) {
    var cursor_spr = asset_get_index("spr_ui_cursor");
    var count = array_length(_items);
    
    for (var i = 0; i < count; i++) {
        var is_active = true;
        if (is_array(_enabled) && i < array_length(_enabled)) {
            is_active = _enabled[i];
        }
        
        var item_y = _y + (i * _spacing);
        
        if (i == _cursor) {
            if (cursor_spr != -1 && is_active) {
                // 스프라이트 커서 아이콘 사용
                draw_sprite(cursor_spr, 0, _x, item_y + (_spacing / 2));
                draw_set_color(is_active ? c_yellow : c_dkgray);
                draw_text(_x + 25, item_y, _items[i]);
            } else {
                draw_set_color(is_active ? c_yellow : c_dkgray);
                draw_text(_x, item_y, "-> " + _items[i]);
            }
        } else {
            draw_set_color(is_active ? c_white : c_dkgray);
            draw_text(_x + 25, item_y, _items[i]);
        }
    }
    draw_set_color(c_white);
}

/// 화면 정중앙 정렬 텍스트
global.DrawCenteredText = function(_y, _text, _color) {
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);
    draw_set_color(_color);
    draw_text(1280 / 2, _y, _text);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_color(c_white);
}

/// 대사 넘기기 프롬프트 (spr_ui_prompt 우선, 없으면 "▼")
global.DrawPrompt = function(_x, _y) {
    var spr = asset_get_index("spr_ui_prompt");
    if (spr != -1) {
        draw_sprite(spr, 0, _x, _y);
    } else {
        draw_set_halign(fa_right);
        draw_set_valign(fa_bottom);
        draw_set_color(c_white);
        draw_text(_x, _y, "▼");
    }
}

/// 타이틀 로고 (spr_title_logo 우선, 없으면 텍스트)
global.DrawTitleLogo = function(_y) {
    var spr = asset_get_index("spr_title_logo");
    if (spr != -1) {
        var sx = (1280 - sprite_get_width(spr)) / 2;
        draw_sprite(spr, 0, sx + sprite_get_xoffset(spr), _y);
    } else {
        global.DrawCenteredText(_y, "BLANK PIXEL", c_white);
    }
}

// ========================== 시스템 메뉴 (ESC) ==========================
global.sys_active = false;
global.sys_state = 0;   // 0:메인, 1:세이브, 2:로드, 3:삭제
global.sys_cursor = 0;
global.sys_slots = 3;   // 최대 세이브 슬롯 개수

// ========================== 세이브/로드 시스템 ==========================
global.GetSaveFileName = function(_slot) {
    return "save_data_" + string(_slot) + ".json";
}

/// 특정 슬롯에 세이브 파일이 존재하는지 확인
global.SaveExists = function(_slot) {
    if (is_undefined(_slot)) _slot = 0; // 하위 호환
    return file_exists(global.GetSaveFileName(_slot));
}

/// 특정 슬롯의 세이브 요약 정보 (UI 표시용)
global.GetSaveInfo = function(_slot) {
    var fname = global.GetSaveFileName(_slot);
    if (!file_exists(fname)) return "Empty";
    
    var file = file_text_open_read(fname);
    var json_str = file_text_read_string(file);
    file_text_close(file);
    
    try {
        var save = json_parse(json_str);
        var hp_str = "HP " + string(save.hp) + "/" + string(save.max_hp);
        // "Room1" 같은 이름을 더 예쁘게 표시하려면 여기서 치환 가능
        return save.room_name + " | " + hp_str;
    } catch(e) {
        return "Corrupted Data";
    }
}

/// 특정 슬롯을 삭제
global.DeleteSave = function(_slot) {
    var fname = global.GetSaveFileName(_slot);
    if (file_exists(fname)) {
        file_delete(fname);
        return true;
    }
    return false;
}

/// 현재 게임 상태를 파일에 저장
global.SaveGame = function(_slot) {
    if (is_undefined(_slot)) _slot = 0;
    var save = {};
    
    // 플레이어 스탯
    save.hp = global.hp;
    save.max_hp = global.max_hp;
    
    // 현재 위치
    save.room_name = room_get_name(room);
    if (instance_exists(Obj_char)) {
        save.player_x = Obj_char.x;
        save.player_y = Obj_char.y;
        save.facing_dir = Obj_char.facing_dir;
    }
    
    // 인벤토리 (구조체 배열 → JSON 호환)
    save.inventory = [];
    for (var i = 0; i < array_length(global.inventory); i++) {
        var item = global.inventory[i];
        array_push(save.inventory, {
            name: item.name,
            type: item.type,
            val: item.val,
            desc: item.desc
        });
    }
    
    // 이벤트 플래그 (ds_map → 구조체 변환)
    save.flags = {};
    var _key = ds_map_find_first(global.flags);
    while (!is_undefined(_key)) {
        variable_struct_set(save.flags, _key, ds_map_find_value(global.flags, _key));
        _key = ds_map_find_next(global.flags, _key);
    }
    
    // JSON으로 직렬화 후 파일에 쓰기
    var json_str = json_stringify(save);
    var file = file_text_open_write(global.GetSaveFileName(_slot));
    file_text_write_string(file, json_str);
    file_text_close(file);
    
    show_debug_message("게임 저장 완료! (슬롯: " + string(_slot) + ")");
}

/// 파일에서 게임 상태를 불러오기
global.LoadGame = function(_slot) {
    if (is_undefined(_slot)) _slot = 0;
    
    if (!global.SaveExists(_slot)) {
        show_debug_message("세이브 파일 없음! (슬롯: " + string(_slot) + ")");
        return false;
    }
    
    var file = file_text_open_read(global.GetSaveFileName(_slot));
    var json_str = file_text_read_string(file);
    file_text_close(file);
    
    var save = json_parse(json_str);
    
    // 플레이어 스탯 복원
    global.hp = save.hp;
    global.max_hp = save.max_hp;
    
    // 인벤토리 복원
    global.inventory = [];
    var inv_data = save.inventory;
    for (var i = 0; i < array_length(inv_data); i++) {
        array_push(global.inventory, inv_data[i]);
    }
    
    // 이벤트 플래그 복원
    ds_map_clear(global.flags);
    var flag_names = variable_struct_get_names(save.flags);
    for (var i = 0; i < array_length(flag_names); i++) {
        var key = flag_names[i];
        ds_map_set(global.flags, key, variable_struct_get(save.flags, key));
    }
    
    // 저장된 룸으로 이동
    var target_room = asset_get_index(save.room_name);
    if (target_room != -1 && room_exists(target_room)) {
        room_goto(target_room);
        // 플레이어 위치는 Room Start에서 복원 (전역 변수에 임시 저장)
        global._load_player_x = save.player_x;
        global._load_player_y = save.player_y;
        global._load_facing_dir = save.facing_dir;
        global._load_pending = true;
    }
    
    show_debug_message("게임 로드 완료!");
    return true;
}

/// 새 게임 초기화
global.NewGame = function() {
    global.hp = 50;
    global.max_hp = 100;
    global.inventory = [];
    global.inv_state = 0;
    global.inv_cursor = 0;
    global.inv_action_cursor = 0;
    global.inventory_active = false;
    global.dialogue_active = false;
    ds_map_clear(global.flags);
    global._load_pending = false;
}

// 로드 복원 대기 플래그
global._load_pending = false;

