<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html lang="ko">

    <head>

        <!-- 문자 인코딩 -->
        <meta charset="UTF-8">

        <!-- 모바일 반응형 -->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

        <!-- Vue -->
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>



        <!-- 공통 페이지 이동 -->
        <script src="/js/page-change.js"></script>


        <!-- 마이페이지 CSS -->
        <link href="/css/user/usermypage.css" rel="stylesheet">

        <title>UNIPET</title>

    </head>

    <body>

        <!-- 헤더 -->
        <jsp:include page="/WEB-INF/header/header.jsp" />

        <!-- Vue 영역 -->
        <div id="app" class="user-page-wrap" v-cloak>

            <div class="user-page-container">
                <jsp:include page="/WEB-INF/user/Mypage/sidebar.jsp">
                    <jsp:param name="activeMenu" value="subscription" />
                </jsp:include>
                

                <!-- 본문 -->
                <main class="user-content">

                    <!-- 페이지 제목 -->
                    <div class="content-header">

                        <h1>구독 관리</h1>

                    </div>

                    <div class="page-inner">

                        <!-- 구독 정보 박스 -->
                        <div class="section-box">

                            <!-- 제목 -->
                            <div class="section-title">

                                구독 관리

                            </div>

                            <!-- 구독중일 경우 -->
                            <div v-if="subscriptionInfo
                                     && subscriptionInfo.status === '이용중'">

                                <!-- 구독 정보 -->
                                <div class="info-card">

                                    <!-- 상품명 -->
                                    <div class="list-title">

                                        {{ subscriptionInfo.planName }}

                                    </div>

                                    <!-- 상태 -->
                                    <div class="list-sub">

                                        상태 :
                                        {{ fnGetSubStatusText(subscriptionInfo.status) }}

                                    </div>

                                    <!-- 다음 결제일 -->
                                    <div class="list-sub">

                                        다음 결제일 :
                                        {{ subscriptionInfo.nextBillingDate || '-' }}

                                    </div>

                                    <!-- 자동결제 여부 -->
                                    <div class="list-sub">

                                        자동결제 :
                                        {{ subscriptionInfo.isAuto === 'Y'
                                        ? '사용중'
                                        : '미사용' }}

                                    </div>

                                </div>

                                <!-- 버튼 영역 -->
                                <div class="btn-box">

                                    <!-- 구독 해지 -->
                                    <button class="small-btn btn-red" @click="fnCancelSubscription">

                                        구독 해지

                                    </button>

                                    <!-- 결제내역 버튼 -->
                                    <button class="small-btn" @click="fnToggleSubscriptionPayList">

                                        {{ showSubscriptionPayList
                                        ? '결제내역 닫기'
                                        : '결제내역 보기' }}

                                    </button>

                                </div>

                                <!-- 안내 문구 -->
                                <div class="list-sub" v-if="subscriptionInfo.canChangeAuto !== 'Y'">

                                    구독 해지는 다음 결제일
                                    1일 전까지만 가능합니다.

                                </div>

                            </div>

                            <!-- 구독중이 아닐 경우 -->
                            <div v-else class="empty-text-box">

                                <p class="empty-msg">

                                    현재 이용 중인
                                    프리미엄 구독 상품이 없습니다.

                                </p>

                                <!-- 구독 페이지 이동 -->
                                <button class="small-btn" style="margin-top:5pt;" @click="fnGoToSubPage">

                                    프리미엄 구독하기

                                </button>

                            </div>

                        </div>

                        <!-- 결제내역 영역 -->
                        <div class="section-box" v-if="showSubscriptionPayList">

                            <!-- 제목 -->
                            <div class="section-title">

                                구독 결제내역

                            </div>

                            <!-- 데이터 없을 경우 -->
                            <div v-if="subscriptionPayList.length === 0" class="empty-text">

                                구독 결제내역이 없습니다.

                            </div>

                            <!-- 결제내역 반복 -->
                            <div class="info-card" v-for="item in subscriptionPayList" :key="item.subNo">

                                <!-- 금액 -->
                                <div class="list-title">

                                    {{ Number(item.subPrice || 0)
                                    .toLocaleString() }}원

                                </div>

                                <!-- 시작일 -->
                                <div class="list-sub">

                                    구독 시작일 :
                                    {{ item.startDate || '-' }}

                                </div>

                                <!-- 종료일 -->
                                <div class="list-sub">

                                    구독 종료일 :
                                    {{ item.endDate || '-' }}

                                </div>

                                <!-- 다음 결제일 -->
                                <div class="list-sub">

                                    다음 결제일 :
                                    {{ item.nextBillingDate || '-' }}

                                </div>

                                <!-- 상태 -->
                                <div class="list-sub">

                                    상태 :
                                    {{ item.statusText || '-' }}

                                </div>

                                <!-- 자동결제 -->
                                <div class="list-sub">

                                    자동결제 :
                                    {{ item.autoText || '-' }}

                                </div>

                            </div>

                        </div>

                    </div>

                </main>

            </div>

        </div>

        <!-- 푸터 -->
        <jsp:include page="/WEB-INF/footer/footer.jsp" />

    </body>

    </html>

    <script>

        // Vue 앱 생성
        const app = Vue.createApp({

            // 데이터 영역
            data() {

                return {

                    // 현재 구독 정보
                    subscriptionInfo: {},

                    // 결제내역 리스트
                    subscriptionPayList: [],

                    // 결제내역 열림 여부
                    showSubscriptionPayList: false

                };

            },

            methods: {

                // 현재 구독 정보 조회
                fnLoadSubscriptionInfo: function () {

                    let self = this;

                    let param = {};

                    $.ajax({

                        // 구독 정보 조회 API
                        url: "/user/subscription-info.dox",

                        dataType: "json",

                        type: "POST",

                        data: param,

                        success: function (data) {

                            // 조회 성공
                            if (data.result === "success") {

                                self.subscriptionInfo =
                                    data.subscriptionInfo || {};

                            } else {

                                self.subscriptionInfo = {};

                            }

                        },

                        error: function () {

                            alert("구독 정보를 불러오지 못했습니다.");

                        }

                    });

                },

                // 결제내역 조회
                fnLoadSubscriptionPayList: function () {

                    let self = this;

                    let param = {};

                    $.ajax({

                        // 결제내역 조회 API
                        url: "/user/subscription-pay-list.dox",

                        dataType: "json",

                        type: "POST",

                        data: param,

                        success: function (data) {

                            // 조회 성공
                            if (data.result === "success") {

                                self.subscriptionPayList =
                                    data.payList
                                    || data.subscriptionPayList
                                    || [];

                            } else {

                                self.subscriptionPayList = [];

                            }

                        },

                        error: function () {

                            alert("결제내역 조회 중 오류가 발생했습니다.");

                        }

                    });

                },

                // 결제내역 열기 / 닫기
                fnToggleSubscriptionPayList: function () {

                    // true / false 반전
                    this.showSubscriptionPayList =
                        !this.showSubscriptionPayList;

                    // 열었을 경우 조회
                    if (this.showSubscriptionPayList) {

                        this.fnLoadSubscriptionPayList();

                    }

                },

                // 구독 해지
                fnCancelSubscription: function () {

                    let self = this;

                    // 사용자 확인
                    if (!confirm("정말 구독을 해지하시겠습니까?")) {

                        return;

                    }

                    $.ajax({

                        // 구독 해지 API
                        url: "/user/cancel-subscription.dox",

                        dataType: "json",

                        type: "POST",

                        data: {},

                        success: function (data) {

                            // 결과 메시지 출력
                            alert(data.message || "처리되었습니다.");

                            // 구독 정보 새로고침
                            self.fnLoadSubscriptionInfo();

                        },

                        error: function () {

                            alert("구독 해지 중 오류가 발생했습니다.");

                        }

                    });

                },
                // 구독 결제 페이지 이동
                fnGoToSubPage: function () {
                    location.href = "/payment/sub.do";
                },


                // 상태 한글 변환
                fnGetSubStatusText: function (status) {

                    // 값 없을 경우
                    if (!status) {

                        return "-";

                    }

                    // 문자열 변환
                    status =
                        String(status)
                            .trim()
                            .toUpperCase();

                    // 상태값 변환
                    if (status === "Y"
                        || status === "이용중") {

                        return "이용중";

                    }

                    if (status === "N") {

                        return "해지";

                    }

                    if (status === "EXP") {

                        return "종료";

                    }

                    return status;

                }

            },

            // 페이지 시작 시 실행
            mounted() {

                let self = this;

                // 구독 정보 조회
                self.fnLoadSubscriptionInfo();

            }

        });

        // Vue mount
        app.mount("#app");

    </script>