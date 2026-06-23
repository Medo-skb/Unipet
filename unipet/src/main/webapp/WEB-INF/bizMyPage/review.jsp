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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bizMyPage/bizCommon.css">
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app" v-cloak>
        <div class="biz-page-wrap">
            <div class="biz-page-container">

                <jsp:include page="/WEB-INF/bizMyPage/bizSidebar.jsp">
                    <jsp:param name="activeMenu" value="review" />
                </jsp:include>

                <section class="biz-content">
                    <div class="content-header">
                        <h1>리뷰 관리</h1>
                    </div>

                    <div class="content-section">
                        <div class="section-header">
                            <h2>리뷰 현황</h2>
                        </div>

                        <div class="summary-grid">
                            <div class="summary-box">
                                <div class="summary-title">전체 리뷰 개수</div>
                                <div class="summary-value">{{reviewSummary.totalReviewCount}}건</div>
                                <div class="summary-desc">총 리뷰 수</div>
                            </div>
                            <div class="summary-box">
                                <div class="summary-title">평균 평점</div>
                                <div class="summary-value">{{reviewSummary.avgRating}}점</div>
                                <div class="summary-desc">리뷰 전체 평균 평점</div>
                            </div>
                            <div class="summary-box">
                                <div class="summary-title">최근 리뷰 평점</div>
                                <div class="summary-value">{{reviewSummary.recentReviewRating}}점</div>
                                <div class="summary-desc">최근 7일 예약 관련 리뷰 평균 평점</div>
                            </div>
                        </div>
                    </div>

                    <div class="content-section">
                        <div class="section-header">
                            <h2>메뉴별 리뷰 목록</h2>
                        </div>

                        <div class="review-filter-area">
                            <button type="button"
                                    class="tab-btn"
                                    :class="{ active: selectedMenuNo === '' }"
                                    @click="fnChangeMenu('')">
                                전체
                            </button>

                            <button type="button"
                                    class="tab-btn"
                                    v-for="menu in reviewMenuList"
                                    :key="menu.menuNo"
                                    :class="{ active: selectedMenuNo == menu.menuNo }"
                                    @click="fnChangeMenu(menu.menuNo)">
                                {{menu.menuName}}
                            </button>
                        </div>

                        <div class="review-list">
                            <div class="review-item" v-if="reviewList.length === 0">
                                <div class="review-text">조회된 리뷰가 없습니다.</div>
                            </div>

                            <div class="review-item" v-for="item in reviewList" :key="item.reviewNo">
                                <div class="review-top">
                                    <div class="review-writer">
                                        예약번호 {{item.rsvNo}} | {{item.userName}} ({{item.nickname}})
                                    </div>
                                    <div class="review-score">
                                        {{'★'.repeat(item.rating)}}{{'☆'.repeat(5 - item.rating)}}
                                    </div>
                                </div>

                                <div class="review-menu">메뉴 : {{item.menuName}}</div>

                                <div class="review-image-box" v-if="item.filePath">
                                    <img v-for="imagePath in fnReviewImageList(item.filePath)"
                                        :key="imagePath"
                                        :src="imagePath"
                                        alt="리뷰 이미지"
                                        class="review-image">
                                </div>

                                <div class="review-text">{{item.rContents}}</div>
                                <div class="review-date">{{item.reviewDate}}</div>

                                <div class="review-btn-area">
                                    <button type="button"
                                            class="line-btn danger-btn"
                                            v-if="!item.repStatus"
                                            @click="fnReportReview(item.reviewNo)">
                                        신고하기
                                    </button>

                                    <button type="button"
                                            class="line-btn"
                                            v-if="item.repStatus === 'WAI'"
                                            disabled>
                                        신고됨
                                    </button>

                                    <button type="button"
                                            class="line-btn"
                                            v-if="item.repStatus === 'REJ'"
                                            disabled>
                                        반려됨
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div v-if="showReportModal" class="modal-overlay">
                    <div class="edit-modal-box">
                        <div class="modal-header">
                            <h2>리뷰 신고</h2>
                            <button type="button" class="modal-close-btn" @click="fnCloseReportModal">X</button>
                        </div>

                        <div class="modal-body">
                            <div class="form-row">
                                <label>신고 사유</label>
                                <textarea v-model="reportForm.reportReason" placeholder="신고 사유를 입력해주세요."></textarea>
                            </div>
                        </div>

                        <div class="modal-footer">
                            <button type="button" class="cancel-btn" @click="fnCloseReportModal">취소</button>
                            <button type="button" class="save-btn" @click="fnSaveReportReview">신고하기</button>
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
                // 변수 - (key : value)
                reviewSummary: {
                    totalReviewCount: 0,
                    avgRating: 0,
                    recentReviewRating: 0
                },
                reviewMenuList: [],
                selectedMenuNo: "",
                reviewList: [],
                showReportModal: false,
                reportForm: {
                    reviewNo: "",
                    reportReason: ""
                }
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnGetReviewSummary: function () {
                let self = this;
                let param = {};

                $.ajax({
                    url: "/getReviewSummary.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.result === "success" && data.info) {
                            self.reviewSummary = {
                                totalReviewCount: data.info.totalReviewCount || 0,
                                avgRating: data.info.avgRating || 0,
                                recentReviewRating: data.info.recentReviewRating || 0
                            };
                        } else {
                            self.reviewSummary = {
                                totalReviewCount: 0,
                                avgRating: 0,
                                recentReviewRating: 0
                            };
                        }
                    },
                    error: function () {
                        alert("리뷰 요약 조회에 실패했습니다.");
                    }
                });
            },

            fnGetReviewMenuList: function () {
                let self = this;
                let param = {};

                $.ajax({
                    url: "/getReviewMenuList.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.result === "success" && data.list) {
                            self.reviewMenuList = data.list;
                        } else {
                            self.reviewMenuList = [];
                        }
                    },
                    error: function () {
                        alert("메뉴 목록 조회에 실패했습니다.");
                    }
                });
            },

            fnGetReviewList: function () {
                let self = this;
                let param = {
                    menuNo: self.selectedMenuNo
                };

                $.ajax({
                    url: "/getReviewList.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.result === "success" && data.list) {
                            self.reviewList = data.list;
                        } else {
                            self.reviewList = [];
                        }
                    },
                    error: function () {
                        alert("리뷰 목록 조회에 실패했습니다.");
                    }
                });
            },

            fnChangeMenu: function (menuNo) {
                let self = this;
                self.selectedMenuNo = menuNo;
                self.fnGetReviewList();
            },

            fnReportReview: function (reviewNo) {
                let self = this;

                self.reportForm = {
                    reviewNo: reviewNo,
                    reportReason: ""
                };

                self.showReportModal = true;
            },

            fnCloseReportModal: function () {
                let self = this;

                self.showReportModal = false;
                self.reportForm = {
                    reviewNo: "",
                    reportReason: ""
                };
            },

            fnSaveReportReview: function () {
                let self = this;

                if (!self.reportForm.reportReason.trim()) {
                    alert("신고 사유를 입력해주세요.");
                    return;
                }

                let param = {
                    reviewNo: self.reportForm.reviewNo,
                    reportReason: self.reportForm.reportReason
                };

                $.ajax({
                    url: "/reportReview.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        if (data.result === "success") {
                            alert("리뷰가 신고되었습니다.");
                            self.fnCloseReportModal();
                            self.fnGetReviewList();
                        } else {
                            alert(data.message || "리뷰 신고에 실패했습니다.");
                        }
                    },
                    error: function () {
                        alert("리뷰 신고 중 오류가 발생했습니다.");
                    }
                });
            },

            fnReviewImageList: function (filePath) {
                if (!filePath) {
                    return [];
                }

                return filePath.split("|").filter(function (item) {
                    return item;
                });
            },

        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            self.fnGetReviewSummary();
            self.fnGetReviewMenuList();
            self.fnGetReviewList();
        }
    });

    app.mount('#app');
</script>