/// @description 여우 렌더링

// 꼬리 흔들기 효과
var tail_sway = sin(degtorad(tail_timer)) * 4;

// 눈 깜빡임
var eye_open = (blink_timer > 5);

// === 몸체 (갈색-주황 그라데이션) ===
// 몸통
draw_set_color(make_color_rgb(180, 120, 60));
draw_ellipse(x - 8, y - 4, x + 8, y + 4, false);

// 머리
draw_set_color(make_color_rgb(200, 140, 70));
draw_circle(x + 9, y - 2, 5, false);

// 귀 (삼각형처럼)
draw_set_color(make_color_rgb(180, 110, 50));
draw_triangle(x + 7, y - 6, x + 5, y - 12, x + 10, y - 10, false);
draw_triangle(x + 11, y - 6, x + 9, y - 12, x + 14, y - 10, false);

// 귀 안쪽 (분홍)
draw_set_color(make_color_rgb(220, 160, 140));
draw_triangle(x + 8, y - 7, x + 6, y - 10, x + 10, y - 9, false);

// 눈 (금색, 깜빡임)
if (eye_open) {
    draw_set_color(make_color_rgb(220, 180, 50));
    draw_circle(x + 11, y - 3, 2, false);
    // 동공
    draw_set_color(c_black);
    draw_circle(x + 11, y - 3, 1, false);
} else {
    draw_set_color(make_color_rgb(180, 120, 60));
    draw_line_width(x + 9, y - 3, x + 13, y - 3, 1);
}

// 코 (작은 검은 점)
draw_set_color(c_black);
draw_circle(x + 14, y - 1, 1, false);

// 꼬리 (흔들리는 효과)
draw_set_color(make_color_rgb(200, 140, 70));
draw_ellipse(x - 12 + tail_sway, y - 2, x - 6 + tail_sway, y + 2, false);
// 꼬리 끝 (흰색)
draw_set_color(make_color_rgb(240, 230, 210));
draw_circle(x - 13 + tail_sway, y, 2, false);

// 다리 (짧은 선)
draw_set_color(make_color_rgb(160, 100, 50));
draw_line_width(x - 4, y + 4, x - 4, y + 8, 2);
draw_line_width(x + 4, y + 4, x + 4, y + 8, 2);

draw_set_color(c_white);
