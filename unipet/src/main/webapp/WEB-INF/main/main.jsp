<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>메인</title>

    <!-- 라이브러리 -->
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

    <!-- 공통 스크립트 -->
    <script src="${pageContext.request.contextPath}/js/page-change.js"></script>

    <!-- 메인 CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css">
</head>

<body>
<div class="page-layout">

    <!-- ============================= -->
    <!-- 헤더 -->
    <!-- ============================= -->
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <!-- ============================= -->
    <!-- 메인 배너 영역 -->
    <!-- ============================= -->
    <section class="main-banner-section">
        <div class="banner-slider" id="bannerSlider">

            <div class="banner-slide active">
                <img src="${pageContext.request.contextPath}/img/main/banner_orange.png" class="banner-image">
            </div>

            <div class="banner-slide">
                <img src="${pageContext.request.contextPath}/img/main/banner_green.png" class="banner-image">
            </div>

            <div class="banner-slide">
                <img src="${pageContext.request.contextPath}/img/main/banner_red.png" class="banner-image">
            </div>

            <div class="banner-overlay-inner">
                <div class="banner-controls">
                    <button type="button" class="banner-btn prev-btn" id="prevBtn">‹</button>
                    <button type="button" class="banner-btn next-btn" id="nextBtn">›</button>
                </div>
            </div>

            <div class="banner-dots">
                <span class="banner-dot active" data-index="0"></span>
                <span class="banner-dot" data-index="1"></span>
                <span class="banner-dot" data-index="2"></span>
            </div>
        </div>
    </section>

    <script src="${pageContext.request.contextPath}/js/main/main.js"></script>

    <!-- ============================= -->
    <!-- 메인 컨텐츠 -->
    <!-- ============================= -->
    <div id="app">
        <div class="container-main">

            <div class="under"></div>

            <!-- ============================= -->
            <!-- 기본 출력 영역 -->
            <!-- - 최근 예약 많은 업체 -->
            <!-- - 인기상품 -->
            <!-- ============================= -->

            <!-- 최근 예약 많은 업체 -->
            <section class="main-store-section">
                <div class="section-header">
                    <h2 class="section-title">최근 예약이 많은 업체</h2>
                </div>

                <div class="store-card-list">
                    <div class="store-card" v-for="(item, index) in popularStoreList" :key="item.storeNo">
                        <div class="store-image-box">
                            <div class="store-rank-badge">{{ index + 1 }}</div>
                            <div class="store-image-placeholder">STORE IMAGE</div>
                        </div>

                        <div class="store-card-body">
                            <div class="store-name-row">
                                <div class="store-name">{{ item.storeName }}</div>
                                <div class="store-category">{{ item.sCategoryName }}</div>
                            </div>

                            <div class="store-best-menu" v-if="item.popularMenuName">
                                👍 {{ item.popularMenuName }}
                            </div>

                            <div class="store-address">{{ item.sAddr }}</div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- 인기상품 -->
            <section class="main-product-section">
                <div class="section-header">
                    <h2 class="section-title">인기상품</h2>
                </div>

                <div class="product-card-list">
                    <div class="product-card" v-for="(item, index) in popularProductList" :key="item.productNo">
                        <div class="product-image-box">
                            <div class="rank-badge">{{ index + 1 }}</div>
                            <div class="product-image-placeholder">IMAGE</div>
                        </div>

                        <div class="product-card-body">
                            <div class="product-name">{{ item.productName }}</div>
                            <div class="product-price">
                                {{ Number(item.productPrice).toLocaleString() }}원
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- ============================= -->
            <!-- 추천 영역 (로그인 사용자) -->
            <!-- ============================= -->
            <section class="main-recommend-section" v-if="isLogin">

                <!-- 찜 기반 추천 -->
                <div class="recommend-section-block" v-if="wishRecommendList.length > 0">
                    <div class="section-header">
                        <h2 class="section-title">찜한 상품과 비슷한 추천</h2>
                    </div>

                    <div class="recommend-card-list">
                        <div class="recommend-card" v-for="item in wishRecommendList">
                            <div class="recommend-image-box">
                                <div class="recommend-image-placeholder">PRODUCT IMAGE</div>
                            </div>

                            <div class="recommend-card-body">
                                <div class="recommend-name">{{ item.productName }}</div>
                                <div class="recommend-reason">
                                    찜한 상품과 같은 카테고리의 추천 상품이에요
                                </div>
                                <div class="recommend-price">
                                    {{ Number(item.productPrice).toLocaleString() }}원
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- 예약 기반 추천 -->
                <div class="recommend-section-block" v-if="reserveRecommendList.length > 0">
                    <div class="section-header">
                        <h2 class="section-title">예약 내역 기반 추천</h2>
                    </div>

                    <div class="recommend-card-list">
                        <div class="recommend-card" v-for="item in reserveRecommendList">
                            <div class="recommend-image-box">
                                <div class="recommend-image-placeholder">PRODUCT IMAGE</div>
                            </div>

                            <div class="recommend-card-body">
                                <div class="recommend-name">{{ item.productName }}</div>
                                <div class="recommend-reason">{{ item.recommendReason }}</div>
                                <div class="recommend-price">
                                    {{ Number(item.productPrice).toLocaleString() }}원
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

            </section>

        </div>
    </div>

    <!-- ============================= -->
    <!-- 푸터 -->
    <!-- ============================= -->
    <jsp:include page="/WEB-INF/footer/footer.jsp" />

</div>

<!-- ============================= -->
<!-- Vue -->
<!-- ============================= -->
<script>
const app = Vue.createApp({
    data() {
        return {
            isLogin: false,
            popularStoreList: [],
            popularProductList: [],
            wishRecommendList: [],
            reserveRecommendList: []
        };
    },
    methods: {
        fnList() {
            const self = this;

            $.ajax({
                url: "/api/main/basic",
                dataType: "json",
                type: "GET",
                success(data) {
                    self.isLogin = data.isLogin || false;
                    self.popularStoreList = data.popularStoreList || [];
                    self.popularProductList = data.popularProductList || [];
                    self.wishRecommendList = data.wishRecommendList || [];
                    self.reserveRecommendList = data.reserveRecommendList || [];
                }
            });
        }
    },
    mounted() {
        this.fnList();
    }
});

app.mount("#app");
</script>

</body>
</html>