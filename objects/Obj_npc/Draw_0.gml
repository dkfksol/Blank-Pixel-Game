/// @description 스프라이트 및 말풍선 렌더링

// 1. 자기 자신의 그림 그리기 (스프라이트가 없으면 초록 박스)
if (sprite_index == -1) {
    draw_set_color(c_green);
    draw_rectangle(x - 16, y - 16, x + 16, y + 16, false);
    draw_set_color(c_white);
} else {
    draw_self();
}

// 2. 머리 위에 동동 뜨던 구식 말풍선 코드는 전부 삭제되었습니다.
// 이제 모든 텍스트는 글로벌 화면의 obj_ui가 혼자 거대한 박스로 그려줍니다!
