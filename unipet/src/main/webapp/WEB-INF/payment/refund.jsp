<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment/refund.css">
    <style>
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <div class="pay-container">
            <div class="pay-header">환불 요청하기</div>

            <div class="pay-section">
                <div class="section-title">환불 대상 상품</div>
                <div class="item-card">
                    <div class="item-content">
                        <img :src="orderInfo.IMG_PATH" class="item-img" alt="상품 이미지">
                        <div class="item-info">
                            <div class="item-name">{{ orderInfo.PRODUCT_NAME }}</div>
                            <div class="item-detail">수량: <b>{{ orderInfo.QTY }}개</b></div>
                        </div>
                    </div>
                    <div class="item-total-price">{{ orderInfo.TOTAL_PRICE?.toLocaleString() }}원</div>
                </div>
            </div>

            <div class="pay-section">
                <div class="section-title">환불 사유 선택</div>
                <div class="input-group">
                    <label>무엇이 문제인가요?</label>
                    <select class="input-field" v-model="refundReason">
                        <option value="">사유를 선택해주세요</option>
                        <option value="단순 변심">실수로 구매했습니다</option>
                        <option value="상품 불량">상품에 결함이 있습니다</option>
                        <option value="배송 지연">배송이 너무 늦습니다</option>
                        <option value="서비스 불만족">기대했던 것과 다릅니다</option>
                        <option value="기타">기타 (아래 상세 내용에 입력)</option>
                    </select>
                </div>

                <div class="input-group" style="margin-top: 20px;" v-if="refundReason === '기타'">
                    <label>상세 내용 <span style="color:#FF4D4F;">(필수)</span></label>
                    <textarea class="input-field" v-model="refundDetail" 
                            placeholder="어떤 문제가 발생했는지 적어주세요." 
                            style="height: 120px; border-radius: 20px; resize: none;"></textarea>
                </div>
            </div>

            <div class="pay-section">
                <div class="section-title">환불 방법</div>
                <div class="summary-box">
                    <div class="summary-row">
                        <span>환불 예정 금액</span>
                        <span class="text-discount">{{ orderInfo.TOTAL_PRICE?.toLocaleString() }}원</span>
                    </div>
                    <div class="summary-row">
                        <span>환불 수단</span>
                        <span>기존 결제 수단</span>
                    </div>
                    <div class="point-info">
                        * 배송 시작 전 주문에 한하여 <b>즉시 환불</b>이 진행됩니다.<br>
                    </div>
                </div>
            </div>

            <div class="btn-group">
                <button class="btn-secondary" @click="fnGoBack">취소</button>
                <button class="btn-primary" @click="fnSubmitRefund">환불 요청 제출하기</button>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/footer/footer.jsp" />

</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                ordNo: "${ordNo}" || 6, 
                rsvNo: "${rsvNo}",
                
                // 2. [테스트 데이터] 화면이 뜨는지 확인하기 위해 가짜 데이터를 넣습니다.
                orderInfo: {
                    PRODUCT_NAME: "유니펫 프리미엄 사료 5kg",
                    QTY: 2,
                    TOTAL_PRICE: 45000,
                    // 실제 있는 이미지 경로를 넣거나, 테스트용 이미지를 쓰세요.
                    IMG_PATH: "https://via.placeholder.com/80", 
                    PAY_NO: 101
                },
                
                refundReason: "",   // 사유 선택값
                refundDetail: ""    // 상세 내용
            };
        },
        watch: {
            refundReason(newVal) {
                // 사유가 '기타'가 아닌 다른 것으로 바뀌면, 적어둔 상세 내용을 싹 비워줌
                if (newVal !== '기타') {
                    this.refundDetail = "";
                }
            }
        },
        methods: {
            fnList: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {

                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>