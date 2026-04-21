<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

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

        <!-- 헤더 -->
        <jsp:include page="/WEB-INF/header/header.jsp" />

 
        <!-- 메인 배너 영역 -->
        <section class="main-banner-section">
            <div class="banner-slider" id="bannerSlider">

                <div class="banner-slide active">
                    <img src="${pageContext.request.contextPath}/img/main/banner_1.png" class="banner-image">
                </div>

                <div class="banner-slide">
                    <img src="${pageContext.request.contextPath}/img/main/banner_2.png" class="banner-image">
                </div>

                <div class="banner-slide">
                    <img src="${pageContext.request.contextPath}/img/main/banner_3.png" class="banner-image">
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

 
        <!-- 메인 컨텐츠 -->
        <div id="app">
            <div class="container-main">

                <div class="under"></div>

                <!-- 멤버십 배너 -->
                <div class="membership-banner-wrap">
                    <img src="${pageContext.request.contextPath}/img/main/membership_banner.png" 
                        class="membership-banner-img" 
                        alt="멤버십 배너">
                </div>

         
                <!-- 최근 예약이 많은 업체 -->
                <section class="main-store-section">
                    <div class="section-header">
                        <h2 class="section-title">최근 예약이 많은 업체</h2>
                    </div>

                    <div class="store-card-list">
                        <div class="store-card" v-for="(item, index) in popularStoreList" :key="index">
                            <div class="store-image-box">
                                <div class="store-image-placeholder">STORE IMAGE</div>
                                <div class="store-rank-badge">{{ index + 1 }}</div>
                            </div>

                            <div class="store-card-body">
                                <div class="store-name-row">
                                    <div class="store-name">{{ item.storeName }}</div>
                                    <div class="store-category">{{ item.sCategoryName }}</div>
                                </div>

                                <div class="store-best-menu">
                                    👍 {{ item.popularMenuName }}
                                </div>

                                <div class="store-address">
                                    {{ item.sAddr }}
                                </div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- 인기 상품 -->
                <section class="main-product-section">
                    <div class="section-header">
                        <h2 class="section-title">인기 상품</h2>
                    </div>

                    <div class="product-card-list">
                        <div class="product-card" v-for="(item, index) in popularProductList" :key="index">
                            <div class="product-image-box">
                                <div class="product-image-placeholder">PRODUCT IMAGE</div>
                                <div class="rank-badge">{{ index + 1 }}</div>
                            </div>

                            <div class="product-card-body">
                                <div class="product-name">{{ item.productName }}</div>
                                <div class="product-price">{{ fnFormatPrice(item.productPrice) }}원</div>
                            </div>
                        </div>
                    </div>
                </section>

                <!-- 카테고리별 추천 업체 -->
                <section class="main-recommend-section">
                <div class="recommend-section-block">
                    <div class="section-header">
                        <h2 class="section-title">카테고리별 추천 업체</h2>
                    </div>

                    <!-- 카테고리 버튼 -->
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

                    <!-- 업체 카드 -->
                    <div class="recommend-card-list">
                        <div class="recommend-card" v-for="(item, index) in storeCategoryList" :key="index">
                            <div class="recommend-image-box">
                                <div class="recommend-image-placeholder">STORE IMAGE</div>
                            </div>

                            <div class="recommend-card-body">
                                <div class="recommend-name-row">
                                    <div class="recommend-name">{{ item.storeName }}</div>
                                    <div class="recommend-category">{{ item.sCategoryName }}</div>
                                </div>

                                <div class="recommend-reason">
                                    선택한 카테고리의 추천 업체
                                </div>

                                <div class="recommend-address">
                                    {{ item.sAddr }}
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 데이터 없을 때 -->
                    <div v-if="isCategoryStoreLoaded && storeCategoryList.length === 0" class="empty-text">
                        해당 카테고리의 업체가 없습니다.
                    </div>
                </div>
            </section>

                    <!-- 카테고리별 추천 상품 -->
                    <div class="recommend-section-block">
                        <div class="section-header">
                            <h2 class="section-title">동물별 추천 상품</h2>
                        </div>

                        <!-- 동물 카테고리 버튼 -->
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

                        <!-- 상품 카드 -->
                        <div class="recommend-card-list">
                            <div class="recommend-card" v-for="(item, index) in productCategoryList" :key="index">
                                <div class="recommend-image-box">
                                    <div class="recommend-image-placeholder">PRODUCT IMAGE</div>
                                </div>

                                <div class="recommend-card-body">
                                    <div class="recommend-name">{{ item.productName }}</div>

                                    <div class="recommend-reason">
                                        선택한 동물 카테고리의 추천 상품
                                    </div>

                                    <div class="recommend-price">
                                        {{ fnFormatPrice(item.productPrice) }}원
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- 데이터 없을 때 -->
                        <div v-if="isAnimalProductLoaded && productCategoryList.length === 0" class="empty-text">
                            해당 동물 카테고리의 상품이 없습니다.
                        </div>
                    </div>
            </div>
        </div>

 
        <!-- 푸터 -->
        <jsp:include page="/WEB-INF/footer/footer.jsp" />

    </div>
</body>

</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                popularStoreList: [],
                popularProductList: [],
                storeCategoryList: [],
                productCategoryList: [],

                animalCategoryList: [],        // 버튼 목록
                selectedAnimalCategory: null,  // 선택된 카테고리
                animalProductCache: {},        // 캐시
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
            fnList: function () {
                let self = this;
                let param = {
                    category: "HOSPITAL", //임시
                    subNo: 1    //임시
                };
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
                    console.log("ajax 오류");
                    console.log(xhr.responseText);
                    console.log(status);
                    console.log(error);
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
                        console.log("카테고리 업체 조회 오류");
                        console.log(xhr.responseText);
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
                        console.log("동물 카테고리별 추천 상품 조회 오류");
                        console.log(xhr.responseText);
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
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnList();
            self.fnCategoryStoreList(self.selectedCategory);
            
        }
    });

    app.mount('#app');
</script>