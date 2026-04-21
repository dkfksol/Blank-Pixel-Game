/// @description 글로벌 매니저 전역 변수 초기화
// 프로젝트 내 어디서든 쓸 수 있게 global 키워드를 사용합니다!
global.dialogue_active = false; // 현재 대화창이 켜져있는가?
global.dialogue_text = "";      // 현재 화면에 띄울 문구

// 카메라 화질 확장으로 인해 UI 레이어 해상도 기준점도 1280x720 으로 튼튼하게 고정해 줍니다.
display_set_gui_size(1280, 720);

global.inventory = []; // 먹은 아이템이 쏙쏙 들어올 무한의 빈 가방(배열)
global.inventory_active = false; // 현재 가방(인벤토리) 화면이 띄워져 있는가?
global.inv_cursor = 0; // 가방 안에서 아이템을 고를 때 쓰는 화살표 커서 위치 번호

// RPG 시스템의 꽃! 플레이어 스탯 (어디서든 접근 가능)
global.hp = 50;
global.max_hp = 100;

// ================== 쯔꾸르(RPG Maker) 이벤트용 전역 마법 스크립트 ==================

// 1. 가방에 특정 아이템이 있는지 찾아주는 스캐너 함수!
// 예시: if (global.HasItem("지하실 열쇠")) { 문 열림! }
global.HasItem = function(_target_name) {
    if (!variable_global_exists("inventory")) return false;
    for (var i = 0; i < array_length(global.inventory); i++) {
        if (global.inventory[i].name == _target_name) {
            return true; // 찾았다! (통과)
        }
    }
    return false; // 없다! (퇴짜)
}

// 2. 퍼즐을 풀었거나 열쇠를 썼을 때 가방에서 아이템을 조용히 지워버리는 소각 스크립트!
// 예시: global.RemoveItem("지하실 열쇠");
global.RemoveItem = function(_target_name) {
    if (!variable_global_exists("inventory")) return false;
    for (var i = 0; i < array_length(global.inventory); i++) {
        if (global.inventory[i].name == _target_name) {
            array_delete(global.inventory, i, 1); // 배열에서 즉시 증발!
            return true; 
        }
    }
    return false;
}
