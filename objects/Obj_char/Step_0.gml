// 1. 이벤트 우선순위: 대화창, 인벤토리, 화면 전환 중 플레이어 행동 정지
if ((variable_global_exists("dialogue_active") && global.dialogue_active == true) || 
    (variable_global_exists("inventory_active") && global.inventory_active == true) ||
    (variable_global_exists("transition_active") && global.transition_active == true)) {
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
    mag = 1; // 대각선 이동 시 속도 정규화
    facing_dir = dir;
    
    idle_timer = 0;
    image_speed = 1;
    
    // 시선 방향에 따른 스프라이트 업데이트
    var new_sprite = sprite_index;
    if (facing_dir >= 45 && facing_dir < 135) {
        new_sprite = asset_get_index("spr_char_up");
    } else if (facing_dir >= 135 && facing_dir < 225) {
        new_sprite = asset_get_index("spr_char_left");
    } else if (facing_dir >= 225 && facing_dir < 315) {
        new_sprite = asset_get_index("spr_char_down");
    } else {
        new_sprite = asset_get_index("spr_char_right");
    }
    
    if (sprite_index != new_sprite) {
        sprite_index = new_sprite;
    }
} else {
    // 이동 정지 시 대기 상태 전환
    idle_timer += 1;
    if (idle_timer >= 6) {
        image_speed = 0;
        image_index = 0;
    }
}

// 4. 물리 충돌 및 이동 적용
var hspd = lengthdir_x(walk_spd * mag, dir);
var vspd = lengthdir_y(walk_spd * mag, dir);

// X축 충돌 처리
if (place_meeting(x + hspd, y, Obj_wall)) {
    while (!place_meeting(x + sign(hspd), y, Obj_wall)) {
        x += sign(hspd);
    }
    hspd = 0;
}
x += hspd;

// Y축 충돌 처리
if (place_meeting(x, y + vspd, Obj_wall)) {
    while (!place_meeting(x, y + sign(vspd), Obj_wall)) {
        y += sign(vspd);
    }
    vspd = 0;
}
y += vspd;

// 5. 상호작용 로직 (Z키)
if (keyboard_check_pressed(ord("Z"))) {
    var center_x = (bbox_left + bbox_right) / 2;
    var center_y = (bbox_top + bbox_bottom) / 2;
    
    // 플레이어의 시선이 머무는 도착점 계산 (전방 32픽셀)
    var sight_dist = 32; 
    var target_x = center_x + lengthdir_x(sight_dist, facing_dir);
    var target_y = center_y + lengthdir_y(sight_dist, facing_dir);
    
    var target_obj = noone;
    var min_dist = 9999;
    
    // 시선 도착점에 가장 가까운 상호작용 객체 탐색
    with (Obj_interactable) {
        var obj_cx = (sprite_index != -1) ? (bbox_left + bbox_right) / 2 : x;
        var obj_cy = (sprite_index != -1) ? (bbox_top + bbox_bottom) / 2 : y;
        
        var dist = point_distance(target_x, target_y, obj_cx, obj_cy);
        
        // 반경 32픽셀 이내의 객체 중 가장 가까운 객체를 선택
        if (dist <= 32 && dist < min_dist) {
            min_dist = dist;
            target_obj = id;
        }
    }
    
    // 대상 객체가 존재하면 상호작용 이벤트(User Event 0) 호출
    if (target_obj != noone) {
        with (target_obj) {
            event_user(0);
        }
    }
}
