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
                            <a href="/biz/storeEdit.do">내 정보 및 업체 정보 수정</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/reservation.do">예약 현황</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/review.do">리뷰 관리</a>
                        </li>
                        <li class="menu-item active">
                            <a href="/biz/sales.do">매출 현황</a>
                        </li>
                    </ul>
                </aside>

                <section class="biz-content">
                    <div class="content-header">
                        <h1>매출 현황</h1>
                    </div>

                    <div class="content-section">
                        <div class="section-header">
                            <h2>매출 요약</h2>
                        </div>

                        <div class="summary-grid">
                            <div class="summary-box">
                                <div class="summary-title">오늘 매출</div>
                                <div class="summary-value">120,000원</div>
                                <div class="summary-desc">오늘 발생한 총 매출</div>
                            </div>
                            <div class="summary-box">
                                <div class="summary-title">이번 주 매출</div>
                                <div class="summary-value">840,000원</div>
                                <div class="summary-desc">최근 7일 누적 매출</div>
                            </div>
                            <div class="summary-box">
                                <div class="summary-title">이번 달 매출</div>
                                <div class="summary-value">3,250,000원</div>
                                <div class="summary-desc">이번 달 누적 매출</div>
                            </div>
                        </div>
                    </div>

                    <div class="content-section">
                        <div class="section-header">
                            <h2>매출 내역</h2>
                        </div>

                        <table class="menu-table">
                            <thead>
                                <tr>
                                    <th>일자</th>
                                    <th>예약건수</th>
                                    <th>주문건수</th>
                                    <th>매출금액</th>
                                    <th>비고</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>2026-04-22</td>
                                    <td>5건</td>
                                    <td>2건</td>
                                    <td>120,000원</td>
                                    <td>정상</td>
                                </tr>
                                <tr>
                                    <td>2026-04-21</td>
                                    <td>7건</td>
                                    <td>3건</td>
                                    <td>185,000원</td>
                                    <td>정상</td>
                                </tr>
                                <tr>
                                    <td>2026-04-20</td>
                                    <td>4건</td>
                                    <td>1건</td>
                                    <td>95,000원</td>
                                    <td>정상</td>
                                </tr>
                            </tbody>
                        </table>
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