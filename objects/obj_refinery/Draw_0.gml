/// @description 정제기 렌더링 (코드 폴백 + 상태 반영)

pulse_timer += 3;
var pulse_alpha = 0.5 + sin(degtorad(pulse_timer)) * 0.2;

// 스프라이트 캐싱 (Create에서 1회만 계산)
if (!variable_instance_exists(id, "_spr_cached")) {
    _spr_cached = true;
    _spr_ref = asset_get_index("spr_refinery");
    _spr_broken = asset_get_index("spr_refinery_broken");
    _spr_active = asset_get_index("spr_refinery_active");
}

if (global.refinery_broken && _spr_broken != -1) {
    draw_sprite(_spr_broken, 0, x, y);
} else if (_spr_ref != -1) {
    draw_sprite(_spr_ref, 0, x, y);
} else {
    // 코드 폴백
    if (global.refinery_broken) {
        // 고장 상태: 붉은 톤 + 연기 표현
        draw_set_color(make_color_rgb(90, 60, 60));
        draw_roundrect(x - 16, y - 12, x + 16, y + 12, false);
        draw_set_color(make_color_rgb(50, 40, 40));
        draw_rectangle(x - 8, y - 12, x + 8, y - 8, false);
        // 경고 빛
        draw_set_alpha(pulse_alpha);
        draw_set_color(make_color_rgb(255, 80, 50));
        draw_circle(x, y, 5, false);
        draw_set_alpha(1.0);
        // 고장 표시
        draw_set_color(c_red);
        draw_line_width(x - 6, y - 6, x + 6, y + 6, 2);
        draw_line_width(x + 6, y - 6, x - 6, y + 6, 2);
    } else {
        draw_set_color(make_color_rgb(80, 80, 90));
        draw_roundrect(x - 16, y - 12, x + 16, y + 12, false);
        draw_set_color(make_color_rgb(50, 50, 60));
        draw_rectangle(x - 8, y - 12, x + 8, y - 8, false);
        
        if (global.inventory_grass > 0) {
            draw_set_alpha(pulse_alpha);
            draw_set_color(make_color_rgb(180, 100, 255));
            draw_circle(x, y, 5, false);
            draw_set_alpha(1.0);
        } else {
            draw_set_color(make_color_rgb(60, 60, 70));
            draw_circle(x, y, 5, false);
        }
        
        // 내구도 경고 (50 미만이면 주황색 점멸)
        if (global.refinery_durability < 50) {
            draw_set_alpha(pulse_alpha * 0.6);
            draw_set_color(make_color_rgb(255, 160, 50));
            draw_circle(x + 10, y - 8, 3, false);
            draw_set_alpha(1.0);
        }
    }
    
    draw_set_color(c_white);
}
