/// @description 고장난 드론 상호작용 (User Event 0)

if (state == "rack" || state == "crashing") {
    if (global.day == 138) {
        global.ShowDialogue([
            { name: "", text: "드론 보관 랙이다.\n현재 드론은 들판에서 채집 임무 중이다." }
        ]);
    }
    exit;
}

global.ShowDialogue([
    { name: "", text: "바닥에 처박힌 드론의 잔해다.\n쓸 만한 부품은 이미 수거했다." }
]);
