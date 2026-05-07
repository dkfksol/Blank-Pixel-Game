/// @description 화면 전환 및 로드 복원 처리

// 로드 후 플레이어 위치 복원 (룸 이동 완료 후 실행)
if (global._load_pending && instance_exists(Obj_char)) {
    Obj_char.x = global._load_player_x;
    Obj_char.y = global._load_player_y;
    Obj_char.facing_dir = global._load_facing_dir;
    global._load_pending = false;
}

// 첫 날(LP-138) 스토리 이벤트 트리거 (NEW GAME 직후 들판에 도착했을 때)
if (global.GetFlag("trigger_first_story") && room == Room2 && !global.dialogue_active) {
    global.SetFlag("trigger_first_story", false);
    
    if (!instance_exists(Obj_char)) instance_create_layer(400, 300, "Instances", Obj_char);
    if (!instance_exists(Obj_camera)) instance_create_layer(400, 300, "Instances", Obj_camera);
    
    global.CheckStoryEvent();
}

// 드론과 함께 귀환한 직후 (Room1에 도착했을 때)
if (global.GetFlag("trigger_drone_return") && room == Room1 && !global.transition_active) {
    global.SetFlag("trigger_drone_return", false);
    
    if (instance_exists(obj_broken_drone)) {
        if (instance_exists(Obj_char)) {
            obj_broken_drone.x = Obj_char.x;
            obj_broken_drone.crash_y = Obj_char.y - 20;
        }
        obj_broken_drone.state = "fly_to_rack";
    }
}

// === Room1 진입 시 여우 스폰 (친밀도 90+ & LP-200+ & 한 번만) ===
if (room == Room1 && global.fox_trust >= 90 && global.day >= 200) {
    if (!instance_exists(obj_fox) && !global.fox_appeared) {
        global.fox_appeared = true;
        // 집 안 구석에 여우가 앉아있음
        if (layer_exists("Instances")) {
            var _f = instance_create_layer(room_width - 80, 60, "Instances", obj_fox);
            _f.state = "resting"; // 집에서는 안식 상태
        }
    }
}

// === cold_night 이벤트: 에너지 추가 감소 (Room1 진입 시 1회) ===
if (room == Room1 && global.daily_event == "cold_night" && !global.GetFlag("cold_applied")) {
    global.SetFlag("cold_applied", true);
    var cold_penalty = floor(global.energy * 0.15);
    global.energy -= cold_penalty;
    if (global.energy < 0) global.energy = 0;
}

// 화면 전환 처리
if (global.transition_active) {
    if (global.transition_phase == 1) {
        global.transition_alpha += global.transition_speed;
        if (global.transition_alpha >= 1) {
            global.transition_alpha = 1;
            if (global.transition_target != noone && room_exists(global.transition_target)) {
                room_goto(global.transition_target);
                if (global.transition_target_x >= 0 && instance_exists(Obj_char)) {
                    Obj_char.x = global.transition_target_x;
                    Obj_char.y = global.transition_target_y;
                }
            }
            global.transition_phase = 2;
        }
    }
    else if (global.transition_phase == 2) {
        global.transition_alpha -= global.transition_speed;
        if (global.transition_alpha <= 0) {
            global.transition_alpha = 0;
            global.transition_active = false;
            global.transition_phase = 0;
        }
    }
}
