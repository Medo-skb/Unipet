<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>UNIPET - 포인트 현황</title>

        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="/js/page-change.js"></script>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/usermypage.css">
    </head>

    <body>
        <jsp:include page="/WEB-INF/header/header.jsp" />

        <div id="app" class="user-page-wrap" v-cloak>
            <div class="user-page-container">

                <jsp:include page="/WEB-INF/user/Mypage/sidebar.jsp" />

                <main class="user-content">
                    <div class="content-header">
                        <h1>포인트 현황</h1>
                    </div>

                    <div class="page-inner">

                        <!-- 포인트 현황 -->
                        <div class="section-box">
                            <div class="section-title">
                                포인트 현황
                            </div>

                            <div class="info-card">
                                <div class="list-title">
                                    현재 보유 포인트
                                </div>

                                <div class="list-sub point-current">
                                    {{ Number(point || 0).toLocaleString() }} P
                                </div>
                            </div>
                        </div>

                        <!-- 포인트 사용내역 -->
                        <div class="section-box">
                            <div class="point-top-area">
                                <div class="section-title" style="margin-bottom:0;">
                                    포인트 사용내역
                                </div>

                                <div class="point-sort-box">
                                    <label>기간</label>
                                    <input type="date" v-model="searchStartDate">
                                    <span>~</span>
                                    <input type="date" v-model="searchEndDate">

                                    <button type="button" class="small-btn" @click="fnSearchByDate">
                                        조회
                                    </button>

                                    <button type="button" class="small-btn" @click="fnResetSearch">
                                        초기화
                                    </button>

                                    <label>정렬</label>
                                    <select v-model="sortType" @change="fnChangeSort">
                                        <option value="DESC">최신순</option>
                                        <option value="ASC">오래된순</option>
                                    </select>
                                </div>
                            </div>

                            <div v-if="pointUseList.length === 0" class="empty-text">
                                사용내역이 없습니다.
                            </div>

                            <!-- 날짜별 그룹 + 페이징 -->
                            <div v-for="group in pagedGroupedPointUseList" :key="group.date">

                                <div class="point-date-title">
                                    {{ group.date }}
                                </div>

                                <div class="info-card" v-for="item in group.list" :key="item.pointNo || item.POINT_NO">

                                    <div class="list-title"
                                        :class="Number(item.pointAmount ?? item.POINT_AMOUNT ?? 0) > 0 ? 'point-plus' : 'point-minus'">

                                        {{ Number(item.pointAmount ?? item.POINT_AMOUNT ?? 0) > 0 ? '+' : '' }}
                                        {{ Number(item.pointAmount ?? item.POINT_AMOUNT ?? 0).toLocaleString() }} P

                                    </div>

                                    <!-- 적립 -->
                                    <div class="list-sub" v-if="Number(item.pointAmount ?? item.POINT_AMOUNT ?? 0) > 0">
                                        적립내역 :
                                        {{ item.pointReason || item.POINT_REASON || item.orderProductText ||
                                        item.ORDER_PRODUCT_TEXT || '포인트 적립' }}
                                    </div>

                                    <!-- 사용 -->
                                    <div class="list-sub" v-else>
                                        주문상품 :
                                        {{ item.orderProductText || item.ORDER_PRODUCT_TEXT || '-' }}
                                    </div>

                                    <div class="list-sub point-time">
                                        시간 :
                                        {{ fnFormatTimeOnly(item.cdate || item.CDATE) }}
                                    </div>

                                    <div class="list-sub">
                                        잔액 :
                                        {{ Number(item.balance ?? item.BALANCE ?? 0).toLocaleString() }} P
                                    </div>

                                </div>
                            </div>

                            <!-- 페이징 -->
                            <div class="paging-box" v-if="pointUseList.length > 0">
                                <button type="button" @click="fnPrevPage" :disabled="page <= 1">
                                    이전
                                </button>

                                <span>{{ page }} / {{ totalPage }}</span>

                                <button type="button" @click="fnNextPage" :disabled="page >= totalPage">
                                    다음
                                </button>
                            </div>

                        </div>

                    </div>
                </main>

            </div>
        </div>

        <jsp:include page="/WEB-INF/footer/footer.jsp" />

        <script>
            const app = Vue.createApp({
                data() {
                    return {
                        point: 0,
                        pointUseList: [],

                        sortType: "DESC",
                        page: 1,
                        pageSize: 10,
                        searchStartDate: "",
                        searchEndDate: "",
                    };
                },

                computed: {
                    sortedPointUseList() {
                        const list = [...this.pointUseList];

                        list.sort((a, b) => {
                            const dateA = new Date(a.cdate || a.CDATE);
                            const dateB = new Date(b.cdate || b.CDATE);

                            return this.sortType === "DESC"
                                ? dateB - dateA
                                : dateA - dateB;
                        });

                        return list;
                    },

                    pagedPointUseList() {
                        const start = (this.page - 1) * this.pageSize;
                        const end = start + this.pageSize;

                        return this.sortedPointUseList.slice(start, end);
                    },

                    pagedGroupedPointUseList() {
                        const groups = {};

                        this.pagedPointUseList.forEach(item => {
                            const date = this.fnFormatDateOnly(item.cdate || item.CDATE);

                            if (!groups[date]) {
                                groups[date] = [];
                            }

                            groups[date].push(item);
                        });

                        return Object.keys(groups).map(date => ({
                            date: date,
                            list: groups[date]
                        }));
                    },

                    totalPage() {
                        return Math.ceil(this.pointUseList.length / this.pageSize) || 1;
                    }
                },

                methods: {
                    fnLoadPointInfo: function () {
                        let self = this;

                        $.ajax({
                            url: "/user/point-info.dox",
                            dataType: "json",
                            type: "POST",
                            data: {},
                            success: function (data) {
                                if (data.result === "success" || data.result === true) {
                                    if (data.info) {
                                        self.point =
                                            data.info.point ||
                                            data.info.POINT ||
                                            0;
                                    } else {
                                        self.point =
                                            data.point ||
                                            data.totalPoint ||
                                            0;
                                    }
                                } else {
                                    self.point = 0;
                                }
                            },
                            error: function () {
                                self.point = 0;
                                alert("포인트 조회 실패");
                            }
                        });
                    },

                    fnLoadPointUseList: function () {
                        let self = this;

                        $.ajax({
                            url: "/user/point-use-list.dox",
                            dataType: "json",
                            type: "POST",
                            data: {
                                startDate: self.searchStartDate,
                                endDate: self.searchEndDate
                            },
                            success: function (data) {
                                if (data.result === "success" || data.result === true) {
                                    self.pointUseList =
                                        data.pointUseList ||
                                        data.list ||
                                        data.useList ||
                                        [];

                                    self.page = 1;
                                } else {
                                    self.pointUseList = [];
                                    self.page = 1;
                                }
                            },
                            error: function () {
                                self.pointUseList = [];
                                self.page = 1;
                                alert("포인트 사용내역 조회 실패");
                            }
                        });
                    },

                    fnChangeSort: function () {
                        this.page = 1;
                    },

                    fnPrevPage: function () {
                        if (this.page > 1) {
                            this.page--;
                        }
                    },

                    fnNextPage: function () {
                        if (this.page < this.totalPage) {
                            this.page++;
                        }
                    },

                    fnSearchByDate: function () {
                        if (this.searchStartDate && this.searchEndDate) {
                            if (this.searchStartDate > this.searchEndDate) {
                                alert("시작일은 종료일보다 늦을 수 없습니다.");
                                return;
                            }
                        }

                        this.page = 1;
                        this.fnLoadPointUseList();
                    },

                    fnResetSearch: function () {
                        this.searchStartDate = "";
                        this.searchEndDate = "";
                        this.page = 1;
                        this.fnLoadPointUseList();
                    },

                    fnFormatDateOnly: function (dateStr) {
                        if (!dateStr) {
                            return "날짜 없음";
                        }

                        let str = String(dateStr).replace("T", " ");

                        return str.length >= 10
                            ? str.substring(0, 10)
                            : str;
                    },

                    fnFormatTimeOnly: function (dateStr) {
                        if (!dateStr) {
                            return "-";
                        }

                        let str = String(dateStr).replace("T", " ");

                        return str.length >= 16
                            ? str.substring(11, 16)
                            : "-";
                    }
                },

                mounted() {
                    this.fnLoadPointInfo();
                    this.fnLoadPointUseList();
                }
            });

            app.mount("#app");
        </script>

    </body>

    </html>