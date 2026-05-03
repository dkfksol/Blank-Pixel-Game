/// @description 들판 입장 시 별사리풀 랜덤 스폰

// 기존 별사리풀 전부 제거 (재입장 시 리셋)
with (obj_star_grass) {
    instance_destroy();
}

// 들판을 가득 채우도록 30~50개의 별사리풀 스폰
var spawn_count = irandom_range(30, 50);
var margin = 48; // 룸 가장자리 여유

for (var i = 0; i < spawn_count; i++) {
    var attempts = 0;
    var placed = false;
    
    while (!placed && attempts < 50) {
        var sx = irandom_range(margin, room_width - margin);
        var sy = irandom_range(margin, room_height - margin);
        
        // 벽과 겹치지 않는지 확인
        if (!place_meeting(sx, sy, Obj_wall)) {
            // 다른 별사리풀과 너무 가깝지 않은지 (자연스러운 군락을 위해 간격을 24로 줄임)
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

show_debug_message("별사리풀 " + string(instance_number(obj_star_grass)) + "개 스폰 완료");

// LP-138 전용: 자율 드론 생성 (아직 파괴되지 않음)
if (global.day == 138) {
    if (!instance_exists(obj_drone)) {
        // 플레이어 근처에 스폰
        var dx = instance_exists(Obj_char) ? Obj_char.x + 30 : room_width / 2;
        var dy = instance_exists(Obj_char) ? Obj_char.y + 30 : room_height / 2;
        instance_create_layer(dx, dy, "Instances", obj_drone);
        show_debug_message("드론 스폰 완료 (자율 채집 모드)");
    }
}
