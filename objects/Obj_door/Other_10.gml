/// @description 상호작용 시 부드러운 방 이동 (User Event 0)

if (target_room == noone) {
    show_debug_message("오류: 이 문의 도착지(target_room)가 설정되지 않았습니다!");
} 
else if (room_exists(target_room)) {
    // 도착 위치가 설정되어 있으면 해당 위치로, 없으면 현재 위치 유지 (-1)
    var dest_x = variable_instance_exists(id, "target_x") ? target_x : -1;
    var dest_y = variable_instance_exists(id, "target_y") ? target_y : -1;
    global.TransitionToRoom(target_room, dest_x, dest_y);
} 
else {
    show_debug_message("오류: 가려는 방이 존재하지 않습니다!");
}
