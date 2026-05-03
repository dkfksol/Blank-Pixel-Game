/// @description 상호작용 시 부드러운 방 이동 (User Event 0)

// 들판(Room2)에서 138일차에 집으로 돌아가려 할 때
if (room == Room2 && global.day == 138 && instance_exists(obj_drone)) {
    if (obj_drone.state == "return_home") exit; // 이미 부른 상태면 무시
    
    // 플레이어가 귀환 대사를 치고 드론을 부름
    global.ShowDialogue([
        { name: "", text: "호버카트가 경고음을 낸다.\n오늘은 여기까지 캔다." },
        { name: "", text: "드론, 복귀해라. 이제 가자!" }
    ]);
    
    obj_drone.state = "return_home";
    exit;
}

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
