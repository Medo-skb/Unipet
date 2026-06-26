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
    <script src="https://js.tosspayments.com/v1/payment"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment/sub.css">
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div class="subs-wrapper">
            <div class="subs-header">
                <h1>UNIPET 멤버십</h1>
                <p>반려동물과의 소중한 일상을 더 편리하고 특별하게 관리하세요.</p>
            </div>

            <div class="plan-container">
                <div class="plan-card">
                    <div class="plan-name">Unipet Basic</div>
                    <p class="plan-desc">기본적인 서비스 이용과 커뮤니티 활동을 위한 플랜입니다.</p>
                    <div class="plan-price">₩0 <span>/ 월</span></div>
                    
                    <a href="#" class="subs-btn btn-basic">현재 이용 중</a>

                    <div class="benefit-title">기본 혜택</div>
                    <ul class="benefit-list">
                        <li class="benefit-item"><span>일반 예약 서비스 이용 가능</span></li>
                        <li class="benefit-item"><span>커뮤니티 게시판 읽기 및 쓰기</span></li>
                        <li class="benefit-item"><span>공용 관광지 정보 조회</span></li>
                    </ul>
                </div>

                <div class="plan-card premium">
                    <div class="plan-name">Unipet Premium</div>
                    <p class="plan-desc">쇼핑몰 정기 구독부터 무료 배송까지, 반려생활에 필요한 모든 실속을 한 번에 누리는 프리미엄 플랜입니다.</p>
                    <div class="plan-price"><span style="text-decoration: line-through;">₩11,000</span> <span class="price-discount">₩{{totalprice}} / 월</span></div>
                    
                    <a href="javascript:;" class="subs-btn btn-premium" @click="fnPaySubs">Premium 시작하기</a>

                    <div class="benefit-title">Premium 전용 혜택</div>
                    <ul class="benefit-list">
                        <li class="benefit-item"><span><strong>쇼핑몰 정기구독 서비스</strong></span></li>
                        <li class="benefit-item"><span>매달 쇼핑몰 쿠폰 지급</span></li>
                        <li class="benefit-item"><span>배송비 무료</span></li>
                        <li class="benefit-item"><span>광고 없는 쾌적한 사이트 이용</span></li>
                    </ul>
                </div>
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
                userId : "${sessionId}",
                info : {},
                totalprice : 1000,
                clientKey: "test_ck_jZ61JOxRQVEAgxoERWwVW0X9bAqw",

            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnGetinfo: function () {
                let self = this;
                let param = {
                    userId : self.userId
                };
                $.ajax({
                    url: "/payment/info.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        self.info = data.info;
                    }
                });
            },
            fnPaySubs: function() {
                let self = this;
                // SDK 초기화
                const tossPayments = TossPayments(self.clientKey);

                // 빌링키 발급창(카드 등록창) 띄우기
                tossPayments.requestBillingAuth('카드', {
                    customerKey: self.info.userId, // 토스에서 유저를 식별하는 고유 키
                    successUrl: window.location.origin + "/payment/toss-success.do", 
                    failUrl: window.location.origin + "/payment/toss-fail.do",
                    // 선택 사항: 결제창에 유저 이메일과 이름을 미리 채워둘 수 있습니다.
                    customerEmail: self.info.email, 
                    customerName: self.info.userName 
                }).catch(function (error) {
                    // 유저가 결제창을 그냥 닫았거나 에러가 났을 때의 처리
                    if (error.code === 'USER_CANCEL') {
                        alert("카드 등록을 취소하셨습니다.");
                    } else {
                        alert("결제창 오류: " + error.message);
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnGetinfo();
        }
    });

    app.mount('#app');
</script>