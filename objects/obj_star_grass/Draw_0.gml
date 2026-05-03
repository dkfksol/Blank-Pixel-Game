/// @description 별사리풀 렌더링 (보라색 글로우 + 기본 스프라이트)

// 글로우 이펙트 타이머 진행
glow_timer += glow_speed;
var glow_alpha = 0.4 + sin(degtorad(glow_timer)) * 0.3;

// 스프라이트가 있으면 스프라이트 사용, 없으면 코드로 폴백
var spr = asset_get_index("spr_star_grass");
if (spr != -1) {
    // 보라색 글로우 원
    draw_set_alpha(glow_alpha * 0.5);
    draw_set_color(make_color_rgb(160, 80, 255));
    draw_circle(x, y, 12, false);
    draw_set_alpha(1.0);
    draw_set_color(c_white);
    
    draw_sprite(spr, 0, x, y);
} else {
    // 코드 폴백: 보라색 글로우 원 + 심볼
    draw_set_alpha(glow_alpha * 0.5);
    draw_set_color(make_color_rgb(120, 50, 200));
    draw_circle(x, y, 14, false);
    draw_set_alpha(glow_alpha);
    draw_set_color(make_color_rgb(180, 100, 255));
    draw_circle(x, y, 8, false);
    draw_set_alpha(1.0);
    
    // 중심에 밝은 점 (결정)
    draw_set_color(make_color_rgb(230, 200, 255));
    draw_circle(x, y - 2, 3, false);
    
    // 풀 줄기 (아래로 짧은 선)
    draw_set_color(make_color_rgb(100, 60, 160));
    draw_line_width(x, y + 3, x - 2, y + 10, 1);
    draw_line_width(x, y + 3, x + 2, y + 10, 1);
    
    draw_set_color(c_white);
}

// --- 미니게임 게이지 바 렌더링 ---
if (minigame_active) {
    var bar_w = 40;
    var bar_h = 6;
    var bar_x = x - bar_w/2;
    var bar_y = y - 25;
    
    // 배경 바 (빨간색 - Fail)
    draw_set_color(make_color_rgb(200, 50, 50));
    draw_rectangle(bar_x, bar_y, bar_x + bar_w, bar_y + bar_h, false);
    
    // 드론 부품 스캐빈징 여부에 따른 구간 너비
    var s_width_percent = global.GetFlag("drone_scavenged") ? 0.5 : 0.2; 
    var good_width_percent = s_width_percent + 0.4; // Good 구간
    
    // Good 구간 (노란색)
    var good_w = bar_w * good_width_percent;
    draw_set_color(make_color_rgb(220, 200, 50));
    draw_rectangle(x - good_w/2, bar_y, x + good_w/2, bar_y + bar_h, false);
    
    // Perfect 구간 (초록색)
    var p_w = bar_w * s_width_percent;
    draw_set_color(make_color_rgb(50, 220, 100));
    draw_rectangle(x - p_w/2, bar_y, x + p_w/2, bar_y + bar_h, false);
    
    // 커서 (흰색 선)
    var cursor_px = bar_x + (bar_w * (cursor_pos / 100));
    draw_set_color(c_white);
    draw_rectangle(cursor_px - 1, bar_y - 2, cursor_px + 1, bar_y + bar_h + 2, false);
    
    // 조작 안내 텍스트
    var sm_fnt = asset_get_index("fnt_main");
    if (sm_fnt != -1) draw_set_font(sm_fnt);
    draw_set_halign(fa_center);
    draw_set_valign(fa_bottom);
    draw_set_color(c_white);
    draw_text_transformed(x, bar_y - 2, "[Z] 정지!", 0.7, 0.7, 0);
    
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
}
