/// @description 임시 그래픽(몸통/시야) 및 센서 테두리 렌더링

// 1. 만약 나중에 진짜 스프라이트(그림)를 넣었다면 정상적으로 출력합니다.
if (sprite_index != -1) {
    draw_self();
} else {
    // 2. 그림이 없다면 파란색 동그라미로 귀여운 몸통을 만듭니다.
    draw_set_color(c_blue);
    draw_circle(x, y, 14, false);
    
    // 3. 내가 바라보고 있는 방향(facing_dir)을 노란색 더듬이(코)로 표현합니다.
    var ray_len = 24; 
    var nose_x = x + lengthdir_x(ray_len, facing_dir);
    var nose_y = y + lengthdir_y(ray_len, facing_dir);
    
    draw_set_color(c_yellow);
    draw_line_width(x, y, nose_x, nose_y, 4); 
}

// 디버그 가이드 선은 렌더링하지 않습니다.
