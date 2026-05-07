/// @description 정제기 상호작용 (User Event 0)

// === 정제기 고장 시 수리 분기 ===
if (global.refinery_broken) {
    if (global.energy < repair_cost) {
        global.ShowDialogue([
            { name: "", text: "정제기의 연결부가 느슨하다.\n수리하려면 힘이 필요하지만, 지금은 지쳐 있다." },
            { name: "시스템", text: "에너지가 부족합니다. (필요: " + string(repair_cost) + ")" }
        ]);
        exit;
    }
    
    global.ShowDialogue([
        { name: "", text: "정제기의 연결부를 분해하고,\n열 접합면의 찌꺼기를 긁어낸다." },
        { name: "", text: "손끝이 데지만, 정제기가 없으면\n별사리풀은 그저 보라색 먼지일 뿐이다." },
        { name: "시스템", text: "정제기 수리 완료!\n에너지 -" + string(repair_cost) }
    ]);
    
    global.energy -= repair_cost;
    global.refinery_durability = 80; // 완벽하진 않지만 사용 가능
    global.refinery_broken = false;
    exit;
}

// === 정상 정제 ===
if (global.inventory_grass <= 0) {
    global.ShowDialogue([
        { name: "", text: "정제기가 낮게 웅웅거린다.\n넣을 별사리풀이 없다." },
        { name: "시스템", text: "별사리풀이 없습니다.\n들판에서 채집해 오세요." }
    ]);
    exit;
}

// 내구도에 따른 변환 효율 변동
var effective_rate = conversion_rate;
if (global.refinery_durability < 50) {
    effective_rate = floor(conversion_rate * 0.7); // 낡은 정제기: 70% 효율
}

// 전부 변환
var grass_count = global.inventory_grass;
var power_gain = grass_count * effective_rate;

// core_power 상한 체크 (100 최대)
var actual_gain = min(power_gain, 100 - global.core_power);
var grass_used = ceil(actual_gain / effective_rate);
if (grass_used <= 0) grass_used = 1;
actual_gain = min(grass_used * effective_rate, 100 - global.core_power);

global.inventory_grass -= grass_used;
global.core_power += actual_gain;
if (global.core_power > 100) global.core_power = 100;

// 정제기 내구도 소모 (사용 시)
global.refinery_durability -= irandom_range(2, 5);
if (global.refinery_durability <= 0) {
    global.refinery_durability = 0;
    // 다음 사용 시 고장으로 전환 (지금은 아직 작동)
}

global.SetFlag("daily_action_done", true);

// 내구도에 따른 대사 변화
if (global.refinery_durability < 30) {
    global.ShowDialogue([
        { name: "", text: "정제기에서 이상한 소리가 난다.\n열 접합면이 마모되고 있다." },
        { name: "", text: "언제 멈춰도 이상하지 않을 것이다." },
        { name: "시스템", text: "별사리풀 " + string(grass_used) + "개 정제 완료!\nCORE POWER +" + string(floor(actual_gain)) + " (현재: " + string(floor(global.core_power)) + "%)\n⚠ 정제기 내구도 낮음!" }
    ]);
} else {
    global.ShowDialogue([
        { name: "", text: "건조기가 열을 뿜고,\n정제기가 얇은 보랏빛 알갱이를 토해 낸다." },
        { name: "", text: "축전조의 수치가 조금씩 올라간다.\n숫자가 올라가는 것만으로 마음이 놓이는 기분을,\n나는 오래전에 배웠다." },
        { name: "시스템", text: "별사리풀 " + string(grass_used) + "개 정제 완료!\nCORE POWER +" + string(floor(actual_gain)) + " (현재: " + string(floor(global.core_power)) + "%)" }
    ]);
}
