/// @description 날씨 시각 효과 렌더링

// === 사전 계산된 파티클 (Create에서 1회 생성, 매 프레임 재사용) ===
if (!variable_instance_exists(id, "_particles_init")) {
    _particles_init = true;
    
    // 모래폭풍용 고정 파티클 좌표 (15개)
    _sand_px = array_create(15);
    _sand_py = array_create(15);
    _sand_r  = array_create(15);
    _sand_a  = array_create(15);
    _sand_spd = array_create(15);
    for (var i = 0; i < 15; i++) {
        _sand_px[i] = random(room_width);
        _sand_py[i] = random(room_height);
        _sand_r[i]  = random_range(1, 3);
        _sand_a[i]  = random_range(0.2, 0.5);
        _sand_spd[i] = random_range(2, 5);
    }
    
    // 바람용 고정 파티클 (5개)
    _wind_px = array_create(5);
    _wind_py = array_create(5);
    _wind_spd = array_create(5);
    for (var i = 0; i < 5; i++) {
        _wind_px[i] = random(room_width);
        _wind_py[i] = random(room_height);
        _wind_spd[i] = random_range(0.3, 0.8);
    }
    
    // 발자국 오프셋 사전 계산 (10개 슬롯, 한 번만 계산)
    _fp_offsets_x = array_create(10);
    _fp_offsets_y = array_create(10);
    for (var i = 0; i < 10; i++) {
        _fp_offsets_x[i] = i * irandom_range(15, 25);
        _fp_offsets_y[i] = sin(i * 1.5) * 8;
    }
}

// === 날씨별 렌더링 ===

if (global.weather == "sandstorm") {
    // 화면 전체 누런 톤
    draw_set_alpha(0.15);
    draw_set_color(make_color_rgb(180, 150, 80));
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0);
    
    // 모래 파티클 (좌표를 Step에서 이동시키는 대신 Draw에서 오프셋)
    draw_set_color(make_color_rgb(200, 170, 100));
    for (var i = 0; i < 15; i++) {
        // 바람에 밀려가는 효과 (current_time 기반 오프셋)
        var px = (_sand_px[i] + (current_time / 20) * _sand_spd[i]) mod room_width;
        draw_set_alpha(_sand_a[i]);
        draw_circle(px, _sand_py[i], _sand_r[i], false);
    }
    draw_set_alpha(1.0);
    
} else if (global.weather == "bountiful") {
    draw_set_alpha(0.08);
    draw_set_color(make_color_rgb(180, 130, 255));
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0);
    
} else if (global.weather == "calm_wind") {
    draw_set_color(make_color_rgb(200, 200, 220));
    for (var i = 0; i < 5; i++) {
        var px = (_wind_px[i] + (current_time / 80) * _wind_spd[i]) mod room_width;
        draw_set_alpha(0.15);
        draw_circle(px, _wind_py[i], 1, false);
    }
    draw_set_alpha(1.0);
    
} else if (global.weather == "red_sky") {
    var red_intensity = 0.1 + (global.bloom_percent / 100) * 0.15;
    draw_set_alpha(red_intensity);
    draw_set_color(make_color_rgb(200, 60, 40));
    draw_rectangle(0, 0, room_width, room_height, false);
    draw_set_alpha(1.0);
}

// === 발자국 렌더링 (사전 계산된 오프셋 사용) ===
if (global.daily_event == "footprints") {
    var fp_x = global.GetFlag("footprint_x");
    var fp_y = global.GetFlag("footprint_y");
    var fp_count = global.GetFlag("footprint_count");
    
    if (fp_x != false && fp_y != false && fp_count != false) {
        draw_set_color(make_color_rgb(120, 90, 60));
        draw_set_alpha(0.5);
        var cnt = min(fp_count, 10); // 최대 10개 슬롯
        for (var i = 0; i < cnt; i++) {
            var ox = fp_x + _fp_offsets_x[i];
            var oy = fp_y + _fp_offsets_y[i];
            draw_circle(ox, oy, 2, false);
            draw_circle(ox - 2, oy - 3, 1, false);
            draw_circle(ox + 2, oy - 3, 1, false);
        }
        draw_set_alpha(1.0);
    }
}

draw_set_color(c_white);
