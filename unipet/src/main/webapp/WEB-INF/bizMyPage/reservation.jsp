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
                        <li class="menu-item active">
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
                        <h1>예약 현황</h1>
                    </div>

                    <div class="content-section">
                        <div class="section-header">
                            <h2>예약 요약</h2>
                        </div>

                        <div class="summary-grid">
                            <div class="summary-box">
                                <div class="summary-title">오늘 예약</div>
                                <div class="summary-value">5건</div>
                                <div class="summary-desc">오늘 접수된 예약 건수</div>
                            </div>
                            <div class="summary-box">
                                <div class="summary-title">대기 예약</div>
                                <div class="summary-value">3건</div>
                                <div class="summary-desc">확인 대기 중인 예약 건수</div>
                            </div>
                            <div class="summary-box">
                                <div class="summary-title">완료 예약</div>
                                <div class="summary-value">18건</div>
                                <div class="summary-desc">최근 완료된 예약 건수</div>
                            </div>
                        </div>
                    </div>

                    <div class="content-section">
                        <div class="section-header">
                            <h2>예약 목록</h2>
                        </div>

                        <table class="menu-table">
                            <thead>
                                <tr>
                                    <th>예약번호</th>
                                    <th>예약자명</th>
                                    <th>예약일시</th>
                                    <th>메뉴명</th>
                                    <th>상태</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>R20260422001</td>
                                    <td>김예림</td>
                                    <td>2026-04-22 13:00</td>
                                    <td>기본 미용</td>
                                    <td>예약완료</td>
                                </tr>
                                <tr>
                                    <td>R20260422002</td>
                                    <td>홍길동</td>
                                    <td>2026-04-22 15:00</td>
                                    <td>목욕</td>
                                    <td>대기중</td>
                                </tr>
                                <tr>
                                    <td>R20260422003</td>
                                    <td>박서준</td>
                                    <td>2026-04-22 17:00</td>
                                    <td>부분 미용</td>
                                    <td>이용완료</td>
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