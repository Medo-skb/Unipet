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
                    <jsp:param name="activeMenu" value="qnaAnswer" />
                </jsp:include>

                <section class="admin-content">
                    <div class="content-card">
                        <h2>쇼핑몰 문의 답변 관리</h2>
                        <div class="content-desc">쇼핑몰 상품 문의와 답변 상태를 조회합니다.</div>

                        <div class="admin-search-box">
                            <select class="admin-search-select" v-model="ansStatus" @change="fnSearchQnaAnswerList">
                                <option value="">전체</option>
                                <option value="N">미답변</option>
                                <option value="Y">답변 완료</option>
                            </select>
                        </div>

                        <div class="admin-qna-table-wrap" v-if="qnaAnswerList.length > 0">
                            <table class="admin-user-table admin-qna-table">
                                <thead>
                                    <tr>
                                        <th>답변여부</th>
                                        <th>문의자 ID</th>
                                        <th>상품 명</th>
                                        <th>문의 제목</th>
                                        <th>문의 내용</th>
                                        <th>비공개 여부</th>
                                        <th>문의 날짜</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="item in pagedQnaList" :key="item.qnaNo">
                                        <td>
                                            <button
                                                v-if="!fnIsAnswered(item)"
                                                type="button"
                                                class="admin-mini-btn qna-answer-action"
                                                @click="fnOpenAnswerModal(item)">
                                                답변하기
                                            </button>

                                            <span v-else class="qna-answer-complete">
                                                답변완료
                                            </span>
                                        </td>

                                        <td>
                                            <span class="qna-ellipsis" :title="fnEmpty(item.userId)">
                                                {{ fnEmpty(item.userId) }}
                                            </span>
                                        </td>

                                        <td>
                                            <button
                                                type="button"
                                                class="detail-link-btn qna-ellipsis-btn"
                                                :title="fnEmpty(item.productName)"
                                                @click="fnGoProductDetail(item.productNo)">
                                                {{ fnEmpty(item.productName) }}
                                            </button>
                                        </td>

                                        <td>
                                            <span class="qna-ellipsis" :title="fnEmpty(item.qnaTitle)">
                                                {{ fnEmpty(item.qnaTitle) }}
                                            </span>
                                        </td>

                                        <td>
                                            <span class="qna-ellipsis" :title="fnEmpty(item.qContents)">
                                                {{ fnEmpty(item.qContents) }}
                                            </span>
                                        </td>

                                        <td>
                                            {{ item.isSecret === 'Y' ? '비공개' : '공개' }}
                                        </td>

                                        <td>
                                            {{ fnQnaDate(item.cdate) }}
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <div class="empty-box" v-else>
                            조회된 상품 문의가 없습니다.
                        </div>
                        <div class="admin-pagination" v-if="qnaAnswerList.length > 0">
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
            </div>
        </div>
        <div class="admin-user-modal-bg" v-if="answerModalOpen">
            <div class="admin-user-modal admin-qna-answer-modal">
                <div class="admin-user-modal-header">
                    <h3>문의 답변 작성</h3>
                    <button type="button" class="admin-user-modal-close" @click="fnCloseAnswerModal">×</button>
                </div>

                <div class="admin-user-modal-body" v-if="selectedQna">
                    <table class="approve-table">
                        <tbody>
                            <tr>
                                <th>문의자 ID</th>
                                <td>{{ fnEmpty(selectedQna.userId) }}</td>
                            </tr>
                            <tr>
                                <th>문의 날짜</th>
                                <td>{{ fnQnaDate(selectedQna.cdate) }}</td>
                            </tr>
                            <tr>
                                <th>문의 제목</th>
                                <td>{{ fnEmpty(selectedQna.qnaTitle) }}</td>
                            </tr>
                            <tr>
                                <th>문의 내용</th>
                                <td>
                                    <div class="qna-modal-content">
                                        {{ fnEmpty(selectedQna.qContents) }}
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>답변 작성</th>
                                <td>
                                    <textarea
                                        class="qna-answer-textarea"
                                        v-model="answerContents"
                                        placeholder="답변 내용을 입력하세요."></textarea>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <div class="report-btn-box">
                        <button type="button" class="btn-approve" @click="fnSaveQnaAnswer">
                            저장
                        </button>
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
            ansStatus: "",
            qnaAnswerList: [],
            currentPage: 1,
            pageSize: 10,
            answerModalOpen: false,
            selectedQna: null,
            answerContents: ""
        };
    },
    computed: {
        totalPage: function () {
            return Math.ceil(this.qnaAnswerList.length / this.pageSize);
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

        pagedQnaList: function () {
            let start = (this.currentPage - 1) * this.pageSize;
            let end = start + this.pageSize;

            return this.qnaAnswerList.slice(start, end);
        }
    },
    methods: {
        fnQnaAnswerList: function () {
            let self = this;

            $.ajax({
                url: "/admin/qna/list.dox",
                type: "POST",
                dataType: "json",
                data: {
                    ansStatus: self.ansStatus
                },
                success: function (data) {
                    if (data.result === "success") {
                        self.qnaAnswerList = data.list || [];

                        if (self.currentPage > self.totalPage) {
                            self.currentPage = self.totalPage || 1;
                        }
                    } else {
                        alert(data.message);
                    }
                },
                error: function () {
                    alert("쇼핑몰 문의 목록 조회 중 오류가 발생했습니다.");
                }
            });
        },

        fnOpenAnswerModal: function (item) {
            this.selectedQna = item;
            this.answerContents = item.aContents || "";
            this.answerModalOpen = true;
        },

        fnCloseAnswerModal: function () {
            this.answerModalOpen = false;
            this.selectedQna = null;
            this.answerContents = "";
        },

        fnSaveQnaAnswer: function () {
            let self = this;

            if (!self.selectedQna || !self.selectedQna.qnaNo) {
                alert("문의 정보가 없습니다.");
                return;
            }

            if (!self.answerContents || self.answerContents.trim() === "") {
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
                    qnaNo: self.selectedQna.qnaNo,
                    aContents: self.answerContents.trim()
                },
                success: function (data) {
                    if (data.result === "success") {
                        alert("답변이 등록되었습니다.");
                        self.fnCloseAnswerModal();
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

        fnGoProductDetail: function (productNo) {
            location.href = "/product/view.do?productNo=" + productNo;
        },

        fnIsAnswered: function (item) {
            return item.ansStatus === "Y";
        },

        fnQnaDate: function (value) {
            if (!value) {
                return "-";
            }

            let dateText = String(value).substring(0, 10);
            let parts = dateText.split("-");

            if (parts.length === 3) {
                return parts[0].substring(2, 4) + "." + parts[1] + "." + parts[2];
            }

            return value;
        },

        fnEmpty: function (value) {
            if (value === null || value === undefined || value === "") {
                return "-";
            }

            return value;
        },
        fnSearchQnaAnswerList: function () {
            this.currentPage = 1;
            this.fnQnaAnswerList();
        },

        fnMovePage: function (page) {
            if (page < 1 || page > this.totalPage) {
                return;
            }

            this.currentPage = page;
        },
    },
    mounted() {
        this.fnQnaAnswerList();
    }
});

app.mount('#app');
</script>