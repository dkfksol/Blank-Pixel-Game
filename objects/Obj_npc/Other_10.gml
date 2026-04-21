/// @description 상호작용 달성 시 실행 (User Event 0)
// 플레이어가 조사를 걸면 이 이벤트가 발동됩니다!

// 전역(글로벌) 매니저에게 나의 대사(my_text)를 띄워달라고 요청합니다.
global.dialogue_text = my_text;
global.dialogue_active = true;

// 대화창이 열리자마자 닫히는 버그 방어
keyboard_clear(ord("Z"));
