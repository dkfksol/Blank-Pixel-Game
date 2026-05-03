/// @description 고장난 드론 초기화 (Room1에 배치)

// 스파크 타이머
spark_timer = random(60);

state = "broken";
if (global.day == 138) state = "rack";
if (global.day == 139 && !global.GetFlag("drone_scavenged")) state = "sparking";

crash_timer = 0;
crash_y = y - 40;
shake_x = 0;

// 추락 컷신 트리거 함수 (상호작용 시 호출됨)
TriggerCrash = function() {
    state = "crashing";
    crash_timer = 0;
    shake_x = 0;
}
