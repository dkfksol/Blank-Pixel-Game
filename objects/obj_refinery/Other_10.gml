/// @description 정제기 상호작용 (User Event 0)

if (global.inventory_grass <= 0) {
    global.ShowDialogue([
        { name: "", text: "정제기가 낮게 웅웅거린다.\n넣을 별사리풀이 없다." },
        { name: "시스템", text: "별사리풀이 없습니다.\n들판에서 채집해 오세요." }
    ]);
    exit;
}

// 전부 변환
var grass_count = global.inventory_grass;
var power_gain = grass_count * conversion_rate;

// core_power 상한 체크 (100 최대)
var actual_gain = min(power_gain, 100 - global.core_power);
var grass_used = ceil(actual_gain / conversion_rate);
if (grass_used <= 0) grass_used = 1;
actual_gain = min(grass_used * conversion_rate, 100 - global.core_power);

global.inventory_grass -= grass_used;
global.core_power += actual_gain;
if (global.core_power > 100) global.core_power = 100;

global.SetFlag("daily_action_done", true); // 행동 완료

global.ShowDialogue([
    { name: "", text: "건조기가 열을 뿜고,\n정제기가 얇은 보랏빛 알갱이를 토해 낸다." },
    { name: "", text: "축전조의 수치가 조금씩 올라간다.\n숫자가 올라가는 것만으로 마음이 놓이는 기분을,\n나는 오래전에 배웠다." },
    { name: "시스템", text: "별사리풀 " + string(grass_used) + "개 정제 완료!\nCORE POWER +" + string(floor(actual_gain)) + " (현재: " + string(floor(global.core_power)) + "%)" }
]);
