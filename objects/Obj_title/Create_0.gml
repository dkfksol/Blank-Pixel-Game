/// @description 타이틀 화면 초기화

cursor = 0;             // 현재 메뉴 커서 위치
menu_items = [];        // 메뉴 항목 배열
menu_enabled = [];      // 항목별 활성화 여부

// 세이브 존재 여부에 따라 메뉴 구성
var has_save = false;
for (var i = 0; i < 3; i++) {
    if (global.SaveExists(i)) { has_save = true; break; }
}

menu_items = ["NEW GAME", "CONTINUE"];
menu_enabled = [true, has_save]; // 세이브 없으면 CONTINUE 비활성

// (타이틀 페이드인 효과 제거)
title_alpha = 1.0;
title_ready = true;
