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

            <div class="search-page-title-box">
                <h2 class="search-page-title">상품 검색 결과</h2>
                <p class="search-page-keyword">
                    '<span>{{ keyword }}</span>' 검색 결과입니다.
                </p>
            </div>

            <section class="search-section">
                <div v-if="productList.length > 0" class="search-list">
                    <div v-for="item in productList"
                        :key="item.productNo"
                        class="search-card search-card-row"
                        @click="fnGoProductDetail(item.productNo)">
                        <div class="search-thumb-wrap">
                            <img v-if="item.filePath && item.fileName"
                                :src="item.filePath + item.fileName"
                                alt="이미지"
                                class="search-thumb-image"
                                @error="handleImgError">

                            <div v-else class="no-image-box">
                                등록된 이미지가<br>없습니다.
                            </div>
                        </div>

                        <div class="search-info">
                            <div class="search-card-title">{{ item.productName }}</div>

                            <div class="search-card-price">
                                {{ item.productPrice }}원
                            </div>

                            <div class="search-card-rating">
                                ★ {{ item.rating }} ({{ item.reviewCount }})
                            </div>

                            <div class="search-card-brand">{{ item.brand }}</div>

                            <div class="search-card-meta">
                                {{ item.aMainType }}
                                <span v-if="item.aSubType"> / {{ item.aSubType }}</span>
                                <span v-if="item.iSubType"> / {{ item.iSubType }}</span>
                            </div>
                        </div>
                    </div>
                </div>

                <div v-else class="search-empty">
                    검색된 상품이 없습니다.
                </div>
            </section>
        </div>
    </div>

    <!-- 푸터 -->
    <jsp:include page="/WEB-INF/footer/footer.jsp" />
</body>
</html>

<script>
const keyword = "${keyword}";

const app = Vue.createApp({
    data() {
        return {
            keyword: keyword,
            productList: []
        };
    },
    methods: {
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
                error: function () {
                    self.productList = [];
                }
            });
        },
        
        handleImgError: function (event) {
            event.target.src = "${pageContext.request.contextPath}/img/no-image.png";
        },

        fnGoProductDetail: function (productNo) {
            if (!productNo) {
                return;
            }
            location.href = "/product/view.do?productNo=" + productNo;
        },
    },
    mounted() {
        let self = this;

        if (!self.keyword || self.keyword.trim() === "") {
            return;
        }

        self.fnProductList();
    }
});

app.mount("#app");
</script>