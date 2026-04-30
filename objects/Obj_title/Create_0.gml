/// @description 타이틀 화면 초기화

cursor = 0;
menu_items = ["NEW GAME", "CONTINUE"];

// 세이브 존재 여부에 따라 CONTINUE 활성화
var has_save = global.AnySaveExists();
menu_enabled = [true, has_save];

title_alpha = 1.0;
title_ready = true;
