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
        <div class="chat-input">
            <textarea
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
                    "예약금 정보",
                    "환불 규정",
                    "이용 안내"
                ],
                faqMap: {
                    "예약금 정보": "예약금은 서비스 예약 확정을 위해 미리 결제하는 금액입니다. 예약 취소 시 환불 여부는 업체 정책에 따라 달라질 수 있습니다.",
                    "환불 규정": "환불 규정은 예약한 업체의 정책에 따라 다르며, 예약 취소 시점에 따라 환불 금액이 달라질 수 있습니다.",
                    "이용 안내": "원하는 업체를 선택한 뒤 예약 가능한 날짜와 시간을 확인하고 예약을 진행하면 됩니다."
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