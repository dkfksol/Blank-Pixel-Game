/// @description 룸 입장 시 뷰포트 재활성화 (Room Start)
// Create 이벤트는 게임 시작할 때 한 번만 불립니다.
// 하지만 룸이 바뀔 때마다 그 룸의 카메라 세팅을 켜줘야 카메라가 멈추지 않습니다!

view_enabled = true;
view_visible[0] = true;

// 룸 에디터 설정 무시하고 엄청 넓은 시야(줌아웃) 강제 지정!
camera_set_view_size(view_camera[0], camWidth, camHeight);
