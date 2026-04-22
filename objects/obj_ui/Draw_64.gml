/// @description 화면 최상단 강제 UI 렌더링 (Draw GUI)
// 이 이벤트 안에 쓴 그림은 카메라가 아무리 흔들려도 모니터 유리에 붙은 것처럼 고정됩니다!

// ========================== 1. 글로벌 상태창 (체력바 등상시 출력) ==========================
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var fnt_id = asset_get_index("fnt_main");
if (fnt_id != -1) draw_set_font(fnt_id);

// draw_set_color(c_red);
// draw_text(30, 30, "HP : " + string(global.hp) + " / " + string(global.max_hp));
// draw_set_color(c_white);

if (global.dialogue_active == true) {
    if (array_length(global.dialogue_data) > 0) {
        var cur_dialogue = global.dialogue_data[global.dialogue_index];
        var speaker_name = cur_dialogue.name;
        var speaker_text = cur_dialogue.text;
        
        // 1. 대강의 박스 사이즈와 (X,Y) 좌표를 정합니다.
        var box_width = 1000;
        var box_height = 200; // 텍스트가 커지므로 박스 높이 증가
        var box_x = (1280 - box_width) / 2; // 가로 정중앙
        var box_y = 720 - box_height - 20;  // 맨 바닥에서 20픽셀 띄움
        
        // 2. 이름표 박스 (이름이 빈칸이 아닐 때만 그리기)
        if (speaker_name != "") {
            draw_set_color(c_black);
            draw_set_alpha(0.85);
            draw_roundrect(box_x, box_y - 60, box_x + 250, box_y + 5, false); // 본체 박스와 살짝 겹치게
            
            draw_set_color(c_white);
            draw_roundrect(box_x, box_y - 60, box_x + 250, box_y + 5, true);
            
            draw_set_color(c_yellow);
            draw_set_halign(fa_center);
            draw_set_valign(fa_middle);
            
            var fnt_id = asset_get_index("fnt_main");
            if (fnt_id != -1) draw_set_font(fnt_id);
            
            // 이름 1.5배 확대
            draw_text_transformed(box_x + 125, box_y - 28, speaker_name, 1.5, 1.5, 0);
            
            // 원상 복구
            draw_set_color(c_white);
        }
        
        // 3. 메인 대사 박스 그리기 (검은 배경, 흰 테두리)
        draw_set_color(c_black);
        draw_set_alpha(0.85);
        draw_roundrect(box_x, box_y, box_x + box_width, box_y + box_height, false);
        
        draw_set_color(c_white);
        draw_set_alpha(1.0);
        draw_roundrect(box_x, box_y, box_x + box_width, box_y + box_height, true);
        
        // 4. 대사 텍스트 세팅
        var fnt_id = asset_get_index("fnt_main");
        if (fnt_id != -1) draw_set_font(fnt_id);
        
        draw_set_halign(fa_left);
        draw_set_valign(fa_top);
        
        // 5. 텍스트 1.5배 확대해서 출력!
        // draw_text_ext_transformed(x, y, string, sep, w, xscale, yscale, angle);
        // sep(줄간격): 대략 40~50, w(자동줄바꿈 너비): 스케일 반영해서 약간 줄여줍니다.
        draw_text_ext_transformed(box_x + 40, box_y + 40, speaker_text, 45, (box_width - 80) / 1.5, 1.5, 1.5, 0);
    }
}

// ========================== 인벤토리 화면 그리기 ==========================
if (global.inv_state > 0) {
    var inv_w = 400; // 가방 크기
    var inv_h = 500;
    var inv_x = (1280 - inv_w) / 2; // 정중앙
    var inv_y = (720 - inv_h) / 2;
    
    // 1. 바탕 박스 그리기 (검은색 배경에 흰색 테두리를 하면 언더테일 느낌이 납니다!)
    draw_set_color(c_black);
    draw_set_alpha(0.85);
    draw_roundrect(inv_x, inv_y, inv_x + inv_w, inv_y + inv_h, false);
    
    // 흰색 테두리
    draw_set_color(c_white);
    draw_roundrect(inv_x, inv_y, inv_x + inv_w, inv_y + inv_h, true);
    
    draw_set_alpha(1.0);
    draw_set_halign(fa_center);
    draw_text(1280 / 2, inv_y + 20, "--- ITEM ---");
    
    draw_set_halign(fa_left); // 왼쪽 정렬 원상복구
    
    var item_count = array_length(global.inventory);
    
    if (item_count == 0) {
        draw_set_color(c_gray);
        draw_text(inv_x + 50, inv_y + 80, "(텅 비어있다)");
        draw_set_color(c_white);
    } else {
        // 아이템 목록 그리기
        for (var i = 0; i < item_count; i++) {
            var my_item = global.inventory[i];
            var draw_pos_y = inv_y + 80 + (i * 35);
            
            if (i == global.inv_cursor) {
                // 커서가 있는 곳
                draw_set_color(c_yellow);
                
                // State 1일 때는 커서가 깜빡이거나 하트 모양이 있으면 좋은데, 텍스트로 일단 처리합니다.
                if (global.inv_state == 1) {
                    draw_text(inv_x + 30, draw_pos_y, "->");
                } else {
                    // State 2 (행동 선택 중)일 때는 아이템 선택 커서는 회색/고정으로 보여줍니다.
                    draw_set_color(c_ltgray);
                    draw_text(inv_x + 30, draw_pos_y, "->");
                }
                
                draw_text(inv_x + 60, draw_pos_y, my_item.name);
                draw_set_color(c_white);
                
                // State 1일 때만 설명서를 아래에 띄워줍니다.
                if (global.inv_state == 1) {
                    draw_set_halign(fa_center);
                    draw_text(inv_x + (inv_w / 2), inv_y + inv_h - 40, my_item.desc);
                    draw_set_halign(fa_left);
                }
            } else {
                // 선택되지 않은 아이템
                draw_set_color(c_white);
                draw_text(inv_x + 60, draw_pos_y, my_item.name);
            }
        }
        
        // ----------------------------------------------------
        // --- State 2: 행동 선택 메뉴 그리기 (사용, 정보, 버리기) ---
        // ----------------------------------------------------
        if (global.inv_state == 2) {
            // 행동 메뉴 박스 위치 (가방 바로 오른쪽 아래쯤)
            var action_w = 350;
            var action_h = 80;
            var action_x = inv_x + inv_w / 2 - action_w / 2;
            var action_y = inv_y + inv_h - 100;
            
            // 행동 박스 그리기
            draw_set_color(c_black);
            draw_roundrect(action_x, action_y, action_x + action_w, action_y + action_h, false);
            draw_set_color(c_white);
            draw_roundrect(action_x, action_y, action_x + action_w, action_y + action_h, true);
            
            // 메뉴 텍스트 배열
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
                    draw_text(mx + 25, my, menu_text[m]); // -> 공간만큼 띄워줌
                }
            }
        }
    }
}
