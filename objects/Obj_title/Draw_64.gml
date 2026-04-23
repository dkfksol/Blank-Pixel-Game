/// @description 타이틀 화면 렌더링 (Draw GUI)

draw_set_alpha(title_alpha);

// 배경
draw_set_color(c_black);
draw_rectangle(0, 0, 1280, 720, false);

// 폰트 설정
var lg_fnt = asset_get_index("fnt_large");
if (lg_fnt == -1) lg_fnt = asset_get_index("fnt_main");
if (lg_fnt != -1) draw_set_font(lg_fnt);

// 게임 타이틀 로고 (원자 컴포넌트 - 스프라이트 자동 감지)
global.DrawTitleLogo(200);

// 부제목
var sm_fnt = asset_get_index("fnt_main");
if (sm_fnt != -1) draw_set_font(sm_fnt);
draw_set_color(c_gray);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);
draw_text(1280 / 2, 260, "- A Pixel Adventure -");

// 메뉴 박스 (원자 컴포넌트)
var menu_w = 300;
var menu_h = 150;
var menu_x = (1280 - menu_w) / 2;
var menu_y = 350;

global.DrawBox(menu_x, menu_y, menu_w, menu_h, 0.7);

// 메뉴 리스트 (원자 컴포넌트 - 커서 스프라이트 자동 감지)
if (lg_fnt != -1) draw_set_font(lg_fnt);
draw_set_halign(fa_left);
draw_set_valign(fa_top);

global.DrawMenuList(menu_x + 40, menu_y + 30, menu_items, cursor, 50, menu_enabled);

// 하단 안내 텍스트
if (sm_fnt != -1) draw_set_font(sm_fnt);
draw_set_halign(fa_center);
draw_set_valign(fa_bottom);
draw_set_color(c_dkgray);

if ((current_time div 600) mod 2 == 0) {
    draw_text(1280 / 2, 680, "Z : SELECT    ↑↓ : MOVE");
}

// 상태 초기화
draw_set_alpha(1.0);
draw_set_color(c_white);
draw_set_halign(fa_left);
draw_set_valign(fa_top);
