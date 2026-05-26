<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <title>UNIPET - 쿠폰 관리</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>

    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/main/header.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/main/footer.css">
    <link rel="stylesheet"
          href="${pageContext.request.contextPath}/css/user/usermypage.css">

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
                    <h1>쿠폰 관리</h1>
                </div>

                <div class="page-inner">

                    <div class="section-box">
                        <div class="section-title">
                            쿠폰 관리
                        </div>

                        <div class="coupon-tabs">
                            <button class="small-btn"
                                    :class="{active: couponTab === 'ALL'}"
                                    @click="couponTab='ALL'">
                                전체
                            </button>

                            <button class="small-btn"
                                    :class="{active: couponTab === 'ABLE'}"
                                    @click="couponTab='ABLE'">
                                사용가능
                            </button>

                            <button class="small-btn"
                                    :class="{active: couponTab === 'USED'}"
                                    @click="couponTab='USED'">
                                사용완료
                            </button>

                            <button class="small-btn"
                                    :class="{active: couponTab === 'EXPIRED'}"
                                    @click="couponTab='EXPIRED'">
                                만료
                            </button>
                        </div>

                        <div v-if="filteredCouponList.length === 0"
                             class="empty-text">
                            쿠폰이 없습니다.
                        </div>

                        <div class="info-card"
                             v-for="coupon in filteredCouponList"
                             :key="coupon.couponNo || coupon.COUPON_NO">

                            <div>
                                <div class="list-title">
                                    {{ coupon.couponName || coupon.COUPON_NAME || '-' }}
                                </div>

                                <div class="list-sub">
                                    할인금액 :
                                    {{ Number(coupon.discountAmt || coupon.DISCOUNT_AMT || coupon.deduceprice || coupon.DEDUCEPRICE || 0).toLocaleString() }}원
                                </div>

                                <div class="list-sub">
                                    유효기간 :
                                    {{ fnFormatDateTime(coupon.startDate || coupon.START_DATE) }}
                                    ~
                                    {{ fnFormatDateTime(coupon.endDate || coupon.END_DATE || coupon.edate || coupon.EDATE) }}
                                </div>

                                <div class="list-sub">
                                    상태 :
                                    {{ fnGetCouponStatusText(coupon) }}
                                </div>

                                <div class="list-sub"
                                     v-if="fnGetCouponStatus(coupon) === 'USED'">
                                    사용 주문 :
                                    {{ coupon.orderProductText || coupon.ORDER_PRODUCT_TEXT || '주문 정보 없음' }}
                                </div>
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
                // 쿠폰 탭
                couponTab: "ALL",

                // 쿠폰 목록
                couponList: []
            };
        },

        computed: {
            // 탭에 따른 쿠폰 목록 필터
            filteredCouponList() {
                if (this.couponTab === "ALL") {
                    return this.couponList;
                }

                return this.couponList.filter(coupon => {
                    return this.fnGetCouponStatus(coupon) === this.couponTab;
                });
            }
        },

        methods: {
            // 쿠폰 목록 조회
            fnLoadCouponList: function () {
                let self = this;

                $.ajax({
                    url: "/user/coupon-list.dox",
                    dataType: "json",
                    type: "POST",
                    data: {},
                    success: function (data) {
                        if (data.result === "success" || data.result === true) {
                            self.couponList =
                                data.couponList ||
                                data.list ||
                                [];
                        } else {
                            self.couponList = [];
                        }
                    },
                    error: function () {
                        self.couponList = [];
                        alert("쿠폰 조회 실패");
                    }
                });
            },

            // 쿠폰 상태 계산
            fnGetCouponStatus: function (coupon) {
                const status =
                    String(coupon.cpStatus || coupon.CP_STATUS || "")
                        .trim()
                        .toUpperCase();

                const endDate =
                    coupon.endDate ||
                    coupon.END_DATE ||
                    coupon.edate ||
                    coupon.EDATE;

                if (status === "USED" || status === "USE") {
                    return "USED";
                }

                if (status === "EXP" || status === "EXPIRED") {
                    return "EXPIRED";
                }

                if (endDate) {
                    const today = new Date();
                    const expireDate = new Date(endDate);

                    today.setHours(0, 0, 0, 0);
                    expireDate.setHours(0, 0, 0, 0);

                    if (expireDate < today) {
                        return "EXPIRED";
                    }
                }

                return "ABLE";
            },

            // 쿠폰 상태 한글 변환
            fnGetCouponStatusText: function (coupon) {
                const status = this.fnGetCouponStatus(coupon);

                if (status === "ABLE") {
                    return "사용가능";
                }

                if (status === "USED") {
                    return "사용완료";
                }

                if (status === "EXPIRED") {
                    return "만료";
                }

                return "-";
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

            self.fnLoadCouponList();
        }
    });

    app.mount("#app");
</script>