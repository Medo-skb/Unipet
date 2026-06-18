<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNIPET - 예약 내역</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>

    <link href="/css/user/usermypage.css" rel="stylesheet">
</head>

<body>
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app" class="user-page-wrap" v-cloak>
        <div class="user-page-container">

            <jsp:include page="/WEB-INF/user/Mypage/sidebar.jsp" />

            <main class="user-content">
                <div class="content-header">
                    <h1>예약 내역</h1>
                </div>

                <div class="page-inner">
                    <div class="section-box">
                        <div class="section-header">
                            <div class="section-title" style="margin-bottom:0;">
                                예약 내역
                            </div>
                        </div>

                        <!-- 날짜 정렬 -->
                        <select class="list-filter-select" v-model="rsvSortDate">
                            <option value="latest">최신순(날짜)</option>
                            <option value="old">오래된순(날짜)</option>
                        </select>

                        <!-- 상세 정렬 -->
                        <select class="list-filter-select" v-model="rsvSortDetail">
                            <option value="timeAsc">시간 빠른순</option>
                            <option value="timeDesc">시간 늦은순</option>
                            <option value="status">예약상태순</option>
                        </select>

                        <div v-if="reservationAllList.length === 0" class="empty-text">
                            예약 내역이 없습니다.
                        </div>

                        <div v-for="group in pagedReservationList"
                             :key="group.date"
                             style="margin-bottom:20px;">

                            <div class="section-title" style="font-size:17px; margin-bottom:10px;">
                                {{ fnFormatDate(group.date) }}
                            </div>

                            <div class="info-card"
                                 v-for="item in group.items"
                                 :key="item.rsvNo || item.RSV_NO">

                                <div style="display:flex; justify-content:space-between; align-items:center; gap:12px;">
                                    <div style="flex:1;">
                                        <div class="list-title">
                                            {{ item.rsvStartTime || item.RSV_START_TIME || '-' }}
                                            ~
                                            {{ item.rsvEndTime || item.RSV_END_TIME || '-' }}
                                        </div>

                                        <div class="list-sub">
                                            예약처 :
                                            {{ item.storeName || item.STORE_NAME || '-' }}
                                        </div>

                                        <div class="list-sub">
                                            반려동물 :
                                            {{ item.petName || item.PET_NAME || '-' }}
                                        </div>

                                        <div class="list-sub">
                                            요청사항 :
                                            {{ item.request || item.REQUEST || '-' }}
                                        </div>

                                        <div class="list-sub">
                                            상태 :
                                            <span class="reserve-status-text"
                                                  :class="fnGetReserveStatusClass(item.rsvStatus || item.RSV_STATUS)">
                                                {{ fnGetReservationStatusText(item.rsvStatus || item.RSV_STATUS) }}
                                            </span>
                                        </div>
                                    </div>

                                    <div class="btn-box">
                                        <button class="small-btn"
                                                v-if="fnCanPayRsv(item)"
                                                @click="fnGoRsvPay(item)">
                                            예약결제
                                        </button>

                                        <button class="small-btn btn-red"
                                                v-if="fnCanRefundRsv(item)"
                                                @click="fnGoRefundRsv(item)">
                                            예약환불
                                        </button>

                                        <button class="small-btn"
                                                v-if="fnCanWriteRsvReview(item)"
                                                @click="fnGoRsvReview(item)">
                                            예약리뷰작성
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 페이징 -->
                        <div class="btn-box paging-box" v-if="rsvTotalPage > 1">
                            <button class="small-btn"
                                    :disabled="rsvPage === 1"
                                    @click="rsvPage--">
                                이전
                            </button>

                            <span>
                                {{ rsvPage }} / {{ rsvTotalPage }}
                            </span>

                            <button class="small-btn"
                                    :disabled="rsvPage === rsvTotalPage"
                                    @click="rsvPage++">
                                다음
                            </button>
                        </div>
                    </div>
                </div>
            </main>

        </div>
    </div>

    <jsp:include page="/WEB-INF/footer/footer.jsp" />

</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 전체 예약 목록
                reservationAllList: [],

                // 정렬
                rsvSortDate: "latest",
                rsvSortDetail: "timeAsc",

                // 페이징
                rsvPage: 1,
                rsvPageSize: 5
            };
        },

        computed: {
            // 날짜 기준 그룹
            groupedReservationList() {
                const grouped = {};

                this.reservationAllList.forEach(item => {
                    const date =
                        item.rsvDate ||
                        item.RSV_DATE ||
                        item.rsv_date ||
                        "날짜 없음";

                    if (!grouped[date]) {
                        grouped[date] = [];
                    }

                    grouped[date].push(item);
                });

                return Object.keys(grouped).map(date => {
                    return {
                        date: date,
                        items: grouped[date]
                    };
                });
            },

            // 정렬된 예약 목록
            sortedReservationList() {
                let list = [...this.groupedReservationList];

                // 날짜 그룹 정렬
                list.sort((a, b) => {
                    const dateA = new Date(a.date);
                    const dateB = new Date(b.date);

                    return this.rsvSortDate === "latest"
                        ? dateB - dateA
                        : dateA - dateB;
                });

                // 그룹 내부 정렬
                list.forEach(group => {
                    group.items.sort((a, b) => {
                        const aTime = a.rsvStartTime || a.RSV_START_TIME || "";
                        const bTime = b.rsvStartTime || b.RSV_START_TIME || "";

                        if (this.rsvSortDetail === "timeAsc") {
                            return String(aTime).localeCompare(String(bTime));
                        }

                        if (this.rsvSortDetail === "timeDesc") {
                            return String(bTime).localeCompare(String(aTime));
                        }

                        if (this.rsvSortDetail === "status") {
                            const aStatus = a.rsvStatus || a.RSV_STATUS || "";
                            const bStatus = b.rsvStatus || b.RSV_STATUS || "";
                            return String(aStatus).localeCompare(String(bStatus));
                        }

                        return 0;
                    });
                });

                return list;
            },

            // 현재 페이지 예약 목록
            pagedReservationList() {
                const start = (this.rsvPage - 1) * this.rsvPageSize;
                return this.sortedReservationList.slice(start, start + this.rsvPageSize);
            },

            // 총 페이지 수
            rsvTotalPage() {
                return Math.ceil(this.sortedReservationList.length / this.rsvPageSize);
            }
        },

        watch: {
            rsvSortDate() {
                this.rsvPage = 1;
            },

            rsvSortDetail() {
                this.rsvPage = 1;
            }
        },

        methods: {
            // 전체 예약 목록 조회
            fnLoadReservationAllList: function () {
                let self = this;
                let param = {};

                $.ajax({
                    url: "/user/reservation-all-list.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        self.reservationAllList =
                            data.result === "success"
                                ? (data.reservationList || [])
                                : [];
                    },
                    error: function () {
                        self.reservationAllList = [];
                        alert("전체 예약 내역을 불러오지 못했습니다.");
                    }
                });
            },

            // 예약 결제 가능 여부
            fnCanPayRsv: function (item) {
                const status =
                    String(item.rsvStatus || item.RSV_STATUS || "")
                        .trim()
                        .toUpperCase();

                return status === "WAI";
            },

            // 예약 환불 가능 여부
            fnCanRefundRsv: function (item) {
                const status =
                    String(item.rsvStatus || item.RSV_STATUS || "")
                        .trim()
                        .toUpperCase();

                return status === "CNF";
            },

            // 예약 리뷰 작성 가능 여부
            fnCanWriteRsvReview: function (item) {
                const status =
                    String(item.rsvStatus || item.RSV_STATUS || "")
                        .trim()
                        .toUpperCase();

                const reviewYn =
                    String(item.reviewYn || item.REVIEW_YN || "N")
                        .trim()
                        .toUpperCase();

                return status === "FIN" && reviewYn !== "Y";
            },

            // 예약 결제 페이지 이동
            fnGoRsvPay: function (item) {
                const rsvNo = item.rsvNo || item.RSV_NO;

                if (!rsvNo) {
                    alert("예약번호가 없습니다.");
                    return;
                }

                window.pageChange("/payment/pay-rsv.do", {
                    rsvNo: rsvNo
                });
            },

            // 예약 환불 페이지 이동
            fnGoRefundRsv: function (item) {
                const rsvNo = item.rsvNo || item.RSV_NO;

                if (!rsvNo) {
                    alert("예약 정보가 없습니다.");
                    return;
                }

                window.pageChange("/payment/refund-rsv.do", {
                    rsvNo: rsvNo
                });
            },

            // 예약 리뷰 작성 페이지 이동
            fnGoRsvReview: function (item) {
                const rsvNo = item.rsvNo || item.RSV_NO;

                if (!rsvNo) {
                    alert("예약번호가 없습니다.");
                    return;
                }

                window.pageChange("/user/mypage/rsv-review.do", {
                    rsvNo: rsvNo
                });
            },

            // 예약 상태 한글 표시
            fnGetReservationStatusText: function (status) {
                status =
                    String(status || "")
                        .trim()
                        .toUpperCase();

                if (status === "WAI") return "대기";
                if (status === "CNF") return "확정";
                if (status === "FIN") return "완료";
                if (status === "CAN") return "취소";

                return status || "-";
            },

            // 예약 상태 CSS
            fnGetReserveStatusClass: function (status) {
                status =
                    String(status || "")
                        .trim()
                        .toUpperCase();

                if (status === "WAI") return "status-orange";
                if (status === "CNF") return "status-blue";
                if (status === "FIN") return "status-green";
                if (status === "CAN") return "status-red";

                return "status-gray";
            },

            // 날짜 표시
            fnFormatDate: function (dateStr) {
                if (!dateStr || dateStr === "날짜 없음") {
                    return "-";
                }

                if (typeof dateStr === "string" && dateStr.length >= 10) {
                    return dateStr.substring(0, 10);
                }

                const date = new Date(dateStr);

                if (isNaN(date.getTime())) {
                    return "-";
                }

                const year = date.getFullYear();
                const month = ("0" + (date.getMonth() + 1)).slice(-2);
                const day = ("0" + date.getDate()).slice(-2);

                return `${year}-${month}-${day}`;
            }
        },

        mounted() {
            let self = this;

            // 처음 시작할 때 예약 목록 조회
            self.fnLoadReservationAllList();
        }
    });

    app.mount("#app");
</script>