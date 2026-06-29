<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>UNIPET</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app" v-cloak>
        <div class="container-main">
            <div class="admin-wrap">

                <jsp:include page="/WEB-INF/admin/adminSidebar.jsp">
                    <jsp:param name="activeMenu" value="userManage" />
                </jsp:include>

                <section class="admin-content">
                    <div class="content-card">
                        <h2>회원 커뮤니티 내역</h2>
                        <div class="content-desc">
                            {{ userId }} 회원이 작성한 커뮤니티 글과 댓글 내역입니다.
                        </div>
                        <div class="report-tab-wrap">
                            <button
                                type="button"
                                class="board-tab-btn"
                                :class="{ active: activeTab === 'post' }"
                                @click="fnChangeTab('post')">
                                글
                            </button>
                            <button
                                type="button"
                                class="board-tab-btn"
                                :class="{ active: activeTab === 'comment' }"
                                @click="fnChangeTab('comment')">
                                댓글
                            </button>
                        </div>

                        <div v-if="activeTab === 'post'">
                            <table class="admin-detail-table">
                                <thead>
                                    <tr>
                                        <th>글 번호</th>
                                        <th>제목</th>
                                        <th>작성일</th>
                                        <th>수정일</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in postList" :key="item.boardNo">
                                        <td>{{ item.boardNo }}</td>
                                        <td>
                                            <button type="button" class="detail-link-btn" @click="fnMoveBoard(item.boardNo)">
                                                {{ item.title }}
                                            </button>
                                        </td>
                                        <td>{{ fnEmpty(item.cdate) }}</td>
                                        <td>{{ fnEmpty(item.udate) }}</td>
                                    </tr>
                                </tbody>
                            </table>

                            <div class="empty-box" v-if="postList.length === 0">
                                작성한 글이 없습니다.
                            </div>
                        </div>

                        <div v-if="activeTab === 'comment'">
                            <table class="admin-detail-table">
                                <thead>
                                    <tr>
                                        <th>댓글 번호</th>
                                        <th>글 제목</th>
                                        <th>댓글 내용</th>
                                        <th>작성일</th>
                                        <th>수정일</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in commentList" :key="item.commentNo">
                                        <td>{{ item.commentNo }}</td>
                                        <td>
                                            <button type="button" class="detail-link-btn" @click="fnMoveBoard(item.boardNo)">
                                                {{ item.title }}
                                            </button>
                                        </td>
                                        <td>{{ fnEmpty(item.cContent) }}</td>
                                        <td>{{ fnEmpty(item.cdate) }}</td>
                                        <td>{{ fnEmpty(item.udate) }}</td>
                                    </tr>
                                </tbody>
                            </table>

                            <div class="empty-box" v-if="commentList.length === 0">
                                작성한 댓글이 없습니다.
                            </div>
                        </div>
                    </div>
                </section>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/footer/footer.jsp" />

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    userId: "${userId}",
                    activeTab: "post",
                    postList: [],
                    commentList: []
                };
            },
            methods: {
                fnPostList: function () {
                    let self = this;

                    $.ajax({
                        url: "/admin/user/communityPostList.dox",
                        type: "POST",
                        dataType: "json",
                        data: {
                            userId: self.userId
                        },
                        success: function (data) {
                            if (data.result === "success") {
                                self.postList = data.list || [];
                            } else {
                                alert(data.message || "글 내역을 불러오지 못했습니다.");
                            }
                        },
                        error: function () {
                            alert("서버 통신 중 오류가 발생했습니다.");
                        }
                    });
                },

                fnCommentList: function () {
                    let self = this;

                    $.ajax({
                        url: "/admin/user/communityCommentList.dox",
                        type: "POST",
                        dataType: "json",
                        data: {
                            userId: self.userId
                        },
                        success: function (data) {
                            if (data.result === "success") {
                                self.commentList = data.list || [];
                            } else {
                                alert(data.message || "댓글 내역을 불러오지 못했습니다.");
                            }
                        },
                        error: function () {
                            alert("서버 통신 중 오류가 발생했습니다.");
                        }
                    });
                },

                fnChangeTab: function (tab) {
                    this.activeTab = tab;

                    if (tab === "post") {
                        this.fnPostList();
                    } else {
                        this.fnCommentList();
                    }
                },

                fnMoveBoard: function (boardNo) {
                    location.href = "/board/view.do?boardNo=" + boardNo;
                },

                fnBack: function () {
                    location.href = "/admin/userManage.do";
                },

                fnEmpty: function (value) {
                    if (value === null || value === undefined || value === "") {
                        return "-";
                    }
                    return value;
                }
            },
            mounted() {
                this.fnPostList();
            }
        });

        app.mount("#app");
    </script>
</body>
</html>