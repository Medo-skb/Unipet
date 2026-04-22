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
                        <li class="menu-item">
                            <a href="/biz/MyPage.do">홈</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/storeEdit.do">업체 소개 수정</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/myInfo.do">내 정보 수정</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/reservation.do">예약 현황</a>
                        </li>
                        <li class="menu-item active">
                            <a href="/biz/review.do">리뷰 관리</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/sales.do">매출 현황</a>
                        </li>
                    </ul>
                </aside>

                <section class="biz-content">
                    <div class="content-header">
                        <h1>리뷰 관리</h1>
                    </div>

                    <div class="content-section">
                        <div class="section-header">
                            <h2>리뷰 요약</h2>
                        </div>

                        <div class="summary-grid">
                            <div class="summary-box">
                                <div class="summary-title">전체 리뷰</div>
                                <div class="summary-value">128건</div>
                                <div class="summary-desc">누적 리뷰 수</div>
                            </div>
                            <div class="summary-box">
                                <div class="summary-title">평균 평점</div>
                                <div class="summary-value">4.8점</div>
                                <div class="summary-desc">고객 평균 만족도</div>
                            </div>
                            <div class="summary-box">
                                <div class="summary-title">미답변 리뷰</div>
                                <div class="summary-value">6건</div>
                                <div class="summary-desc">답변이 필요한 리뷰</div>
                            </div>
                        </div>
                    </div>

                    <div class="content-section">
                        <div class="section-header">
                            <h2>최근 리뷰</h2>
                        </div>

                        <div class="review-list">
                            <div class="review-item">
                                <div class="review-top">
                                    <div class="review-writer">김예림</div>
                                    <div class="review-score">★★★★★</div>
                                </div>
                                <div class="review-text">친절하고 꼼꼼하게 잘해주셨어요. 다음에도 이용할게요.</div>
                                <div class="review-date">2026-04-22</div>
                            </div>

                            <div class="review-item">
                                <div class="review-top">
                                    <div class="review-writer">홍길동</div>
                                    <div class="review-score">★★★★☆</div>
                                </div>
                                <div class="review-text">전체적으로 만족했지만 대기 시간이 조금 있었어요.</div>
                                <div class="review-date">2026-04-21</div>
                            </div>

                            <div class="review-item">
                                <div class="review-top">
                                    <div class="review-writer">박서준</div>
                                    <div class="review-score">★★★★★</div>
                                </div>
                                <div class="review-text">매장도 깔끔하고 서비스도 좋아서 만족합니다.</div>
                                <div class="review-date">2026-04-20</div>
                            </div>
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