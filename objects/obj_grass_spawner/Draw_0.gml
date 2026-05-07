/// @description 날씨 시각 효과 렌더링

// === 날씨별 화면 전체 톤/파티클 효과 ===

if (global.weather == "sandstorm") {
    // 모래폭풍: 화면에 모래색 입자가 날림 + 전체적으로 누런 톤
    draw_set_alpha(0.15);
    draw_set_color(make_color_rgb(180, 150, 80));
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0);
    
    // 모래 파티클
    draw_set_color(make_color_rgb(200, 170, 100));
    for (var i = 0; i < 15; i++) {
        var px = random(room_width);
        var py = random(room_height);
        draw_set_alpha(random_range(0.2, 0.5));
        draw_circle(px, py, random_range(1, 3), false);
    }
    draw_set_alpha(1.0);
    
} else if (global.weather == "bountiful") {
    // 풍작일: 화면이 약간 밝고 보랏빛 빛이 감돌음
    draw_set_alpha(0.08);
    draw_set_color(make_color_rgb(180, 130, 255));
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0);
    
} else if (global.weather == "calm_wind") {
    // 고요한 바람: 미세한 파티클이 느리게 이동
    draw_set_color(make_color_rgb(200, 200, 220));
    for (var i = 0; i < 5; i++) {
        var px = (random(room_width) + current_time / 50) mod room_width;
        var py = random(room_height);
        draw_set_alpha(random_range(0.1, 0.25));
        draw_circle(px, py, 1, false);
    }
    draw_set_alpha(1.0);
    
} else if (global.weather == "red_sky") {
    // 붉은 하늘: 개화 임박, 화면 전체가 붉은 톤
    var red_intensity = 0.1 + (global.bloom_percent / 100) * 0.15;
    draw_set_alpha(red_intensity);
    draw_set_color(make_color_rgb(200, 60, 40));
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0);
}

// === 발자국 렌더링 (여우 이벤트) ===
if (global.daily_event == "footprints") {
    var fp_x = global.GetFlag("footprint_x");
    var fp_y = global.GetFlag("footprint_y");
    var fp_count = global.GetFlag("footprint_count");
    
    if (fp_x != false && fp_y != false) {
        draw_set_color(make_color_rgb(120, 90, 60));
        draw_set_alpha(0.5);
        for (var i = 0; i < fp_count; i++) {
            var ox = fp_x + i * irandom_range(15, 25);
            var oy = fp_y + sin(i * 1.5) * 8;
            // 작은 발자국 (3개의 점)
            draw_circle(ox, oy, 2, false);
            draw_circle(ox - 2, oy - 3, 1, false);
            draw_circle(ox + 2, oy - 3, 1, false);
        }
        draw_set_alpha(1.0);
    }
}

draw_set_color(c_white);
