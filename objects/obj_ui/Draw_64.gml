/// @description 화면 최상단 강제 UI 렌더링 (Draw GUI)

// 기본 폰트 설정
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var fnt_id = asset_get_index("fnt_main");
if (fnt_id != -1) draw_set_font(fnt_id);

// ========================== 대화창 렌더링 ==========================
if (global.dialogue_active == true) {
    if (array_length(global.dialogue_data) > 0) {
        var cur_dialogue = global.dialogue_data[global.dialogue_index];
        var speaker_name = cur_dialogue.name;
        var speaker_text = cur_dialogue.text;
        
        // 박스 레이아웃
        var box_width = 1000;
        var box_height = 200;
        var box_x = (1280 - box_width) / 2;
        var box_y = 720 - box_height - 20;
        
        // 이름표 박스 (원자 컴포넌트 사용)
        if (speaker_name != "") {
            global.DrawNameBox(box_x, box_y - 50, 200, 55, 0.85);
            
            draw_set_color(c_yellow);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            
            var lg_fnt = asset_get_index("fnt_large");
            if (lg_fnt == -1) lg_fnt = asset_get_index("fnt_main");
            if (lg_fnt != -1) draw_set_font(lg_fnt);
            
            draw_text(box_x + 100, box_y - 22, speaker_name);
            draw_set_color(c_white);
        }
        
        // 메인 대사 박스 (원자 컴포넌트 사용)
        global.DrawBox(box_x, box_y, box_width, box_height, 0.85);
        
        // 텍스트 폰트 설정
        var lg_fnt = asset_get_index("fnt_large");
        if (lg_fnt == -1) lg_fnt = asset_get_index("fnt_main");
        if (lg_fnt != -1) draw_set_font(lg_fnt);
        
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        
        // 타이핑 이펙트
        var display_text = string_copy(speaker_text, 1, global.typing_pos);
        draw_text_ext(box_x + 40, box_y + 40, display_text, -1, box_width - 80);
        
        // 타이핑 완료 시 깜빡이는 프롬프트 (원자 컴포넌트 사용)
        if (global.typing_done) {
            if ((current_time div 500) mod 2 == 0) {
                global.DrawPrompt(box_x + box_width - 30, box_y + box_height - 15);
            }
        }
    }
}

// ========================== 인벤토리 화면 렌더링 ==========================
if (global.inv_state > 0) {
    var inv_w = 400;
    var inv_h = 500;
    var inv_x = (1280 - inv_w) / 2;
    var inv_y = (720 - inv_h) / 2;
    
    // 메인 인벤토리 박스 (원자 컴포넌트 사용)
    global.DrawBox(inv_x, inv_y, inv_w, inv_h, 0.85);
    
    draw_set_halign(fa_center);
    draw_text(1280 / 2, inv_y + 20, "--- ITEM ---");
    
    draw_set_halign(fa_left);
    
    var item_count = array_length(global.inventory);
    
    if (item_count == 0) {
        draw_set_color(c_gray);
        draw_text(inv_x + 50, inv_y + 80, "(텅 비어있다)");
        draw_set_color(c_white);
    } else {
        for (var i = 0; i < item_count; i++) {
            var my_item = global.inventory[i];
            var draw_pos_y = inv_y + 80 + (i * 35);
            
            if (i == global.inv_cursor) {
                draw_set_color(c_yellow);
                
                if (global.inv_state == 1) {
                    draw_text(inv_x + 30, draw_pos_y, "->");
                } else {
                    draw_set_color(c_ltgray);
                    draw_text(inv_x + 30, draw_pos_y, "->");
                }
                
                draw_text(inv_x + 60, draw_pos_y, my_item.name);
                draw_set_color(c_white);
                
                if (global.inv_state == 1) {
                    draw_set_halign(fa_center);
                    draw_text(inv_x + (inv_w / 2), inv_y + inv_h - 40, my_item.desc);
                    draw_set_halign(fa_left);
                }
            } else {
                draw_set_color(c_white);
                draw_text(inv_x + 60, draw_pos_y, my_item.name);
            }
        }
        
        // State 2: 행동 선택 메뉴 (원자 컴포넌트 사용)
        if (global.inv_state == 2) {
            var action_w = 350;
            var action_h = 80;
            var action_x = inv_x + inv_w / 2 - action_w / 2;
            var action_y = inv_y + inv_h - 100;
            
            global.DrawBox(action_x, action_y, action_w, action_h, 1.0);
            
            var menu_text = ["사용", "정보", "버리기"];
            var menu_spacing = action_w / 3;
            
            for (var m = 0; m < 3; m++) {
                var mx = action_x + 20 + (m * menu_spacing);
                var my = action_y + 25;
                
                if (m == global.inv_action_cursor) {
                    draw_set_color(c_yellow);
                    draw_text(mx, my, "-> " + menu_text[m]);
                    draw_set_color(c_white);
                } else {
                    draw_set_color(c_white);
                    draw_text(mx + 25, my, menu_text[m]);
                }
            }
        }
    }
}

// ========================== 시스템 메뉴 (ESC) 화면 렌더링 ==========================
if (global.sys_active) {
    // 배경 어둡게
    draw_set_color(c_black);
    draw_set_alpha(0.6);
    draw_rectangle(0, 0, 1280, 720, false);
    draw_set_alpha(1.0);
    
    var sys_w = 500;
    var sys_h = 400;
    var sys_x = (1280 - sys_w) / 2;
    var sys_y = (720 - sys_h) / 2;
    
    global.DrawBox(sys_x, sys_y, sys_w, sys_h, 0.9);
    
    draw_set_halign(fa_center);
    var title = "SYSTEM MENU";
    if (global.sys_state == 1) title = "SAVE GAME";
    else if (global.sys_state == 2) title = "LOAD GAME";
    else if (global.sys_state == 3) title = "DELETE SAVE";
    
    draw_set_color(c_white);
    draw_text(1280 / 2, sys_y + 30, "- " + title + " -");
    draw_set_halign(fa_left);
    
    var menu_items = [];
    var menu_enabled = [];
    
    if (global.sys_state == 0) {
        // 메인: 0=RESUME, 1=SAVE, 2=LOAD, 3=DELETE, 4=TITLE
        menu_items = ["RESUME", "SAVE", "LOAD", "DELETE SAVE", "TITLE SCREEN"];
        // 로드/삭제는 세이브가 하나라도 있을 때만 활성화 (선택적)
        var any_save = false;
        for (var i=0; i<global.sys_slots; i++) {
            if (global.SaveExists(i)) { any_save = true; break; }
        }
        menu_enabled = [true, true, any_save, any_save, true];
        global.DrawMenuList(sys_x + 100, sys_y + 100, menu_items, global.sys_cursor, 45, menu_enabled);
    } 
    else {
        // 슬롯 메뉴 (1:Save, 2:Load, 3:Delete)
        for (var i = 0; i < global.sys_slots; i++) {
            var info = global.GetSaveInfo(i);
            array_push(menu_items, "Slot " + string(i + 1) + " : " + info);
            
            if (global.sys_state == 1) {
                array_push(menu_enabled, true); // 세이브는 항상 가능 (덮어쓰기)
            } else {
                array_push(menu_enabled, global.SaveExists(i)); // 로드/삭제는 존재할 때만
            }
        }
        array_push(menu_items, "BACK");
        array_push(menu_enabled, true);
        
        global.DrawMenuList(sys_x + 50, sys_y + 100, menu_items, global.sys_cursor, 55, menu_enabled);
    }
}

// ========================== 인게임 HUD ==========================
// 타이틀 화면이 아닐 때만 표시
if (room != Room_title && !global.sys_active) {
    var sm_fnt = asset_get_index("fnt_main");
    if (sm_fnt != -1) draw_set_font(sm_fnt);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    var hud_x = 20;
    var hud_y = 15;
    
    // 반투명 HUD 배경 박스
    draw_set_color(c_black);
    draw_set_alpha(0.5);
    draw_roundrect(hud_x - 5, hud_y - 5, hud_x + 250, hud_y + 90, false);
    draw_set_alpha(1.0);
    
    // --- 날짜 표시 ---
    draw_set_color(c_ltgray);
    draw_text(hud_x + 5, hud_y, "LP-" + string(global.day));
    
    // --- 에너지 바 ---
    var bar_x = hud_x + 5;
    var bar_y = hud_y + 25;
    var bar_w = 200;
    var bar_h = 14;
    var energy_ratio = global.energy / global.max_energy;
    
    // 배경 (어두운 바)
    draw_set_color(c_dkgray);
    draw_roundrect(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);
    
    // 에너지 바 (초록→빨강 그라데이션)
    if (energy_ratio > 0) {
        var bar_color = merge_color(c_red, c_lime, energy_ratio);
        draw_set_color(bar_color);
        draw_roundrect(bar_x, bar_y, bar_x + (bar_w * energy_ratio), bar_y + bar_h, false);
    }
    
    // 에너지 텍스트
    draw_set_color(c_white);
    draw_text(bar_x + bar_w + 8, bar_y - 2, string(global.energy));
    
    // --- 별사리풀 보유량 ---
    draw_set_color(make_color_rgb(180, 130, 255)); // 보라색
    draw_text(hud_x + 5, hud_y + 48, "★ " + string(global.inventory_grass));
    
    // --- 코어 파워 ---
    var core_color = c_lime;
    if (global.core_power < 30) core_color = c_red;
    else if (global.core_power < 60) core_color = c_yellow;
    
    draw_set_color(core_color);
    draw_text(hud_x + 80, hud_y + 48, "CORE: " + string(floor(global.core_power)) + "%");
    
    // --- 개화 프로토콜 진행률 (소수점 1자리) ---
    if (global.bloom_percent > 0) {
        draw_set_color(make_color_rgb(255, 200, 100));
        draw_text(hud_x + 5, hud_y + 70, "BLOOM: " + string(floor(global.bloom_percent * 10) / 10) + "%");
    }
    
    draw_set_color(c_white);
}

// ========================== 화면 전환 오버레이 ==========================
if (global.transition_active) {
    draw_set_color(c_black);
    draw_set_alpha(global.transition_alpha);
    draw_rectangle(0, 0, 1280, 720, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
}
