/// @description 상호작용 달성 시 실행 (조사하기)

if (is_open == false) {
    // 1. 상태를 '열림'으로 바꾼다.
    is_open = true;
    
    // 2. 상자의 껍데기를 1번 그림(열린 사진)으로 확 바꾼다!
    image_index = 1; 
    
    // 3. 글로벌 배낭에 선물을 쑤셔 넣는다! (이젠 단순 글씨가 아닌 능력치 덩어리입니다)
    var new_item = {
        name: item_name,
        type: item_type,
        val: item_val,
        desc: item_desc
    };
    array_push(global.inventory, new_item); 
    
    // 4. 전 세계에 "나 이거 먹었다!" 라며 자막을 알림
    // Create 창에서 미리 적어둔 msg_success 변수를 불러옵니다.
    global.dialogue_text = msg_success;
    global.dialogue_active = true;
    
    keyboard_clear(ord("Z")); // 대화창 창 뜰 때 다중 따닥 방지
} else {
    // 이미 털려버린 빈 상자라면
    // Create 창에서 미리 적어둔 msg_empty 변수를 불러옵니다.
    global.dialogue_text = msg_empty;
    global.dialogue_active = true;
    
    keyboard_clear(ord("Z"));
}
