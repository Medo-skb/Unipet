<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>UNIPET</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bizMyPage/bizCommon.css">
</head>
<body>
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app" v-cloak>
        <div class="biz-page-wrap">
            <div class="biz-page-container">

                <jsp:include page="/WEB-INF/bizMyPage/bizSidebar.jsp">
                    <jsp:param name="activeMenu" value="apply" />
                </jsp:include>

                <section class="biz-content">
                    <div class="content-header">
                        <h1>사업자 신청</h1>
                    </div>

                    <div class="content-section">
                        <div v-if="applyInfo && applyInfo.sStatus === 'REJ'">
                            <div class="section-header">
                                <h2>입점 신청이 반려되었습니다.</h2>
                            </div>

                            <div class="empty-text">
반려 사유: {{ applyInfo.rejReason ? applyInfo.rejReason : '반려 사유가 등록되지 않았습니다.' }}
                            </div>
                            <div class="empty-text-re">업체 정보를 수정한 후 재신청해주세요.</div>

                            <div class="section-btn-area">
                                <button type="button" class="edit-btn" @click="fnOpenReapplyModal">
                                    재신청하기
                                </button>
                            </div>
                        </div>

                        <div v-else-if="applyInfo && applyInfo.sStatus === 'PND'">
                            <div class="empty-text">
                                입점 신청이 접수되었습니다. 관리자 승인 심사 중입니다.
                            </div>
                        </div>

                        <div v-else>
                            <div class="empty-text">
                                등록된 입점 신청 정보가 없습니다.
                            </div>
                        </div>
                    </div>

                    <div class="reapply-modal-bg" v-if="reapplyModalOpen">
                        <div class="reapply-modal">
                            <div class="reapply-modal-header">
                                <h3>사업자 재신청</h3>
                                <button type="button" class="reapply-modal-close" @click="fnCloseReapplyModal">×</button>
                            </div>

                            <div class="reapply-modal-body">
                                <div class="signup-section">
                                    <div class="signup-section">
                                        <div class="section-title">신청 업체</div>

                                        <div class="selected-store" v-if="selectedStore">
                                            <div class="selected-label">선택한 업체</div>
                                            <div class="selected-name">{{ selectedStore.storeName }}</div>
                                            <div class="selected-detail">{{ fnCategoryName(selectedStore.sCategory) }} · {{ selectedStore.sAddr }}</div>
                                        </div>

                                        <div class="empty-text" v-else>
                                            신청 업체 정보를 불러오지 못했습니다.
                                        </div>
                                    </div>

                                <div class="signup-section">
                                    <div class="section-title">사업자 정보</div>

                                    <div class="input-group">
                                        <label>사업자번호</label>
                                        <div class="biznum-row">
                                            <input type="text" class="input-field biznum-input biznum-3" v-model="biznum1" maxlength="3" placeholder="123" :readonly="biznumChecked" @input="fnOnlyBiznum('biznum1', 3)">
                                            <span class="biznum-dash">-</span>
                                            <input type="text" class="input-field biznum-input biznum-2" v-model="biznum2" maxlength="2" placeholder="45" :readonly="biznumChecked" @input="fnOnlyBiznum('biznum2', 2)">
                                            <span class="biznum-dash">-</span>
                                            <input type="text" class="input-field biznum-input biznum-5" v-model="biznum3" maxlength="5" placeholder="67890" :readonly="biznumChecked" @input="fnOnlyBiznum('biznum3', 5)">
                                            <button type="button" class="btn-sub" @click="fnCheckBiznum" :disabled="biznumChecked">
                                                {{ biznumChecked ? '확인완료' : '중복확인' }}
                                            </button>
                                            <button type="button" class="btn-sub btn-biznum-reset" v-if="biznumChecked" @click="fnResetBiznum">
                                                다시입력
                                            </button>
                                        </div>
                                        <div v-if="biznumMsg" class="info-text" :class="{ success: biznumChecked }">{{ biznumMsg }}</div>
                                    </div>

                                    <div class="input-group">
                                        <label>대표자명</label>
                                        <input type="text" class="input-field" v-model="ceoName" placeholder="대표자명을 입력해주세요">
                                    </div>

                                    <div class="input-group">
                                        <label>기존 사업자등록증</label>
                                        <div class="info-text">
                                            <button
                                                v-if="bizFileName"
                                                type="button"
                                                class="biz-file-link"
                                                @click="fnOpenBizFile">
                                                {{ bizFileName }}
                                            </button>
                                            <span v-else>등록된 파일이 없습니다.</span>
                                        </div>
                                    </div>

                                    <div class="input-group">
                                        <label>사업자등록증 재등록</label>
                                        <input type="file" class="input-field file-field" @change="fnHandleFile" accept=".jpg,.jpeg,.png,.pdf">
                                        <div class="info-text">새 파일을 선택하면 기존 사업자등록증이 변경됩니다.</div>
                                    </div>
                                </div>
                            </div>

                            <div class="reapply-modal-footer">
                                <button type="button" class="cancel-btn" @click="fnCloseReapplyModal">취소</button>
                                <button type="button" class="edit-btn" @click="fnReapplyBiz">재신청하기</button>
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
                    applyInfo: null,

                    reapplyModalOpen: false,
                    selectedStore: null,

                    sUserId: "",
                    ceoName: "",
                    biznum1: "",
                    biznum2: "",
                    biznum3: "",
                    biznumChecked: false,
                    biznumMsg: "",
                    bizFileName: "",
                    bizFile: null
                };
            },
            methods: {
                fnGetApplyStatus: function () {
                    let self = this;

                    $.ajax({
                        url: "/biz/applyStatus.dox",
                        dataType: "json",
                        type: "POST",
                        data: {},
                        success: function (data) {
                            if (data.result === "success") {
                                self.applyInfo = data.info;

                                if (
                                    self.applyInfo
                                    && self.applyInfo.sStatus !== "REJ"
                                    && self.applyInfo.sStatus !== "PND"
                                ) {
                                    location.href = "/biz/MyPage.do";
                                    return;
                                }
                            } else {
                                alert(data.message);
                            }
                        },
                        error: function () {
                            alert("서버 통신 중 오류가 발생했습니다.");
                        }
                    });
                },
                fnOpenReapplyModal: function () {
                    this.reapplyModalOpen = true;
                },
                fnCloseReapplyModal: function () {
                    this.reapplyModalOpen = false;
                },
                fnOpenReapplyModal: function () {
                    let self = this;

                    $.ajax({
                        url: "/admin/biz/reapplyInfo.dox",
                        type: "POST",
                        dataType: "json",
                        data: {},
                        success: function (data) {
                            if (data.result === "success") {
                                let info = data.info;

                                self.sUserId = info.sUserId;
                                self.ceoName = info.ceoName;
                                self.bizFileName = info.bizFileName;

                                self.biznum1 = "";
                                self.biznum2 = "";
                                self.biznum3 = "";
                                self.biznumChecked = false;
                                self.biznumMsg = "";

                                self.selectedStore = {
                                    storeNo: info.storeNo,
                                    storeName: info.storeName,
                                    sCategory: info.sCategory,
                                    sAddr: info.sAddr
                                };
                                self.bizFile = null;
                                self.reapplyModalOpen = true;
                            } else {
                                alert(data.message || "재신청 정보를 불러오지 못했습니다.");
                            }
                        },
                        error: function () {
                            alert("서버 통신 중 오류가 발생했습니다.");
                        }
                    });
                },

                fnCloseReapplyModal: function () {
                    this.reapplyModalOpen = false;
                },

                fnCategoryName: function (category) {
                    if (category === "HOS") return "병원";
                    if (category === "SAL") return "미용";
                    if (category === "BRD") return "위탁시설";
                    return "기타";
                },

                fnResetIdCheck: function () {
                    if (this.userId === this.originalUserId) {
                        this.idChecked = true;
                        this.idMsg = "현재 사용 중인 아이디입니다.";
                    } else {
                        this.idChecked = false;
                        this.idMsg = "";
                    }
                },

                fnCheckId: function () {
                    let self = this;

                    if (!self.userId || self.userId.trim() === "") {
                        alert("아이디를 입력해주세요.");
                        return;
                    }

                    if (self.userId.trim() === self.originalUserId) {
                        self.idChecked = true;
                        self.idMsg = "현재 사용 중인 아이디입니다.";
                        alert("현재 사용 중인 아이디입니다.");
                        return;
                    }

                    $.ajax({
                        url: "/user/checkBiz.dox",
                        type: "POST",
                        dataType: "json",
                        data: { userId: self.userId.trim() },
                        success: function (data) {
                            if (data.count > 0) {
                                self.idChecked = false;
                                self.idMsg = "이미 사용 중인 아이디입니다.";
                                alert("이미 사용 중인 아이디입니다.");
                            } else {
                                self.idChecked = true;
                                self.idMsg = "사용 가능한 아이디입니다.";
                                alert("사용 가능한 아이디입니다.");
                            }
                        }
                    });
                },

                fnOnlyBiznum: function (key, maxLength) {
                    this[key] = this[key].replace(/[^0-9]/g, "").slice(0, maxLength);
                    this.biznumChecked = false;
                    this.biznumMsg = "";
                },

                fnGetBiznum: function () {
                    return this.biznum1 + "-" + this.biznum2 + "-" + this.biznum3;
                },

                fnCheckBiznum: function () {
                    let self = this;
                    let biznum = self.fnGetBiznum();

                    if (self.biznum1.length !== 3 || self.biznum2.length !== 2 || self.biznum3.length !== 5) {
                        alert("사업자번호를 XXX-XX-XXXXX 형식으로 입력해주세요.");
                        return;
                    }

                    $.ajax({
                        url: "/biz/checkBiznum.dox",
                        type: "POST",
                        dataType: "json",
                        data: {
                            biznum: biznum,
                            storeNo: self.selectedStore ? self.selectedStore.storeNo : ""
                        },
                        success: function (data) {
                            if (data.count > 0) {
                                self.biznumChecked = false;
                                self.biznumMsg = "이미 등록된 사업자번호입니다.";
                                alert("이미 등록된 사업자번호입니다.");
                            } else {
                                self.biznumChecked = true;
                                self.biznumMsg = "사용 가능한 사업자번호입니다.";
                                alert("사용 가능한 사업자번호입니다.");
                            }
                        },
                        error: function () {
                            alert("사업자번호 중복확인 중 오류가 발생했습니다.");
                        }
                    });
                },

                fnOpenBizFile: function () {
                    if (!this.bizFileName) {
                        alert("등록된 파일이 없습니다.");
                        return;
                    }

                    window.open("/img/bizfile/" + this.bizFileName, "_blank");
                },

                fnHandleFile: function (e) {
                    this.bizFile = e.target.files[0];
                },

                fnReapplyBiz: function () {
                    let self = this;

                    if (!self.selectedStore) {
                        alert("신청할 업체를 선택해주세요.");
                        return;
                    }

                    let biznum = self.fnGetBiznum();

                    if (self.biznum1.length !== 3 || self.biznum2.length !== 2 || self.biznum3.length !== 5) {
                        alert("사업자번호를 XXX-XX-XXXXX 형식으로 입력해주세요.");
                        return;
                    }

                    if (!self.biznumChecked) {
                        alert("사업자번호 중복확인을 해주세요.");
                        return;
                    }

                    if (!self.ceoName || self.ceoName.trim() === "") {
                        alert("대표자명을 입력해주세요.");
                        return;
                    }

                    if (!confirm("입력한 정보로 재신청하시겠습니까?")) {
                        return;
                    }

                    const formData = new FormData();
                    formData.append("storeNo", self.selectedStore.storeNo);
                    formData.append("oldStoreNo", self.applyInfo.storeNo);
                    formData.append("sUserId", self.sUserId);
                    formData.append("biznum", biznum);
                    formData.append("ceoName", self.ceoName.trim());

                    if (self.bizFile) {
                        formData.append("bizFile", self.bizFile);
                    }

                    $.ajax({
                        url: "/admin/biz/reapply.dox",
                        type: "POST",
                        data: formData,
                        processData: false,
                        contentType: false,
                        dataType: "json",
                        success: function (data) {
                            alert(data.message);
                            if (data.result === "success") {
                                self.fnCloseReapplyModal();
                                self.fnGetApplyStatus();
                            }
                        },
                        error: function () {
                            alert("재신청 처리 중 오류가 발생했습니다.");
                        }
                    });
                },
                fnResetBiznum: function () {
                    this.biznumChecked = false;
                    this.biznumMsg = "";
                },
            },
            mounted() {
                this.fnGetApplyStatus();
            }
        });

        app.mount("#app");
    </script>
</body>
</html>