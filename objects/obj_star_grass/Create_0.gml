/// @description 별사리풀 초기화

// 채집 시 에너지 소모량 (LP-138에는 면제됨)
harvest_cost = 10;

// 보라색 글로우 효과용 타이머
glow_timer = random(360);
glow_speed = 2;

// 채집 가능 상태
harvestable = true;

// --- 타이밍 미니게임 변수 ---
minigame_active = false;
minigame_delay = 0;
minigame_result_timer = 0; // 결과 확인(깜빡임) 대기 타이머
minigame_result_dist = 0;  // 결과 판정용 거리 저장
cursor_pos = 0;
cursor_spd = 2.8; // 커서 이동 속도 조정 (3.8에서 2.8로 살짝 감속)

