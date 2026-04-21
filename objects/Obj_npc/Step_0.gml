/// @description 플레이어와 멀어지면 대화창 끄기
if (show_text == true) {
    if (instance_exists(Obj_char)) {
        // 플레이어 캐릭터와 거리가 40 픽셀 이상 멀어지면
        if (distance_to_object(Obj_char) > 40) {
            show_text = false; // 대화창 숨기기
        }
    }
}
