/// @description 카메라 설정 (에러 수정판)
persistent = true; // ★핵심: 룸이 바뀌어도 카메라가 파괴되지 않고 다음 룸으로 따라갑니다.

// 1. 혹시라도 룸 에디터에서 [Visible] 체크가 누락되었을 경우를 대비해
// 코드로 강제로 뷰포트를 켜버립니다. (화면 먹통 방지)
view_enabled = true;
view_visible[0] = true;

// 2. 따라다닐 대상
target = Obj_char;

// 3. 표시할 화면(카메라) 가로/세로 해상도 (훨씬 넓은 시야 / 줌아웃 효과)
camWidth = 1920;
camHeight = 1080;

// 4. 시작할 때 플레이어를 즉시 찾아서 그 위치로 카메라 중심을 둡니다.
if (instance_exists(target)) {
    x = target.x;
    y = target.y;
} else {
    x = room_width / 2;
    y = room_height / 2;
}

// (선택) 게임 창 크기는 모니터에 따라 잘리지 않게 1280x720 크기로 유지하되, 담기는 내용은 1920 사이즈로 압축하여 줌아웃 효과를 줍니다!
window_set_size(1280, 720);

// 그래픽 표면 리사이즈 (픽셀이 깨지지 않게 해상도 고정)
surface_resize(application_surface, camWidth, camHeight);
