/// @description 여우 렌더링

// 스프라이트 캐싱
if (!variable_instance_exists(id, "_spr_cached")) {
    _spr_cached = true;
    _spr_idle = asset_get_index("spr_fox_idle");
    _spr_walk = asset_get_index("spr_fox_walk");
    _spr_rest = asset_get_index("spr_fox_rest");
}

// 스프라이트가 있으면 사용
if (_spr_idle != -1) {
    if (state == "resting" && _spr_rest != -1) {
        draw_sprite(_spr_rest, 0, x, y);
    } else if ((state == "wary" || state == "curious") && _spr_walk != -1) {
        draw_sprite(_spr_walk, floor(tail_timer / 15) mod sprite_get_number(_spr_walk), x, y);
    } else {
        draw_sprite(_spr_idle, floor(tail_timer / 20) mod sprite_get_number(_spr_idle), x, y);
    }
    exit;
}

// === 코드 폴백 ===
var tail_sway = sin(degtorad(tail_timer)) * 4;
var eye_open = (blink_timer > 5);

// 몸통
draw_set_color(make_color_rgb(180, 120, 60));
draw_ellipse(x - 8, y - 4, x + 8, y + 4, false);

// 머리
draw_set_color(make_color_rgb(200, 140, 70));
draw_circle(x + 9, y - 2, 5, false);

// 귀
draw_set_color(make_color_rgb(180, 110, 50));
draw_triangle(x + 7, y - 6, x + 5, y - 12, x + 10, y - 10, false);
draw_triangle(x + 11, y - 6, x + 9, y - 12, x + 14, y - 10, false);

// 귀 안쪽
draw_set_color(make_color_rgb(220, 160, 140));
draw_triangle(x + 8, y - 7, x + 6, y - 10, x + 10, y - 9, false);

// 눈
if (eye_open) {
    draw_set_color(make_color_rgb(220, 180, 50));
    draw_circle(x + 11, y - 3, 2, false);
    draw_set_color(c_black);
    draw_circle(x + 11, y - 3, 1, false);
} else {
    draw_set_color(make_color_rgb(180, 120, 60));
    draw_line_width(x + 9, y - 3, x + 13, y - 3, 1);
}

// 코
draw_set_color(c_black);
draw_circle(x + 14, y - 1, 1, false);

// 꼬리
draw_set_color(make_color_rgb(200, 140, 70));
draw_ellipse(x - 12 + tail_sway, y - 2, x - 6 + tail_sway, y + 2, false);
draw_set_color(make_color_rgb(240, 230, 210));
draw_circle(x - 13 + tail_sway, y, 2, false);

// 다리
draw_set_color(make_color_rgb(160, 100, 50));
draw_line_width(x - 4, y + 4, x - 4, y + 8, 2);
draw_line_width(x + 4, y + 4, x + 4, y + 8, 2);

draw_set_color(c_white);
