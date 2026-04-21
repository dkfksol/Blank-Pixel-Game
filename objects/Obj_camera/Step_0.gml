/// @description 부드러운 카메라 추적 및 뷰 적용

// 1. 플레이어가 존재하는지 확인
if (instance_exists(target)) {
    // 2. lerp 함수를 사용해 현재 위치에서 목표 위치로 서서히 미끄러짐 (0.1 속도)
    var spd = 0.1;
    x = lerp(x, target.x, spd);
    y = lerp(y, target.y, spd);
}

// 3. 실제 카메라 렌즈의 좌상단(x, y) 좌표 계산 (오브젝트 x,y가 화면 중앙에 오게 만듦)
var cam_x = x - (camWidth / 2);
var cam_y = y - (camHeight / 2);

// 룸 바깥으로 카메라가 나가는 것을 막는 기능 (필요하면 주석 해제)
// cam_x = clamp(cam_x, 0, room_width - camWidth);
// cam_y = clamp(cam_y, 0, room_height - camHeight);

// 4. GameMaker 시스템 설정: 뷰포트[0]에 우리가 계산한 시점과 크기를 덮어씌움
camera_set_view_pos(view_camera[0], cam_x, cam_y);
camera_set_view_size(view_camera[0], camWidth, camHeight);
