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
    <script src="https://cdn.jsdelivr.net/npm/apexcharts"></script>
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
                    </ul>
                </aside>

                <section class="biz-content">
                    <div class="content-header">
                        <h1>사업자 마이페이지</h1>
                    </div>

                    <div class="content-section">
                        <div class="section-header">
                            <h2>오늘의 일정</h2>
                        </div>

                        <div class="schedule-list" v-if="todayScheduleList.length > 0">
                            <div class="schedule-item" v-for="item in todayScheduleList" :key="item.rsvTime + item.userName + item.menuName">
                                <span class="schedule-time">{{ item.rsvTime }}</span>
                                <span class="schedule-text">{{ item.userName }} / {{ item.menuName }}</span>
                            </div>
                        </div>

                        <div class="empty-text" v-else>
                            오늘 예정된 예약이 없습니다.
                        </div>
                    </div>

                    <div class="content-section">
                        <div class="section-header">
                            <h2>메뉴 예약 분포</h2>
                        </div>

                        <div class="chart-row">
                            <!-- 왼쪽: 차트 -->
                            <div class="chart-left">
                                <div id="menuPieChart"></div>
                            </div>

                            <!-- 오른쪽: 리스트 -->
                            <div class="chart-right">
                                <div class="chart-summary">
                                    <div class="total-count">
                                        총 예약 <strong>{{ totalCount }}건</strong>
                                    </div>

                                    <ul class="menu-rank">
                                        <li v-for="(item, index) in menuChartList" :key="index">
                                            {{ index + 1 }}. {{ item.menuName }}
                                            ({{ item.percent }}%, {{ item.reserveCount }}건)
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="content-section">
                        <div class="section-header">
                            <h2>하루 예약 건수 그래프</h2>
                        </div>

                        <div id="dailyReservationChart"></div>
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
                todayScheduleList: [],
                menuChart: null,
                menuChartList: [],
                totalCount: 0,
                dailyChart: null,
                dailyChartList: []
            };
        },
        methods: {
            // 오늘의 일정 조회
                fnTodayScheduleList: function () {
                    let self = this;
                    let param = {};

                    $.ajax({
                        url: "/getTodayScheduleList.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result === "success") {
                                self.todayScheduleList = data.list;
                            } else {
                                self.todayScheduleList = [];
                                alert(data.message);
                            }
                        },
                        error: function () {
                            alert("오늘의 일정 조회 중 오류가 발생했습니다.");
                        }
                    });
                },

                fnMenuChartList: function () {
                    let self = this;
                    let param = {};

                    $.ajax({
                        url: "/getMenuChartList.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            if (data.result === "success") {
                                self.menuChartList = data.list;
                                self.fnRenderMenuChart();
                            } else {
                                self.menuChartList = [];
                                alert(data.message);
                            }
                        },
                        error: function () {
                            alert("메뉴 예약 분포 조회 중 오류가 발생했습니다.");
                        }
                    });
                },

                fnRenderMenuChart: function () {
                    let self = this;

                    let total = self.menuChartList.reduce((sum, item) => sum + item.reserveCount, 0);
                    self.totalCount = total;

                    self.menuChartList.forEach(item => {
                        item.percent = total > 0 ? ((item.reserveCount / total) * 100).toFixed(1) : 0;
                    });

                    let seriesData = self.menuChartList.map(item => item.reserveCount);
                    let labelData = self.menuChartList.map(item => item.menuName);

                    if (self.menuChart) {
                        self.menuChart.destroy();
                    }

                    let options = {
                        series: seriesData,
                        chart: {
                            type: 'pie',
                            width: 400,
                            height: 400
                        },
                        labels: labelData,
                        legend: {
                            show: false
                        }
                    };

                    self.menuChart = new ApexCharts(document.querySelector("#menuPieChart"), options);
                    self.menuChart.render();
                },

                fnDailyReservationChartList: function () {
                    let self = this;
                    let param = {};

                    $.ajax({
                        url: "/getDailyReservationChartList.dox",
                        dataType: "json",
                        type: "POST",
                        data: param,
                        success: function (data) {
                            console.log("daily chart data:", data);

                            if (data.result === "success") {
                                self.dailyChartList = data.list;
                                self.fnRenderDailyReservationChart();
                            } else {
                                self.dailyChartList = [];
                                alert(data.message);
                            }
                        },
                        error: function () {
                            alert("하루 예약 건수 조회 중 오류가 발생했습니다.");
                        }
                    });
                },

                fnRenderDailyReservationChart: function () {
                    let self = this;

                    // 1. 백엔드에서 받은 데이터를 날짜별로 map으로 정리
                    let dataMap = {};

                    self.dailyChartList.forEach(item => {
                        dataMap[item.rsvDate] = Number(item.reserveCount);
                    });

                    // 2. 최근 30일 날짜 배열 만들기
                    let categoryData = [];
                    let seriesData = [];

                    for (let i = 29; i >= 0; i--) {
                        let date = new Date();
                        date.setDate(date.getDate() - i);

                        let month = String(date.getMonth() + 1).padStart(2, '0');
                        let day = String(date.getDate()).padStart(2, '0');
                        let label = month + '-' + day;

                        categoryData.push(label);
                        seriesData.push(dataMap[label] || 0);
                    }

                    // 3. 기존 차트 제거
                    if (self.dailyChart) {
                        self.dailyChart.destroy();
                    }

                    // 4. 새 차트 생성
                    let options = {
                        series: [{
                            name: '예약 건수',
                            data: seriesData
                        }],
                        chart: {
                            type: 'line',
                            height: 350,
                            toolbar: {
                                show: false
                            }
                        },
                        stroke: {
                            curve: 'smooth',
                            width: 3
                        },
                        xaxis: {
                            categories: categoryData
                        },
                        yaxis: {
                            min: 0,
                            forceNiceScale: true
                        },
                        dataLabels: {
                            enabled: false
                        },
                        legend: {
                            show: false
                        },
                        tooltip: {
                            y: {
                                formatter: function (val) {
                                    return val + "건";
                                }
                            }
                        }
                    };

                    self.dailyChart = new ApexCharts(document.querySelector("#dailyReservationChart"), options);
                    self.dailyChart.render();
                },

        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnTodayScheduleList();
            self.fnMenuChartList();
            self.fnDailyReservationChartList();
        }
    });

    app.mount('#app');
</script>