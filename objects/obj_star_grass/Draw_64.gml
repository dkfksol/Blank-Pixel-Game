/// @description 미니게임 UI 렌더링 (화면 중앙 고정)

if (minigame_active) {
    var gw = display_get_gui_width();
    var gh = display_get_gui_height();
    
    // UI를 화면 중앙에 거대하게 배치 (가로 400픽셀)
    var bar_w = 400;
    var bar_h = 30;
    var bar_x = (gw / 2) - (bar_w / 2);
    var bar_y = (gh / 2) + 100; // 화면 중앙보다 살짝 아래
    
    // 배경 바 (빨간색 - Fail)
    draw_set_color(make_color_rgb(200, 50, 50));
    draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);
    
    // 드론 부품 스캐빈징 여부에 따른 구간 너비
    var s_width_percent = global.GetFlag("drone_scavenged") ? 0.5 : 0.2; 
    var good_width_percent = s_width_percent + 0.4; // Good 구간
    
    // Good 구간 (노란색)
    var good_w = bar_w * good_width_percent;
    draw_set_color(make_color_rgb(220, 200, 50));
    draw_rectangle((gw/2) - good_w/2, bar_y, (gw/2) + good_w/2, bar_y + bar_h, false);
    
    // Perfect 구간 (초록색)
    var p_w = bar_w * s_width_percent;
    draw_set_color(make_color_rgb(50, 220, 100));
    draw_rectangle((gw/2) - p_w/2, bar_y, (gw/2) + p_w/2, bar_y + bar_h, false);
    
    // 커서 (흰색 두꺼운 선)
    var cursor_px = bar_x + (bar_w * (cursor_pos / 100));
    draw_set_color(c_white);
    draw_rectangle(cursor_px - 4, bar_y - 8, cursor_px + 4, bar_y + bar_h + 8, false);
    
    // 조작 안내 텍스트 (화면 중앙에 큼직하게)
    var sm_fnt = asset_get_index("fnt_main");
    if (sm_fnt != -1) draw_set_font(sm_fnt);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    
    draw_text_transformed(gw / 2, bar_y - 20, "타이밍에 맞춰 [Z] 키를 누르세요!", 1.5, 1.5, 0);
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
