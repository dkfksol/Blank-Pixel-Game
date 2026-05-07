/// @description 들판 입장 시 별사리풀 랜덤 스폰

// 기존 별사리풀 전부 제거 (재입장 시 리셋)
with (obj_star_grass) {
    instance_destroy();
}

// 날씨에 따른 스폰량 변동
var base_count = irandom_range(30, 50);
var spawn_count = floor(base_count * global.weather_spawn_mult);
var margin = 48; // 룸 가장자리 여유

for (var i = 0; i < spawn_count; i++) {
    var attempts = 0;
    var placed = false;
    
    while (!placed && attempts < 50) {
        var sx = irandom_range(margin, room_width - margin);
        var sy = irandom_range(margin, room_height - margin);
        
        // 벽과 겹치지 않는지 확인
        if (!place_meeting(sx, sy, Obj_wall)) {
            var too_close = false;
            with (obj_star_grass) {
                if (point_distance(x, y, sx, sy) < 24) {
                    too_close = true;
                    break;
                }
            }
            
            if (!too_close) {
                instance_create_layer(sx, sy, "Instances", obj_star_grass);
                placed = true;
            }
        }
        attempts++;
    }
}

show_debug_message("별사리풀 " + string(instance_number(obj_star_grass)) + "개 스폰 완료 (날씨: " + global.weather + ")");

// 드론 스폰 (LP-138~142, 아직 파괴되지 않은 경우)
if (global.day >= 138 && global.day <= 142 && !global.GetFlag("drone_destroyed")) {
    if (!instance_exists(obj_drone)) {
        var dx = instance_exists(Obj_char) ? Obj_char.x + 30 : room_width / 2;
        var dy = instance_exists(Obj_char) ? Obj_char.y + 30 : room_height / 2;
        instance_create_layer(dx, dy, "Instances", obj_drone);
    }
}

// 여우 발자국 스폰 (LP-148 이후, 이벤트로 결정)
if (global.daily_event == "footprints" && global.day >= 148) {
    // 들판 구석에 3~5개의 작은 발자국을 남김
    var fp_count = irandom_range(3, 5);
    var fp_x = irandom_range(100, room_width - 100);
    var fp_y = irandom_range(100, room_height - 100);
    // 발자국은 별도 오브젝트 대신 플래그로 처리 (Draw에서 렌더링)
    global.SetFlag("footprint_x", fp_x);
    global.SetFlag("footprint_y", fp_y);
    global.SetFlag("footprint_count", fp_count);
}

// 여우 실체 스폰 (친밀도 30 이상이면 들판에 등장)
if (global.fox_trust >= 30 && global.day >= 155) {
    if (!instance_exists(obj_fox)) {
        var fx = irandom_range(200, room_width - 200);
        var fy = irandom_range(200, room_height - 200);
        if (layer_exists("Instances")) {
            instance_create_layer(fx, fy, "Instances", obj_fox);
        }
    }
}

// === 날씨 안내 대사 (하루에 한 번) ===
if (!global.weather_announced) {
    global.weather_announced = true;
    
    switch (global.weather) {
        case "sandstorm":
            global.ShowDialogue([
                { name: "", text: "모래바람이 분다.\n시야가 좁아지고, 손끝이 거칠어진다." },
                { name: "시스템", text: "모래폭풍: 채집 난이도 증가, 별사리풀 감소" }
            ]);
            break;
        case "bountiful":
            global.ShowDialogue([
                { name: "", text: "오늘따라 들판이 눈부시다.\n별사리풀의 결정이 평소보다 크게 맺혔다." },
                { name: "시스템", text: "풍작일: 별사리풀 증가, 채집 약간 수월" }
            ]);
            break;
        case "calm_wind":
            global.ShowDialogue([
                { name: "", text: "바람도 아닌 것이, 바람 같은 것.\n공기가 유난히 고요하다." }
            ]);
            break;
        case "red_sky":
            global.ShowDialogue([
                { name: "", text: "하늘이 붉다.\n저녁도 아닌데 빛이 붉어지고,\n유리 너머 공기가 흐르는 것처럼 보인다." },
                { name: "", text: "돔에서 무언가가 바뀌고 있다." }
            ]);
            break;
    }
    
    // 일일 이벤트 대사
    if (global.daily_event == "comm_static") {
        global.ShowDialogue([
            { name: "시스템", text: "[수신] 잡음 혼재 신호 감지\n[상태] 복호 불가 — 단편 수신" },
            { name: "", text: "통신기에서 의미를 잃은 소리가 흘러나왔다.\n누군가의 숨소리일까. 바람소리일까." }
        ]);
    } else if (global.daily_event == "cold_night") {
        global.ShowDialogue([
            { name: "", text: "어젯밤은 유난히 추웠다.\n코어의 열이 바닥을 덜 데웠고,\n나는 장갑을 끼고 잤다." },
            { name: "시스템", text: "한파 영향: 에너지가 평소보다 적게 회복되었습니다." }
        ]);
    } else if (global.daily_event == "footprints" && global.day >= 148) {
        global.ShowDialogue([
            { name: "", text: "들판 한쪽에 작은 발자국이 나 있다.\n이 행성에 나 말고 걸어 다니는 것이 있다는 뜻이다." },
            { name: "", text: "발자국은 얕고, 빠르다.\n경계심이 느껴진다. 나와 비슷한." }
        ]);
    }
}
