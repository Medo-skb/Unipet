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

                        <div class="admin-search-box">
                            <select class="admin-search-select" v-model="reportType" @change="fnSearchReportList">
                                <option value="">전체 카테고리</option>
                                <option value="bookingReview">예약 리뷰</option>
                                <option value="communityPost">커뮤니티 글</option>
                                <option value="communityComment">커뮤니티 댓글</option>
                            </select>
                        </div>

                        <div class="admin-report-table-wrap admin-list-fixed-area" v-if="filteredReportList.length > 0">
                            <table class="admin-user-table admin-report-table">
                                <thead>
                                    <tr>
                                        <th>처리</th>
                                        <th>신고 대상</th>
                                        <th>카테고리</th>
                                        <th>신고자</th>
                                        <th>작성자</th>
                                        <th>신고사유</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in pagedReportList" :key="item.reportType + '_' + item.reportNo">
                                        <td>
                                            <div v-if="item.reportStatus === 'WAI'">
                                                <button type="button" class="admin-mini-btn report-approve-text-btn" @click="fnApproveReport(item)">
                                                    승인
                                                </button>
                                                <button type="button" class="admin-mini-btn report-reject-text-btn" @click="fnRejectReport(item)">
                                                    반려
                                                </button>
                                            </div>

                                            <span v-else :class="['report-status-badge', item.reportStatus === 'ACC' ? 'approve' : 'reject']">
                                                {{ fnReportStatusText(item.reportStatus) }}
                                            </span>
                                        </td>

                                        <td>
                                            <button type="button" class="detail-link-btn" @click="fnOpenReportTarget(item)">
                                                보기
                                            </button>
                                        </td>

                                        <td>{{ fnReportTypeText(item.reportType) }}</td>
                                        <td>{{ fnEmpty(item.reporterId) }}</td>
                                        <td>{{ fnEmpty(fnReportedUserId(item)) }}</td>

                                        <td>
                                            <span class="report-ellipsis" :title="fnEmpty(item.reportReason)">
                                                {{ fnEmpty(item.reportReason) }}
                                            </span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="empty-box" v-else>
                            조회된 신고가 없습니다.
                        </div>

                        <div class="admin-pagination" v-if="filteredReportList.length > 0">
                            <button type="button" class="page-btn" :disabled="currentPage === 1" @click="fnMovePage(currentPage - 1)">
                                이전
                            </button>

                            <button type="button"
                                    class="page-btn"
                                    v-for="page in pageList"
                                    :key="page"
                                    :class="{ active: currentPage === page }"
                                    @click="fnMovePage(page)">
                                {{ page }}
                            </button>

                            <button type="button" class="page-btn" :disabled="currentPage === totalPage" @click="fnMovePage(currentPage + 1)">
                                다음
                            </button>
                        </div>

                    </div>
                </section>
                <div class="admin-user-modal-bg" v-if="reviewModalOpen">
                    <div class="admin-user-modal admin-report-review-modal">
                        <div class="admin-user-modal-header">
                            <h3>예약 리뷰 신고 대상</h3>
                            <button type="button" class="admin-user-modal-close" @click="fnCloseReviewModal">×</button>
                        </div>

                        <div class="admin-user-modal-body" v-if="selectedReviewReport">
                            <table class="approve-table">
                                <tbody>
                                    <tr><th>업체명</th><td>{{ fnEmpty(selectedReviewReport.storeName) }}</td></tr>
                                    <tr><th>메뉴명</th><td>{{ fnEmpty(selectedReviewReport.menuName) }}</td></tr>
                                    <tr><th>신고자</th><td>{{ fnEmpty(selectedReviewReport.reporterId) }}</td></tr>
                                    <tr><th>작성자</th><td>{{ fnEmpty(fnReportedUserId(selectedReviewReport)) }}</td></tr>
                                    <tr><th>신고사유</th><td>{{ fnEmpty(selectedReviewReport.reportReason) }}</td></tr>
                                    <tr>
                                        <th>리뷰내용</th>
                                        <td>
                                            <div class="report-modal-content">
                                                {{ fnEmpty(selectedReviewReport.rContents) }}
                                            </div>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>리뷰 첨부 사진</th>
                                        <td>
                                            <div v-if="selectedReviewReport.filePath" class="report-preview-img-list">
                                                <img v-for="filePath in fnFilePathList(selectedReviewReport.filePath)"
                                                    :key="filePath"
                                                    :src="filePath"
                                                    class="report-preview-img">
                                            </div>
                                            <span v-else>사진 없음</span>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="admin-user-modal-bg" v-if="commentModalOpen">
                    <div class="admin-user-modal admin-report-review-modal">
                        <div class="admin-user-modal-header">
                            <h3>댓글 신고 대상</h3>
                            <button type="button" class="admin-user-modal-close" @click="fnCloseCommentModal">×</button>
                        </div>

                        <div class="admin-user-modal-body" v-if="selectedCommentReport">
                            <table class="approve-table">
                                <tbody>
                                    <tr>
                                        <th>글 제목</th>
                                        <td>
                                            <button type="button"
                                                    class="detail-link-btn"
                                                    @click="fnGoBoardNewTab(selectedCommentReport.boardNo)">
                                                {{ fnEmpty(selectedCommentReport.title) }}
                                            </button>
                                        </td>
                                    </tr>
                                    <tr>
                                        <th>댓글 작성시간</th>
                                        <td>{{ fnEmpty(selectedCommentReport.createTime) }}</td>
                                    </tr>
                                    <tr>
                                        <th>댓글 내용</th>
                                        <td>
                                            <div class="report-modal-content">
                                                {{ fnEmpty(selectedCommentReport.contents) }}
                                            </div>
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
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
                reportType: "",
                reportList: [],
                currentPage: 1,
                pageSize: 10,

                reviewModalOpen: false,
                selectedReviewReport: null,

                commentModalOpen: false,
                selectedCommentReport: null
            };
        },
        computed: {
            filteredReportList: function () {
                let self = this;

                return self.reportList.filter(function (item) {
                    if (self.reportType && item.reportType !== self.reportType) {
                        return false;
                    }

                    return true;
                });
            },

            totalPage: function () {
                return Math.ceil(this.filteredReportList.length / this.pageSize);
            },

            pageList: function () {
                let list = [];
                let startPage = Math.floor((this.currentPage - 1) / 5) * 5 + 1;
                let endPage = Math.min(startPage + 4, this.totalPage);

                for (let i = startPage; i <= endPage; i++) {
                    list.push(i);
                }

                return list;
            },

            pagedReportList: function () {
                let start = (this.currentPage - 1) * this.pageSize;
                let end = start + this.pageSize;

                return this.filteredReportList.slice(start, end);
            }
        },
        methods: {
            fnLoadReportList: function () {
                let self = this;

                self.reportList = [];

                $.ajax({
                    url: "/getReservationReviewReportList.dox",
                    type: "POST",
                    dataType: "json",
                    success: function (data) {
                        if (data.result === "success") {
                            (data.list || []).forEach(function (item) {
                                item.reportType = "bookingReview";
                                item.reportStatus = item.repStatus || "WAI";
                                self.reportList.push(item);
                            });
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function () {
                        alert("예약 리뷰 신고 조회 중 오류가 발생했습니다.");
                    }
                });

                $.ajax({
                    url: "/admin/report/communityPostList.dox",
                    type: "POST",
                    dataType: "json",
                    success: function (data) {
                        if (data.result === "success") {
                            (data.list || []).forEach(function (item) {
                                item.reportType = "communityPost";
                                item.reportStatus = item.repStatus || "WAI";
                                self.reportList.push(item);
                            });

                            self.$nextTick(function () {
                                self.fnSyncReportTableScroll();
                            });
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function () {
                        alert("커뮤니티 글 신고 조회 중 오류가 발생했습니다.");
                    }
                });

                $.ajax({
                    url: "/admin/report/communityCommentList.dox",
                    type: "POST",
                    dataType: "json",
                    success: function (data) {
                        if (data.result === "success") {
                            (data.list || []).forEach(function (item) {
                                item.reportType = "communityComment";
                                item.reportStatus = item.repStatus || "WAI";
                                self.reportList.push(item);
                            });
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function () {
                        alert("커뮤니티 댓글 신고 조회 중 오류가 발생했습니다.");
                    }
                });
            },

            fnSearchReportList: function () {
                this.currentPage = 1;
            },

            fnMovePage: function (page) {
                if (page < 1 || page > this.totalPage) {
                    return;
                }

                this.currentPage = page;
            },

            fnOpenReportTarget: function (item) {
                if (item.reportType === "bookingReview") {
                    this.selectedReviewReport = item;
                    this.reviewModalOpen = true;
                    return;
                }

                if (item.reportType === "communityComment") {
                    this.selectedCommentReport = item;
                    this.commentModalOpen = true;
                    return;
                }

                if (item.reportType === "communityPost") {
                    if (item.boardNo) {
                        this.fnGoBoardNewTab(item.boardNo);
                    } else {
                        alert("이동할 게시글 번호가 없습니다.");
                    }
                }
            },

            fnCloseReviewModal: function () {
                this.reviewModalOpen = false;
                this.selectedReviewReport = null;
            },

            fnApproveReport: function (item) {
                let self = this;

                if (!confirm("해당 신고를 승인하시겠습니까?")) return;

                let banYn = "N";
                if (confirm("신고당한 사람의 계정을 정지하시겠습니까?")) {
                    banYn = "Y";
                }

                $.ajax({
                    url: item.reportType === "bookingReview" ? "/admin/report/approve.dox" : "/admin/report/communityApprove.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        reportNo: item.reportNo,
                        reviewNo: item.reviewNo,
                        targetNo: item.targetNo,
                        reportedUserId: self.fnReportedUserId(item),
                        type: item.reportType === "communityPost" ? "POST" : "COMMENT",
                        banYn: banYn
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            alert("승인 처리되었습니다.");
                            self.fnLoadReportList();
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function () {
                        alert("승인 처리 중 오류가 발생했습니다.");
                    }
                });
            },

            fnRejectReport: function (item) {
                let self = this;

                if (!confirm("해당 신고를 반려하시겠습니까?")) return;

                $.ajax({
                    url: item.reportType === "bookingReview" ? "/admin/report/reject.dox" : "/admin/report/communityReject.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        reportNo: item.reportNo
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            alert("반려 처리되었습니다.");
                            self.fnLoadReportList();
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function () {
                        alert("반려 처리 중 오류가 발생했습니다.");
                    }
                });
            },

            fnReportStatusText: function (status) {
                if (status === "WAI") return "미처리";
                if (status === "ACC") return "승인";
                if (status === "REJ") return "반려";
                return this.fnEmpty(status);
            },

            fnReportTypeText: function (type) {
                if (type === "bookingReview") return "예약 리뷰";
                if (type === "communityPost") return "커뮤니티 글";
                if (type === "communityComment") return "커뮤니티 댓글";
                return this.fnEmpty(type);
            },

            fnReportedUserId: function (item) {
                return item.reportedUserId || item.userId;
            },

            fnFilePathList: function (filePath) {
                if (!filePath) {
                    return [];
                }

                return filePath.split("|").filter(function (item) {
                    return item;
                });
            },

            fnEmpty: function (value) {
                if (value === null || value === undefined || value === "") {
                    return "-";
                }

                return value;
            },
            fnCloseCommentModal: function () {
                this.commentModalOpen = false;
                this.selectedCommentReport = null;
            },

            fnGoBoardNewTab: function (boardNo) {
                if (!boardNo) {
                    alert("이동할 게시글 번호가 없습니다.");
                    return;
                }

                window.open("/board/view.do?boardNo=" + boardNo, "_blank");
            },
        },
        mounted() {
            this.fnLoadReportList();

        }
    });

    app.mount('#app');
</script>