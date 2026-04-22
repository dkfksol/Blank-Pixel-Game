/// @description 화면 최상단 강제 UI 렌더링 (Draw GUI)

// 1. 글로벌 상태창 (체력바 등 상시 출력) 설정
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
        
        // 박스 레이아웃 설정
        var box_width = 1000;
        var box_height = 200;
        var box_x = (1280 - box_width) / 2;
        var box_y = 720 - box_height - 20;
        
        // 이름표 박스 렌더링 (이름이 존재할 때만)
        if (speaker_name != "") {
            draw_set_color(c_black);
            draw_set_alpha(0.85);
            draw_roundrect(box_x, box_y - 50, box_x + 200, box_y + 5, false);
            
            draw_set_color(c_white);
            draw_roundrect(box_x, box_y - 50, box_x + 200, box_y + 5, true);
            
            draw_set_color(c_yellow);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            
            var lg_fnt = asset_get_index("fnt_large");
            if (lg_fnt == -1) lg_fnt = asset_get_index("fnt_main");
            if (lg_fnt != -1) draw_set_font(lg_fnt);
            
            draw_text(box_x + 100, box_y - 22, speaker_name);
            draw_set_color(c_white);
        }
        
        // 메인 대사 박스 렌더링
        draw_set_color(c_black);
        draw_set_alpha(0.85);
        draw_roundrect(box_x, box_y, box_x + box_width, box_y + box_height, false);
        
        draw_set_color(c_white);
        draw_set_alpha(1.0);
        draw_roundrect(box_x, box_y, box_x + box_width, box_y + box_height, true);
        
        // 텍스트 설정 및 출력
        var lg_fnt = asset_get_index("fnt_large");
        if (lg_fnt == -1) lg_fnt = asset_get_index("fnt_main");
        if (lg_fnt != -1) draw_set_font(lg_fnt);
        
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        
        draw_text_ext(box_x + 40, box_y + 40, speaker_text, -1, box_width - 80);
    }
}

// ========================== 인벤토리 화면 렌더링 ==========================
if (global.inv_state > 0) {
    var inv_w = 400;
    var inv_h = 500;
    var inv_x = (1280 - inv_w) / 2;
    var inv_y = (720 - inv_h) / 2;
    
    // 메인 인벤토리 박스 렌더링
    draw_set_color(c_black);
    draw_set_alpha(0.85);
    draw_roundrect(inv_x, inv_y, inv_x + inv_w, inv_y + inv_h, false);
    
    draw_set_color(c_white);
    draw_roundrect(inv_x, inv_y, inv_x + inv_w, inv_y + inv_h, true);
    
    draw_set_alpha(1.0);
    draw_set_halign(fa_center);
    draw_text(1280 / 2, inv_y + 20, "--- ITEM ---");
    
    draw_set_halign(fa_left);
    
    var item_count = array_length(global.inventory);
    
    if (item_count == 0) {
        draw_set_color(c_gray);
        draw_text(inv_x + 50, inv_y + 80, "(텅 비어있다)");
        draw_set_color(c_white);
    } else {
        // 아이템 목록 렌더링
        for (var i = 0; i < item_count; i++) {
            var my_item = global.inventory[i];
            var draw_pos_y = inv_y + 80 + (i * 35);
            
            if (i == global.inv_cursor) {
                draw_set_color(c_yellow);
                
                // 현재 상태에 따른 커서 표시
                if (global.inv_state == 1) {
                    draw_text(inv_x + 30, draw_pos_y, "->");
                } else {
                    draw_set_color(c_ltgray);
                    draw_text(inv_x + 30, draw_pos_y, "->");
                }
                
                draw_text(inv_x + 60, draw_pos_y, my_item.name);
                draw_set_color(c_white);
                
                // 아이템 상세 설명 출력
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
        
        // 인벤토리 State 2: 행동 선택 메뉴 렌더링
        if (global.inv_state == 2) {
            var action_w = 350;
            var action_h = 80;
            var action_x = inv_x + inv_w / 2 - action_w / 2;
            var action_y = inv_y + inv_h - 100;
            
            draw_set_color(c_black);
            draw_roundrect(action_x, action_y, action_x + action_w, action_y + action_h, false);
            draw_set_color(c_white);
            draw_roundrect(action_x, action_y, action_x + action_w, action_y + action_h, true);
            
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
