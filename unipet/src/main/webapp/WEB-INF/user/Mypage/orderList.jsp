<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>

    <link href="/css/user/usermypage.css" rel="stylesheet">

    <title>UNIPET - 주문 내역</title>
</head>

<body>
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app" class="user-page-wrap" v-cloak>
        <div class="user-page-container">

            <jsp:include page="/WEB-INF/user/Mypage/sidebar.jsp">
                <jsp:param name="activeMenu" value="order" />
            </jsp:include>

            <main class="user-content">
                <div class="content-header">
                    <h1>주문 내역</h1>
                </div>

                <div class="page-inner">

                    <!-- 주문 목록 화면 -->
                    <div v-if="currentView === 'orderList'">
                        <div class="section-box">
                            <div class="section-title">쇼핑몰 주문 내역</div>

                            <select class="list-filter-select" v-model="orderSortType">
                                <option value="latest">최신순</option>
                                <option value="old">오래된순</option>
                                <option value="amountHigh">금액 높은순</option>
                                <option value="amountLow">금액 낮은순</option>
                            </select>

                            <div v-if="groupedOrderList.length === 0" class="empty-text">
                                주문 내역이 없습니다.
                            </div>

                            <div class="info-card"
                                 v-for="group in pagedOrderList"
                                 :key="group.orderNo"
                                 style="margin-bottom:16px;">

                                <!-- 주문 상단 -->
                                <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:14px;">
                                    <div>
                                        <div class="list-title">
                                            주문일자 : {{ fnFormatDateTime(group.orderDate) }}
                                        </div>
                                      
                                    </div>

                                    <!-- 주문건 기준 환불 버튼 -->
                                    <button class="small-btn btn-red"
                                            v-if="group.items.length > 0 && fnCanRefundOrder(group.items[0])"
                                            @click="fnGoRefundShop(group.items[0])">
                                        환불
                                    </button>
                                </div>

                                <!-- 상품 리스트 -->
                                <div v-for="order in group.items"
                                     :key="order.orderDetailNo || order.orderNo + '-' + order.productNo"
                                     class="order-item">

                                    <img class="order-img"
                                         :src="order.productImg || '/img/no-image.png'"
                                         alt="상품이미지">

                                    <div style="flex:1;">
                                        <div class="list-title">
                                            {{ order.productName || '-' }}
                                        </div>

                                        <div class="list-sub">
                                            수량 : {{ order.qty || 0 }}개
                                        </div>

                                        <div class="list-sub">
                                            금액 :
                                            {{ Number(order.price || 0).toLocaleString() }}원
                                        </div>

                                        <div class="list-status">
                                            결제상태 :
                                            {{ fnGetPayStatusText(order.payStatus || order.PAY_STATUS) }}
                                        </div>

                                        <div class="list-status"
                                             v-if="String(order.payStatus || order.PAY_STATUS || '').toUpperCase() !== 'CAN'">
                                            배송상태 :
                                            {{ fnGetDeliStatusText(order.deliStatus || order.DELI_STATUS) }}
                                        </div>

                                        <div class="btn-box" style="margin-top:8px;">
                                            <button class="small-btn"
                                                    v-if="fnCanWriteReview(order)"
                                                    @click="fnGoReview(order)">
                                                상품리뷰 작성
                                            </button>

                                            <button class="small-btn"
                                                    v-if="fnCanViewWrittenReview(order)"
                                                    @click="fnOpenWrittenReview(order)">
                                                작성완료 리뷰 보기
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- 주문 페이징 -->
                            <div class="btn-box paging-box" v-if="orderTotalPage > 1">
                                <button class="small-btn"
                                        :disabled="orderPage === 1"
                                        @click="orderPage--">
                                    이전
                                </button>

                                <span>
                                    {{ orderPage }} / {{ orderTotalPage }}
                                </span>

                                <button class="small-btn"
                                        :disabled="orderPage === orderTotalPage"
                                        @click="orderPage++">
                                    다음
                                </button>
                            </div>
                        </div>
                    </div>

                    <!-- 작성한 리뷰 상세 화면 -->
                    <div v-if="currentView === 'reviewDetail'">
                        <div class="section-box">
                            <div class="section-header">
                                <div class="section-title">리뷰 상세</div>
                                <button class="small-btn" @click="currentView = 'orderList'">
                                    주문목록으로
                                </button>
                            </div>

                            <div class="info-card">
                                <img class="order-img"
                                     :src="selectedReview.productImg || '/img/no-image.png'"
                                     alt="상품이미지">

                                <div class="list-title">
                                    {{ selectedReview.productName || '-' }}
                                </div>

                                <div class="list-sub">
                                    주문일자 : {{ fnFormatDateTime(selectedReview.orderDate) }}
                                </div>

                                <div class="list-sub">
                                    리뷰내용 :
                                    {{ selectedReview.reviewContent || selectedReview.REVIEW_CONTENT || '리뷰 없음' }}
                                </div>
                            </div>
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
                // 현재 화면
                currentView: "orderList",

                // 주문 목록
                orderList: [],

                // 정렬 / 페이징
                orderSortType: "latest",
                orderPage: 1,
                orderPageSize: 5,

                // 선택한 리뷰
                selectedReview: {}
            };
        },

        computed: {
            // 주문번호 기준으로 주문 묶기
            groupedOrderList() {
                const grouped = {};

                this.orderList.forEach(order => {
                    const orderNo = order.orderNo || order.ORD_NO || "주문번호없음";

                    if (!grouped[orderNo]) {
                        grouped[orderNo] = [];
                    }

                    grouped[orderNo].push(order);
                });

                return Object.keys(grouped).map(orderNo => {
                    return {
                        orderNo: orderNo,
                        orderDate: grouped[orderNo][0]?.orderDate || grouped[orderNo][0]?.ORD_DATE || "",
                        items: grouped[orderNo]
                    };
                });
            },

            // 정렬된 주문 목록
            sortedOrderList() {
                let list = [...this.groupedOrderList];

                if (this.orderSortType === "latest") {
                    list.sort((a, b) => new Date(b.orderDate) - new Date(a.orderDate));
                } else if (this.orderSortType === "old") {
                    list.sort((a, b) => new Date(a.orderDate) - new Date(b.orderDate));
                } else if (this.orderSortType === "amountHigh") {
                    list.sort((a, b) => this.fnGetOrderTotal(b) - this.fnGetOrderTotal(a));
                } else if (this.orderSortType === "amountLow") {
                    list.sort((a, b) => this.fnGetOrderTotal(a) - this.fnGetOrderTotal(b));
                }

                return list;
            },

            // 현재 페이지 주문 목록
            pagedOrderList() {
                const start = (this.orderPage - 1) * this.orderPageSize;
                return this.sortedOrderList.slice(start, start + this.orderPageSize);
            },

            // 총 페이지 수
            orderTotalPage() {
                return Math.ceil(this.sortedOrderList.length / this.orderPageSize);
            }
        },

        watch: {
            // 정렬 변경 시 첫 페이지로 이동
            orderSortType() {
                this.orderPage = 1;
            }
        },

        methods: {
            // 주문 목록 조회
            fnLoadOrderList: function () {
                let self = this;

                $.ajax({
                    url: "/user/order-list.dox",
                    dataType: "json",
                    type: "POST",
                    data: {},
                    success: function (data) {
                        self.orderList =
                            data.result === "success"
                                ? (data.orderList || [])
                                : [];
                    },
                    error: function () {
                        self.orderList = [];
                        alert("주문 내역을 불러오지 못했습니다.");
                    }
                });
            },

            // 주문 그룹 총액 계산
            fnGetOrderTotal: function (group) {
                if (!group.items || group.items.length === 0) {
                    return 0;
                }

                return group.items.reduce((sum, item) => {
                    return sum + Number(item.price || item.PRICE || 0) * Number(item.qty || item.QTY || 0);
                }, 0);
            },

            // 환불 가능 여부
            fnCanRefundOrder: function (order) {
                if (!order) {
                    return false;
                }

                const deliStatus = String(order.deliStatus || order.DELI_STATUS || "").trim().toUpperCase();
                const payStatus = String(order.payStatus || order.PAY_STATUS || "").trim().toUpperCase();

                if (deliStatus === "CAN" || deliStatus === "CANCEL" || deliStatus === "CMP") {
                    return false;
                }

                if (payStatus === "CAN" || payStatus === "CANCEL" || payStatus === "FAL") {
                    return false;
                }

                return true;
            },

            // 쇼핑몰 환불 페이지 이동
            fnGoRefundShop: function (order) {
                if (!order || !(order.orderNo || order.ORD_NO)) {
                    alert("환불에 필요한 주문 정보가 없습니다.");
                    return;
                }

                window.pageChange("/payment/refund-shop.do", {
                    ordNo: order.orderNo || order.ORD_NO
                });
            },

            // 상품 리뷰 작성 가능 여부
            fnCanWriteReview: function (order) {
                if (!order) {
                    return false;
                }

                const deliStatus = String(order.deliStatus || order.DELI_STATUS || "").trim().toUpperCase();
                const reviewYn = String(order.reviewYn || order.REVIEW_YN || "N").trim().toUpperCase();

                return deliStatus === "CMP" && reviewYn !== "Y";
            },

            // 작성완료 리뷰 보기 가능 여부
            fnCanViewWrittenReview: function (order) {
                if (!order) {
                    return false;
                }

                const deliStatus = String(order.deliStatus || order.DELI_STATUS || "").trim().toUpperCase();
                const reviewYn = String(order.reviewYn || order.REVIEW_YN || "N").trim().toUpperCase();

                return deliStatus === "CMP" && reviewYn === "Y";
            },

            // 상품 리뷰 작성 페이지 이동
            fnGoReview: function (order) {
                if (!order) {
                    return;
                }

                const productNo = order.productNo || order.PRODUCT_NO;
                const orderNo = order.orderNo || order.ORD_NO;

                if (!productNo || !orderNo) {
                    alert("리뷰 작성에 필요한 주문 정보가 없습니다.");
                    return;
                }

                window.pageChange("/user/mypage/prd-review.do", {
                    productNo: productNo,
                    ordNo: orderNo
                });
            },

            // 작성완료 리뷰 상세
            fnOpenWrittenReview: function (order) {
                this.selectedReview = order;
                this.currentView = "reviewDetail";
            },

            // 결제 상태 표시
            fnGetPayStatusText: function (status) {
                status = String(status || "").trim().toUpperCase();

                if (status === "RDY") return "결제대기";
                if (status === "PAY") return "결제완료";
                if (status === "CAN") return "결제취소";
                if (status === "FAL") return "결제실패";

                return status || "-";
            },

            // 배송 상태 표시
            fnGetDeliStatusText: function (status) {
                status = String(status || "").trim().toUpperCase();

                if (status === "RDY") return "배송준비";
                if (status === "SHP") return "배송중";
                if (status === "CMP") return "배송완료";
                if (status === "CAN") return "배송취소";

                return status || "-";
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
            this.fnLoadOrderList();
        }
    });

    app.mount("#app");
</script>

</body>
</html>