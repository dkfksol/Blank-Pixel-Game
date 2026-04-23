/// @description 화면 전환 로직 업데이트

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
