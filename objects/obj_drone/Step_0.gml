/// @description 자율 채집 로직

// LP-138이 아니면 파괴 (고장났거나 스토리상 존재하지 않음)
if (global.day != 138) {
    instance_destroy();
    exit;
}

if (state == 0) {
    // 별사리풀 탐색
    if (instance_number(obj_star_grass) > 0) {
        target_grass = instance_nearest(x, y, obj_star_grass);
        if (target_grass != noone && !target_grass.minigame_active) {
            state = 1;
        }
    }
} else if (state == 1) {
    // 목표물로 이동
    if (instance_exists(target_grass)) {
        // 이동 중 플레이어가 수동 채집을 시작했다면 양보함
        if (target_grass.minigame_active) {
            state = 0;
            speed = 0;
            exit;
        }
        
        move_towards_point(target_grass.x, target_grass.y, 2.5);
        
        // 도착 판정
        if (point_distance(x, y, target_grass.x, target_grass.y) < 5) {
            speed = 0;
            state = 2;
            harvest_timer = 30; // 30프레임 동안 채집 진행
        }
    } else {
        // 목표가 사라짐
        state = 0;
        speed = 0;
    }
} else if (state == 2) {
    // 채집 중
    if (instance_exists(target_grass)) {
        // 채집 도중 플레이어가 수동 채집을 시작했다면 양보함
        if (target_grass.minigame_active) {
            state = 0;
            speed = 0;
            exit;
        }
        
        harvest_timer--;
        if (harvest_timer <= 0) {
            global.inventory_grass += 1;
            instance_destroy(target_grass);
            state = 0;
        }
    } else {
        state = 0;
    }
} else if (state == "return_home") {
    // 플레이어가 귀환 명령을 내린 상태
    if (global.dialogue_active) return; // 대화 중엔 대기
    
    if (instance_exists(Obj_door)) {
        var _door = instance_nearest(x, y, Obj_door);
        move_towards_point(_door.x, _door.y, 4);
        
        // 문에 도착하면 플레이어와 함께 룸 전환
        if (point_distance(x, y, _door.x, _door.y) < 15) {
            var _dest_x = variable_instance_exists(_door, "target_x") ? _door.target_x : -1;
            var _dest_y = variable_instance_exists(_door, "target_y") ? _door.target_y : -1;
            
            global.SetFlag("trigger_drone_return", true);
            global.TransitionToRoom(_door.target_room, _dest_x, _dest_y);
            instance_destroy(); // 들판 드론 삭제
        }
    }
}
