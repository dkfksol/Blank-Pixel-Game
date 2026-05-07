/// @description 여우 초기화

// 행동 상태
state = "wary";  // wary(경계), curious(호기심), near(가까이), resting(쉬는중)

// 움직임
move_timer = 0;
move_dir = 0;
wander_speed = 0.8;

// 시각 효과
tail_timer = 0;
blink_timer = irandom_range(60, 180);

// 경계 거리 (친밀도에 따라 줄어듦)
flee_dist = 120 - global.fox_trust; // 친밀도 높을수록 가까이 접근 허용
if (flee_dist < 30) flee_dist = 30;
