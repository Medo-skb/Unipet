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
                <span v-html="msg.text"></span>
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
                        text: `안녕하세요. UNIPET 챗봇입니다!
메뉴 이용이 궁금하다면 아래 버튼을 눌러주세요.`,
                        type: "bot"
                    }
                ],
                isLoading: false,
                currentCategory: "AI 상담",

                quickButtons: [
                    "AI 상담",
                    "예약",
                    "쇼핑",
                    "커뮤니티",
                ],

                faqMap: {
                    "예약": {
                        "예약 방법": `원하는 업체 상세 페이지에서 ‘예약하기’를 클릭한 후 날짜와 시간을 선택하고 예약금을 결제하면 예약이 완료됩니다.`,

                        "예약금": `예약금은 서비스 예약 확정을 위해 사전에 결제하는 금액입니다.
총 결제 금액의 약 10%가 예약금으로 부과됩니다.`,

                        "예약 취소": `마이페이지 > 예약 내역에서 예약을 취소할 수 있습니다.
단, 환불 규정에 따라 환불 금액이 달라질 수 있습니다.`,

                        "환불 규정": `방문 3일 전: 100% 환불
방문 1~2일 전: 50% 환불
당일 및 노쇼: 환불 불가

※ 예약 시간보다 15분 이상 지각 시 노쇼로 처리될 수 있습니다.`
                    },

                    "쇼핑": {
                        "배송 기간": `결제 완료 후 일반적으로 1~3일 이내에 배송됩니다.
단, 제주 및 도서산간 지역은 배송 기간이 추가로 소요될 수 있습니다.`,

                        "배송비": `기본 배송비는 3,000원이며, 3만 원 이상 구매 시 무료배송이 적용됩니다.
또한 UNIPET 정기 구독 이용 시 배송비는 무료입니다.`,

                        "교환/반품": `상품 수령 후 7일 이내에 교환 및 반품 신청이 가능합니다.
단, 사용 흔적이 있거나 포장이 훼손된 경우에는 제한될 수 있습니다.`,

                        "주문 취소": `상품이 배송 준비 상태 이전일 경우, 마이페이지 > 주문 내역에서 주문 취소가 가능합니다.`
                    },

                    "커뮤니티": {
                        "게시글 작성": `로그인 후 커뮤니티 게시판에서 카테고리를 선택한 뒤 ‘글쓰기’ 버튼을 통해 게시글을 작성할 수 있습니다.`,

                    "카테고리": `커뮤니티 카테고리는 ‘통합’과 ‘지역’으로 나뉘어 있습니다.
                    
‘통합’ 카테고리는 반려동물에 관한 자유로운 이야기, 질문, 정보 및 팁을 공유하는 공간입니다.
‘지역’ 카테고리는 산책, 소모임, 지역 정보 등 각 지역별로 소통할 수 있는 공간입니다.`,

                        "신고 방법": `게시글 또는 댓글의 ‘신고’ 버튼을 클릭한 후 사유를 선택하면 신고가 접수됩니다.
관리자가 확인 후 필요한 조치를 진행합니다.`,

                        "이용 규칙": `욕설, 광고, 도배, 비방성 게시글은 관리자에 의해 삭제되거나 이용이 제한될 수 있습니다.`
                    },
                },
                
            };
        },
        methods: {
            normalizeText(text) {
                return text.replace(/\s/g, "");
            },

            sendMessage(customText = null) {
                const inputText = (customText ?? this.userInput).trim();
                const normalizedInput = this.normalizeText(inputText);

                if (inputText === "" || this.isLoading) {
                    return;
                }

                this.messages.push({
                    text: inputText,
                    type: "user"
                });

                this.userInput = "";
                this.scrollToBottom();

                // 1. 챗봇과 대화하기 메뉴를 누른 경우
                if (normalizedInput === this.normalizeText("AI 상담")) {
                    this.currentCategory = "AI 상담";

                    this.messages.push({
                        text: `반려동물에 관한 궁금한 점을 UNIPET 챗봇이 간단하게 알려드려요.
편하게 질문해보세요!`,
                        type: "bot"
                    });

                    this.scrollToBottom();
                    return;
                }

                // 2. 큰 메뉴를 입력하거나 버튼으로 누른 경우
                const matchedCategory = Object.keys(this.faqMap).find(category =>
                    this.normalizeText(category) === normalizedInput
                );

                if (matchedCategory) {
                    this.currentCategory = matchedCategory;

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
                if (this.currentCategory && this.faqMap[this.currentCategory]) {
                    const matchedQuestion = Object.keys(this.faqMap[this.currentCategory]).find(question =>
                        this.normalizeText(question) === normalizedInput
                    );

                    if (matchedQuestion) {
                        this.messages.push({
                            text: this.faqMap[this.currentCategory][matchedQuestion],
                            type: "bot"
                        });

                        this.scrollToBottom();
                        return;
                    }
                }

                // 4. 챗봇과 대화하기가 아닌 메뉴에서는 지정된 답변 외 입력 차단
                if (this.currentCategory !== "AI 상담") {
                    this.messages.push({
                        text: `해당 메뉴는 없습니다.
UNIPET 챗봇과 대화를 원하신다면 AI 상담를 눌러주세요.`,
                        type: "bot"
                    });

                    this.scrollToBottom();
                    return;
                }

                // 5. 챗봇과 대화하기 모드일 때만 Gemini 호출
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

                        let formatted = response.replace(/\n/g, "<br>");

                        formatted = formatted.replace(
                            /업체번호:\s*(\d+)/g,
                            '<a class="store-link" href="/reservation/store-detail.do?storeNo=$1" target="_blank" rel="noopener noreferrer">상세보기</a>'
                        );

                        this.messages.push({
                            text: formatted,
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