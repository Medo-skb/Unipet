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
                    <jsp:param name="activeMenu" value="storeApprove" />
                </jsp:include>

                <section class="admin-content">
                    <div class="content-card">
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
                                                <td>
                                                    {{
                                                        item.sCategory === 'HOS' ? '병원' :
                                                        item.sCategory === 'SAL' ? '미용실' :
                                                        item.sCategory === 'BRD' ? '위탁시설' :
                                                        item.sCategory
                                                    }}
                                                </td>
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
                                        <button type="button" class="btn-approve" @click="fnApprove(item)">
                                            승인
                                        </button>
                                        <button type="button" class="btn-reject" @click="fnReject(item)">
                                            반려
                                        </button>
                                    </div>
                                </div>
                            </template>
                        </div>

                        <div class="empty-box" v-if="fnPendingCount() === 0">
                            승인 대기 중인 사업자가 없습니다.
                        </div>
                    </div>
                </section>
            </div>
        </div>

        <!-- 사업자 반려 사유 입력 모달 -->
        <div class="reject-modal-bg" v-if="rejectModalOpen">
            <div class="reject-modal">
                <div class="reject-modal-header">
                    <h3>반려 사유 입력</h3>
                    <button type="button" class="reject-modal-close" @click="fnCloseRejectModal">×</button>
                </div>

                <div class="reject-modal-body">
                    <div class="reject-store-name">
                        업체명: <strong>{{ rejectTarget ? rejectTarget.storeName : '' }}</strong>
                    </div>

                    <textarea
                        class="reject-reason-textarea"
                        v-model="rejectReason"
                        placeholder="반려 사유를 입력하세요."></textarea>
                </div>

                <div class="reject-modal-footer">
                    <button type="button" class="btn-cancel" @click="fnCloseRejectModal">취소</button>
                    <button type="button" class="btn-reject" @click="fnSubmitReject">반려</button>
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
                approveList: [],

                rejectModalOpen: false,
                rejectTarget: null,
                rejectReason: ""
            };
        },
        methods: {
            fnBizList: function () {
                let self = this;

                $.ajax({
                    url: "/adminBiz.dox",
                    dataType: "json",
                    type: "POST",
                    data: {},
                    success: function (data) {
                        if (data.result === "success") {
                            self.approveList = data.list || [];
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

                self.rejectTarget = item;
                self.rejectReason = "";
                self.rejectModalOpen = true;
            },

            fnCloseRejectModal: function () {
                let self = this;

                self.rejectModalOpen = false;
                self.rejectTarget = null;
                self.rejectReason = "";
            },

            fnSubmitReject: function () {
                let self = this;

                if (!self.rejectTarget) {
                    alert("반려할 업체 정보가 없습니다.");
                    return;
                }

                let rejReason = self.rejectReason.trim();

                if (rejReason === "") {
                    alert("반려 사유를 입력하세요.");
                    return;
                }

                if (!confirm(self.rejectTarget.storeName + " 업체를 반려하시겠습니까?")) {
                    return;
                }

                $.ajax({
                    url: "/editBizStatusRej.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        storeNo: self.rejectTarget.storeNo,
                        sUserId: self.rejectTarget.sUserId,
                        rejReason: rejReason
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            alert("반려 완료되었습니다.");
                            self.fnCloseRejectModal();
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

                if (!self.approveList || self.approveList.length === 0) {
                    return 0;
                }

                return self.approveList.filter(function (item) {
                    return item.uStatus === "PND";
                }).length;
            }
        },
        mounted() {
            let self = this;
            self.fnBizList();
        }
    });

    app.mount('#app');
</script>