<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
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
                <div v-if="boardList.length > 0" class="search-list">
                    <div v-for="item in boardList" :key="item.boardNo" class="search-card">
                        <div class="search-card-title">{{ item.title }}</div>
                        <div class="search-card-desc board-content">{{ item.bContent }}</div>
                    </div>
                </div>

                <div v-else class="search-empty">
                    검색된 게시글이 없습니다.
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
const bMainNo = "${bMainNo}";

const app = Vue.createApp({
    data() {
        return {
            keyword: keyword,
            bMainNo: bMainNo,
            boardList: []
        };
    },
    computed: {
        pageTitle() {
            if (this.bMainNo == "1") return "통합 게시판 검색 결과";
            if (this.bMainNo == "2") return "지역 게시판 검색 결과";
            return "커뮤니티 검색 결과";
        }
    },
    methods: {
        fnBoardList: function () {
            let self = this;
            let param = {
                keyword: self.keyword,
                bMainNo: self.bMainNo
            };

            $.ajax({
                url: "/getSearchBoardList.dox",
                dataType: "json",
                type: "POST",
                data: param,
                success: function (data) {
                    if (data.result == "success") {
                        self.boardList = data.list;
                    } else {
                        self.boardList = [];
                    }
                },
                error: function () {
                    self.boardList = [];
                }
            });
        }
    },
    mounted() {
        let self = this;

        if (!self.keyword || self.keyword.trim() === "") {
            return;
        }

        self.fnBoardList();
    }
});

app.mount("#app");
</script>