/// @description 추락 연출 업데이트

if (state == "sparking") {
    // 상호작용 대기 상태 (랙 위에서 스파크를 튀기며 부들부들)
    shake_x = random_range(-1, 1);
} else if (state == "crashing") {
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
        // 3단계: 바닥에 충돌 후 진짜 상실감 대사 출력 (스토리 통합)
        global.ShowDialogue([
            { name: "", text: "드론의 한쪽 날개가 보관 랙에 걸렸다.\n균형을 잃은 기체가 공중에서 한 번 흔들리더니\n그대로 바닥으로 곤두박질쳤다." },
            { name: "", text: "나는 한동안 움직이지 못했다.\n내가 잃은 것은 단순한 기계가 아니었다." },
            { name: "", text: "이 행성에서 '편함'이라 부를 수 있는\n마지막 한 조각이었다." },
            { name: "", text: "\"괜찮아… 괜찮아. 아직.\"" },
            { name: "", text: "나는 파편을 주워 들고, 연결부를 살핀다.\n살릴 수 있을까. 살릴 수 없다면, 얼마나 더 느려질까." },
            { name: "", text: "숫자들이 머릿속에서 먼저 계산된다.\n그리고 그 숫자 뒤에서, 늦게 도착한 감정이 숨을 내쉰다." },
            { name: "", text: "불안. 짜증. 그리고 아주 오래된, 버려졌다는 감각." },
            { name: "", text: "드론은 완전히 죽진 않았다.\n다만 이제는 한 번 일을 시키면 두 번 확인해야 한다." },
            { name: "", text: "공정은 병목이 생기고, 하루는 더 길어진다.\n내 하루는 원래도 길었다. 길이가 늘어나는 건,\n그저 견딜 일이 늘어난다는 뜻이었다." },
            { name: "시스템", text: "드론 부품을 획득하여 채집 도구를 강화했습니다.\n수동 채집(미니게임) 시 [Perfect] 판정 구간이 대폭 넓어집니다!" }
        ]);
        
        // 컷신 종료와 함께 부품 스캐빈징 자동 적용
        global.SetFlag("drone_scavenged", true);
        global.inventory_grass += 2;
        
        state = "broken"; // 완전히 부서진 상태로 진입
    }
}
