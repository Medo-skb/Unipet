<%@ page language="java"
    contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>

    <link href="/css/user/usermypage.css" rel="stylesheet">

    <title>UNIPET</title>
</head>

<body>

<jsp:include page="/WEB-INF/header/header.jsp" />

<div id="app" class="user-page-wrap" v-cloak>
    <div class="user-page-container">

        <jsp:include page="/WEB-INF/user/Mypage/sidebar.jsp">
            <jsp:param name="activeMenu" value="community" />
        </jsp:include>

        <main class="user-content">
            <div class="content-header">
                <h1>커뮤니티 활동</h1>
            </div>

            <div class="page-inner">

                <!-- 최근 게시글 -->
                <div class="section-box">
                    <div class="section-header">
                        <div class="section-title" style="margin-bottom:0;">
                            {{ showAllPost ? '내 전체 게시글' : '최근 내 게시글' }}
                        </div>

                        <button class="small-btn" @click="fnShowAllPost">
                            {{ showAllPost ? '최근 게시글 보기' : '전체보기' }}
                        </button>
                    </div>

                    <div v-if="postList.length === 0" class="empty-text">
                        작성한 게시글이 없습니다.
                    </div>

                    <div class="list-item"
                         v-for="item in displayPostList"
                         :key="'post-' + item.id">

                        <div class="post-title"
                             @click="fnGoPostDetail(item.boardNo || item.BOARD_NO || item.id)">
                            [{{ item.boardName }}] {{ item.title }}
                        </div>

                        <div class="list-sub">
                            {{ fnFormatDateTime(item.cdate) }}
                        </div>
                    </div>
                </div>

                <!-- 댓글 -->
                <div class="section-box">
                    <div class="section-header">
                        <div class="section-title" style="margin-bottom:0;">
                            {{ showAllComment ? '내 전체 댓글' : '최근 내 댓글' }}
                        </div>

                        <button class="small-btn" @click="fnShowAllComment">
                            {{ showAllComment ? '최근 댓글 보기' : '전체보기' }}
                        </button>
                    </div>

                    <div v-if="commentList.length === 0" class="empty-text">
                        작성한 댓글이 없습니다.
                    </div>

                    <div class="list-item"
                         v-for="item in displayCommentList"
                         :key="'comment-' + item.id">

                        <div class="list-title post-title"
                             style="cursor:pointer;"
                             @click="fnGoPostDetail(item.boardNo || item.BOARD_NO)">
                            [{{ item.boardName }}] {{ item.content }}
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

<jsp:include page="/WEB-INF/footer/footer.jsp" />

<script>
    const app = Vue.createApp({
        data() {
            return {
                postList: [],
                commentList: [],

                showAllPost: false,
                showAllComment: false
            };
        },

        computed: {
            displayPostList() {
                if (this.showAllPost) {
                    return this.postList;
                }
                return this.postList.slice(0, 3);
            },

            displayCommentList() {
                if (this.showAllComment) {
                    return this.commentList;
                }
                return this.commentList.slice(0, 3);
            }
        },

        methods: {
            fnLoadPostList: function () {
                let self = this;

                $.ajax({
                    url: "/user/community-post-list.dox",
                    type: "POST",
                    dataType: "json",
                    success: function (data) {
                        if (data.result === "success") {
                            self.postList = data.postList || [];
                        } else {
                            self.postList = [];
                        }
                    },
                    error: function () {
                        self.postList = [];
                        alert("게시글 조회 실패");
                    }
                });
            },

            fnLoadCommentList: function () {
                let self = this;

                $.ajax({
                    url: "/user/community-comment-list.dox",
                    type: "POST",
                    dataType: "json",
                    success: function (data) {
                        if (data.result === "success") {
                            self.commentList = data.commentList || [];
                        } else {
                            self.commentList = [];
                        }
                    },
                    error: function () {
                        self.commentList = [];
                        alert("댓글 조회 실패");
                    }
                });
            },

            fnShowAllPost: function () {
                this.showAllPost = !this.showAllPost;
            },

            fnShowAllComment: function () {
                this.showAllComment = !this.showAllComment;
            },

            fnGoPostDetail: function (boardNo) {
                if (!boardNo) {
                    alert("게시글 번호를 찾을 수 없습니다.");
                    return;
                }

                pageChange("/board/view.do", {
                    boardNo: boardNo
                });
            },

            fnFormatDateTime: function (dateStr) {
                if (!dateStr) {
                    return "-";
                }

                let str = String(dateStr).replace("T", " ");

                return str.length >= 16
                    ? str.substring(0, 16)
                    : str;
            }
        },

        mounted() {
            this.fnLoadPostList();
            this.fnLoadCommentList();
        }
    });

    app.mount("#app");
</script>

</body>
</html>