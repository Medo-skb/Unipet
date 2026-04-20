<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Premium 정기결제 등록</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <script src="/js/main/main.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment/pay-sub.css">
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <div class="payment-wrapper">
            <div class="payment-card">
                <div class="payment-title">
                    <h2>결제 수단 등록</h2>
                    <p>Unipet Premium 매월 <span class="price-highlight">{{totalprice}}원</span> 정기결제</p>
                </div>

                <div class="form-group">
                    <label>카드 번호</label>
                    <input type="text" class="form-control" v-model="card.number" placeholder="0000-0000-0000-0000" maxlength="19">
                </div>
                
                <div class="form-row">
                    <div class="form-group">
                        <label>유효기간 (MM)</label>
                        <input type="text" class="form-control" v-model="card.expiryMonth" placeholder="월 (예: 12)" maxlength="2">
                    </div>
                    <div class="form-group">
                        <label>유효기간 (YY)</label>
                        <input type="text" class="form-control" v-model="card.expiryYear" placeholder="연도 (예: 25)" maxlength="2">
                    </div>
                </div>

                <div class="form-group">
                    <label>생년월일 6자리</label>
                    <input type="text" class="form-control" v-model="card.birth" placeholder="예: 900101" maxlength="10">
                </div>

                <div class="form-group">
                    <label>카드 비밀번호 앞 2자리</label>
                    <input type="password" class="form-control" v-model="card.pwd2Digit" placeholder="**" maxlength="2">
                </div>

                <button class="btn-submit" @click="fnIssueBilling">동의하고 정기결제 시작하기</button>
            </div>
        </div>
    </div>

</body>
</html>
<script>
    const app = Vue.createApp({
        data() {
            return {
                // 1. 세션에서 가져온 유저 ID
                // userId : "${sessionId}",
                userId : "tset_user01",
                totalprice : "${totalprice}", 
                
                // 3. HTML 폼의 v-model과 연결될 카드 데이터 객체
                card: {
                    number: "",
                    expiryMonth: "",
                    expiryYear: "",
                    birth: "",
                    pwd2Digit: ""
                }
            };
        },
        methods: {
            // 결제 버튼(@click)을 눌렀을 때 실행되는 함수
            fnIssueBilling: function () {
                let self = this;
                
                // [검증] 사용자가 빈칸을 제출하지 못하도록 프론트엔드 단에서 차단
                if(!self.card.number || self.card.number.length < 15) { 
                    alert("카드번호를 정확히 입력해주세요."); 
                    return; 
                }
                if(!self.card.expiryMonth || !self.card.expiryYear) { 
                    alert("유효기간을 입력해주세요."); 
                    return; 
                }
                if(!self.card.birth) { 
                    alert("생년월일(또는 사업자번호)을 입력해주세요."); 
                    return; 
                }
                if(!self.card.pwd2Digit) { 
                    alert("비밀번호 앞 2자리를 입력해주세요."); 
                    return; 
                }

                // [조립] 백엔드(/payment/billing.dox)로 넘겨줄 데이터 포장
                let param = {
                    userId: self.userId,
                    totalprice: self.totalprice,
                    cardNumber: self.card.number,
                    expiryYear: self.card.expiryYear,
                    expiryMonth: self.card.expiryMonth,
                    birth: self.card.birth,
                    pwd2Digit: self.card.pwd2Digit
                };

                // [통신] 백엔드 API 호출 (비인증 빌링키 발급 요청)
                $.ajax({
                    url: "/payment/billing.dox",
                    dataType: "json",
                    type: "POST",
                    data: param, 
                    success: function (data) {
                        if(data.result === "success") {
                            alert("빌링키 발급 및 정기결제 등록이 완료되었습니다!");
                            pageChange("/main.do"); 
                        } else {
                            alert("결제 수단 등록 실패: " + data.message);
                        }
                    },
                    error: function(err) {
                        console.error("AJAX Error: ", err);
                        alert("서버와 통신 중 오류가 발생했습니다.");
                    }
                });
            }
        },
        mounted() {
            let self = this;
        }
    });

    app.mount('#app');
</script>