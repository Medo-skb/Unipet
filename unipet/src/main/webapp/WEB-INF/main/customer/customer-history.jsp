<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>UNIPET</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/customer.css">
</head>
<body>

<jsp:include page="/WEB-INF/header/header.jsp" />

<div id="app" v-cloak>
    <div class="customer-wrap">

        <jsp:include page="/WEB-INF/main/customer/customerSidebar.jsp">
            <jsp:param name="activeMenu" value="history" />
        </jsp:include>

        <section class="customer-content">
            <div class="customer-card">
                <h2>문의 내역</h2>
                <p class="customer-desc">
                    작성한 홈페이지 문의와 답변 상태를 확인할 수 있습니다.
                </p>

                <div class="customer-history-filter">
                    <select class="customer-filter-select" v-model="filter.unaType" @change="fnSearch">
                        <option value="">전체 유형</option>
                        <option value="계정/로그인">계정/로그인</option>
                        <option value="결제">결제</option>
                        <option value="배송">배송</option>
                        <option value="교환/반품/환불">교환/반품/환불</option>
                        <option value="쿠폰/이벤트">쿠폰/이벤트</option>
                        <option value="사이트 오류">사이트 오류</option>
                        <option value="입점/사업자 문의">입점/사업자 문의</option>
                        <option value="기타">기타</option>
                    </select>

                    <select class="customer-filter-select" v-model="filter.answerYn" @change="fnSearch">
                        <option value="">전체 답변 상태</option>
                        <option value="N">미답변</option>
                        <option value="Y">답변 완료</option>
                    </select>

                    <input type="text"
                           class="customer-filter-input"
                           v-model="filter.keyword"
                           @keydown.enter="fnSearch"
                           placeholder="문의 제목 또는 본문 검색">

                    <button type="button" class="customer-filter-btn" @click="fnSearch">검색</button>
                </div>

                <div class="customer-history-table-wrap">
                    <table class="customer-history-table">
                        <thead>
                            <tr>
                                <th style="width: 120px;">답변 여부</th>
                                <th style="width: 160px;">유형</th>
                                <th>문의 제목</th>
                                <th style="width: 140px;">문의 날짜</th>
                            </tr>
                        </thead>
                        <tbody>
                            <template v-if="list.length > 0">
                                <template v-for="item in list" :key="item.unaNo">
                                    <tr class="customer-history-row" @click="fnToggleDetail(item)">
                                        <td>
                                            <span :class="['answer-badge', item.answerYn === 'Y' ? 'complete' : 'wait']">
                                                {{ item.answerYn === 'Y' ? '답변 완료' : '미답변' }}
                                            </span>
                                        </td>
                                        <td>{{ item.unaType }}</td>
                                        <td class="history-title">{{ item.unaTitle }}</td>
                                        <td>{{ item.cdate }}</td>
                                    </tr>

                                    <tr v-if="selectedUnaNo === item.unaNo" class="customer-history-detail-row">
                                        <td colspan="4">
                                            <div class="customer-history-detail">
                                                <div class="detail-block">
                                                    <div class="detail-label">문의 제목</div>
                                                    <div class="detail-content title">{{ item.unaTitle }}</div>
                                                </div>

                                                <div class="detail-block">
                                                    <div class="detail-label">문의 내용</div>
                                                    <div class="detail-content">{{ item.unaContent }}</div>
                                                </div>

                                                <div class="detail-block">
                                                    <div class="detail-label">답변 내용</div>

                                                    <div class="detail-content answer" v-if="item.answerYn === 'Y' && item.unaAnswer">
                                                        {{ item.unaAnswer }}
                                                    </div>

                                                    <div class="detail-content no-answer" v-else>
                                                        아직 답변이 등록되지 않은 문의입니다.<br>
                                                        관리자가 문의 내용을 확인한 뒤 답변을 등록할 예정입니다.
                                                    </div>
                                                </div>
                                            </div>
                                        </td>
                                    </tr>
                                </template>
                            </template>

                            <tr v-else>
                                <td colspan="4">
                                    <div class="customer-empty-box">조회된 문의 내역이 없습니다.</div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="customer-pagination" v-if="totalPage > 0">
                    <button type="button"
                            class="page-btn"
                            :disabled="page === 1"
                            @click="fnMovePage(page - 1)">
                        이전
                    </button>

                    <button type="button"
                            v-for="num in pageList"
                            :key="num"
                            :class="['page-btn', page === num ? 'active' : '']"
                            @click="fnMovePage(num)">
                        {{ num }}
                    </button>

                    <button type="button"
                            class="page-btn"
                            :disabled="page === totalPage"
                            @click="fnMovePage(page + 1)">
                        다음
                    </button>
                </div>
            </div>
        </section>
    </div>
</div>

<jsp:include page="/WEB-INF/footer/footer.jsp" />

<script>
const app = Vue.createApp({
    data() {
        return {
            list: [],
            filter: {
                unaType: "",
                answerYn: "",
                keyword: ""
            },
            page: 1,
            pageSize: 10,
            count: 0,
            selectedUnaNo: null
        };
    },
    computed: {
        totalPage() {
            return Math.ceil(this.count / this.pageSize);
        },

        pageList() {
            const blockSize = 5;
            const currentBlock = Math.ceil(this.page / blockSize);
            const startPage = (currentBlock - 1) * blockSize + 1;
            let endPage = startPage + blockSize - 1;

            if (endPage > this.totalPage) {
                endPage = this.totalPage;
            }

            let list = [];
            for (let i = startPage; i <= endPage; i++) {
                list.push(i);
            }

            return list;
        }
    },
    mounted() {
        this.fnGetList();
    },
    methods: {
        fnGetList() {
            let self = this;

            $.ajax({
                url: "/unipet/customer/history/list.dox",
                type: "POST",
                dataType: "json",
                data: {
                    unaType: self.filter.unaType,
                    answerYn: self.filter.answerYn,
                    keyword: self.filter.keyword,
                    page: self.page
                },
                success: function(data) {
                    if (data.result === "success") {
                        self.list = data.list || [];
                        self.count = data.count || 0;
                        self.pageSize = data.pageSize || 10;
                        self.selectedUnaNo = null;
                    } else if (data.result === "notLogin") {
                        alert("로그인 후 확인할 수 있습니다.");
                        location.href = "/user/login.do";
                    } else {
                        alert(data.message || "문의 내역 조회에 실패했습니다.");
                    }
                },
                error: function() {
                    alert("문의 내역 조회 중 오류가 발생했습니다.");
                }
            });
        },

        fnSearch() {
            this.page = 1;
            this.fnGetList();
        },

        fnMovePage(num) {
            if (num < 1 || num > this.totalPage || num === this.page) {
                return;
            }

            this.page = num;
            this.fnGetList();
        },

        fnToggleDetail(item) {
            if (this.selectedUnaNo === item.unaNo) {
                this.selectedUnaNo = null;
            } else {
                this.selectedUnaNo = item.unaNo;
            }
        }
    }
});

app.mount("#app");
</script>

</body>
</html>