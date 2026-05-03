/// @description 고장난 드론 초기화 (Room1에 배치)

// 스파크 타이머
spark_timer = random(60);

state = "broken";
if (global.day == 138) state = "rack";

crash_timer = 0;
crash_y = y;
shake_x = 0;

// 추락 컷신 트리거 함수
TriggerCrash = function() {
    state = "crashing";
    crash_timer = 0;
    crash_y = y - 40; // 랙 위의 높이
    shake_x = 0;
    
    // 첫 텍스트: 이상 현상(소리)만 먼저 출력
    global.ShowDialogue([
        { name: "시스템", text: "LP-139." },
        { name: "", text: "그때, 날카로운 금속성 울림이 뒤를 친다." }
    ]);
}
