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
