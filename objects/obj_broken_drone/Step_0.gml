/// @description 추락 연출 업데이트

if (state == "crashing") {
    // 텍스트(대화)가 열려있으면 연출 일시정지
    if (global.dialogue_active) return;
    
    crash_timer++;
    
    if (crash_timer < 30) {
        // 1단계: 랙에서 부들부들 떨림 (스파크)
        shake_x = random_range(-3, 3);
    } else if (crash_timer == 30) {
        // 떨어지기 직전
        shake_x = 0;
    } else if (crash_timer < 45) {
        // 2단계: 아래로 무겁게 추락
        crash_y += 4;
        if (crash_y > y + 5) crash_y = y + 5;
    } else if (crash_timer == 50) {
        // 3단계: 바닥에 충돌 후 진짜 상실감 대사 출력
        global.ShowDialogue([
            { name: "", text: "드론의 한쪽 날개가 보관 랙에 걸렸다.\n균형을 잃은 기체가 공중에서 한 번 흔들리더니\n그대로 바닥으로 곤두박질쳤다." },
            { name: "", text: "나는 한동안 움직이지 못했다.\n내가 잃은 것은 단순한 기계가 아니었다." },
            { name: "", text: "이 행성에서 '편함'이라 부를 수 있는\n마지막 한 조각이었다." },
            { name: "", text: "\"괜찮아… 괜찮아. 아직.\"" }
        ]);
        state = "broken"; // 완전히 부서진 상태로 진입
    }
}
