<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNIPET</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app" v-cloak>
        <div class="container-main">
            <div class="admin-wrap">

                <jsp:include page="/WEB-INF/admin/adminSidebar.jsp">
                    <jsp:param name="activeMenu" value="report" />
                </jsp:include>

                <section class="admin-content">
                    <div class="content-card">
                        <h2>커뮤니티 및 리뷰 신고 관리</h2>
                        <div class="content-desc">신고 유형별로 접수된 신고를 확인하고 처리할 수 있습니다.</div>

                        <div class="report-tab-wrap">
                            <button 
                                type="button"
                                class="report-tab-btn"
                                :class="{ active : reportTab === 'bookingReview' }"
                                @click="fnChangeReportTab('bookingReview')">
                                예약 리뷰 신고
                            </button>

                            <button 
                                type="button"
                                class="report-tab-btn"
                                :class="{ active : reportTab === 'productReview' }"
                                @click="fnChangeReportTab('productReview')">
                                상품 리뷰 신고
                            </button>

                            <button 
                                type="button"
                                class="report-tab-btn"
                                :class="{ active : reportTab === 'communityPost' }"
                                @click="fnChangeReportTab('communityPost')">
                                커뮤니티 글 신고
                            </button>

                            <button 
                                type="button"
                                class="report-tab-btn"
                                :class="{ active : reportTab === 'communityComment' }"
                                @click="fnChangeReportTab('communityComment')">
                                커뮤니티 댓글 신고
                            </button>
                        </div>

                        <!-- 예약 리뷰 신고 -->
                        <div v-if="reportTab === 'bookingReview'">
                            <div class="report-section-title">예약 리뷰 신고 목록</div>

                            <div class="report-list" v-if="bookingReviewReportList.length > 0">
                                <div class="report-card" v-for="item in bookingReviewReportList" :key="item.reportNo">
                                    <table class="report-table">
                                        <tbody>
                                            <tr>
                                                <th>신고번호</th>
                                                <td>{{ item.reportNo }}</td>
                                                <th>리뷰번호</th>
                                                <td>{{ item.reviewNo }}</td>
                                            </tr>
                                            <tr>
                                                <th>신고자</th>
                                                <td>{{ item.reporterId }}</td>
                                                <th>작성자</th>
                                                <td>{{ item.userId }}</td>
                                            </tr>
                                            <tr>
                                                <th>리뷰 내용</th>
                                                <td colspan="3">{{ item.rContents }}</td>
                                            </tr>
                                            <tr>
                                                <th>업체명</th>
                                                <td>{{ item.storeName }}</td>
                                                <th>예약번호</th>
                                                <td>{{ item.rsvNo }}</td>
                                            </tr>
                                            <tr>
                                                <th>리뷰 이미지</th>
                                                <td colspan="3">
                                                    <img v-if="item.filePath" :src="item.filePath" class="report-preview-img">
                                                    <span v-else>첨부 이미지 없음</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>신고 사유</th>
                                                <td colspan="3">{{ item.reportReason }}</td>
                                            </tr>
                                            <tr>
                                                <th>처리상태</th>
                                                <td colspan="3">{{ fnReportStatusText(item.repStatus) }}</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="report-btn-box">
                                        <button type="button" class="btn-approve"
                                            @click="fnApproveReport(item)">
                                            승인
                                        </button>

                                        <button type="button" class="btn-reject"
                                            @click="fnRejectReport(item)">
                                            반려
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div class="empty-box" v-else>
                                예약 리뷰 신고가 없습니다.
                            </div>
                        </div>

                        <!-- 상품 리뷰 신고 -->
                        <div v-if="reportTab === 'productReview'">
                            <div class="report-section-title">상품 리뷰 신고 목록</div>

                            <div class="report-list" v-if="productReviewReportList.length > 0">
                                <div class="report-card" v-for="item in productReviewReportList" :key="item.reportNo">
                                    <table class="report-table">
                                        <tbody>
                                            <tr>
                                                <th>신고번호</th>
                                                <td>{{ item.reportNo }}</td>
                                                <th>리뷰번호</th>
                                                <td>{{ item.reviewNo }}</td>
                                            </tr>
                                            <tr>
                                                <th>신고자</th>
                                                <td>{{ item.reporterId }}</td>
                                                <th>작성자</th>
                                                <td>{{ item.userId }}</td>
                                            </tr>
                                            <tr>
                                                <th>리뷰 내용</th>
                                                <td colspan="3">{{ item.rContents }}</td>
                                            </tr>
                                            <tr>
                                                <th>상품명</th>
                                                <td>{{ item.productName }}</td>
                                                <th>주문번호</th>
                                                <td>{{ item.ordNo }}</td>
                                            </tr>
                                            <tr>
                                                <th>리뷰 이미지</th>
                                                <td colspan="3">
                                                    <img v-if="item.filePath" :src="item.filePath" class="report-preview-img">
                                                    <span v-else>첨부 이미지 없음</span>
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>처리상태</th>
                                                <td colspan="3">{{ fnReportStatusText(item.repStatus) }}</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="report-btn-box">
                                        <button type="button" class="btn-approve"
                                            @click="fnApproveReport(item)">
                                            승인
                                        </button>

                                        <button type="button" class="btn-reject"
                                            @click="fnRejectReport(item)">
                                            반려
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div class="empty-box" v-else>
                                상품 리뷰 신고가 없습니다.
                            </div>
                        </div>

                        <!-- 커뮤니티 글 신고 -->
                        <div v-if="reportTab === 'communityPost'">
                            <div class="report-section-title">커뮤니티 글 신고 목록</div>

                            <div class="report-list" v-if="communityPostReportList.length > 0">
                                <div class="report-card" v-for="item in communityPostReportList" :key="item.reportNo">
                                    <table class="report-table">
                                        <tbody>
                                            <tr>
                                                <th>글번호</th>
                                                <td>{{ item.targetNo }}</td>
                                                <th>신고자 아이디</th>
                                                <td>{{ item.reporterId }}</td>
                                            </tr>
                                            <tr>
                                                <th>작성자</th>
                                                <td>{{ item.reportedUserId }}</td>
                                                <th>신고 상태</th>
                                                <td>{{ fnReportStatusText(item.repStatus) }}</td>
                                            </tr>
                                            <tr>
                                                <th>신고 사유</th>
                                                <td colspan="3">{{ item.reportReason }}</td>
                                            </tr>
                                            <tr>
                                                <th>게시글 이미지</th>
                                                <td colspan="3">
                                                    <img v-if="item.filePath" :src="item.filePath" class="report-preview-img">
                                                    <span v-else>첨부 이미지 없음</span>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="report-btn-box">
                                        <button type="button" class="btn-approve"
                                            @click="fnApproveCommunity(item, 'POST')">
                                            승인
                                        </button>

                                        <button type="button" class="btn-reject"
                                            @click="fnRejectCommunity(item)">
                                            반려
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div class="empty-box" v-else>
                                커뮤니티 글 신고가 없습니다.
                            </div>
                        </div>

                        <!-- 커뮤니티 댓글 신고 -->
                        <div v-if="reportTab === 'communityComment'">
                            <div class="report-section-title">커뮤니티 댓글 신고 목록</div>

                            <div class="report-list" v-if="communityCommentReportList.length > 0">
                                <div class="report-card" v-for="item in communityCommentReportList" :key="item.reportNo">
                                    <table class="report-table">
                                        <tbody>
                                            <tr>
                                                <th>신고자 아이디</th>
                                                <td>{{ item.reporterId }}</td>
                                                <th>작성자 아이디</th>
                                                <td>{{ item.reportedUserId }}</td>
                                            </tr>
                                            <tr>
                                                <th>신고 사유</th>
                                                <td>{{ item.reportReason }}</td>
                                                <th>신고 상태</th>
                                                <td>{{ fnReportStatusText(item.repStatus) }}</td>
                                            </tr>
                                            <tr>
                                                <th>댓글의 글 제목</th>
                                                <td colspan="3">
                                                    <a href="javascript:;" class="file-link" @click="fnGoBoardDetail(item.boardNo)">
                                                        {{ item.title }}
                                                    </a>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="report-btn-box">
                                        <button type="button" class="btn-approve"
                                            @click="fnApproveCommunity(item, 'COMMENT')">
                                            승인
                                        </button>

                                        <button type="button" class="btn-reject"
                                            @click="fnRejectCommunity(item)">
                                            반려
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div class="empty-box" v-else>
                                커뮤니티 댓글 신고가 없습니다.
                            </div>
                        </div>

                    </div>
                </section>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/footer/footer.jsp" />

</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                reportTab: "bookingReview",

                bookingReviewReportList: [],
                productReviewReportList: [],
                communityPostReportList: [],
                communityCommentReportList: []
            };
        },
        methods: {
            fnChangeReportTab: function(tabName) {
                let self = this;

                self.reportTab = tabName;
                localStorage.setItem("reportTab", tabName);

                if (tabName === "bookingReview") {
                    self.fnBookingReviewReportList();
                } else if (tabName === "productReview") {
                    self.fnProductReviewReportList();
                } else if (tabName === "communityPost") {
                    self.fnCommunityPostReportList();
                } else if (tabName === "communityComment") {
                    self.fnCommunityCommentReportList();
                }
            },

            fnReportStatusText: function (status) {
                if (status === "WAI") {
                    return "접수";
                } else if (status === "REJ") {
                    return "반려";
                } else {
                    return status;
                }
            },

            fnProductReviewReportList: function () {
                let self = this;

                $.ajax({
                    url: "/getProductReviewReportList.dox",
                    type: "POST",
                    dataType: "json",
                    data: {},
                    success: function (data) {
                        if (data.result === "success") {
                            self.productReviewReportList = data.list || [];
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function () {
                        alert("상품 리뷰 신고 목록 조회 중 오류가 발생했습니다.");
                    }
                });
            },

            fnBookingReviewReportList: function () {
                let self = this;

                $.ajax({
                    url: "/getReservationReviewReportList.dox",
                    type: "POST",
                    dataType: "json",
                    data: {},
                    success: function (data) {
                        if (data.result === "success") {
                            self.bookingReviewReportList = data.list || [];
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function () {
                        alert("예약 리뷰 신고 목록 조회 중 오류가 발생했습니다.");
                    }
                });
            },

            fnApproveReport: function(item) {
                let self = this;

                if (!confirm("해당 신고를 승인하시겠습니까?")) {
                    return;
                }

                let banYn = "N";

                if (confirm("신고당한 사람의 계정을 정지하시겠습니까?")) {
                    banYn = "Y";
                }

                $.ajax({
                    url: "/admin/report/approve.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        reportNo: item.reportNo,
                        reviewNo: item.reviewNo,
                        reportedUserId: item.userId,
                        banYn: banYn
                    },
                    success: function(data) {
                        if (data.result === "success") {
                            alert("승인 처리되었습니다.");
                            self.fnProductReviewReportList();
                            self.fnBookingReviewReportList();
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function() {
                        alert("서버 오류가 발생했습니다.");
                    }
                });
            },

            fnRejectReport: function(item) {
                let self = this;

                if (!confirm("해당 신고를 반려하시겠습니까?")) {
                    return;
                }

                $.ajax({
                    url: "/admin/report/reject.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        reportNo: item.reportNo
                    },
                    success: function(data) {
                        if (data.result === "success") {
                            alert("반려 처리되었습니다.");
                            self.fnProductReviewReportList();
                            self.fnBookingReviewReportList();
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function() {
                        alert("서버 오류가 발생했습니다.");
                    }
                });
            },

            fnCommunityPostReportList: function () {
                let self = this;

                $.ajax({
                    url: "/admin/report/communityPostList.dox",
                    type: "POST",
                    dataType: "json",
                    success: function (data) {
                        if (data.result === "success") {
                            self.communityPostReportList = data.list || [];
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function () {
                        alert("커뮤니티 글 신고 조회 실패");
                    }
                });
            },

            fnCommunityCommentReportList: function () {
                let self = this;

                $.ajax({
                    url: "/admin/report/communityCommentList.dox",
                    type: "POST",
                    dataType: "json",
                    success: function (data) {
                        if (data.result === "success") {
                            self.communityCommentReportList = data.list || [];
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function () {
                        alert("커뮤니티 댓글 신고 조회 실패");
                    }
                });
            },

            fnGoBoardDetail: function (boardNo) {
                location.href = "/board/view.do?boardNo=" + boardNo;
            },

            fnApproveCommunity: function(item, type) {
                let self = this;

                if (!confirm("해당 신고를 승인하시겠습니까?")) {
                    return;
                }

                let banYn = "N";

                if (confirm("신고당한 사람의 계정을 정지하시겠습니까?")) {
                    banYn = "Y";
                }

                $.ajax({
                    url: "/admin/report/communityApprove.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        reportNo: item.reportNo,
                        targetNo: item.targetNo,
                        type: type,
                        reportedUserId: item.reportedUserId,
                        banYn: banYn
                    },
                    success: function(data) {
                        if (data.result === "success") {
                            alert("승인 처리되었습니다.");
                            self.fnCommunityPostReportList();
                            self.fnCommunityCommentReportList();
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function() {
                        alert("서버 오류 발생");
                    }
                });
            },

            fnRejectCommunity: function(item) {
                let self = this;

                if (!confirm("해당 신고를 반려하시겠습니까?")) {
                    return;
                }

                $.ajax({
                    url: "/admin/report/communityReject.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        reportNo: item.reportNo
                    },
                    success: function(data) {
                        if (data.result === "success") {
                            alert("반려 처리되었습니다.");
                            self.fnCommunityPostReportList();
                            self.fnCommunityCommentReportList();
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function() {
                        alert("서버 오류 발생");
                    }
                });
            }
        },
        mounted() {
            let self = this;
            let savedTab = localStorage.getItem("reportTab");

            if (savedTab) {
                self.reportTab = savedTab;
            }

            if (self.reportTab === "bookingReview") {
                self.fnBookingReviewReportList();
            } else if (self.reportTab === "productReview") {
                self.fnProductReviewReportList();
            } else if (self.reportTab === "communityPost") {
                self.fnCommunityPostReportList();
            } else if (self.reportTab === "communityComment") {
                self.fnCommunityCommentReportList();
            }
        }
    });

    app.mount('#app');
</script>