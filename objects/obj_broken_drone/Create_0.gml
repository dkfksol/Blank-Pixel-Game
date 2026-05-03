/// @description 고장난 드론 초기화 (Room1에 배치)

// 스파크 타이머
spark_timer = random(60);

state = "broken";
if (global.day == 138) state = "rack";
if (global.day == 139 && !global.GetFlag("drone_scavenged")) state = "sparking";

crash_timer = 0;
crash_y = y - 40;
shake_x = 0;

rack_x = x; // 거치대의 본래 X좌표 보존
rack_y = y; // 거치대의 본래 Y좌표 보존

// 추락 컷신 트리거 함수 (상호작용 시 호출됨)
TriggerCrash = function() {
    state = "crashing";
    crash_timer = 0;
    shake_x = 0;
    
    // 만약 139일차 아침이라면 LP-139 텍스트 출력
    if (global.day == 139) {
        global.ShowDialogue([
            { name: "시스템", text: "LP-139. 건조-정제 진행." },
            { name: "", text: "드론이 풀을 옮기고, 건조기가 열을 뿜고,\n정제기가 얇은 보랏빛 알갱이를 토해 낸다." },
            { name: "", text: "축전조의 수치가 조금씩 올라간다.\n숫자가 올라가는 것만으로 마음이 놓이는 기분을,\n나는 오래전에 배웠다." },
            { name: "", text: "그때, 날카로운 금속성 울림이 방 한구석에서 들렸다." }
        ]);
    } else {
        // 138일차 귀환 직후에 상호작용해서 떨어지는 경우
        global.ShowDialogue([
            { name: "", text: "거치대로 날아간 드론의 상태가 이상하다.\n가까이 다가가 상태를 확인하려 손을 뻗은 순간..." },
            { name: "", text: "날카로운 금속성 울림이 방 안을 울렸다." }
        ]);
    }
}
