/// @description UI 전용 초기화 (렌더링 설정만)

// 중복 생성 방지 (싱글톤 패턴)
if (instance_number(object_index) > 1) {
    instance_destroy();
    exit;
}

// UI 레이어 해상도 고정
display_set_gui_size(1280, 720);
