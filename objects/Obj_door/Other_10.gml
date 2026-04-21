/// @description 상호작용 시 방 이동 (User Event 0)
// 플레이어가 문을 바라보고 Z키를 누르면(상호작용) 이 이벤트가 무조건 발동됩니다!
// 목적지 설정(Creation Code) 자체를 빼먹고 타지 않았는지 가장 먼저 검사합니다.
if (target_room == noone) {
    show_debug_message("오류: 이 문의 도착지(target_room)가 'Creation Code'에 세팅되지 않았습니다!");
} 
// 목적지가 지정되어 있고, 그 방이 게임에 실제로 존재한다면 워프!
else if (room_exists(target_room)) {
    room_goto(target_room);
} 
// 이름을 오타 등으로 잘못 적은 경우
else {
    show_debug_message("오류: 가려는 방이 지워졌거나 이름이 틀립니다!");
}
