/// @description 플레이어 이동 및 상호작용

// 1. UI/전환 중 행동 정지 (variable_global_exists 제거 — 항상 존재하는 변수)
if (global.dialogue_active || global.inventory_active || 
    global.sys_active || global.transition_active) {
    image_speed = 0;
    image_index = 0;
    exit;
}

// 2. 키보드 입력 처리
var key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var key_left  = keyboard_check(vk_left)  || keyboard_check(ord("A"));
var key_down  = keyboard_check(vk_down)  || keyboard_check(ord("S"));
var key_up    = keyboard_check(vk_up)    || keyboard_check(ord("W"));

var h_move = key_right - key_left; 
var v_move = key_down - key_up;    

var dir = point_direction(0, 0, h_move, v_move);
var mag = point_distance(0, 0, h_move, v_move);

// 3. 이동 및 애니메이션 처리
if (mag > 0) {
    mag = 1;
    facing_dir = dir;
    
    idle_timer = 0;
    image_speed = 1;
    
    // 시선 방향에 따른 스프라이트 (캐싱 — Create에서 1회 조회)
    var new_sprite = sprite_index;
    if (facing_dir >= 45 && facing_dir < 135) {
        new_sprite = _spr_up;
    } else if (facing_dir >= 135 && facing_dir < 225) {
        new_sprite = _spr_left;
    } else if (facing_dir >= 225 && facing_dir < 315) {
        new_sprite = _spr_down;
    } else {
        new_sprite = _spr_right;
    }
    
    if (sprite_index != new_sprite) {
        sprite_index = new_sprite;
    }
} else {
    idle_timer += 1;
    if (idle_timer >= 6) {
        image_speed = 0;
        image_index = 0;
    }
}

// 4. 물리 충돌 및 이동 적용
var hspd = lengthdir_x(walk_spd * mag, dir);
var vspd = lengthdir_y(walk_spd * mag, dir);

if (place_meeting(x + hspd, y, Obj_wall)) {
    while (!place_meeting(x + sign(hspd), y, Obj_wall)) {
        x += sign(hspd);
    }
    hspd = 0;
}
x += hspd;

if (place_meeting(x, y + vspd, Obj_wall)) {
    while (!place_meeting(x, y + sign(vspd), Obj_wall)) {
        y += sign(vspd);
    }
    vspd = 0;
}
y += vspd;

// 5. 상호작용 로직 (Z키) — pressed 일때만 탐색
if (keyboard_check_pressed(ord("Z"))) {
    var target_obj = noone;
    var min_dist = 60; // 최대 탐색 반경을 초기값으로 설정
    
    with (Obj_interactable) {
        var dist = point_distance(other.x, other.y, x, y);
        
        // 반경 체크를 먼저 수행 (비용 낮음) → 통과 시에만 각도 계산
        if (dist <= min_dist) {
            var dir_to_obj = point_direction(other.x, other.y, x, y);
            var angle_diff = abs(angle_difference(other.facing_dir, dir_to_obj));
            
            if (angle_diff <= 90) {
                min_dist = dist;
                target_obj = id;
            }
        }
    }
    
    if (target_obj != noone) {
        with (target_obj) {
            event_user(0);
        }
    }
}
