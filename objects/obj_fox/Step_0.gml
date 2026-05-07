/// @description 여우 행동 로직

if (global.dialogue_active) exit;

var player_dist = 9999;
if (instance_exists(Obj_char)) {
    player_dist = point_distance(x, y, Obj_char.x, Obj_char.y);
}

// 상태 전이
if (state == "wary") {
    // 플레이어가 너무 가까우면 도망
    if (player_dist < flee_dist) {
        // 플레이어 반대 방향으로 도망
        var dir_away = point_direction(Obj_char.x, Obj_char.y, x, y);
        x += lengthdir_x(3, dir_away);
        y += lengthdir_y(3, dir_away);
        
        // 화면 밖으로 나가면 사라짐
        if (x < -20 || x > room_width + 20 || y < -20 || y > room_height + 20) {
            instance_destroy();
            exit;
        }
    } else {
        // 무작위 배회
        move_timer--;
        if (move_timer <= 0) {
            move_dir = irandom(359);
            move_timer = irandom_range(30, 90);
        }
        x += lengthdir_x(wander_speed * 0.3, move_dir);
        y += lengthdir_y(wander_speed * 0.3, move_dir);
    }
    
    // 친밀도 50 이상이면 호기심 상태로 전환
    if (global.fox_trust >= 50) state = "curious";
    
} else if (state == "curious") {
    // 플레이어를 멀리서 바라봄, 가까이 가면 약간만 물러남
    if (player_dist < flee_dist * 0.5) {
        var dir_away = point_direction(Obj_char.x, Obj_char.y, x, y);
        x += lengthdir_x(1.5, dir_away);
        y += lengthdir_y(1.5, dir_away);
    } else if (player_dist > 200) {
        // 너무 멀면 천천히 다가옴
        var dir_to = point_direction(x, y, Obj_char.x, Obj_char.y);
        x += lengthdir_x(0.5, dir_to);
        y += lengthdir_y(0.5, dir_to);
    }
    
    // 친밀도 70 이상이면 가까이 상태
    if (global.fox_trust >= 70) state = "near";
    
} else if (state == "near") {
    // 플레이어 근처에 앉아있음
    if (player_dist > 80) {
        var dir_to = point_direction(x, y, Obj_char.x, Obj_char.y);
        x += lengthdir_x(0.8, dir_to);
        y += lengthdir_y(0.8, dir_to);
    }
    // 거의 도망가지 않음
    
} else if (state == "resting") {
    // 가만히 앉아있음 (집 안에서)
}

// 영역 제한
x = clamp(x, 20, room_width - 20);
y = clamp(y, 20, room_height - 20);

// 깜빡임 타이머
blink_timer--;
if (blink_timer <= 0) blink_timer = irandom_range(60, 180);

tail_timer += 3;
