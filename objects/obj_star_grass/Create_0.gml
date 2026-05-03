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
cursor_pos = 0;
cursor_spd = 1.5; // 커서 이동 속도 (조금 더 느리게 조절)

