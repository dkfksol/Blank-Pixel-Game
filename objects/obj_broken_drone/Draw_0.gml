/// @description 고장난 드론 렌더링

// 랙 그리기 (항상 렌더링)
draw_set_color(make_color_rgb(80, 80, 90));
draw_roundrect(x - 12, y - 4, x + 12, y + 4, false);

if (state == "rack") {
    // 빈 랙이므로 종료
    draw_set_color(c_white);
    exit;
} else if (state == "crashing" || state == "sparking") {
    // 컷신: 랙 위에서 스파크를 튀기거나 추락 중인 드론
    var dx = x + shake_x;
    var dy = crash_y;
    
    // 본체
    draw_set_color(make_color_rgb(220, 220, 230));
    draw_roundrect(dx - 8, dy - 6, dx + 8, dy + 6, false);
    
    // 프로펠러
    draw_set_color(make_color_rgb(150, 150, 160));
    draw_ellipse(dx - 14, dy - 8, dx - 4, dy - 4, false);
    draw_ellipse(dx + 4, dy - 8, dx + 14, dy - 4, false);
    
    // 치명적 고장 스파크
    if (random(100) < 40) {
        draw_set_color(c_yellow);
        draw_circle(dx + random_range(-10, 10), dy + random_range(-5, 5), random_range(1, 3), false);
    }
    
    draw_set_color(c_white);
    exit;
}

// === 이하 state == "broken" ===

// 부서진 드론 본체 (바닥에 처박힌 모습)
draw_set_color(make_color_rgb(180, 180, 190));
draw_roundrect(x - 10, y - 4, x + 8, y + 6, false);

// 부러진 프로펠러 
draw_set_color(make_color_rgb(100, 100, 110));
draw_line_width(x - 10, y, x - 18, y + 6, 2);

// 센서를 안 뜯었으면 깜빡이는 불빛, 뜯었으면 꺼짐
if (!global.GetFlag("drone_scavenged")) {
    spark_timer--;
    if (spark_timer <= 0) {
        // 스파크 효과
        draw_set_color(c_yellow);
        draw_circle(x + random_range(-5, 5), y + random_range(-2, 2), 2, false);
        spark_timer = irandom_range(10, 40);
    }
    
    // 희미한 센서 빛
    draw_set_color(make_color_rgb(50, 100, 150));
    draw_circle(x + 4, y + 2, 2, false);
}

draw_set_color(c_white);
