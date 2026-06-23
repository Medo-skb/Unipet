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

                            <div class="report-group-list" v-if="bookingReviewGroupList.length > 0">
                                <div class="report-group-box" v-for="item in bookingReviewGroupList" :key="item.storeNo">
                                    <button type="button"
                                        class="report-group-item"
                                        :class="{ active: selectedBookingReviewGroup && selectedBookingReviewGroup.storeNo === item.storeNo }"
                                        @click="fnSelectBookingReviewGroup(item)">
                                        <span class="report-ellipsis">{{ item.storeName }}</span>
                                        <strong>{{ item.reportCount }}개</strong>
                                    </button>

                                    <div class="report-detail-wrap" v-if="selectedBookingReviewGroup && selectedBookingReviewGroup.storeNo === item.storeNo">
                                        <div class="report-detail-top">
                                            <div class="report-detail-title">
                                                {{ item.storeName }} 신고 내역
                                            </div>

                                            <div class="report-detail-actions">
                                                <button type="button" class="btn-approve" @click="fnGoStoreDetail(item.storeNo)">
                                                    해당 업체로 이동
                                                </button>
                                                <button type="button" class="btn-approve" @click="fnApproveBatch('bookingReview')">
                                                    모두 승인
                                                </button>
                                                <button type="button" class="btn-reject" @click="fnRejectBatch('bookingReview')">
                                                    모두 반려
                                                </button>
                                            </div>
                                        </div>

                                        <div class="report-list" v-if="bookingReviewReportList.length > 0">
                                            <div class="report-card" v-for="detail in bookingReviewReportList" :key="detail.reportNo">
                                                <table class="report-table">
                                                    <tbody>
                                                        <tr>
                                                            <th>신고자</th>
                                                            <td>{{ detail.reporterId }}</td>
                                                            <th>작성자</th>
                                                            <td>{{ detail.userId }}</td>
                                                        </tr>
                                                        <tr>
                                                            <th>신고사유</th>
                                                            <td colspan="3">{{ detail.reportReason }}</td>
                                                        </tr>
                                                        <tr>
                                                            <th>리뷰 내용</th>
                                                            <td colspan="3">{{ detail.rContents }}</td>
                                                        </tr>
                                                        <tr>
                                                            <th>리뷰 첨부 사진</th>
                                                            <td colspan="3">
                                                                <div v-if="detail.filePath" class="report-preview-img-list">
                                                                    <img v-for="filePath in fnFilePathList(detail.filePath)"
                                                                        :key="filePath"
                                                                        :src="filePath"
                                                                        class="report-preview-img">
                                                                </div>
                                                                <span v-else>사진 없음</span>
                                                            </td>
                                                        </tr>
                                                        <tr>
                                                            <th>메뉴명</th>
                                                            <td colspan="3">{{ detail.menuName ? detail.menuName : '삭제된 메뉴' }}</td>
                                                        </tr>
                                                    </tbody>
                                                </table>

                                                <div class="report-btn-box">
                                                    <button type="button" class="btn-reject" @click="fnRejectReport(detail)">
                                                        반려
                                                    </button>
                                                    <button type="button" class="btn-approve" @click="fnApproveReport(detail)">
                                                        승인
                                                    </button>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <div class="empty-box" v-else>
                                예약 리뷰 신고가 없습니다.
                            </div>
                        </div>

                        <!-- 커뮤니티 글 신고 -->
                        <div v-if="reportTab === 'communityPost'">
                            <div class="report-section-title">커뮤니티 글 신고 목록</div>

                            <div class="report-group-list" v-if="communityPostGroupList.length > 0">
                                <div class="report-group-box" v-for="item in communityPostGroupList" :key="item.targetNo">
                                    <button type="button"
                                        class="report-group-item"
                                        :class="{ active: selectedCommunityPostGroup && selectedCommunityPostGroup.targetNo === item.targetNo }"
                                        @click="fnSelectCommunityPostGroup(item)">
                                        <span class="report-ellipsis">{{ item.title }}</span>
                                        <strong>{{ item.reportCount }}개</strong>
                                    </button>

                                    <div class="report-detail-wrap" v-if="selectedCommunityPostGroup && selectedCommunityPostGroup.targetNo === item.targetNo">
                                        <div class="report-detail-top">
                                            <div class="report-detail-title report-ellipsis">
                                                {{ item.title }} 신고 내역
                                            </div>

                                            <div class="report-detail-actions">
                                                <button type="button" class="btn-approve" @click="fnGoBoardDetail(item.boardNo)">
                                                    해당 글로 이동
                                                </button>
                                                <button type="button" class="btn-approve" @click="fnApproveBatch('communityPost')">
                                                    승인
                                                </button>
                                                <button type="button" class="btn-reject" @click="fnRejectBatch('communityPost')">
                                                    반려
                                                </button>
                                            </div>
                                        </div>

                                        <div class="report-list" v-if="communityPostReportList.length > 0">
                                            <div class="report-card" v-for="detail in communityPostReportList" :key="detail.reportNo">
                                                <table class="report-table">
                                                    <tbody>
                                                        <tr>
                                                            <th>신고자</th>
                                                            <td>{{ detail.reporterId }}</td>
                                                            <th>작성자</th>
                                                            <td>{{ detail.reportedUserId }}</td>
                                                        </tr>
                                                        <tr>
                                                            <th>신고사유</th>
                                                            <td colspan="3">{{ detail.reportReason }}</td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
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

                            <div class="report-group-list" v-if="communityCommentGroupList.length > 0">
                                <div class="report-group-box" v-for="item in communityCommentGroupList" :key="item.targetNo">
                                    <button type="button"
                                        class="report-group-item"
                                        :class="{ active: selectedCommunityCommentGroup && selectedCommunityCommentGroup.targetNo === item.targetNo }"
                                        @click="fnSelectCommunityCommentGroup(item)">
                                        <span class="report-ellipsis">
                                            {{ item.contents ? item.contents : item.title }}
                                        </span>
                                        <strong>{{ item.reportCount }}개</strong>
                                    </button>

                                    <div class="report-detail-wrap" v-if="selectedCommunityCommentGroup && selectedCommunityCommentGroup.targetNo === item.targetNo">
                                        <div class="report-detail-top">
                                            <div class="report-detail-title report-ellipsis">
                                                {{ item.contents ? item.contents : item.title }} 신고 내역
                                            </div>

                                            <div class="report-detail-actions">
                                                <button type="button" class="btn-approve" @click="fnGoBoardDetail(item.boardNo)">
                                                    해당 글로 이동
                                                </button>
                                                <button type="button" class="btn-approve" @click="fnApproveBatch('communityComment')">
                                                    승인
                                                </button>
                                                <button type="button" class="btn-reject" @click="fnRejectBatch('communityComment')">
                                                    반려
                                                </button>
                                            </div>
                                        </div>

                                        <div class="report-list" v-if="communityCommentReportList.length > 0">
                                            <div class="report-card" v-for="detail in communityCommentReportList" :key="detail.reportNo">
                                                <table class="report-table">
                                                    <tbody>
                                                        <tr>
                                                            <th>신고자</th>
                                                            <td>{{ detail.reporterId }}</td>
                                                            <th>작성자</th>
                                                            <td>{{ detail.reportedUserId }}</td>
                                                        </tr>
                                                        <tr>
                                                            <th>신고사유</th>
                                                            <td>{{ detail.reportReason }}</td>
                                                            <th>글 제목</th>
                                                            <td>
                                                                <span class="report-ellipsis">{{ detail.title }}</span>
                                                            </td>
                                                        </tr>
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
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

                bookingReviewGroupList: [],
                bookingReviewReportList: [],
                selectedBookingReviewGroup: null,

                communityPostGroupList: [],
                communityPostReportList: [],
                selectedCommunityPostGroup: null,

                communityCommentGroupList: [],
                communityCommentReportList: [],
                selectedCommunityCommentGroup: null
            };
        },
            methods: {
            fnChangeReportTab: function(tabName) {
                let self = this;

                self.reportTab = tabName;
                localStorage.setItem("reportTab", tabName);

                self.fnLoadCurrentTab();
            },

            fnLoadCurrentTab: function() {
                let self = this;

                if (self.reportTab === "bookingReview") {
                    self.fnBookingReviewGroupList();
                } else if (self.reportTab === "communityPost") {
                    self.fnCommunityPostGroupList();
                } else if (self.reportTab === "communityComment") {
                    self.fnCommunityCommentGroupList();
                }
            },

            fnReportStatusText: function(status) {
                if (status === "WAI") return "접수";
                if (status === "REJ") return "반려";
                if (status === "ACC") return "승인";
                return status;
            },

            fnBookingReviewGroupList: function() {
                let self = this;

                $.ajax({
                    url: "/admin/report/reservationGroupList.dox",
                    type: "POST",
                    dataType: "json",
                    success: function(data) {
                        if (data.result === "success") {
                            self.bookingReviewGroupList = data.list || [];

                            self.selectedBookingReviewGroup = null;
                            self.bookingReviewReportList = [];
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function() {
                        alert("예약 리뷰 신고 그룹 조회 중 오류가 발생했습니다.");
                    }
                });
            },

            fnSelectBookingReviewGroup: function(item) {
                let self = this;

                if (self.selectedBookingReviewGroup && self.selectedBookingReviewGroup.storeNo === item.storeNo) {
                    self.selectedBookingReviewGroup = null;
                    self.bookingReviewReportList = [];
                    return;
                }

                self.selectedBookingReviewGroup = item;

                $.ajax({
                    url: "/admin/report/reservationDetailList.dox",
                    type: "POST",
                    dataType: "json",
                    data: { storeNo: item.storeNo },
                    success: function(data) {
                        if (data.result === "success") {
                            self.bookingReviewReportList = data.list || [];
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function() {
                        alert("예약 리뷰 신고 상세 조회 중 오류가 발생했습니다.");
                    }
                });
            },

            fnCommunityPostGroupList: function() {
                let self = this;

                $.ajax({
                    url: "/admin/report/communityPostGroupList.dox",
                    type: "POST",
                    dataType: "json",
                    success: function(data) {
                        if (data.result === "success") {
                            self.communityPostGroupList = data.list || [];

                            self.selectedCommunityPostGroup = null;
                            self.communityPostReportList = [];
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function() {
                        alert("커뮤니티 글 신고 그룹 조회 중 오류가 발생했습니다.");
                    }
                });
            },

            fnSelectCommunityPostGroup: function(item) {
                let self = this;

                if (self.selectedCommunityPostGroup && self.selectedCommunityPostGroup.targetNo === item.targetNo) {
                    self.selectedCommunityPostGroup = null;
                    self.communityPostReportList = [];
                    return;
                }

                self.selectedCommunityPostGroup = item;

                $.ajax({
                    url: "/admin/report/communityPostDetailList.dox",
                    type: "POST",
                    dataType: "json",
                    data: { targetNo: item.targetNo },
                    success: function(data) {
                        if (data.result === "success") {
                            self.communityPostReportList = data.list || [];
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function() {
                        alert("커뮤니티 글 신고 상세 조회 중 오류가 발생했습니다.");
                    }
                });
            },

            fnCommunityCommentGroupList: function() {
                let self = this;

                $.ajax({
                    url: "/admin/report/communityCommentGroupList.dox",
                    type: "POST",
                    dataType: "json",
                    success: function(data) {
                        if (data.result === "success") {
                            self.communityCommentGroupList = data.list || [];

                            self.selectedCommunityCommentGroup = null;
                            self.communityCommentReportList = [];
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function() {
                        alert("커뮤니티 댓글 신고 그룹 조회 중 오류가 발생했습니다.");
                    }
                });
            },

            fnSelectCommunityCommentGroup: function(item) {
                let self = this;

                if (self.selectedCommunityCommentGroup && self.selectedCommunityCommentGroup.targetNo === item.targetNo) {
                    self.selectedCommunityCommentGroup = null;
                    self.communityCommentReportList = [];
                    return;
                }

                self.selectedCommunityCommentGroup = item;

                $.ajax({
                    url: "/admin/report/communityCommentDetailList.dox",
                    type: "POST",
                    dataType: "json",
                    data: { targetNo: item.targetNo },
                    success: function(data) {
                        if (data.result === "success") {
                            self.communityCommentReportList = data.list || [];
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function() {
                        alert("커뮤니티 댓글 신고 상세 조회 중 오류가 발생했습니다.");
                    }
                });
            },

            fnApproveReport: function(item) {
                let self = this;

                if (!confirm("해당 신고를 승인하시겠습니까?")) return;

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
                            self.fnLoadCurrentTab();
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function() {
                        alert("승인 처리 중 오류가 발생했습니다.");
                    }
                });
            },

            fnRejectReport: function(item) {
                let self = this;

                if (!confirm("해당 신고를 반려하시겠습니까?")) return;

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
                            self.fnLoadCurrentTab();
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function() {
                        alert("반려 처리 중 오류가 발생했습니다.");
                    }
                });
            },

            fnApproveBatch: function(reportType) {
                let self = this;
                let targetNo = "";
                let storeNo = "";

                if (reportType === "bookingReview") {
                    if (!self.selectedBookingReviewGroup) return;
                    storeNo = self.selectedBookingReviewGroup.storeNo;
                } else if (reportType === "communityPost") {
                    if (!self.selectedCommunityPostGroup) return;
                    targetNo = self.selectedCommunityPostGroup.targetNo;
                } else if (reportType === "communityComment") {
                    if (!self.selectedCommunityCommentGroup) return;
                    targetNo = self.selectedCommunityCommentGroup.targetNo;
                }

                if (!confirm("해당 대상의 신고가 승인됩니다. 승인하시겠습니까?")) return;

                let banYn = "N";
                if (confirm("신고당한 사람의 계정을 정지하시겠습니까?")) {
                    banYn = "Y";
                }

                $.ajax({
                    url: "/admin/report/batchApprove.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        reportType: reportType,
                        storeNo: storeNo,
                        targetNo: targetNo,
                        banYn: banYn
                    },
                    success: function(data) {
                        if (data.result === "success") {
                            alert("승인 처리되었습니다.");
                            self.fnLoadCurrentTab();
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function() {
                        alert("승인 처리 중 오류가 발생했습니다.");
                    }
                });
            },

            fnRejectBatch: function(reportType) {
                let self = this;
                let targetNo = "";
                let storeNo = "";

                if (reportType === "bookingReview") {
                    if (!self.selectedBookingReviewGroup) return;
                    storeNo = self.selectedBookingReviewGroup.storeNo;
                } else if (reportType === "communityPost") {
                    if (!self.selectedCommunityPostGroup) return;
                    targetNo = self.selectedCommunityPostGroup.targetNo;
                } else if (reportType === "communityComment") {
                    if (!self.selectedCommunityCommentGroup) return;
                    targetNo = self.selectedCommunityCommentGroup.targetNo;
                }

                if (!confirm("해당 대상의 신고가 반려됩니다. 반려하시겠습니까?")) return;

                $.ajax({
                    url: "/admin/report/batchReject.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        reportType: reportType,
                        storeNo: storeNo,
                        targetNo: targetNo
                    },
                    success: function(data) {
                        if (data.result === "success") {
                            alert("반려 처리되었습니다.");
                            self.fnLoadCurrentTab();
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function() {
                        alert("반려 처리 중 오류가 발생했습니다.");
                    }
                });
            },

            fnGoStoreDetail: function(storeNo) {
                location.href = "/reservation/store-detail.do?storeNo=" + storeNo;
            },

            fnGoBoardDetail: function(boardNo) {
                location.href = "/board/view.do?boardNo=" + boardNo;
            },

            fnFilePathList: function(filePath) {
                if (!filePath) {
                    return [];
                }

                return filePath.split("|").filter(function(item) {
                    return item;
                });
            },
        },
        mounted() {
            let self = this;
            let savedTab = localStorage.getItem("reportTab");

            if (savedTab && savedTab !== "productReview") {
                self.reportTab = savedTab;
            }

            self.fnLoadCurrentTab();
        }
    });

    app.mount('#app');
</script>