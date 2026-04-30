/// @description 침대 렌더링 (코드 폴백)

var spr = asset_get_index("spr_bed");
if (spr != -1) {
    draw_sprite(spr, 0, x, y);
} else {
    // 코드 폴백: 간이 침대 표현
    
    // 침대 프레임 (어두운 갈색)
    draw_set_color(make_color_rgb(80, 60, 40));
    draw_roundrect(x - 14, y - 8, x + 14, y + 10, false);
    
    // 이불 (어두운 남색)
    draw_set_color(make_color_rgb(40, 50, 80));
    draw_roundrect(x - 12, y - 6, x + 12, y + 8, false);
    
    // 베개 (밝은 회색)
    draw_set_color(make_color_rgb(160, 160, 170));
    draw_roundrect(x - 10, y - 6, x - 2, y + 0, false);
    
    draw_set_color(c_white);
}
