/// @description 정제기 렌더링 (코드 폴백)

pulse_timer += 3;
var pulse_alpha = 0.5 + sin(degtorad(pulse_timer)) * 0.2;

var spr = asset_get_index("spr_refinery");
if (spr != -1) {
    draw_sprite(spr, 0, x, y);
} else {
    // 코드 폴백: 금속 박스 + 기계 표현
    draw_set_color(make_color_rgb(80, 80, 90));
    draw_roundrect(x - 16, y - 12, x + 16, y + 12, false);
    
    // 상단 투입구
    draw_set_color(make_color_rgb(50, 50, 60));
    draw_rectangle(x - 8, y - 12, x + 8, y - 8, false);
    
    // 내부 빛 (활성 표시)
    if (global.inventory_grass > 0) {
        draw_set_alpha(pulse_alpha);
        draw_set_color(make_color_rgb(180, 100, 255));
        draw_circle(x, y, 5, false);
        draw_set_alpha(1.0);
    } else {
        draw_set_color(make_color_rgb(60, 60, 70));
        draw_circle(x, y, 5, false);
    }
    
    draw_set_color(c_white);
}
