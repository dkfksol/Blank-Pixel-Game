/// @description 화면 전환 및 로드 복원 처리

// 로드 후 플레이어 위치 복원 (룸 이동 완료 후 실행)
if (global._load_pending && instance_exists(Obj_char)) {
    Obj_char.x = global._load_player_x;
    Obj_char.y = global._load_player_y;
    Obj_char.facing_dir = global._load_facing_dir;
    global._load_pending = false;
}

// 첫 날(LP-138) 스토리 이벤트 트리거 (NEW GAME 직후)
if (global.GetFlag("trigger_first_story") && room != Room_title && !global.dialogue_active) {
    global.SetFlag("trigger_first_story", false);
    global.CheckStoryEvent();
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
