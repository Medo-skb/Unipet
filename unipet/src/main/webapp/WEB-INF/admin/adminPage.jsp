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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
</head>
<body>

    <!-- 헤더 -->
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <div class="container-main">
            <div class="admin-wrap">
                <!-- 왼쪽 메뉴 -->
                <aside class="admin-sidebar">
                    <div 
                        class="menu-item"
                        :class="{ active : currentMenu === 'report' }"
                        @click="fnChangeMenu('report')">
                        커뮤니티 및 리뷰 신고 관리
                    </div>
                    <div 
                        class="menu-item"
                        :class="{ active : currentMenu === 'storeApprove' }"
                        @click="fnChangeMenu('storeApprove')">
                        사업자 입점 승인 관리
                    </div>
                    <div 
                        class="menu-item"
                        :class="{ active : currentMenu === 'qnaAnswer' }"
                        @click="fnChangeMenu('qnaAnswer')">
                        쇼핑몰 문의 답변 관리
                    </div>
                </aside>

                <!-- 오른쪽 내용 -->
                <section class="admin-content">
                    <div class="content-card">
                        <template v-if="currentMenu === 'report'">
                            <h2>커뮤니티 및 리뷰 신고 관리</h2>
                            <div class="content-desc">신고 유형별로 접수된 신고를 확인하고 처리할 수 있습니다.</div>

                            <!-- 신고 서브 탭 -->
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
                        </template>

                        <template v-if="currentMenu === 'storeApprove'">
                            <h2>사업자 입점 승인 관리</h2>
                            <div class="content-desc">승인 대기 중인 사업자 목록입니다.</div>

                            <div class="approve-list" v-if="approveList && approveList.length > 0">
                                <template v-for="item in approveList" :key="item.storeNo">
                                    <div class="approve-card" v-if="item.uStatus === 'PND'">
                                        <table class="approve-table">
                                            <tbody>
                                                <tr>
                                                    <th>업체 번호</th>
                                                    <td>{{ item.storeNo }}</td>
                                                </tr>
                                                <tr>
                                                    <th>아이디</th>
                                                    <td>{{ item.sUserId }}</td>
                                                </tr>
                                                <tr>
                                                    <th>업체명</th>
                                                    <td>{{ item.storeName }}</td>
                                                </tr>
                                                <tr>
                                                    <th>업종</th>
                                                    <td>{{ item.sCategory }}</td>
                                                </tr>
                                                <tr>
                                                    <th>주소</th>
                                                    <td>{{ item.sAddr }} {{ item.sFullAddr }}</td>
                                                </tr>
                                                <tr>
                                                    <th>상태</th>
                                                    <td>
                                                        {{
                                                            item.uStatus === 'PND' ? '승인 대기'
                                                            : item.uStatus === 'APR' ? '승인'
                                                            : item.uStatus === 'REJ' ? '거부'
                                                            : item.uStatus
                                                        }}
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>사업자 등록증 사본</th>
                                                    <td>
                                                        <a v-if="item.filePath && item.fileName"
                                                        href="javascript:;"
                                                        class="file-link"
                                                        @click="fnFilePreview(item)">
                                                            {{ item.originName }}
                                                        </a>
                                                        <span v-else>사업자 등록증 사본 파일이 없습니다.</span>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>

                                        <div class="approve-btn-box">
                                            <button type="button" class="btn-approve" @click="fnApprove(item)">승인</button>
                                            <button type="button" class="btn-reject" @click="fnReject(item)">반려</button>
                                        </div>
                                    </div>
                                </template>
                            </div>

                            <div class="empty-box" v-if="fnPendingCount() === 0">
                                승인 대기 중인 사업자가 없습니다.
                            </div>
                        </template>

                        <template v-if="currentMenu === 'qnaAnswer'">
                            <h2>쇼핑몰 문의 답변 관리</h2>
                            <div class="content-desc">답변이 등록되지 않은 상품 문의 목록입니다.</div>

                            <div class="qna-list" v-if="qnaAnswerList.length > 0">
                                <div class="qna-card" v-for="item in qnaAnswerList" :key="item.qnaNo">
                                    <table class="report-table">
                                        <tbody>
                                            <tr>
                                                <th>상품명</th>
                                                <td colspan="3">
                                                    <span class="link-text" @click="fnGoProductDetail(item.productNo)">
                                                        {{ item.productName }}
                                                    </span>
                                                </td>
                                            </tr>

                                            <tr>
                                                <th>문의자</th>
                                                <td>
                                                    {{ item.userName }}
                                                    <span v-if="item.nickname">({{ item.nickname }})</span>
                                                </td>
                                                <th>문의자 ID</th>
                                                <td>{{ item.userId }}</td>
                                            </tr>

                                            <tr>
                                                <th>문의 날짜</th>
                                                <td colspan="3">{{ item.cdate }}</td>
                                            </tr>

                                            <tr>
                                                <th>문의 제목</th>
                                                <td colspan="3">{{ item.qnaTitle }}</td>
                                            </tr>
                                            <tr>
                                                <th>문의 내용</th>
                                                <td colspan="3">{{ item.qContents }}</td>
                                            </tr>
                                            <tr>
                                                <th>비공개 여부</th>
                                                <td colspan="3">
                                                    {{ item.isSecret === 'Y' ? '비공개' : '공개' }}
                                                </td>
                                            </tr>
                                            <tr>
                                                <th>답변 작성</th>
                                                <td colspan="3">
                                                    <textarea 
                                                        class="qna-answer-textarea"
                                                        v-model="item.aContents"
                                                        placeholder="답변 내용을 입력하세요."></textarea>
                                                </td>
                                            </tr>
                                        </tbody>
                                    </table>

                                    <div class="report-btn-box">
                                        <button type="button" class="btn-reject" @click="fnDeleteQna(item)">
                                            문의 삭제
                                        </button>

                                        <button type="button" class="btn-approve" @click="fnSaveQnaAnswer(item)">
                                            답변 등록
                                        </button>
                                    </div>
                                </div>
                            </div>

                            <div class="empty-box" v-else>
                                답변 대기 중인 문의가 없습니다.
                            </div>
                        </template>
                    </div>
                </section>
            </div>
        </div>
    </div>

    <!-- 푸터 -->
    <jsp:include page="/WEB-INF/footer/footer.jsp" />

</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                currentMenu: "report",
                reportTab: "bookingReview",

                approveList: [],
                bannerList: [],
                selectedFile: null,

                bookingReviewReportList: [],
                productReviewReportList: [],
                communityPostReportList: [],
                communityCommentReportList: [],
                qnaAnswerList: []
                
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnChangeMenu: function (menuName) {
                let self = this;
                self.currentMenu = menuName;

                localStorage.setItem("adminCurrentMenu", menuName);

                if (menuName === "report") {
                    let savedTab = localStorage.getItem("reportTab");

                    if (savedTab) {
                        self.reportTab = savedTab;
                    } else {
                        self.reportTab = "bookingReview";
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

                if (menuName === "storeApprove") {
                    self.fnBizList();
                }

                if (menuName === "qnaAnswer") {
                    self.fnQnaAnswerList();
                }
            },

            fnQnaAnswerList: function () {
                let self = this;

                $.ajax({
                    url: "/admin/qna/list.dox",
                    type: "POST",
                    dataType: "json",
                    success: function (data) {
                        if (data.result === "success") {
                            self.qnaAnswerList = data.list || [];
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function () {
                        alert("쇼핑몰 문의 목록 조회 중 오류가 발생했습니다.");
                    }
                });
            },

            fnSaveQnaAnswer: function (item) {
                let self = this;

                if (!item.aContents || item.aContents.trim() === "") {
                    alert("답변 내용을 입력하세요.");
                    return;
                }

                if (!confirm("해당 문의에 답변을 등록하시겠습니까?")) {
                    return;
                }

                $.ajax({
                    url: "/admin/qna/answer.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        qnaNo: item.qnaNo,
                        aContents: item.aContents
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            alert("답변이 등록되었습니다.");
                            self.fnQnaAnswerList();
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function () {
                        alert("답변 등록 중 오류가 발생했습니다.");
                    }
                });
            },

            fnDeleteQna: function (item) {
                let self = this;

                if (!confirm("해당 문의를 삭제하시겠습니까?")) {
                    return;
                }

                $.ajax({
                    url: "/admin/qna/delete.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        qnaNo: item.qnaNo
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            alert("문의가 삭제되었습니다.");
                            self.fnQnaAnswerList();
                        } else {
                            alert("문의 삭제에 실패했습니다.");
                        }
                    },
                    error: function () {
                        alert("문의 삭제 중 오류가 발생했습니다.");
                    }
                });
            },

            fnGoProductDetail: function(productNo) {
                location.href = "/product/view.do?productNo=" + productNo;
            },

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
                let param = {};

                $.ajax({
                    url: "/getProductReviewReportList.dox",
                    type: "POST",
                    dataType: "json",
                    data: param,
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
                let param = {};

                $.ajax({
                    url: "/getReservationReviewReportList.dox",
                    type: "POST",
                    dataType: "json",
                    data: param,
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

            // 사업자 승인 대기 목록 조회
            fnBizList: function () {
                let self = this;
                let param = {};

                $.ajax({
                    url: "/adminBiz.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {

                        if (data.result === "success") {
                            self.approveList = data.list;
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function () {
                        alert("서버 통신 중 오류가 발생했습니다.");
                    }
                });
            },

            fnApprove: function (item) {
                let self = this;

                if (!confirm(item.storeName + " 업체를 승인하시겠습니까?")) {
                    return;
                }

                $.ajax({
                    url: "/editBizStatusApr.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        storeNo: item.storeNo,
                        sUserId: item.sUserId
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            alert("승인 완료되었습니다.");
                            self.fnBizList();
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function () {
                        alert("서버 통신 중 오류가 발생했습니다.");
                    }
                });
            },

            fnReject: function (item) {
                let self = this;

                if (!confirm(item.storeName + " 업체를 반려하시겠습니까?")) {
                    return;
                }

                let rejReason = prompt("반려 사유를 입력하세요.");

                if (rejReason === null) {
                    return;
                }

                rejReason = rejReason.trim();

                $.ajax({
                    url: "/editBizStatusRej.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        storeNo: item.storeNo,
                        sUserId: item.sUserId,
                        rejReason: rejReason
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            alert("반려 완료되었습니다.");
                            self.fnBizList();
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function () {
                        alert("서버 통신 중 오류가 발생했습니다.");
                    }
                });
            },

            fnFilePreview: function (item) {
                let url = item.filePath + item.fileName;
                window.open(url, "_blank");
            },

            fnPendingCount: function () {
                let self = this;
                return self.approveList.filter(function (item) {
                    return item.uStatus === "PND";
                }).length;
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
            },
            
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            let savedMenu = localStorage.getItem("adminCurrentMenu");
                let savedTab = localStorage.getItem("reportTab");

                if (savedMenu) {
                    self.currentMenu = savedMenu;
                }

                if (savedTab) {
                    self.reportTab = savedTab;
                }

                if (self.currentMenu === "storeApprove") {
                    self.fnBizList();
                }

                if (self.currentMenu === "report") {
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

                if (self.currentMenu === "qnaAnswer") {
                    self.fnQnaAnswerList();
                }
        }
    });

    app.mount('#app');
</script>