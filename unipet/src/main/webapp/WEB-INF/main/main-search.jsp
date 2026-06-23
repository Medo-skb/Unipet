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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/main-search.css">
</head>
<body>

    <!-- 헤더 -->
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app" class="search-page">

        <div class="search-container">

            <div v-if="!keyword || keyword.trim() === ''" class="search-empty">
                검색어를 입력해주세요.
            </div>

            <div v-else>
                <div class="search-page-title-box">
                    <h2 class="search-page-title">검색 결과</h2>
                    <p class="search-page-keyword">
                        '<span>{{ keyword }}</span>' 검색 결과입니다.
                    </p>
                </div>

                <!-- 업체 -->
                <section class="search-section">
                    <h3 class="search-section-title">업체</h3>

                    <div class="search-subsection">
                        <h4 class="search-subsection-title">병원</h4>

                        <div v-if="hospitalList.length > 0" class="search-list">
                            <div v-for="item in hospitalList.slice(0, 4)"
                                :key="item.storeNo"
                                class="search-card search-card-row"
                                @click="fnGoStore(item)">
                                <div class="search-thumb-wrap">
                                    <img v-if="item.filePath && item.fileName"
                                        :src="item.filePath + item.fileName"
                                        class="search-thumb-image"
                                        @error="handleImgError">

                                    <div v-else class="no-image-box">
                                        등록된 이미지가<br>없습니다.
                                    </div>
                                </div>

                                <div class="search-info">
                                    <div class="search-card-title">
                                        <span v-if="item.badgeText" class="badge">{{ item.badgeText }}</span>
                                        {{ item.storeName }}
                                    </div>

                                    <div v-if="item.menuName1" class="search-card-menu">
                                        {{ item.menuName1 }} - {{ item.menuPrice1 }}원 ~
                                    </div>

                                    <div class="search-card-desc">{{ item.sAddr }}</div>
                                </div>
                            </div>
                            <div v-if="hospitalCount > 4" class="search-more-wrap">
                                <div class="search-more-btn" @click="fnGoStorePage('HOS')">병원 더보기 ></div>
                            </div>
                        </div>

                        <div v-else class="search-empty">
                            검색된 병원이 없습니다.
                        </div>
                    </div>

                    <div class="search-subsection">
                        <h4 class="search-subsection-title">미용실</h4>

                        <div v-if="salonList.length > 0" class="search-list">
                            <div v-for="item in salonList.slice(0, 4)"
                                :key="item.storeNo"
                                class="search-card search-card-row"
                                @click="fnGoStore(item)">
                                <div class="search-thumb-wrap">
                                    <img v-if="item.filePath && item.fileName"
                                        :src="item.filePath + item.fileName"
                                        class="search-thumb-image"
                                        @error="handleImgError">

                                    <div v-else class="no-image-box">
                                        등록된 이미지가<br>없습니다.
                                    </div>
                                </div>

                                <div class="search-info">
                                    <div class="search-card-title">
                                        <span v-if="item.badgeText" class="badge">
                                            {{ item.badgeText }}
                                        </span>
                                        {{ item.storeName }}
                                    </div>

                                    <div v-if="item.menuName1" class="search-card-menu">
                                        {{ item.menuName1 }} - {{ item.menuPrice1 }}원 ~
                                    </div>

                                    <div class="search-card-desc">{{ item.sAddr }}</div>
                                </div>
                            </div>
                            <div v-if="salonCount > 4" class="search-more-wrap">
                                <div class="search-more-btn" @click="fnGoStorePage('SAL')">미용실 더보기 ></div>
                            </div>
                        </div>

                        <div v-else class="search-empty">
                            검색된 미용실이 없습니다.
                        </div>
                    </div>

                    <div class="search-subsection">
                        <h4 class="search-subsection-title">위탁시설</h4>

                        <div v-if="boardingList.length > 0" class="search-list">
                            <div v-for="item in boardingList.slice(0, 4)"
                                :key="item.storeNo"
                                class="search-card search-card-row"
                                @click="fnGoStore(item)">
                                <div class="search-thumb-wrap">
                                    <img v-if="item.filePath && item.fileName"
                                        :src="item.filePath + item.fileName"
                                        class="search-thumb-image"
                                        @error="handleImgError">

                                    <div v-else class="no-image-box">
                                        등록된 이미지가<br>없습니다.
                                    </div>
                                </div>

                                <div class="search-info">
                                    <div class="search-card-title">
                                        <span v-if="item.badgeText" class="badge">{{ item.badgeText }}</span>
                                        {{ item.storeName }}
                                    </div>

                                    <div v-if="item.menuName1" class="search-card-menu">
                                        {{ item.menuName1 }} - {{ item.menuPrice1 }}원 ~
                                    </div>

                                    <div class="search-card-desc">{{ item.sAddr }}</div>
                                </div>
                            </div>
                            <div v-if="boardingCount > 4" class="search-more-wrap">
                                <div class="search-more-btn" @click="fnGoStorePage('BRD')">위탁시설 더보기 ></div>
                            </div>
                        </div>

                        <div v-else class="search-empty">
                            검색된 위탁시설이 없습니다.
                        </div>
                    </div>
                </section>

                <!-- 상품 -->
                <section class="search-section">
                    <h3 class="search-section-title">상품</h3>

                    <div v-if="productList.length > 0" class="search-list">
                        <div v-for="item in productList.slice(0, 4)"
                            :key="item.productNo"
                            class="search-card search-card-row"
                            @click="fnGoProductDetail(item.productNo)">
                            <div class="search-thumb-wrap">
                                <img v-if="item.filePath && item.fileName"
                                    :src="item.filePath + item.fileName"
                                    class="search-thumb-image"
                                    @error="handleImgError">

                                <div v-else class="no-image-box">
                                    등록된 이미지가<br>없습니다.
                                </div>
                            </div>

                            <div class="search-info">
                                <div class="search-card-title">{{ item.productName }}</div>
                                <div class="search-card-price">{{ item.productPrice }}원</div>
                                <div class="search-card-rating">★ {{ item.rating }} ({{ item.reviewCount }})</div>
                                <div class="search-card-brand">{{ item.brand }}</div>
                                <div class="search-card-meta">
                                    {{ item.aMainType }}
                                    <span v-if="item.aSubType"> / {{ item.aSubType }}</span>
                                    <span v-if="item.iSubType"> / {{ item.iSubType }}</span>
                                </div>
                            </div>
                        </div>

                        <div v-if="productCount > 4" class="search-more-wrap">
                            <div class="search-more-btn" @click="fnGoProductPage">
                                상품 더보기 >
                            </div>
                        </div>
                    </div>

                    <div v-else class="search-empty">
                        검색된 상품이 없습니다.
                    </div>
                </section>

                <!-- 커뮤니티 -->
                <section class="search-section">
                    <h3 class="search-section-title">커뮤니티</h3>

                    <div class="search-subsection">
                        <h4 class="search-subsection-title">통합 게시판</h4>

                        <div v-if="totalBoardList.length > 0" class="search-list">
                            <div v-for="item in totalBoardList.slice(0, 4)"
                                :key="item.boardNo"
                                class="search-card"
                                @click="fnGoBoardDetail(item.boardNo)">
                                <div class="search-card-title">{{ fnRemoveHtml(item.title) }}</div>
                                <div class="search-card-desc board-content">{{ fnRemoveHtml(item.bContent) }}</div>
                            </div>
                            <div v-if="totalBoardCount > 4" class="search-more-wrap">
                                <div class="search-more-btn" @click="fnGoBoardPage(1)">
                                    통합 게시판 더보기 >
                                </div>
                            </div>
                        </div>

                        <div v-else class="search-empty">
                            검색된 통합 게시글이 없습니다.
                        </div>
                    </div>

                    <div class="search-subsection">
                        <h4 class="search-subsection-title">지역 게시판</h4>

                        <div v-if="localBoardList.length > 0" class="search-list">
                            <div v-for="item in localBoardList.slice(0, 4)"
                                :key="item.boardNo"
                                class="search-card"
                                @click="fnGoBoardDetail(item.boardNo)">
                                <div class="search-card-title">{{ fnRemoveHtml(item.title) }}</div>
                                <div class="search-card-desc board-content">{{ fnRemoveHtml(item.bContent) }}</div>
                            </div>
                            <div v-if="localBoardCount > 4" class="search-more-wrap">
                                <div class="search-more-btn" @click="fnGoBoardPage(2)">
                                    지역 게시판 더보기 >
                                </div>
                            </div>
                        </div>

                        <div v-else class="search-empty">
                            검색된 지역 게시글이 없습니다.
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </div>

    <!-- ============================= -->
    <!-- 푸터 -->
    <!-- ============================= -->
    <jsp:include page="/WEB-INF/footer/footer.jsp" />
</body>
</html>

<script>
    const keyword = "${keyword}"
    const app = Vue.createApp({
        data() {
            return {
                keyword: keyword,

                hospitalList: [],
                salonList: [],
                boardingList: [],

                hospitalCount: 0,
                salonCount: 0,
                boardingCount: 0,

                productList: [],
                productCount: 0,

                totalBoardList: [],
                localBoardList: [],

                totalBoardCount: 0,
                localBoardCount: 0
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnStoreList: function (sCategory) {
                let self = this;
                let param = {
                    keyword: self.keyword,
                    sCategory: sCategory
                };

                $.ajax({
                    url: "/getSearchStoreList.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.result == "success") {
                            if (sCategory === "HOS") self.hospitalList = data.list;
                            if (sCategory === "SAL") self.salonList = data.list;
                            if (sCategory === "BRD") self.boardingList = data.list;
                        } else {
                            if (sCategory === "HOS") self.hospitalList = [];
                            if (sCategory === "SAL") self.salonList = [];
                            if (sCategory === "BRD") self.boardingList = [];
                        }
                    },
                    error: function () {
                        if (sCategory === "HOS") self.hospitalList = [];
                        if (sCategory === "SAL") self.salonList = [];
                        if (sCategory === "BRD") self.boardingList = [];
                    }
                });
            },

            fnStoreCount: function (sCategory) {
                let self = this;
                let param = {
                    keyword: self.keyword,
                    sCategory: sCategory
                };

                $.ajax({
                    url: "/getSearchStoreCount.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.result == "success") {
                            if (sCategory === "HOS") self.hospitalCount = data.count;
                            if (sCategory === "SAL") self.salonCount = data.count;
                            if (sCategory === "BRD") self.boardingCount = data.count;
                        } else {
                            if (sCategory === "HOS") self.hospitalCount = 0;
                            if (sCategory === "SAL") self.salonCount = 0;
                            if (sCategory === "BRD") self.boardingCount = 0;
                        }
                    },
                    error: function () {
                        if (sCategory === "HOS") self.hospitalCount = 0;
                        if (sCategory === "SAL") self.salonCount = 0;
                        if (sCategory === "BRD") self.boardingCount = 0;
                    }
                });
            },

            fnProductList: function () {
                let self = this;
                let param = {
                    keyword: self.keyword
                };

                $.ajax({
                    url: "/getSearchProductList.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.result == "success") {
                            self.productList = data.list;
                        } else {
                            self.productList = [];
                        }
                    },
                });
            },

            fnProductCount: function () {
                let self = this;
                let param = {
                    keyword: self.keyword
                };

                $.ajax({
                    url: "/getSearchProductCount.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.result == "success") {
                            self.productCount = data.count;
                        } else {
                            self.productCount = 0;
                        }
                    },
                    error: function () {
                        self.productCount = 0;
                    }
                });
            },

            fnBoardList: function (bMainNo) {
                let self = this;
                let param = {
                    keyword: self.keyword,
                    bMainNo: bMainNo
                };

                $.ajax({
                    url: "/getSearchBoardList.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.result == "success") {
                            if (bMainNo == 1) self.totalBoardList = data.list;
                            if (bMainNo == 2) self.localBoardList = data.list;
                        } else {
                            if (bMainNo == 1) self.totalBoardList = [];
                            if (bMainNo == 2) self.localBoardList = [];
                        }
                    }
                });
            },

            fnBoardCount: function (bMainNo) {
                let self = this;
                let param = {
                    keyword: self.keyword,
                    bMainNo: bMainNo
                };

                $.ajax({
                    url: "/getSearchBoardCount.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.result == "success") {
                            if (bMainNo == 1) self.totalBoardCount = data.count;
                            if (bMainNo == 2) self.localBoardCount = data.count;
                        }
                    }
                });
            },

            fnGoStorePage: function (sCategory) {
                let self = this;
                location.href = "/main/search/store.do?keyword=" 
                    + encodeURIComponent(self.keyword) + "&sCategory=" + sCategory;
            },

            fnGoProductPage: function () {
                let self = this;
                location.href = "/main/search/product.do?keyword="
                    + encodeURIComponent(self.keyword);
            },

            fnGoBoardPage: function (bMainNo) {
                let self = this;
                location.href = "/main/search/board.do?keyword="
                    + encodeURIComponent(self.keyword)
                    + "&bMainNo=" + bMainNo;
            },

            handleImgError: function (event) {
                event.target.src = "${pageContext.request.contextPath}/img/no-image.png";
            },

            fnGoStore: function (item) {
                if (!item) {
                    return;
                }

                if (item.sStatus === "EXT") {
                    let addrPart = "";

                    if (item.sAddr) {
                        const addrArray = item.sAddr.split(" ");
                        addrPart = addrArray.length > 1 ? addrArray[1] : addrArray[0];
                    }

                    const keyword = addrPart + " " + item.storeName;
                    const naverMapUrl = "https://map.naver.com/v5/search/" + encodeURIComponent(keyword.trim());

                    window.open(naverMapUrl, "_blank");
                    return;
                }

                if (!item.storeNo) {
                    return;
                }

                location.href = "/reservation/store-detail.do?storeNo=" + item.storeNo;
            },

            fnGoProductDetail: function (productNo) {
                if (!productNo) {
                    return;
                }
                location.href = "/product/view.do?productNo=" + productNo;
            },

            fnGoBoardDetail: function (boardNo) {
                if (!boardNo) {
                    return;
                }
                location.href = "/board/view.do?boardNo=" + boardNo;
            },

            fnRemoveHtml: function (value) {
                if (!value) {
                    return "";
                }

                let temp = document.createElement("div");
                temp.innerHTML = value;

                return temp.textContent || temp.innerText || "";
            },

        }, // methods
        mounted() {
            let self = this;

            if (!self.keyword || self.keyword.trim() === "") {
                return;
            }

            self.fnStoreList("HOS");
            self.fnStoreList("SAL");
            self.fnStoreList("BRD");

            self.fnStoreCount("HOS");
            self.fnStoreCount("SAL");
            self.fnStoreCount("BRD");

            self.fnProductList();
            self.fnProductCount();

            self.fnBoardList(1);
            self.fnBoardList(2);

            self.fnBoardCount(1);
            self.fnBoardCount(2);
        }
    });

    app.mount('#app');
</script>