/// @description 화면 최상단 강제 UI 렌더링 (Draw GUI)
// 이 이벤트 안에 쓴 그림은 카메라가 아무리 흔들려도 모니터 유리에 붙은 것처럼 고정됩니다!

// ========================== 1. 글로벌 상태창 (체력바 등상시 출력) ==========================
draw_set_halign(fa_left);
draw_set_valign(fa_top);

var fnt_id = asset_get_index("fnt_main");
if (fnt_id != -1) draw_set_font(fnt_id);

draw_set_color(c_red);
draw_text(30, 30, "HP : " + string(global.hp) + " / " + string(global.max_hp));
draw_set_color(c_white);

if (global.dialogue_active == true) {
    // 1. 대강의 박스 사이즈와 (X,Y) 좌표를 정합니다.
    var box_width = 1000;
    var box_height = 150;
    var box_x = (1280 - box_width) / 2; // 가로 정중앙
    var box_y = 720 - box_height - 20;  // 맨 바닥에서 20픽셀 수면 위로 띄움
    
    // 2. 80% 반투명한 검은색 넓은 자막 바(Bar) 그리기
    draw_set_color(c_black);
    draw_set_alpha(0.8);
    draw_roundrect(box_x, box_y, box_x + box_width, box_y + box_height, false);
    
    // 3. 안에 들어갈 흰색 텍스트 세팅
    draw_set_color(c_white);
    draw_set_alpha(1.0);
    
    // 회원님이 전에 만들어두셨던 멋진 한글 폰트 적용
    var fnt_id = asset_get_index("fnt_main");
    if (fnt_id != -1) draw_set_font(fnt_id);
    
    // 글씨를 왼쪽 상단 정렬로 예쁘게 맞춥니다.
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    
    // 4. 모서리에서 30픽셀 안쪽부터 여유롭게 대사(글) 적기 시작!
    draw_text(box_x + 30, box_y + 30, global.dialogue_text);
    
    // 5. 물감을 다 썼으면 설정들을 원상복구 시켜둡니다. (오류 방지)
    draw_set_color(c_white);
}

// ========================== 인벤토리 화면 그리기 ==========================
if (global.inventory_active == true) {
    var inv_w = 400; // 가방 크기
    var inv_h = 500;
    var inv_x = (1280 - inv_w) / 2; // 정중앙
    var inv_y = (720 - inv_h) / 2;
    
    // 반투명한 거대 파란 박스(가방 레이아웃) 그리기
    draw_set_color(c_navy);
    draw_set_alpha(0.9);
    draw_roundrect(inv_x, inv_y, inv_x + inv_w, inv_y + inv_h, false);
    
    draw_set_color(c_white);
    draw_set_alpha(1.0);
    draw_set_halign(fa_center);
    draw_text(1280 / 2, inv_y + 20, "[ 아 이 템 가 방 ]");
    
    draw_set_halign(fa_left); // 왼쪽 정렬 원상복구
    
    // 배열(배낭) 속에 든 아이템 개수만큼 반복하며 그려주기!
    var item_count = array_length(global.inventory);
    
    if (item_count == 0) {
        draw_set_color(c_gray);
        draw_text(inv_x + 30, inv_y + 80, "가방이 텅 비었다...");
        draw_set_color(c_white);
    } else {
        // 아이템 개수만큼 한 줄씩 밑으로 내려가며 그립니다.
        for (var i = 0; i < item_count; i++) {
            var my_item = global.inventory[i]; // 단순 문자열이 아닌 Struct 덩어리가 튀어나옵니다!
            var draw_pos_y = inv_y + 80 + (i * 35); // 35픽셀씩 간격을 두고 밑으로 배치
            
            // 만약 지금 그리고 있는 줄 번호가 화살표(커서)가 가리키는 곳과 똑같다면!
            if (i == global.inv_cursor) {
                draw_set_color(c_yellow); // 노란색으로 빛나게!
                
                // ▶ 특수문자는 폰트에 등록되어 있지 않으면 네모로 깨지므로, 기본 영어 기호인 -> 로 바꿨습니다!
                draw_text(inv_x + 30, draw_pos_y, "-> " + my_item.name);
                draw_set_color(c_white);
                
                // 지금 내포인터가 가리키는 물건의 "사용 설명서(desc)"를 가방 맨 아래에 띄워줍니다!
                draw_set_halign(fa_center);
                draw_text(inv_x + (inv_w / 2), inv_y + inv_h - 40, my_item.desc);
                draw_set_halign(fa_left); // 복구
            } else {
                draw_text(inv_x + 50, draw_pos_y, "- " + my_item.name);
            }
        }
    }
}
