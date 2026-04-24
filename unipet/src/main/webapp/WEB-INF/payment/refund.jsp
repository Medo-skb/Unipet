<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>환불 요청</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment/refund.css">
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <div class="pay-container">
            <div class="pay-header">환불 요청하기</div>

            <div class="pay-section" v-if="list && list.length > 0">
                <div class="section-title">환불 대상 상품</div>
                
                <div v-for="item in list" :key="item.productNo" class="item-card">
                    <div class="item-content">
                        <img :src="item.filePath + item.fileName" class="item-img" alt="상품 이미지">
                        <div class="item-info">
                            <div class="item-name">{{ item.productName }}</div>
                            <div class="item-detail">
                                수량: <b>{{ item.ordQty }}개</b> | 가격: <b>{{ item.unitPrice?.toLocaleString() }}원</b>
                            </div>
                        </div>
                    </div>
                    <div class="item-total-price">{{ (item.ordQty * item.unitPrice).toLocaleString() }}원</div>
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

            <div class="pay-section" v-if="info.totalPrice">
                <div class="section-title">환불 내용</div>
                <div class="summary-box">
                    <div class="summary-row">
                        <span>환불 예정 금액</span>
                        <span class="text-discount">{{ info.totalPrice?.toLocaleString() }}원</span>
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
                ordNo: "${ordNo}" || 6, 
                
                info: {},   // 전체 결제 정보 (totalPrice, payNo 등)
                list: [],   // 환불할 상품 리스트 목록 배열
                
                refundReason: "",   
                refundDetail: ""    
            };
        },
        watch: {
            refundReason(newVal) {
                if (newVal !== '기타') {
                    this.refundDetail = "";
                }
            }
        },
        methods: {
            // [데이터 가져오기]
            fnGetInfo: function () {
                let self = this;
                $.ajax({
                    url: "/payment/getOrder.dox", // 만약 getOrder.dox를 같이 쓴다면 바꿔주세요!
                    dataType: "json",
                    type: "POST",
                    data: { id: self.ordNo }, // 백엔드에서 id로 받으면 id: self.ordNo 로 수정
                    success: function (data) {
                        if(data.info) {
                            self.info = data.info;
                            self.list = data.list || []; // 리스트 꽂아주기
                        } else {
                            alert("주문 정보를 찾을 수 없습니다.");
                        }
                    }
                });
            },
            // [환불 제출]
            fnSubmitRefund: function () {
                let self = this;

                // 폼 검증
                if(!self.refundReason || self.refundReason === '사유를 선택해주세요') {
                    alert("환불 사유를 반드시 선택해주세요.");
                    return; 
                }
                if(self.refundReason === '기타' && !self.refundDetail.trim()) {
                    alert("기타 사유에 대한 상세 내용을 입력해주세요.");
                    return;
                }

                // 서버로 전송할 파라미터 (info 객체에서 추출)
                const param = {
                    ordNo: self.ordNo,
                    payNo: self.info.payNo,           // Order 객체의 payNo 매핑
                    amount: self.info.totalPrice,     // Order 객체의 totalPrice 매핑
                    reason: self.refundReason === '기타' ? self.refundReason + " - " + self.refundDetail : self.refundReason
                };

                if(confirm("상품을 환불하시겠습니까?")) {
                    $.ajax({
                        url: "/payment/productRefund.dox",
                        dataType: "json",
                        type: "POST",
                        data: param, // JSON.stringify 없이 폼 데이터로 전송
                        success: function (data) {
                            if(data.result === "success") {
                                alert("환불 완료!");
                                location.href = "/user/UserMypage.dox";
                            } else {
                                alert("오류: " + data.message);
                            }
                        }
                    });
                }   
            },
            fnGoBack: function() { window.history.back(); }
        },
        mounted() {
            let self = this;
            self.fnGetInfo();
        }
    });

    app.mount('#app');
</script>