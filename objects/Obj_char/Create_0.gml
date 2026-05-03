/// @description 플레이어 초기 설정

// 중복 생성 방지 (persistent 특성상 룸 이동 시 이미 존재하면 룸에 배치된 것은 삭제)
if (instance_number(object_index) > 1) {
    instance_destroy();
    exit;
}

persistent = true; // ★핵심: 룸이 바뀌어도 이 오브젝트(플레이어)를 삭제하지 않고 다음 방으로 데려갑니다!

walk_spd = 3.5; // 이동 속도
facing_dir = 270; // 시선 방향 (기본: 270도/아래쪽)

// 게임 시작 직후 서있을 때 보여질 기본 이미지를 "아래를 보는 캐릭터"로 확정합니다.
// (나중에 특정 방에서 오른쪽을 보고 시작하게 하려면 여기서 spr_char_right로 바꾸시면 됩니다!)
sprite_index = asset_get_index("spr_char_down"); 

idle_timer = 0; // 연타 방지용 멈춤 타이머
