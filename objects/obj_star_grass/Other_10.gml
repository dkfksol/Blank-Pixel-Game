/// @description 별사리풀 채집 상호작용 (User Event 0)

if (!harvestable) {
    global.ShowDialogue([{ name: "", text: "이미 캔 풀이다." }]);
    exit;
}

// 에너지 부족 체크
if (global.energy < harvest_cost) {
    global.ShowDialogue([
        { name: "", text: "숨이 차다. 더 이상은 무리다." },
        { name: "시스템", text: "에너지가 부족합니다. (" + string(global.energy) + "/" + string(harvest_cost) + ")" }
    ]);
    exit;
}

// 채집 성공
global.energy -= harvest_cost;
global.inventory_grass += 1;
harvestable = false;

global.ShowDialogue([
    { name: "", text: "별사리풀을 캤다.\n손바닥에 닿은 결정은 차갑고,\n곧 미세한 분말로 부서진다." },
    { name: "시스템", text: "별사리풀 +1 (보유: " + string(global.inventory_grass) + ")\n에너지 -" + string(harvest_cost) }
]);

// 채집 후 인스턴스 파괴 (시각적으로 사라짐)
instance_destroy();
