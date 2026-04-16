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
    <script src="/js/main/main.js"></script>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment/pay-rsv.css">
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <div class="payment-container">
            <h1>결제 상세 정보</h1>
            
            <table class="payment-table">
                <tr>
                    <th>예약 번호</th>
                    <td>{{ info.rsvNo }}</td>
                </tr>
                <tr>
                    <th>예약 업체</th>
                    <td>{{ info.storeName }}</td>
                </tr>
                <tr>
                    <th>선택 메뉴</th>
                    <td>{{ info.menuName }}</td>
                </tr>
                <tr>
                    <th>예약 일시</th>
                    <td>{{ info.rsvDate }}</td>
                </tr>
                <tr>
                    <th>예약자명</th>
                    <td>{{ info.userName }}</td>
                </tr>
                <tr>
                    <th>메뉴 가격</th>
                    <td>{{ info.menuPrice }}원</td>
                </tr>
            </table>

            <div class="amount-box">
                <div class="row">
                    <span>총 금액</span>
                    <span>{{ info.menuPrice }}원</span>
                </div>
                <div class="row highlight">
                    <span>선결제 예약금 (10%)</span>
                    <span class="price">{{ deposit }}원</span>
                </div>
                <div class="row footer-info">
                    <span>현장 결제 금액</span>
                    <span>{{ balance }}원</span>
                </div>
            </div>

            <div class="btn-group">
                <button class="btn-cancel" onclick="history.back()">취소</button>
                <button class="btn-pay" @click="fnPayment">결제하기</button>
            </div>
        </div>
    </div>
</body>
</html> 

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                info : {},
                deposit : "",
                balance : ""
            };
        },
        methods: {
            // 1. 초기 예약 정보 로드
            fnGetInfo: function () {
                let self = this;
                $.ajax({
                    url: "/payment/rsv.dox",
                    dataType: "json",
                    type: "POST",
                    success: function (data) {
                        self.info = data.info;
                        self.deposit = data.deposit;
                        self.balance = data.info.menuPrice - data.deposit;
                    }
                });
            },

            // 2. 포트원 결제창 호출 (버튼 클릭 시 실행)
            fnPayment: function () {
                let self = this;
                
                // 포트원 초기화
                const { IMP } = window;
                IMP.init("imp15084381"); 

                // 결제 요청
                IMP.request_pay({
                    pg: "html5_inicis",           
                    pay_method: "card",
                    merchant_uid: "unipet_rsv_" + Date.now(), 
                    name: self.info.storeName + " 예약금", 
                    amount: self.deposit,                 
                    buyer_name: self.info.userName,       
                    buyer_tel: self.info.phone            // 핸드폰 번호 (문자 발송용)
                }, function (response) {
                    console.log("포트원 응답:", response); 
                    
                    if (response.success) {
                        // 결제 성공 시 DB 저장 로직 실행
                        self.fnAddPayment(response); 
                    } else {
                        alert("결제 실패: " + response.error_msg);
                    }
                });
            },

            // 3. 서버 DB에 결제 내역 저장
            fnAddPayment: function(rsp) {
                const self = this;
                
                // [수정 포인트] METHOD_NO는 null로, payType에 실제 수단 저장
                const param = {
                    userId: self.info.userId,      // 결제자 ID
                    methodNo: null,                // 일반 결제이므로 NULL 전송
                    payType: rsp.pay_method,       // 'card', 'kakaopay' 등
                    rsvNo: self.info.rsvNo,        // 예약 번호
                    ordName: rsp.name,             // 주문명
                    totalPrice: rsp.paid_amount,   // 실결제 금액
                    tid: rsp.imp_uid,              // 포트원 고유 번호 (TID)
                    payStatus: "PAY"              // 상태
                };

                $.ajax({
                    url: "/payment/add.dox", 
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function(data) {
                        if(data.result === "success") {
                            alert("예약 및 결제가 완료되었습니다!");
                            // 메인페이지로 이동
                            // location.href = "/my-reservation.do"; 
                        } else {
                            alert("결제는 성공했으나 시스템 기록에 실패했습니다. 관리자에게 문의하세요.");
                        }
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnGetInfo();
        }
    });

    app.mount('#app');
</script>