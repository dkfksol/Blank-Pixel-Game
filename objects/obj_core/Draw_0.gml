/// @description 도화 코어 렌더링 (금속 꽃봉오리 + 글로우)

bloom_timer += bloom_speed;
var breath_scale = 1.0 + sin(degtorad(bloom_timer)) * 0.05;
var bloom_ratio = global.bloom_percent / 100;

var spr = asset_get_index("spr_core");
if (spr != -1) {
    draw_sprite_ext(spr, 0, x, y, breath_scale, breath_scale, 0, c_white, 1.0);
} else {
    // 코드 폴백: 금속 꽃봉오리

    // 외부 글로우 (bloom%에 따라 강해짐)
    var glow_r = 0.3 + bloom_ratio * 0.5;
    draw_set_alpha(glow_r * 0.4);
    var glow_color = merge_color(make_color_rgb(100, 150, 200), make_color_rgb(255, 200, 100), bloom_ratio);
    draw_set_color(glow_color);
    draw_circle(x, y, 22 * breath_scale, false);
    draw_set_alpha(1.0);
    
    // 꽃봉오리 본체 (금속 회색~골드 그라데이션)
    var body_color = merge_color(make_color_rgb(120, 130, 140), make_color_rgb(200, 180, 120), bloom_ratio);
    draw_set_color(body_color);
    
    // 꽃잎 모양 (5방향 타원)
    for (var i = 0; i < 5; i++) {
        var angle = (360 / 5) * i + bloom_timer * 0.2;
        var petal_x = x + lengthdir_x(8 * breath_scale, angle);
        var petal_y = y + lengthdir_y(8 * breath_scale, angle);
        draw_ellipse(petal_x - 6, petal_y - 4, petal_x + 6, petal_y + 4, false);
    }
    
    // 중심 코어 (밝은 원)
    var core_color = merge_color(make_color_rgb(180, 200, 220), make_color_rgb(255, 240, 180), bloom_ratio);
    draw_set_color(core_color);
    draw_circle(x, y, 6 * breath_scale, false);
    
    // 내부 빛 (core_power에 따른 밝기)
    var inner_alpha = (global.core_power / 100) * 0.8;
    draw_set_alpha(inner_alpha);
    draw_set_color(c_white);
    draw_circle(x, y, 3, false);
    draw_set_alpha(1.0);
    
    draw_set_color(c_white);
}
