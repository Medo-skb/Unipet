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

</head>
<body>
    <!-- ============================= -->
    <!-- 헤더 -->
    <!-- ============================= -->
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">

        <div v-if="keyword && keyword.trim() !== ''">
            <h3>업체</h3>

            <div>
                <h4>병원</h4>

                <div v-if="hospitalList.length > 0">
                    <div v-for="item in hospitalList" :key="item.storeNo">
                        <div>{{ item.storeName }}</div>
                        <div>{{ item.sAddr }}</div>
                        <hr>
                    </div>
                    <div v-if="hospitalCount > 4">병원 더보기 ></div>
                </div>

                <div v-else>
                    검색된 병원이 없습니다.
                </div>
            </div>

            <div>
                <h4>미용실</h4>

                <div v-if="salonList.length > 0">
                    <div v-for="item in salonList" :key="item.storeNo">
                        <div>{{ item.storeName }}</div>
                        <div>{{ item.sAddr }}</div>
                        <hr>
                    </div>
                    <div v-if="salonCount > 4">미용실 더보기 ></div>
                </div>

                <div v-else>
                    검색된 미용실이 없습니다.
                </div>
            </div>

            <div>
                <h4>위탁시설</h4>

                <div v-if="boardingList.length > 0">
                    <div v-for="item in boardingList" :key="item.storeNo">
                        <div>{{ item.storeName }}</div>
                        <div>{{ item.sAddr }}</div>
                        <hr>
                    </div>
                    <div v-if="boardingCount > 4">위탁시설 더보기 ></div>
                </div>

                <div v-else>
                    검색된 위탁시설이 없습니다.
                </div>
            </div>
        </div>

        <div v-if="keyword && keyword.trim() !== ''">
            <h3>상품</h3>

            <div v-if="productList.length > 0">
                <div v-for="item in productList" :key="item.productNo">
                    <div>{{ item.productName }}</div>
                    <div>{{ item.brand }}</div>
                    <div>
                        {{ item.aMainType }}
                        <span v-if="item.aSubType"> / {{ item.aSubType }}</span>
                        <span v-if="item.iSubType"> / {{ item.iSubType }}</span>
                    </div>
                    <hr>
                </div>

                <div v-if="productCount > 4">상품 더보기 ></div>
            </div>

            <div v-else>
                검색된 상품이 없습니다.
            </div>
        </div>

        <div v-if="keyword && keyword.trim() !== ''">
            <h3>커뮤니티</h3>

            <div>
                <h4>통합 게시판</h4>

                <div v-if="totalBoardList.length > 0">
                    <div v-for="item in totalBoardList" :key="item.boardNo">
                        <div>{{ item.title }}</div>
                        <div>{{ item.bContent }}</div>
                        <hr>
                    </div>
                    <div v-if="totalBoardCount > 4">통합 게시판 더보기 ></div>
                </div>

                <div v-else>
                    검색된 통합 게시글이 없습니다.
                </div>
            </div>

            <div>
                <h4>지역 게시판</h4>

                <div v-if="localBoardList.length > 0">
                    <div v-for="item in localBoardList" :key="item.boardNo">
                        <div>{{ item.title }}</div>
                        <div>{{ item.bContent }}</div>
                        <hr>
                    </div>
                    <div v-if="localBoardCount > 4">지역 게시판 더보기 ></div>
                </div>

                <div v-else>
                    검색된 지역 게시글이 없습니다.
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
            }

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