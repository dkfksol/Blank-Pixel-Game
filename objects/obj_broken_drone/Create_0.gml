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
    
    // 첫 텍스트: LP-139 서두 전체 + 추락 직전 소리
    global.ShowDialogue([
        { name: "시스템", text: "LP-139. 건조-정제 진행." },
        { name: "", text: "드론이 풀을 옮기고, 건조기가 열을 뿜고,\n정제기가 얇은 보랏빛 알갱이를 토해 낸다." },
        { name: "", text: "축전조의 수치가 조금씩 올라간다.\n숫자가 올라가는 것만으로 마음이 놓이는 기분을,\n나는 오래전에 배웠다." },
        { name: "", text: "그때, 날카로운 금속성 울림이 뒤를 친다." }
    ]);
}
