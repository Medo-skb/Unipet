<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">

<head>

    <!-- 문자 인코딩 -->
    <meta charset="UTF-8">

    <!-- 모바일 반응형 -->
    <meta name="viewport"
          content="width=device-width, initial-scale=1.0">

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <!-- Vue -->
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

    <!-- 공통 페이지 이동 -->
    <script src="/js/page-change.js"></script>

    <!-- 마이페이지 CSS -->
    <link href="/css/user/usermypage.css"
          rel="stylesheet">

    <title>UNIPET - 커뮤니티 활동</title>

</head>

<body>

    <!-- 헤더 -->
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <!-- Vue 영역 -->
    <div id="app"
         class="user-page-wrap"
         v-cloak>

        <div class="user-page-container">

            <!-- 사이드바 -->
            <jsp:include page="/WEB-INF/user/Mypage/sidebar.jsp" />

            <!-- 본문 -->
            <main class="user-content">

                <!-- 페이지 제목 -->
                <div class="content-header">

                    <h1>커뮤니티 활동</h1>

                </div>

                <div class="page-inner">

                    <!-- 최근 게시글 -->
                    <div class="section-box">

                        <div class="section-header">

                            <div class="section-title"
                                 style="margin-bottom:0;">

                                최근 내 게시글

                            </div>

                            <button class="small-btn"
                                    @click="fnShowAllPost">

                                전체보기

                            </button>

                        </div>

                        <!-- 게시글 없을 때 -->
                        <div v-if="postList.length === 0"
                             class="empty-text">

                            작성한 게시글이 없습니다.

                        </div>

                        <!-- 게시글 목록 -->
                        <div class="list-item"
                             v-for="item in displayPostList"
                             :key="item.id">

                            <div class="post-title"
                                 @click="fnGoPostDetail(item.id)">

                                [{{ item.boardName }}]
                                {{ item.title }}

                            </div>

                            <div class="list-sub">

                                {{ fnFormatDateTime(item.cdate) }}

                            </div>

                        </div>

                    </div>

                    <!-- 댓글 -->
                    <div class="section-box">

                        <div class="section-title">

                            내 댓글

                        </div>

                        <!-- 댓글 없을 때 -->
                        <div v-if="commentList.length === 0"
                             class="empty-text">

                            작성한 댓글이 없습니다.

                        </div>

                        <!-- 댓글 목록 -->
                        <div class="list-item"
                             v-for="item in commentList"
                             :key="item.id">

                            <div class="list-title">

                                [{{ item.boardName }}]
                                {{ item.content }}

                            </div>

                            <div class="list-sub">

                                {{ fnFormatDateTime(item.cdate) }}

                            </div>

                        </div>

                    </div>

                </div>

            </main>

        </div>

    </div>

    <!-- 푸터 -->
    <jsp:include page="/WEB-INF/footer/footer.jsp" />

<script>

    // Vue 생성
    const app = Vue.createApp({

        data() {

            return {

                // 게시글 목록
                postList: [],

                // 댓글 목록
                commentList: [],

                // 전체보기 여부
                showAllPost: false

            };

        },

        computed: {

            // 화면 표시 게시글
            displayPostList() {

                if (this.showAllPost) {

                    return this.postList;

                }

                return this.postList.slice(0, 3);

            }

        },

        methods: {

            // 게시글 조회
            fnLoadPostList: function () {

                let self = this;

                $.ajax({

                    url: "/user/community-post-list.dox",

                    type: "POST",

                    dataType: "json",

                    success: function (data) {

                        if (data.result === "success") {

                            self.postList =
                                data.postList || [];

                        } else {

                            self.postList = [];

                        }

                    },

                    error: function () {

                        alert("게시글 조회 실패");

                    }

                });

            },

            // 댓글 조회
            fnLoadCommentList: function () {

                let self = this;

                $.ajax({

                    url: "/user/community-comment-list.dox",

                    type: "POST",

                    dataType: "json",

                    success: function (data) {

                        if (data.result === "success") {

                            self.commentList =
                                data.commentList || [];

                        } else {

                            self.commentList = [];

                        }

                    },

                    error: function () {

                        alert("댓글 조회 실패");

                    }

                });

            },

            // 전체 게시글 보기
            fnShowAllPost: function () {

                this.showAllPost =
                    !this.showAllPost;

            },

            // 게시글 상세 이동
            fnGoPostDetail: function (boardNo) {

                pageChange("/board/view.do", {
                    boardNo: boardNo
                });

            },

            // 날짜 포맷
            fnFormatDateTime: function (dateStr) {

                if (!dateStr) {

                    return "-";

                }

                let str =
                    String(dateStr)
                        .replace("T", " ");

                return str.substring(0, 16);

            }

        },

        // 시작 시 실행
        mounted() {

            this.fnLoadPostList();
            this.fnLoadCommentList();

        }

    });

    app.mount("#app");

</script>

</body>
</html>