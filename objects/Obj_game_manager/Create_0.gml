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

// ========================== 도화선 핵심 시스템 ==========================
global.day = 138;              // 현재 날짜 (LP-138 시작 → LP-250 엔딩)
global.energy = 100;           // 일일 행동력 (이동/채집/수리 소모)
global.max_energy = 100;       // 최대 행동력
global.core_power = 20;        // 도화 코어 유지 수치 (0~100)
global.inventory_grass = 0;    // 별사리풀 보유량
global.core_power_decay = 3;   // 매일 core_power 자연 감소량

/// 개화 프로토콜 진행률 계산 (core_power 누적 기반)
/// core_power가 일정 수준 이상 유지되면 bloom 상승
global.bloom_percent = 0;
global.bloom_thresholds_checked = ds_map_create();

global.CalcBloomPercent = function() {
    // core_power에 비례해서 bloom 상승 (매일 하루를 마감할 때 호출)
    // 112일 (LP-138 ~ LP-250) 동안 100%에 도달해야 함
    // 기본: 매일 core_power/100 만큼의 비율로 bloom 증가
    var daily_bloom = (global.core_power / 100) * 1.5;
    global.bloom_percent += daily_bloom;
    if (global.bloom_percent > 100) global.bloom_percent = 100;
    return global.bloom_percent;
}

// ========================== 스토리 로그 데이터 ==========================
// 날짜/조건별 자동 재생 대사 데이터 (하드코딩 방지를 위해 중앙 관리)
global.story_logs = ds_map_create();

// LP-138: 게임 시작 (첫 채집 안내)
ds_map_set(global.story_logs, 138, [
    { name: "", text: "LP-138. 채집 개시." },
    { name: "", text: "\"여기 있네.\"" },
    { name: "", text: "보랏빛 끝이 아주 작게, 빛을 털어낸다.\n이 행성의 아침은 늘 건조하고, 숨은 늘 얕다." },
    { name: "", text: "그래도 별사리풀만은 자기 방식으로 살아 있다.\n결정은 먹을 것이 아니다.\n그러나 이 집의 열과 전력은 결국 그것으로 돌아간다." },
    { name: "", text: "축전조가 비어 가면 조명이 먼저 떨리고,\n그 다음엔 드론의 날개가 느려진다.\n마지막은 내 호흡이다." },
    { name: "", text: "그래서 오늘도 나는 들판을 뒤집는다.\n마치 내가 여기 있는 이유가, 이것뿐인 사람처럼." }
]);

// LP-139: 드론 사고
ds_map_set(global.story_logs, 139, [
    { name: "", text: "LP-139. 건조-정제 진행." },
    { name: "", text: "드론이 풀을 옮기고, 건조기가 열을 뿜고,\n정제기가 얇은 보랏빛 알갱이를 토해 낸다." },
    { name: "", text: "그때, 날카로운 금속성 울림이 뒤를 친다." },
    { name: "", text: "드론의 한쪽 날개가 보관 랙에 걸렸다.\n균형을 잃은 기체가 공중에서 한 번 흔들리더니\n그대로 바닥으로 곤두박질쳤다." },
    { name: "", text: "나는 한동안 움직이지 못했다.\n내가 잃은 것은 단순한 기계가 아니었다." },
    { name: "", text: "이 행성에서 '편함'이라 부를 수 있는\n마지막 한 조각이었다." },
    { name: "", text: "\"괜찮아… 괜찮아. 아직.\"" }
]);

// LP-140: 외부 점검 + 통신 수신
ds_map_set(global.story_logs, 140, [
    { name: "", text: "LP-140. 외부 점검." },
    { name: "", text: "땅은 조용하고, 돔 밖은 더 조용하다.\n가끔은 조용함이 소리처럼 들린다." },
    { name: "", text: "그때 통신 장치가 깜박인다." },
    { name: "시스템", text: "[수신] 자동 비콘 핑: 유효\n[발신] DOHWA CORE / FIELD NODE 03\n[내용] 귀환 비콘 출력 저하. 좌표 송신. 유지 요청." },
    { name: "", text: "'귀환'이라는 단어는 오래된 상처를 건드리는\n방식으로 반짝인다.\n귀환은 늘 누군가에게만 허락된 말이었다." }
]);

// bloom 83% 이벤트
ds_map_set(global.story_logs, "bloom_83", [
    { name: "시스템", text: "[알림] 개화 프로토콜 진행 중.\n[진행] 83%" },
    { name: "", text: "개화. 나는 이 단어를 처음 본다.\n그리고 이상하게, 처음부터 알고 있었던 것처럼 느껴진다." },
    { name: "", text: "돔의 따뜻함이, 단순한 보온이 아니었다는 걸." }
]);

// bloom 94% 이벤트
ds_map_set(global.story_logs, "bloom_94", [
    { name: "시스템", text: "[개화 프로토콜] 94%\n[안내] LOCAL OPERATOR 권한으로 중단 불가\n[안내] 중단 권한: HOUSE ADMIN / ORBIT RELAY" },
    { name: "", text: "멈출 수 없다." },
    { name: "", text: "그리고 더 잔인한 건, 멈춘다고 해도\n내가 얻는 건 '조용한 죽음'뿐이라는 점이다." },
    { name: "", text: "멈추지 못한다면, 끝까지 가게 하자.\n대신 내가 여기 있었다는 증거를 남기자." }
]);

// bloom 100% 이벤트 (엔딩 직전)
ds_map_set(global.story_logs, "bloom_100", [
    { name: "", text: "LP-250. 이 기록을 보는 사람에게." },
    { name: "", text: "\"나는 이 행성의 토착민이었다.\n이름은… 이제 의미 없다.\n여기 남는 건 내가 했던 일들뿐이다.\"" },
    { name: "", text: "\"나는 귀환 비콘을 유지했다.\n누군가가 다시 여길 찾을 수 있도록.\n그게 내 일이었고, 내가 버티는 방식이었다.\"" },
    { name: "", text: "\"그래도 이걸 남긴다.\n만약 네가 이 기록을 본다면…" },
    { name: "", text: "이 행성에는 한때 다른 하늘이 있었다는 걸\n기억해 줬으면 한다.\"" },
    { name: "", text: "\"…하늘이, 다시 생겨.\"" }
]);

/// 스토리 이벤트 체크 (하루 마감 시 호출)
global.CheckStoryEvent = function() {
    // 날짜 기반 이벤트
    if (ds_map_exists(global.story_logs, global.day)) {
        var _key = string(global.day);
        if (!global.GetFlag("story_" + _key)) {
            global.SetFlag("story_" + _key, true);
            
            if (global.day == 139) {
                // 특별 연출: 드론 추락 컷신 트리거
                if (instance_exists(obj_broken_drone)) {
                    obj_broken_drone.TriggerCrash();
                } else {
                    global.ShowDialogue(ds_map_find_value(global.story_logs, 139));
                }
            } else {
                global.ShowDialogue(ds_map_find_value(global.story_logs, global.day));
            }
            return true;
        }
    }
    
    // 개화율 기반 이벤트
    if (global.bloom_percent >= 83 && !global.GetFlag("story_bloom_83")) {
        global.SetFlag("story_bloom_83", true);
        global.ShowDialogue(ds_map_find_value(global.story_logs, "bloom_83"));
        return true;
    }
    if (global.bloom_percent >= 94 && !global.GetFlag("story_bloom_94")) {
        global.SetFlag("story_bloom_94", true);
        global.ShowDialogue(ds_map_find_value(global.story_logs, "bloom_94"));
        return true;
    }
    
    return false;
}

/// 하루 마감 처리 (침대 상호작용 시 호출)
global.EndDay = function() {
    // 1. 개화 프로토콜 진행률 갱신
    global.CalcBloomPercent();
    
    // 2. 코어 파워 자연 감소
    global.core_power -= global.core_power_decay;
    if (global.core_power < 0) global.core_power = 0;
    
    // 3. 날짜 증가
    global.day += 1;
    
    // 4. 에너지 회복
    global.energy = global.max_energy;
    
    // 5. 일일 행동 플래그 초기화 (다음 날에는 새로 행동해야 잘 수 있음)
    global.SetFlag("daily_action_done", false);
    
    // 6. 스토리 이벤트 체크 (결과 반환)
    return global.CheckStoryEvent();
}

/// 게임 오버 체크 (core_power가 0이면 게임오버)
global.CheckGameOver = function() {
    if (global.core_power <= 0) {
        global.ShowDialogue([
            { name: "", text: "축전조의 수치가 0에 도달했다." },
            { name: "", text: "조명이 꺼지고, 드론이 멈추고…\n마지막으로 내 호흡이 멈춘다." },
            { name: "", text: "귀환 비콘의 신호가 끊어진다.\n이제, 아무도 오지 않는다." },
            { name: "시스템", text: "GAME OVER" }
        ]);
        // 게임오버 플래그 설정
        global.SetFlag("game_over", true);
        return true;
    }
    return false;
}

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
        global.DrawCenteredText(_y, "도화선", c_white);
    }
}

// ========================== 시스템 메뉴 (ESC) ==========================
global.sys_active = false;
global.sys_state = 0;   // 0:메인, 1:세이브, 2:로드, 3:삭제
global.sys_cursor = 0;
global.sys_slots = 3;   // 최대 세이브 슬롯 개수

// ========================== 세이브/로드 시스템 ==========================

/// 세이브 파일 경로 반환
global.GetSaveFileName = function(_slot) {
    return "save_data_" + string(_slot) + ".json";
}

/// 파일에서 JSON 문자열 전체를 안전하게 읽기
/// file_text_read_string은 줄바꿈까지만 읽으므로 EOF까지 반복 필요
global._ReadFileContents = function(_fname) {
    var file = file_text_open_read(_fname);
    var result = "";
    while (!file_text_eof(file)) {
        result += file_text_read_string(file);
        file_text_readln(file);
    }
    file_text_close(file);
    return result;
}

/// 특정 슬롯에 세이브 파일이 존재하는지 확인
global.SaveExists = function(_slot) {
    return file_exists(global.GetSaveFileName(_slot));
}

/// 어떤 슬롯이든 세이브가 하나라도 있는지
global.AnySaveExists = function() {
    for (var i = 0; i < global.sys_slots; i++) {
        if (global.SaveExists(i)) return true;
    }
    return false;
}

/// 특정 슬롯의 세이브 요약 정보 (UI 표시용)
global.GetSaveInfo = function(_slot) {
    var fname = global.GetSaveFileName(_slot);
    if (!file_exists(fname)) return "- Empty -";
    
    try {
        var json_str = global._ReadFileContents(fname);
        var save = json_parse(json_str);
        var day_str = variable_struct_exists(save, "day") ? "LP-" + string(save.day) : "???";
        var core_str = variable_struct_exists(save, "core_power") ? "CORE:" + string(floor(save.core_power)) + "%" : "";
        return day_str + " | " + core_str;
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
    var save = {};
    
    // 플레이어 스탯
    save.hp = global.hp;
    save.max_hp = global.max_hp;
    
    // 도화선 시스템 데이터
    save.day = global.day;
    save.energy = global.energy;
    save.core_power = global.core_power;
    save.inventory_grass = global.inventory_grass;
    save.bloom_percent = global.bloom_percent;
    
    // 현재 위치
    save.room_name = room_get_name(room);
    if (instance_exists(Obj_char)) {
        save.player_x = Obj_char.x;
        save.player_y = Obj_char.y;
        save.facing_dir = Obj_char.facing_dir;
    } else {
        save.player_x = 0;
        save.player_y = 0;
        save.facing_dir = 270;
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
    return true;
}

/// 파일에서 게임 상태를 불러오기
global.LoadGame = function(_slot) {
    if (!global.SaveExists(_slot)) {
        show_debug_message("세이브 파일 없음! (슬롯: " + string(_slot) + ")");
        return false;
    }
    
    var json_str = global._ReadFileContents(global.GetSaveFileName(_slot));
    var save;
    
    try {
        save = json_parse(json_str);
    } catch(e) {
        show_debug_message("세이브 파일 파싱 실패!");
        return false;
    }
    
    // 플레이어 스탯 복원
    global.hp = save.hp;
    global.max_hp = save.max_hp;
    
    // 도화선 시스템 데이터 복원
    global.day = variable_struct_exists(save, "day") ? save.day : 138;
    global.energy = variable_struct_exists(save, "energy") ? save.energy : 100;
    global.core_power = variable_struct_exists(save, "core_power") ? save.core_power : 20;
    global.inventory_grass = variable_struct_exists(save, "inventory_grass") ? save.inventory_grass : 0;
    global.bloom_percent = variable_struct_exists(save, "bloom_percent") ? save.bloom_percent : 0;
    
    // 인벤토리 복원
    global.inventory = [];
    if (variable_struct_exists(save, "inventory")) {
        var inv_data = save.inventory;
        for (var i = 0; i < array_length(inv_data); i++) {
            array_push(global.inventory, inv_data[i]);
        }
    }
    
    // 이벤트 플래그 복원
    ds_map_clear(global.flags);
    if (variable_struct_exists(save, "flags")) {
        var flag_names = variable_struct_get_names(save.flags);
        for (var i = 0; i < array_length(flag_names); i++) {
            var key = flag_names[i];
            ds_map_set(global.flags, key, variable_struct_get(save.flags, key));
        }
    }
    
    // UI 상태 초기화
    global.dialogue_active = false;
    global.inv_state = 0;
    global.inventory_active = false;
    global.sys_active = false;
    
    // 로드 복원 데이터 설정
    global._load_player_x = variable_struct_exists(save, "player_x") ? save.player_x : 0;
    global._load_player_y = variable_struct_exists(save, "player_y") ? save.player_y : 0;
    global._load_facing_dir = variable_struct_exists(save, "facing_dir") ? save.facing_dir : 270;
    global._load_pending = true;
    
    // 저장된 룸으로 이동
    var target_room = asset_get_index(save.room_name);
    if (target_room != -1 && room_exists(target_room)) {
        // persistent 캐릭터가 타이틀에서 살아있을 수 있으므로 제거
        if (instance_exists(Obj_char)) {
            Obj_char.persistent = false;
            instance_destroy(Obj_char);
        }
        if (instance_exists(Obj_camera)) {
            Obj_camera.persistent = false;
            instance_destroy(Obj_camera);
        }
        room_goto(target_room);
    }
    
    show_debug_message("게임 로드 완료! (슬롯: " + string(_slot) + ")");
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
    global.sys_active = false;
    ds_map_clear(global.flags);
    global._load_pending = false;
    
    // 도화선 시스템 초기화
    global.day = 138;
    global.energy = 100;
    global.core_power = 20;
    global.inventory_grass = 0;
    global.bloom_percent = 0;
    
    // 타이틀에서 남아있을 수 있는 persistent 캐릭터 제거
    if (instance_exists(Obj_char)) {
        Obj_char.persistent = false;
        instance_destroy(Obj_char);
    }
    if (instance_exists(Obj_camera)) {
        Obj_camera.persistent = false;
        instance_destroy(Obj_camera);
    }
}

/// 타이틀로 안전하게 돌아가기
global.GoToTitle = function() {
    global.sys_active = false;
    global.dialogue_active = false;
    global.inv_state = 0;
    global.inventory_active = false;
    global._load_pending = false;
    
    // persistent 객체 정리
    if (instance_exists(Obj_char)) {
        Obj_char.persistent = false;
        instance_destroy(Obj_char);
    }
    if (instance_exists(Obj_camera)) {
        Obj_camera.persistent = false;
        instance_destroy(Obj_camera);
    }
    
    room_goto(Room_title);
}

// 로드 복원 대기 플래그
global._load_pending = false;
global._load_player_x = 0;
global._load_player_y = 0;
global._load_facing_dir = 270;
