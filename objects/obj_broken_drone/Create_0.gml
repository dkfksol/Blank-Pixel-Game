/// @description 고장난 드론 초기화 (Room1에 배치)

// 스파크 타이머
spark_timer = random(60);

// 상태 결정: 드론이 아직 살아있는 동안에는 빈 랙
state = "broken";
if (global.day <= 142 && !global.GetFlag("drone_destroyed")) {
    state = "rack"; // 드론이 들판에 있으므로 빈 랙
} else if (global.day == 143 && !global.GetFlag("drone_scavenged")) {
    state = "sparking"; // 사고 당일: 스파크 대기
}

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
    
    global.ShowDialogue([
        { name: "", text: "거치대로 날아간 드론의 상태가 이상하다.\n가까이 다가가 상태를 확인하려 손을 뻗은 순간..." },
        { name: "", text: "날카로운 금속성 울림이 방 안을 울렸다." }
    ]);
}
