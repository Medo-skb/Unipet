<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNIPET</title>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/customer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/gemini-chat.css">
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app" v-cloak>
        <div class="customer-wrap">

            <jsp:include page="/WEB-INF/main/customer/customerSidebar.jsp">
                <jsp:param name="activeMenu" value="chatbot" />
            </jsp:include>

            <section class="customer-content">
                <div class="chat-wrap">
                    <div class="chat-header">UNIPET Chatbot</div>

                    <div class="chat-box" ref="chatBox">
                        <div v-for="msg in messages" :class="['message', msg.type]">
                            <div v-html="formatMessage(msg.text)"></div>

                            <button
                                v-if="msg.showInquiryButton"
                                type="button"
                                class="chat-inquiry-link-btn"
                                @click="goInquiry">
                                홈페이지 문의로 이동
                            </button>
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
            </section>
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
                currentCategory: "",

                quickButtons: [
                    "예약",
                    "쇼핑",
                    "커뮤니티",
                    "문의하기"
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

            formatMessage(text) {
                if (!text) {
                    return "";
                }

                return text.replace(/\n/g, "<br>");
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

                // 문의하기는 홈페이지 문의로 안내
                if (this.isInquiryQuestion(normalizedInput)) {
                    this.messages.push({
                        text: `해당 내용은 홈페이지 문의를 이용해주세요.
            관리자가 확인 후 답변드릴 수 있습니다.`,
                        type: "bot",
                        showInquiryButton: true
                    });

                    this.scrollToBottom();
                    return;
                }

                // 큰 메뉴를 입력하거나 버튼으로 누른 경우
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

                // 큰 메뉴가 선택된 상태에서 세부 질문을 입력한 경우
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

                this.messages.push({
                    text: `해당 메뉴는 없습니다.

            상단 버튼에서 예약, 쇼핑, 커뮤니티, 문의하기 중 하나를 선택해주세요.`,
                    type: "bot"
                });

                this.scrollToBottom();
                return;
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

            isInquiryQuestion(normalizedInput) {
                const inquiryKeywords = [
                    "문의",
                    "문의하기",
                    "고객센터",
                    "상담원",
                    "관리자",
                    "답변",
                    "문의등록",
                    "홈페이지문의",
                    "입점문의",
                    "사업자문의",
                    "오류문의",
                    "결제문의",
                    "배송문의",
                    "환불문의",
                    "교환문의",
                    "반품문의",
                    "쿠폰문의",
                    "이벤트문의",
                    "계정문의",
                    "로그인문의"
                ];

                return inquiryKeywords.some(keyword => normalizedInput.includes(this.normalizeText(keyword)));
            },
        }
    });

    app.mount("#app");
</script>
</body>
</html>