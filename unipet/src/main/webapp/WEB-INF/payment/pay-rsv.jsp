<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNIPET</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <script src="/js/main/main.js"></script>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css">
    <!-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment/pay-rsv.css"> -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment/pay-rsv2.css">
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <div class="payment-container">
            <h1>결제 상세 정보</h1>
            
            <table class="payment-table">
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
                    <th>예약 시간</th>
                    <td>{{info.rsvStartTime}} ~ {{info.rsvEndTime}}</td>
                </tr>
                <tr>
                    <th>예약자명</th>
                    <td>{{ info.userName }}</td>
                </tr>
                <tr>
                    <th>가격</th>
                    <td>{{ info.menuPrice }}원</td>
                </tr>
            </table>

            <div class="amount-box">
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
                <button class="btn-cancel" onclick="location.href = '/user/mypage.do'">취소</button>
                <button class="btn-pay" @click="fnPayment">결제하기</button>
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
                rsvNo : "${rsvNo}",
                userId : "${sessionId}",
                info : {},
                deposit : "",
                balance : "",
                isPayComplete: false
            };
        },
        methods: {
            // 1. 초기 예약 정보 로드
            fnGetInfo: function () {
                let self = this;

                const param = {
                    rsvNo : self.rsvNo,
                    userId : self.userId
                }
 
                $.ajax({
                    url: "/payment/rsv.dox",
                    dataType: "json",
                    type: "POST",
                    data : param,
                    success: function (data) {
                        if (data.info) {
                            self.info = data.info;
                            self.deposit = data.deposit;
                            self.balance = data.info.menuPrice - data.deposit;

                            // rsvStatus가 'WAI'(결제대기/예약대기)가 아니면 이미 처리된 건으로 간주
                            if (self.info.rsvStatus !== 'WAI') {
                                alert("잘못된 접근입니다.");
                                location.href = "/main.do";
                                return;
                            }
                            if (!self.info.phone || self.info.phone.trim() === '') {
                                alert("본인인증이 필요한 서비스입니다. 인증 페이지로 이동합니다.");
                                // location.href = "/member/verification.do"; 
                                location.href = "/main.do"; 
                                return;
                            }
                        } else {
                            // 데이터 자체가 없는 경우 대비
                            alert("존재하지 않는 예약 정보입니다.");
                            location.href = "/main.do";
                        }
                    }
                });
            },
            // 2. 포트원 결제창 호출
            fnPayment: function () {
                let self = this;

                if(!self.info.userId) {
                    alert("로그인이 필요한 서비스입니다.");
                    return;
                }

                const { IMP } = window;
                IMP.init("imp15084381"); 

                IMP.request_pay({
                    pg: "html5_inicis.INIpayTest",
                    pay_method: "card",
                    merchant_uid: "unipet_rsv_" + Date.now(), 
                    name: self.info.storeName + " 예약금", 
                    amount: self.deposit, 
                    buyer_name: self.info.userName,  
                    buyer_tel: self.info.phone,
                    buyer_email: self.info.email
                }, function (response) {
                    // 성공하든 실패하든 일단 서버로 기록을 보냄
                    self.fnAddPayment(response); 
                });
            },

            // 3. 서버 DB에 결제 내역 저장
            fnAddPayment: function(rsp) {
                let self = this;
                
                // 성공 여부에 따른 상태값 결정
                let status = rsp.success ? "PAY" : "FAL";
                
                const param = {
                    userId: self.info.userId,              
                    payType: rsp.pay_method || "unknown", // 실패 시에는 값이 없을 수 있음
                    rsvNo: self.info.rsvNo,        
                    ordName: self.info.storeName + " 예약금", 
                    payFlg : "RSV",
                    totalprice: self.deposit,   
                    tid: rsp.imp_uid || "N/A",    
                    payStatus: status              // ★ 여기서 PAY 또는 FAL 전송
                };

                $.ajax({
                    url: "/payment/add.dox", 
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function(data) {
                        if (status === "PAY" && data.result === "success") {
                            self.isPayComplete = true; // 가드 해제
                            alert("예약 및 결제가 완료되었습니다.");
                            pageChange("/payment/pay-success.do", { rsvNo: param.rsvNo });
                        } else {
                            self.isPayComplete = true; 
                            
                            alert("결제를 취소하거나 실패했습니다. 예약 내역에서 다시 시도해주세요.");
                            
                            // 마이페이지 예약 탭 트리거 설정
                            sessionStorage.setItem("triggerFunction", "openRsvList");
                            
                            // 마이페이지로 이동
                            location.href = "/user/mypage.do";
                        }
                    }
                });
            },
            fnLeaveGuard(event) {
                // 결제가 완료되어 성공 페이지로 이동할 때는 묻지 않습니다.
                if (this.isPayComplete) return;

                event.preventDefault();
                event.returnValue = ''; // 크롬에서 이 코드가 있어야 경고창이 뜹니다.
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            if (!self.rsvNo || self.rsvNo === "null") {
                alert("잘못된 접근입니다. 메인 페이지로 이동합니다.");
                location.href = "/main.do";
                return; 
            }
            self.fnGetInfo();
            window.addEventListener('beforeunload', this.fnLeaveGuard);
        },
        beforeUnmount() {
            // 페이지를 떠날 때 리스너 제거 (중요: 메모리 누수 방지)
            window.removeEventListener('beforeunload', this.fnLeaveGuard);
        },
    });

    app.mount('#app');
</script>