/// @description 드론 렌더링 (코드 폴백)

hover_timer += 4;
var hover_y = sin(degtorad(hover_timer)) * 3;

// 드론 본체 (하얀색 박스)
draw_set_color(make_color_rgb(220, 220, 230));
draw_roundrect(x - 8, y - 6 + hover_y, x + 8, y + 6 + hover_y, false);

// 프로펠러 양옆
draw_set_color(make_color_rgb(150, 150, 160));
draw_ellipse(x - 14, y - 8 + hover_y, x - 4, y - 4 + hover_y, false);
draw_ellipse(x + 4, y - 8 + hover_y, x + 14, y - 4 + hover_y, false);

// 파란색 눈(센서)
draw_set_color(make_color_rgb(50, 200, 255));
draw_circle(x + 3, y + hover_y, 2, false);

draw_set_color(c_white);

// 상태 표시창 (수확 중일 때)
if (state == 2) {
    draw_set_color(make_color_rgb(50, 200, 255));
    draw_line_width(x, y + hover_y, target_grass.x, target_grass.y, 2);
    draw_set_color(c_white);
}
