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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bizMyPage/bizCommon.css">
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app" v-cloak>
        <div class="biz-page-wrap">
            <div class="biz-page-container">

                <jsp:include page="/WEB-INF/bizMyPage/bizSidebar.jsp">
                    <jsp:param name="activeMenu" value="reservation" />
                </jsp:include>

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
                                <div class="summary-value">{{summaryInfo.todayReservationCount}}건</div>
                                <div class="summary-desc">오늘 날짜 예약 건수</div>
                            </div>
                            <div class="summary-box">
                                <div class="summary-title">최근 예약</div>
                                <div class="summary-value">{{summaryInfo.weekReservationCount}}건</div>
                                <div class="summary-desc">최근 7일 이내 예약 건수</div>
                            </div>
                            <div class="summary-box">
                                <div class="summary-title">완료 예약</div>
                                <div class="summary-value">{{summaryInfo.completeReservationCount}}건</div>
                                <div class="summary-desc">총 서비스 완료된 예약 건수</div>
                            </div>
                        </div>
                    </div>

                    <div class="content-section">
                        <div class="section-header">
                            <h2>예약 목록</h2>
                        </div>

                        <div class="reservation-tab-area">
                            <button type="button"
                                    class="tab-btn"
                                    :class="{ active: reservationCategory === 'TODAY' }"
                                    @click="fnChangeReservationCategory('TODAY')">
                                오늘 예약
                            </button>

                            <button type="button"
                                    class="tab-btn"
                                    :class="{ active: reservationCategory === 'CNF' }"
                                    @click="fnChangeReservationCategory('CNF')">
                                예약완료
                            </button>

                            <button type="button"
                                    class="tab-btn"
                                    :class="{ active: reservationCategory === 'FIN' }"
                                    @click="fnChangeReservationCategory('FIN')">
                                서비스완료
                            </button>
                        </div>

                        <div class="table-wrap">
                            <table class="menu-table reservation-table">
                                <thead>
                                    <tr>
                                        <th>예약번호</th>
                                        <th>예약자명</th>
                                        <th>예약자 번호</th>
                                        <th>예약일시</th>
                                        <th>메뉴명</th>
                                        <th>요구사항</th>
                                        <th>펫이름</th>
                                        <th>동물</th>
                                        <th>품종</th>
                                        <th>생년월일</th>
                                        <th>성별</th>
                                        <th>상태</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-if="reservationList.length === 0">
                                        <td colspan="11" class="empty-text">조회된 예약이 없습니다.</td>
                                    </tr>

                                    <tr v-for="item in reservationList" :key="item.rsvNo">
                                        <td>{{item.rsvNo}}</td>
                                        <td>{{item.userName}}</td>
                                        <td>{{item.phone}}</td>
                                        <td>{{item.rsvDateTime}}</td>
                                        <td>{{item.menuName}}</td>
                                        <td>{{item.request}}</td>
                                        <td>{{item.petName}}</td>
                                        <td>{{item.species}}</td>
                                        <td>{{item.breed}}</td>
                                        <td>{{item.birthdate}}</td>
                                        <td>{{item.gender}}</td>
                                        <td>{{item.rsvStatusName}}</td>
                                    </tr>
                                </tbody>
                            </table>
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
                summaryInfo: {
                    todayReservationCount: 0,
                    weekReservationCount: 0,
                    completeReservationCount: 0
                },
                reservationCategory: "TODAY",
                reservationList: []
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnGetReservationSummary: function () {
                let self = this;
                let param = {};

                $.ajax({
                    url: "/getReservationSummary.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.result === "success" && data.info) {
                            self.summaryInfo = {
                                todayReservationCount: data.info.todayReservationCount || 0,
                                weekReservationCount: data.info.weekReservationCount || 0,
                                completeReservationCount: data.info.completeReservationCount || 0
                            };
                        } else {
                            self.summaryInfo = {
                                todayReservationCount: 0,
                                weekReservationCount: 0,
                                completeReservationCount: 0
                            };
                        }
                    },
                    error: function () {
                        alert("예약 요약 조회에 실패했습니다.");
                    }
                });
            },

            fnGetReservationList: function () {
                let self = this;
                let param = {
                    category: self.reservationCategory
                };

                $.ajax({
                    url: "/getReservationList.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.result === "success" && data.list) {
                            self.reservationList = data.list;
                        } else {
                            self.reservationList = [];
                        }
                    },
                    error: function () {
                        alert("예약 목록 조회에 실패했습니다.");
                    }
                });
            },

            fnChangeReservationCategory: function (category) {
                let self = this;
                self.reservationCategory = category;
                self.fnGetReservationList();
            },


        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnGetReservationSummary();
            self.fnGetReservationList();
        }
    });

    app.mount('#app');
</script>