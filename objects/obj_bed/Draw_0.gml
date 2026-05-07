/// @description 침대 렌더링 (코드 폴백 + 열화 반영)

// 스프라이트 캐싱
if (!variable_instance_exists(id, "_spr_cached")) {
    _spr_cached = true;
    _spr_bed = asset_get_index("spr_bed");
    _spr_worn = asset_get_index("spr_bed_worn");
}

if (global.bed_quality < 30 && _spr_worn != -1) {
    draw_sprite(_spr_worn, 0, x, y);
} else if (_spr_bed != -1) {
    draw_sprite(_spr_bed, 0, x, y);
} else {
    // 코드 폴백
    if (global.bed_quality <= 0) {
        // 부서진 침대
        draw_set_color(make_color_rgb(60, 45, 30));
        draw_roundrect(x - 14, y - 8, x + 14, y + 10, false);
        draw_set_color(make_color_rgb(35, 40, 60));
        draw_roundrect(x - 10, y - 4, x + 12, y + 9, false);
        // 부서진 표시 (X자)
        draw_set_color(make_color_rgb(120, 80, 50));
        draw_line_width(x - 8, y - 4, x + 6, y + 6, 1);
    } else if (global.bed_quality < 30) {
        // 낡은 침대 (색이 바랜 느낌)
        draw_set_color(make_color_rgb(70, 55, 35));
        draw_roundrect(x - 14, y - 8, x + 14, y + 10, false);
        draw_set_color(make_color_rgb(35, 45, 70));
        draw_roundrect(x - 12, y - 6, x + 12, y + 8, false);
        draw_set_color(make_color_rgb(130, 130, 140));
        draw_roundrect(x - 10, y - 6, x - 2, y + 0, false);
    } else {
        // 정상 침대
        draw_set_color(make_color_rgb(80, 60, 40));
        draw_roundrect(x - 14, y - 8, x + 14, y + 10, false);
        draw_set_color(make_color_rgb(40, 50, 80));
        draw_roundrect(x - 12, y - 6, x + 12, y + 8, false);
        draw_set_color(make_color_rgb(160, 160, 170));
        draw_roundrect(x - 10, y - 6, x - 2, y + 0, false);
    }
    
    draw_set_color(c_white);
}
