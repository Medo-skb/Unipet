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

        <style>
            [v-cloak] {
                display: none;
            }
        </style>
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
                            <div class="section-title">
                                포인트 사용내역
                            </div>

                            <div v-if="pointUseList.length === 0" class="empty-text">
                                사용내역이 없습니다.
                            </div>

                            <div class="info-card" v-for="item in sortedPointUseList"
                                :key="item.pointNo || item.POINT_NO">

                                <div class="list-title"
                                    :class="Number(item.pointAmount ?? item.POINT_AMOUNT ?? 0) > 0 ? 'point-plus' : 'point-minus'">

                                    {{ Number(item.pointAmount ?? item.POINT_AMOUNT ?? 0) > 0 ? '+' : '' }}
                                    {{ Number(item.pointAmount ?? item.POINT_AMOUNT ?? 0).toLocaleString() }} P

                                </div>

                               
                                <!-- 적립 -->
                                <div class="list-sub" v-if="Number(item.pointAmount ?? item.POINT_AMOUNT ?? 0) > 0">

                                    적립내역 :
                                    {{ item.pointReason || item.POINT_REASON || '포인트 적립' }}

                                </div>

                                <!-- 사용 -->
                                <div class="list-sub" v-else>

                                    주문상품 :
                                    {{ item.orderProductText || item.ORDER_PRODUCT_TEXT || '-' }}

                                </div>



                                <div class="list-sub">
                                    날짜 :
                                    {{ fnFormatDateTime(item.cdate || item.CDATE) }}
                                </div>
                                 <div class="list-sub">
                                    잔액 :
                                    {{ Number(item.balance ?? item.BALANCE ?? 0).toLocaleString() }} P
                                </div>
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
                    // 현재 보유 포인트
                    point: 0,

                    // 포인트 사용내역
                    pointUseList: []
                };
            },

            computed: {
                // 포인트 내역 정렬
                sortedPointUseList() {
                    const list = [...this.pointUseList];

                    list.sort((a, b) => {
                        const dateA = new Date(a.cdate || a.CDATE);
                        const dateB = new Date(b.cdate || b.CDATE);

                        return dateB - dateA;
                    });

                    return list;
                }
            },

            methods: {
                // 현재 보유 포인트 조회
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

                // 포인트 사용내역 조회
                fnLoadPointUseList: function () {
                    let self = this;

                    $.ajax({
                        url: "/user/point-use-list.dox",
                        dataType: "json",
                        type: "POST",
                        data: {},
                        success: function (data) {
                            if (data.result === "success" || data.result === true) {
                                self.pointUseList =
                                    data.pointUseList ||
                                    data.list ||
                                    data.useList ||
                                    [];
                            } else {
                                self.pointUseList = [];
                            }
                        },
                        error: function () {
                            self.pointUseList = [];
                            alert("포인트 사용내역 조회 실패");
                        }
                    });
                },

                // 날짜 표시
                fnFormatDateTime: function (dateStr) {
                    if (!dateStr) {
                        return "-";
                    }

                    let str = String(dateStr).replace("T", " ");

                    if (str.length >= 16) {
                        return str.substring(0, 16);
                    }

                    return str;
                }
            },

            mounted() {
                let self = this;

                self.fnLoadPointInfo();
                self.fnLoadPointUseList();
            }
        });

        app.mount("#app");
    </script>