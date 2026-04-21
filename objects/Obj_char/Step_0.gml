// ★ 맨위의 최우선 규칙: 전세계 대화창이 띄워져 있거나 가방창이 열려있다면? 주인공은 무조건 행동 정지! ★
if ((variable_global_exists("dialogue_active") && global.dialogue_active == true) || 
    (variable_global_exists("inventory_active") && global.inventory_active == true)) {
    image_speed = 0; // 달리기 일시정지
    image_index = 0; // 쩍벌 멈춤 방지를 위해 차렷 자세로 돌림
    exit; // => 이 즉시 이 밑에 있는 조작 코드를 전부 다 무시하고 강제로 끝내버립니다!! (Cutscene 효과)
}

// 1. 키보드 입력 받기 (WASD, 방향키 동시 지원)
var key_right = keyboard_check(vk_right) || keyboard_check(ord("D"));
var key_left = keyboard_check(vk_left) || keyboard_check(ord("A"));
var key_down = keyboard_check(vk_down) || keyboard_check(ord("S"));
var key_up = keyboard_check(vk_up) || keyboard_check(ord("W"));

// 2. 가로/세로 이동 방향 (벡터) 계산
var h_move = key_right - key_left; 
var v_move = key_down - key_up;    

var dir = point_direction(0, 0, h_move, v_move);
var mag = point_distance(0, 0, h_move, v_move);

// 이동 중일 때 속도 제한 및 시선 방향 갱신 / ★ 걷기 애니메이션 실행
if (mag > 0) {
    mag = 1;
    facing_dir = dir; // 가장 최근에 움직인 방향을 기억
    
    idle_timer = 0; // 움직이기 시작하면 멈춤 타이머 리셋
    image_speed = 1; // 애니메이션 발 구르기 속도 정상 (1배속)
    
    // 각도에 맞게 스프라이트(그림) 실시간 교체
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
    
    // 같은 방향으로 걷고 있는데 스프라이트를 또 교체해서 버벅거리는 현상 방지
    if (sprite_index != new_sprite) {
        sprite_index = new_sprite;
    }
} else {
    // 방향키를 떼었어도 바로 멈추지 않고 타이머를 잽니다.
    idle_timer += 1;
    
    // 만약 손을 떼고 0.1초(6프레임)가 지났다면: 이건 연타가 아니라 진짜로 멈춘 것!
    if (idle_timer >= 6) {
        image_speed = 0; // 달리기 정지
        image_index = 0; // 진짜 차렷 자세(0번)로 복귀
    }
}

var hspd = lengthdir_x(walk_spd * mag, dir);
var vspd = lengthdir_y(walk_spd * mag, dir);

// 3. 물리 충돌 처리 및 최종 이동

// 가로 이동 및 벽 충돌 (Obj_wall)
if (place_meeting(x + hspd, y, Obj_wall)) {
    // 벽에 부딪히기 직전까지 1픽셀씩 조심스럽게 전진합니다. (안 하면 벽에 끼임)
    while (!place_meeting(x + sign(hspd), y, Obj_wall)) {
        x += sign(hspd);
    }
    hspd = 0; // 벽에 꽉 닿았으므로 이동 정지
}
x += hspd;

// 세로 이동 및 벽 충돌 (Obj_wall)
if (place_meeting(x, y + vspd, Obj_wall)) {
    // 벽에 부딪히기 직전까지 1픽셀씩 조심스럽게 전진
    while (!place_meeting(x, y + sign(vspd), Obj_wall)) {
        y += sign(vspd);
    }
    vspd = 0; // 빙판처럼 미끄러지지 않고 딱 멈춤
}
y += vspd;

// 4. 상호작용 (Z키)
if (keyboard_check_pressed(ord("Z"))) {
    // 플레이어가 바라보는 앞쪽(facing_dir)으로 22픽셀 나아간 위치 계산
    var check_dist = 22; 
    var check_x = x + lengthdir_x(check_dist, facing_dir);
    var check_y = y + lengthdir_y(check_dist, facing_dir);
    
    // 이제 특정 오브젝트가 아니라 넓은 의미의 "상호작용 물체(obj_interactable)"를 모두 탐색합니다.
    var target_obj = noone;
    
    // 룸 안의 모든 Obj_interactable (부모 및 그것을 상속받은 자식들) 순회
    with (Obj_interactable) {
        if (point_distance(x, y, check_x, check_y) <= 32) {
            target_obj = id; // 찾았다!
            break;
        }
    }
    
    // 만약 허공이 아니라 상호작용 객체가 잡혔다면
    if (target_obj != noone) {
        // 내가 직접 변수를 고치는 대신, "너의 고유 상호작용 이벤트를 실행해!" 라고 명령합니다.
        with (target_obj) {
            event_user(0); // 대상의 User Event 0번 실행
        }
    }
}
