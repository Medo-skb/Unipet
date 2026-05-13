<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNIPET</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="${pageContext.request.contextPath}/js/page-change.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main.css">
</head>

<body>
    <div class="page-layout">

        <jsp:include page="/WEB-INF/header/header.jsp" />

        <section class="main-banner-section">
            <div class="banner-slider" id="bannerSlider">

            <a href="${pageContext.request.contextPath}/main/kindergarten.do" class="banner-slide active">
                <img src="${pageContext.request.contextPath}/img/main/banner_1.png" 
                    class="banner-image">
            </a>

            <a href="${pageContext.request.contextPath}/reservation/store-detail.do?storeNo=3508" class="banner-slide">
                <img src="${pageContext.request.contextPath}/img/main/banner_2.png"
                    class="banner-image">
            </a>

            <a href="${pageContext.request.contextPath}/reservation/store-detail.do?storeNo=3538" class="banner-slide">
                <img src="${pageContext.request.contextPath}/img/main/banner_3.png" 
                    class="banner-image">
            </a>

                <div class="banner-overlay-inner">
                    <div class="banner-controls">
                        <button type="button" class="banner-btn prev-btn" id="prevBtn" aria-label="이전">
                            <svg viewBox="0 0 24 24" class="banner-arrow">
                                <path d="M15 6L9 12L15 18"></path>
                            </svg>
                        </button>

                        <button type="button" class="banner-btn next-btn" id="nextBtn" aria-label="다음">
                            <svg viewBox="0 0 24 24" class="banner-arrow">
                                <path d="M9 6L15 12L9 18"></path>
                            </svg>
                        </button>
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

        <div id="app">

            <div class="basic-info-modal-wrap" v-if="showBasicInfoModal">
                <div class="basic-info-modal-box">
                    <div class="basic-info-modal-title">기본정보 입력이 필요합니다</div>
                    <div class="basic-info-modal-text">
                        소셜 로그인 회원은 서비스 이용을 위해<br>
                        기본정보를 먼저 입력해야 합니다.
                    </div>
                    <button type="button" class="basic-info-modal-btn" @click="goBasicInfoPage">
                        기본정보 입력하러 가기
                    </button>
                </div>
            </div>

            <div class="container-main">

                <div class="under"></div>

                <div class="membership-banner-wrap">
                    <a href="${pageContext.request.contextPath}/payment/sub.do">
                        <img src="${pageContext.request.contextPath}/img/main/membership_banner.png" 
                            class="membership-banner-img">
                    </a>
                </div>
                
                <section class="main-store-section scroll-fade-up">
                    <div class="section-header">
                        <h2 class="section-title">최근 예약이 많은 업체</h2>
                    </div>

                    <div class="store-card-list">
                        <div class="store-card"
                            v-for="(item, index) in popularStoreList"
                            :key="index"
                            @click="fnGoStoreDetail(item.storeNo)">

                            <div class="store-image-box">
                                <img v-if="item.filePath && item.fileName"
                                    :src="item.filePath + item.fileName"
                                    class="store-image"
                                    @error="handleImgError">

                                <div v-else class="no-image-box">
                                    등록된 이미지가<br>없습니다.
                                </div>

                                <div class="store-rank-badge">{{ index + 1 }}</div>
                            </div>

                            <div class="store-card-body">
                                <div class="store-name-row">
                                    <div class="store-name">{{ item.storeName }}</div>
                                    <div class="store-category">{{ item.sCategoryName }}</div>
                                </div>

                                <div class="store-best-menu">
                                    {{ item.subTitle }}
                                </div>

                                <div class="store-address">
                                    {{ item.sAddr }}
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="main-product-section scroll-fade-up">
                    <div class="section-header">
                        <h2 class="section-title">최다 찜 상품</h2>
                    </div>

                    <div class="product-card-list">
                        <div class="product-card"
                            v-for="(item, index) in popularProductList"
                            :key="index"
                            @click="fnGoProductDetail(item.productNo)">

                            <div class="product-image-box">
                                <img v-if="item.filePath && item.fileName"
                                    :src="item.filePath + item.fileName"
                                    class="product-image"
                                    @error="handleImgError">

                                <div v-else class="no-image-box">
                                    등록된 이미지가<br>없습니다.
                                </div>

                                <div class="rank-badge">{{ index + 1 }}</div>
                            </div>

                            <div class="product-card-body">
                                <div class="product-name">{{ item.productName }}</div>
                                <div class="product-price">{{ fnFormatPrice(item.productPrice) }}원</div>
                            </div>
                        </div>
                    </div>
                </section>

                <section class="main-recommend-section scroll-fade-up">
                    <div class="recommend-section-block">

                        <div class="section-header">
                            <h2 class="section-title">카테고리별 인기 업체</h2>
                        </div>

                        <div class="category-tab-wrap">
                            <button
                                v-for="cate in categoryList"
                                :key="cate.code"
                                type="button"
                                class="category-tab-btn"
                                :class="{ active: selectedCategory === cate.code }"
                                @click="fnCategoryStoreList(cate.code)">
                                {{ cate.name }}
                            </button>
                        </div>

                        <div class="recommend-card-list">
                            <div class="recommend-card"
                                v-for="(item, index) in storeCategoryList"
                                :key="index"
                                @click="fnGoStoreDetail(item.storeNo)">

                                <div class="recommend-image-box">
                                    <img v-if="item.filePath && item.fileName"
                                        :src="item.filePath + item.fileName"
                                        class="recommend-image"
                                        @error="handleImgError">

                                    <div v-else class="no-image-box">
                                        등록된 이미지가<br>없습니다.
                                    </div>
                                </div>

                                <div class="recommend-card-body">
                                    <div class="recommend-name-row">
                                        <div class="recommend-name">{{ item.storeName }}</div>
                                        <div class="recommend-category">{{ item.sCategoryName }}</div>
                                    </div>

                                    <div class="recommend-reason">
                                        {{ item.subTitle }}
                                    </div>

                                    <div class="recommend-address">
                                        {{ item.sAddr }}
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div v-if="isCategoryStoreLoaded && storeCategoryList.length === 0" class="empty-text">
                            해당 카테고리의 업체가 없습니다.
                        </div>
                    </div>
                </section>

                <div class="recommend-section-block scroll-fade-up">
                    <div class="section-header">
                        <h2 class="section-title">동물별 인기 상품</h2>
                    </div>

                    <div class="category-tab-wrap">
                        <button
                            v-for="cate in animalCategoryList"
                            :key="cate.aMainNo"
                            type="button"
                            class="category-tab-btn"
                            :class="{ active: selectedAnimalCategory === cate.aMainNo }"
                            @click="fnAnimalProductList(cate.aMainNo)">
                            {{ cate.aMainType }}
                        </button>
                    </div>

                    <div class="recommend-card-list">
                        <div class="recommend-card"
                            v-for="(item, index) in productCategoryList"
                            :key="index"
                            @click="fnGoProductDetail(item.productNo)">

                            <div class="recommend-image-box">
                                <img v-if="item.filePath && item.fileName"
                                    :src="item.filePath + item.fileName"
                                    class="recommend-image"
                                    @error="handleImgError">

                                <div v-else class="no-image-box">
                                    등록된 이미지가<br>없습니다.
                                </div>
                            </div>

                            <div class="recommend-card-body">
                                <div class="recommend-name">{{ item.productName }}</div>
                                <div class="recommend-price">
                                    {{ fnFormatPrice(item.productPrice) }}원
                                </div>
                            </div>
                        </div>
                    </div>

                    <div v-if="isAnimalProductLoaded && productCategoryList.length === 0" class="empty-text">
                        해당 동물 카테고리의 상품이 없습니다.
                    </div>
                </div>

            </div>
        </div>

        <!-- 챗봇 플로팅 버튼 -->
        <div class="chatbot-floating-btn" onclick="location.href='/unipet/chatbot.do'">
            <div class="chatbot-icon">💬</div>
            <div class="chatbot-text">
                <strong>챗봇 상담</strong>
                <span>궁금한 점을 물어보세요</span>
            </div>
        </div>

        <jsp:include page="/WEB-INF/footer/footer.jsp" />

    </div>
</body>

</html>

<c:if test="${param.bizBlock eq 'Y'}">
    <script>
        alert('사업자 회원은 해당 메뉴를 이용할 수 없습니다.');
    </script>
</c:if>

<script>
    const app = Vue.createApp({
        data() {
            return {
                showBasicInfoModal: false,

                popularStoreList: [],
                popularProductList: [],
                storeCategoryList: [],
                productCategoryList: [],

                animalCategoryList: [],
                selectedAnimalCategory: null,
                animalProductCache: {},
                isAnimalProductLoaded: false,

                categoryList: [
                    { code: "HOS", name: "병원" },
                    { code: "SAL", name: "미용실" },
                    { code: "BRD", name: "위탁시설" },
                ],

                selectedCategory: "HOS",
                categoryStoreCache: {},
                isCategoryStoreLoaded: false
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnCheckSocialBasicInfo: function () {
                let self = this;

                $.ajax({
                    url: "/main/social-basic-check.dox",
                    dataType: "json",
                    type: "POST",
                    success: function (data) {
                        if (data.result === "success" && data.needBasicInfo === true) {
                            self.showBasicInfoModal = true;
                        }
                    },
                    error: function () {
                    }
                });
            },

            goBasicInfoPage: function () {
                location.href = "/user/phone-verify.do";
            },
            fnList: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "http://localhost:8080/getMainBasicList.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        self.popularStoreList = data.list || [];
                        self.popularProductList = data.list2 || [];
                        self.animalCategoryList = data.list5 || [];
                        self.fnInitAnimalCategory();
                    },
                    error: function (xhr, status, error) {
                }
                });
            },

            fnCategoryStoreList: function (category) {
                let self = this;

                self.selectedCategory = category;

                if (self.categoryStoreCache[category]) {
                    self.storeCategoryList = self.categoryStoreCache[category];
                    self.isCategoryStoreLoaded = true;
                    return;
                }

                $.ajax({
                    url: "/getMainBasicList.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        category: category,
                        subNo: 1
                    },
                    success: function (data) {
                        self.storeCategoryList = data.list3 || [];
                        self.categoryStoreCache[category] = data.list3 || [];
                        self.isCategoryStoreLoaded = true;
                    },
                    error: function (xhr, status, error) {
                        self.isCategoryStoreLoaded = true;
                    }
                });
            },

            fnInitAnimalCategory: function () {
                let self = this;

                if (self.animalCategoryList.length > 0 && !self.selectedAnimalCategory) {
                    self.selectedAnimalCategory = self.animalCategoryList[0].aMainNo;
                    self.fnAnimalProductList(self.selectedAnimalCategory);
                }
            },

            fnAnimalProductList: function (aMainNo) {
                let self = this;

                self.selectedAnimalCategory = aMainNo;

                // 이미 조회한 카테고리는 캐시 사용
                if (self.animalProductCache[aMainNo]) {
                    self.productCategoryList = self.animalProductCache[aMainNo];
                    self.isAnimalProductLoaded = true;
                    return;
                }

                self.isAnimalProductLoaded = false;

                $.ajax({
                    url: "/getMainBasicList.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        aMainNo: aMainNo
                    },
                    success: function (data) {
                        self.productCategoryList = data.list4 || [];
                        self.animalProductCache[aMainNo] = data.list4 || [];
                        self.isAnimalProductLoaded = true;
                    },
                    error: function (xhr, status, error) {
                        self.productCategoryList = [];
                        self.isAnimalProductLoaded = true;
                    }
                });
            },

            // 가격 콤마 처리
            fnFormatPrice: function (price) {
                if (price == null || price == "") {
                    return "0";
                }
                return Number(price).toLocaleString();
            },

            handleImgError: function (event) {
                event.target.src = "${pageContext.request.contextPath}/img/no-image.png";
            },

            fnGoStoreDetail: function (storeNo) {
                if (!storeNo) {
                    return;
                }
                location.href = "/reservation/store-detail.do?storeNo=" + storeNo;
            },

            fnGoProductDetail: function (productNo) {
                if (!productNo) {
                    return;
                }
                location.href = "/product/view.do?productNo=" + productNo;
            },

        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnList();
            self.fnCategoryStoreList(self.selectedCategory);
            <c:if test="${not empty sessionScope.sessionId and sessionScope.sessionRole eq 'USER'}">
                self.fnCheckSocialBasicInfo();
            </c:if>
            
        }
    });

    app.mount('#app');
    
</script>