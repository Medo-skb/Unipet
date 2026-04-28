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
                quickButtons: [
                    "UNIPET",
                    "예약금",
                    "환불 규정",
                    
                ],
                faqMap: {
                    "UNIPET": `UNIPET에서 병원, 미용, 위탁기관 예약 서비스를 한번에 간편하게 이용해보세요! 또한 쇼핑을 통해 다양한 반려동물 상품도 만나보실 수 있습니다.`,
                    "예약금": `<UNIPET 예약금>
예약금은 서비스 예약 확정을 위해 미리 결제하는 금액입니다. 
예약금은 총 금액의 10% 입니다.`,
                    "환불 규정": `<UNIPET 환불 규정>
방문 3일 전: 예약 결제 금액의 100% 환불
방문 1일 전 ~ 2일 전: 예약 결제 금액의 50% 환불
방문 당일 및 노쇼: 환불 불가
예약 시간보다 15분 이상 늦으실 경우 노쇼로 간주되어 자동 취소될 수 있습니다.`,
                },
                
            };
        },
        methods: {
            sendMessage(customText = null) {
                const inputText = customText ? customText : this.userInput.trim();

                if (inputText === "" || this.isLoading) {
                    return;
                }

                this.messages.push({
                    text: inputText,
                    type: "user"
                });

                this.userInput = "";
                this.scrollToBottom();

                // 미리 정한 질문이면 바로 답변
                if (this.faqMap[inputText]) {
                    this.messages.push({
                        text: this.faqMap[inputText],
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