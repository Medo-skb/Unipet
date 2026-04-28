<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNIPET</title>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/gemini-chat.css">
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app" class="chat-wrap">
        <div class="chat-header">UNIPET 챗봇</div>

        <div class="chat-box" ref="chatBox">
            <div v-for="msg in messages" :class="['message', msg.type]">
                {{ msg.text }}
            </div>
        </div>

        <div class="quick-button-wrap">
            <button
                v-for="buttonText in quickButtons"
                :key="buttonText"
                class="quick-button"
                @click="quickQuestion(buttonText)"
                :disabled="isLoading">
                {{ buttonText }}
            </button>
        </div>
        <div class="chat-input" >
            <textarea spellcheck="false" autocorrect="off" autocomplete="off"
                v-model="userInput"
                @keydown.enter.exact.prevent="sendMessage()"
                placeholder="메시지를 입력하세요...">
            </textarea>
            <button @click="sendMessage()" :disabled="isLoading">
                {{ isLoading ? '전송중' : '전송' }}
            </button>
        </div>
    </div>

    <jsp:include page="/WEB-INF/footer/footer.jsp" />

<script>
    const app = Vue.createApp({
        data() {
            return {
                userInput: "",
                messages: [
                    {
                        text: `안녕하세요. UNIPET 입니다! 어떤것이 궁금하신가요?`,
                        type: "bot"
                    }
                ],
                isLoading: false,
                currentCategory: null,

                quickButtons: [
                    "예약",
                    "쇼핑",
                    "커뮤니티",
                    "계정"
                ],

                faqMap: {
                    "예약": {
                        "예약 방법": `원하는 업체 상세 페이지에서 날짜와 시간을 선택한 뒤 예약금을 결제하면 예약이 완료됩니다.`,

                        "예약금": `예약금은 서비스 예약 확정을 위해 미리 결제하는 금액입니다.
총 결제 금액의 약 10%가 예약금으로 부과됩니다.`,

                        "예약 취소": `마이페이지 > 예약 내역에서 예약을 취소할 수 있습니다.
단, 환불 규정에 따라 환불 금액이 달라질 수 있습니다.`,

                        "환불 규정": `방문 3일 전: 100% 환불
방문 1~2일 전: 50% 환불
당일 및 노쇼: 환불 불가

                ※ 예약 시간보다 15분 이상 지각 시 노쇼로 처리될 수 있습니다.`
                    },

                    "쇼핑": {
                        "배송 기간": `배송은 결제 완료 후 보통 2~5일 정도 소요됩니다.`,

                        "배송비": `배송비는 상품 또는 판매 조건에 따라 다르게 적용될 수 있습니다.`,

                        "교환/반품": `상품 수령 후 7일 이내 교환/반품 신청이 가능합니다.
단, 사용 흔적이 있거나 포장이 훼손된 경우 제한될 수 있습니다.`,

                        "주문 취소": `배송 준비 전 상태에서는 마이페이지 > 주문 내역에서 주문 취소가 가능합니다.`
                    },

                    "커뮤니티": {
                        "게시글 작성": `로그인 후 커뮤니티 게시판에서 글쓰기 버튼을 눌러 게시글을 작성할 수 있습니다.`,

                        "댓글 삭제": `본인이 작성한 댓글은 댓글 영역의 삭제 버튼을 통해 삭제할 수 있습니다.`,

                        "신고 방법": `게시글 또는 댓글의 신고 버튼을 눌러 사유를 선택하면 신고가 접수됩니다.`,

                        "이용 규칙": `욕설, 광고, 도배, 비방성 게시글은 관리자에 의해 삭제되거나 이용 제한이 발생할 수 있습니다.`
                    },

                    "계정": {
                        "비밀번호 변경": `마이페이지 > 내 정보 수정에서 비밀번호를 변경할 수 있습니다.`,

                        "회원 탈퇴": `마이페이지 > 내 정보 수정에서 회원 탈퇴를 신청할 수 있습니다.`,

                        "고객센터": `이용 중 문제가 발생하면 고객센터 또는 1:1 문의를 이용해주세요.`
                    }
                },
                
            };
        },
        methods: {
            sendMessage(customText = null) {
                const inputText = (customText ?? this.userInput).trim();

                if (inputText === "" || this.isLoading) {
                    return;
                }

                this.messages.push({
                    text: inputText,
                    type: "user"
                });

                this.userInput = "";
                this.scrollToBottom();

                // 1. 큰 메뉴를 입력하거나 버튼으로 누른 경우
                if (this.faqMap[inputText]) {
                    this.currentCategory = inputText;

                    const subMenus = Object.keys(this.faqMap[this.currentCategory]);
                    const menuText = subMenus.map(menu => `- ` + menu).join(`\n`);

                    this.messages.push({
                        text: inputText + ` 관련 메뉴입니다.

` + menuText + `

궁금한 내용을 입력해주세요.`,
                        type: "bot"
                    });

                    this.scrollToBottom();
                    return;
                }

                // 2. 큰 메뉴가 선택된 상태에서 세부 질문을 입력한 경우
                if (this.currentCategory && this.faqMap[this.currentCategory][inputText]) {
                    this.messages.push({
                        text: this.faqMap[this.currentCategory][inputText],
                        type: "bot"
                    });

                    this.scrollToBottom();
                    return;
                }

                // 그 외에는 Gemini 호출
                this.isLoading = true;

                this.messages.push({
                    text: "전송중...",
                    type: "bot",
                    loading: true
                });
                this.scrollToBottom();

                $.ajax({
                    url: "/gemini/chat",
                    type: "GET",
                    data: { input: inputText },
                    success: (response) => {
                        this.removeLoadingMessage();

                        this.messages.push({
                            text: response,
                            type: "bot"
                        });

                        this.isLoading = false;
                        this.scrollToBottom();
                    },
                    error: (xhr) => {
                        this.removeLoadingMessage();

                        this.messages.push({
                            text: xhr.responseText || "잠시 후 다시 시도해주세요.",
                            type: "bot"
                        });

                        this.isLoading = false;
                        this.scrollToBottom();
                    }
                });
            },
            
            removeLoadingMessage() {
                this.messages = this.messages.filter(msg => !msg.loading);
            },

            scrollToBottom() {
                this.$nextTick(() => {
                    const chatBox = this.$refs.chatBox;
                    chatBox.scrollTop = chatBox.scrollHeight;
                });
                
            },
            quickQuestion(buttonText) {
                this.sendMessage(buttonText);
            },
        }
    });

    app.mount("#app");
</script>
</body>
</html>