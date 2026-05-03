/// @description 고장난 드론 상호작용 (User Event 0)

if (state == "rack" || state == "crashing") {
    if (global.day == 138) {
        global.ShowDialogue([
            { name: "", text: "드론 보관 랙이다.\n현재 드론은 들판에서 채집 임무 중이다." }
        ]);
    }
    exit;
}

if (!global.GetFlag("drone_scavenged")) {
    // 최초 상호작용 시 부품 획득
    global.SetFlag("drone_scavenged", true);
    global.ShowDialogue([
        { name: "", text: "한쪽 날개가 박살난 드론이다.\n다시는 날지 못할 것이다." },
        { name: "", text: "조심스럽게 메인 센서를 분해해\n내 장갑에 부착했다." },
        { name: "시스템", text: "[시스템] 장비 업그레이드 완료.\n별사리풀 채집 시 안정성(Perfect 구간)이 대폭 상승합니다." },
        { name: "", text: "이제 채집을 할 때마다,\n이 녀석의 센서음이 들릴 것이다." }
    ]);
} else {
    // 이미 부품을 뜯어낸 후
    global.ShowDialogue([
        { name: "", text: "센서마저 뜯어낸 드론의 잔해다.\n차갑게 식어 있다." }
    ]);
}
