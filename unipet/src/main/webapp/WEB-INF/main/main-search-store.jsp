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
                <h2 class="search-page-title">{{ pageTitle }}</h2>
                <p class="search-page-keyword">
                    '<span>{{ keyword }}</span>' 검색 결과입니다.
                </p>
            </div>

            <section class="search-section">
                <div v-if="storeList.length > 0" class="search-list">
                    <div v-for="item in storeList"
                        :key="item.storeNo"
                        class="search-card search-card-row"
                        @click="fnGoStore(item)">
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
                            <div class="search-card-title">
                                <span v-if="item.badgeText" class="badge">
                                    {{ item.badgeText }}
                                </span>
                                {{ item.storeName }}
                            </div>

                            <div v-if="item.menuName1" class="search-card-menu">
                                {{ item.menuName1 }} - {{ item.menuPrice1 }}원
                            </div>

                            <div class="search-card-desc">{{ item.sAddr }}</div>
                        </div>
                    </div>
                </div>

                <div v-else class="search-empty">
                    검색된 업체가 없습니다.
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
    const sCategory = "${sCategory}";

    const app = Vue.createApp({
        data() {
            return {
                keyword: keyword,
                sCategory: sCategory,
                storeList: []
            };
        },
        computed: {
            pageTitle() {
                if (this.sCategory === "HOS") return "병원 검색 결과";
                if (this.sCategory === "SAL") return "미용실 검색 결과";
                if (this.sCategory === "BRD") return "위탁시설 검색 결과";
                return "업체 검색 결과";
            }
        },
        methods: {
            fnStoreList: function () {
                let self = this;
                let param = {
                    keyword: self.keyword,
                    sCategory: self.sCategory
                };

                $.ajax({
                    url: "/getSearchStoreList.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.result == "success") {
                            self.storeList = data.list;
                        } else {
                            self.storeList = [];
                        }
                    },
                    error: function () {
                        self.storeList = [];
                    }
                });
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
        },
        mounted() {
            let self = this;

            if (!self.keyword || self.keyword.trim() === "") {
                return;
            }

            self.fnStoreList();
        }
    });

    app.mount("#app");
</script>