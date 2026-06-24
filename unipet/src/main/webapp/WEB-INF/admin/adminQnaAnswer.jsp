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
                        <div class="content-desc">답변이 등록되지 않은 상품 문의 목록입니다.</div>

                        <div class="qna-list" v-if="qnaGroupList.length > 0">
                            <div class="qna-product-card" v-for="group in qnaGroupList" :key="group.productNo">
                                <div class="qna-product-header" @click="fnToggleQnaProduct(group.productNo)">
                                    <div class="qna-product-title">
                                        <span class="qna-toggle-icon">
                                            {{ openedProductMap[group.productNo] ? '▼' : '▶' }}
                                        </span>

                                        <span class="link-text" @click.stop="fnGoProductDetail(group.productNo)">
                                            {{ group.productName }}
                                        </span>
                                    </div>

                                    <span class="qna-product-count">
                                        문의 {{ group.items.length }}건
                                    </span>
                                </div>

                                <div class="qna-card" v-if="openedProductMap[group.productNo]" v-for="item in group.items" :key="item.qnaNo">
                                    <table class="report-table">
                                        <tbody>
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
                        </div>

                        <div class="empty-box" v-else>
                            답변 대기 중인 문의가 없습니다.
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
                qnaAnswerList: [],
                openedProductMap: {}
            };
        },
        computed: {
            qnaGroupList: function () {
                let groupMap = {};
                let groupList = [];

                this.qnaAnswerList.forEach(function (item) {
                    let productNo = item.productNo;

                    if (!groupMap[productNo]) {
                        groupMap[productNo] = {
                            productNo: productNo,
                            productName: item.productName,
                            items: []
                        };

                        groupList.push(groupMap[productNo]);
                    }

                    groupMap[productNo].items.push(item);
                });

                return groupList;
            }
        },
        methods: {
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

            fnToggleQnaProduct: function (productNo) {
                this.openedProductMap[productNo] = !this.openedProductMap[productNo];
            }
        },
        mounted() {
            let self = this;
            self.fnQnaAnswerList();
        }
    });

    app.mount('#app');
</script>