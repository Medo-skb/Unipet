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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bizMyPage/bizCommon.css">
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <div class="biz-page-wrap">
            <div class="biz-page-container">

                <aside class="biz-sidebar">
                    <div class="sidebar-title">나의 업체관리</div>

                    <ul class="sidebar-menu">
                        <li class="menu-item active">
                            <a href="/biz/main.do">홈</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/storeEdit.do">내정보 및 업체 정보 수정</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/reservation.do">예약 현황</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/review.do">리뷰 관리</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/sales.do">매출 현황</a>
                        </li>
                    </ul>
                </aside>

                <section class="biz-content">
                    <div class="content-header">
                        <h1>사업자 마이페이지</h1>
                    </div>

                    <div class="content-section">
                        <div class="section-header">
                            <h2>오늘의 일정</h2>
                            <a href="javascript:void(0);" class="more-link">전체보기</a>
                        </div>

                        <div class="schedule-list">
                            <div class="schedule-item">
                                <span class="schedule-time">10:00</span>
                                <span class="schedule-text">홍길동님 예약</span>
                            </div>
                            <div class="schedule-item">
                                <span class="schedule-time">13:00</span>
                                <span class="schedule-text">김예림님 예약</span>
                            </div>
                            <div class="schedule-item">
                                <span class="schedule-time">15:30</span>
                                <span class="schedule-text">박서준님 예약</span>
                            </div>
                        </div>
                    </div>

                    <div class="content-section">
                        <div class="section-header">
                            <h2>업체 소개</h2>
                        </div>

                        <div class="store-summary-box">
                            <div class="store-thumb">
                                <img src="/img/default_store.png" alt="업체 이미지">
                            </div>

                            <div class="store-summary-info">
                                <h3>예시 업체명</h3>
                                <p class="store-desc">
                                    저희 업체는 고객 만족을 최우선으로 생각하며 정성껏 서비스를 제공합니다.
                                </p>

                                <ul class="store-info-list">
                                    <li><strong>영업시간</strong> 09:00 ~ 18:00</li>
                                    <li><strong>연락처</strong> 010-1234-5678</li>
                                    <li><strong>주소</strong> 서울시 강남구 예시로 123</li>
                                </ul>
                            </div>
                        </div>
                    </div>

                    <div class="summary-grid">
                        <div class="summary-box">
                            <div class="summary-title">예약 현황</div>
                            <div class="summary-value">12건</div>
                            <div class="summary-desc">최근 7일 이내 예약 건수</div>
                        </div>

                        <div class="summary-box">
                            <div class="summary-title">리뷰 관리</div>
                            <div class="summary-value">8건</div>
                            <div class="summary-desc">최근 7일 이내 리뷰 건수</div>
                        </div>

                        <div class="summary-box">
                            <div class="summary-title">매출 현황</div>
                            <div class="summary-value">580,000원</div>
                            <div class="summary-desc">이번 달 누적 매출</div>
                        </div>
                    </div>
                </section>
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
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
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