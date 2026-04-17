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
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                userId : "${sessionId}",
                info : {},
                totalprice : 100,
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnGetinfo: function () {
                let self = this;
                let param = {};
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
            fnPaySubs: function () {
                let self = this;
                
                // 데이터가 잘 로드됐는지 최종 확인
                if (!self.info.userId) {
                    alert("사용자 정보를 불러올 수 없습니다.");
                    return;
                }

                const { IMP } = window;
                IMP.init("imp15084381"); // 사용자님의 가맹점 식별코드

                IMP.request_pay({
                    pg: "html5_inicis.INIpayTest", // 테스트용 PG사
                    pay_method: "card",
                    merchant_uid: "subs_" + new Date().getTime(), // 주문번호 (매번 중복되지 않게)
                    
                    // ★ 정기결제의 핵심: customer_uid가 있어야 빌링키가 발급됨
                    customer_uid: "unipet_user_" + self.info.userId, 
                    
                    name: "유니펫 프리미엄 멤버십",
                    amount: self.totalprice, // 테스트 결제 금액
                    
                    // [서버에서 긁어온 정보 바인딩]
                    buyer_name: self.info.userName,
                    buyer_tel: self.info.phone,
                }, function (rsp) {
                    if (rsp.success) {
                        // 결제 성공 시, 아까 설계한 '3단계 DB 인서트' 로직으로 이동
                        self.fnAddSubs(rsp);
                    } else {
                        alert("결제 실패: " + rsp.error_msg);
                    }
                });
            },
            fnAddSubs: function(rsp) {
                let self = this;

                let param = {
                    userId: self.info.userId,
                    subNo: self.info.subNo,             // 서버에서 구독 분기를 타게 만드는 핵심 키
                    totalprice: self.totalprice,        // XML의 #{totalprice}와 매칭
                    tid: rsp.imp_uid,                   // 포트원 거래 고유번호
                    pmName : rsp.card_name || rsp.pay_method, // PM_NAME 컬럼으로 들어갈 값
                    customerUid : rsp.customer_uid,      // 발급된 빌링키 식별자
                    payStatus: "PAY",                   // 결제 성공 상태
                    ordName: "유니펫 프리미엄 멤버십"     // 결제명
                };

                $.ajax({
                    url: "/payment/add.dox",
                    type: "POST",
                    dataType: "json",
                    data: param,
                    success: function(data) {
                        if(data.result === "success") {
                            alert("축하합니다! 프리미엄 구독이 시작되었습니다.");
                            location.href = "/main.do";
                        }
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