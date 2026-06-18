<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNIPET</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/signupbiz.css">
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <div class="signup-container">
            <div class="signup-header">사업자 회원가입</div>

            <div class="signup-section">
                <div class="section-title">업체 검색</div>

                <div class="input-group">
                    <label>업체명</label>
                    <input type="text" class="input-field" v-model="searchKeyword" placeholder="업체명을 입력해주세요">
                </div>

                <div class="search-row">
                    <div class="input-group">
                        <label>지역</label>
                        <input type="text" class="input-field" v-model="searchRegion" placeholder="예: 종로구, 효제동">
                    </div>
                    <div class="input-group">
                        <label>업종</label>
                        <select class="input-field" v-model="searchCategory">
                            <option value="">전체</option>
                            <option value="HOS">병원</option>
                            <option value="SAL">미용</option>
                            <option value="BRD">위탁시설</option>
                        </select>
                    </div>
                </div>

                <button type="button" class="btn-sub" @click="fnSearchStore">업체 검색</button>

                <div class="store-result-box" v-if="storeList.length > 0">
                    <div class="store-card" v-for="item in storeList" :key="item.storeNo" :class="{ active: selectedStore && selectedStore.storeNo === item.storeNo }">
                        <div class="store-info">
                            <div class="store-name">{{ item.storeName }}</div>
                            <div class="store-detail">{{ fnCategoryName(item.sCategory) }} · {{ item.sAddr }}</div>
                            <div class="store-detail" v-if="item.lat && item.lng">좌표: {{ item.lat }}, {{ item.lng }}</div>
                        </div>
                        <button type="button" class="btn-select" @click="fnSelectStore(item)">선택</button>
                    </div>
                </div>

                <div class="empty-text" v-if="isSearched && storeList.length === 0">
                    검색 결과가 없습니다. 업체명, 지역, 업종을 다시 확인해주세요.
                </div>

                <div class="selected-store" v-if="selectedStore">
                    <div class="selected-label">선택한 업체</div>
                    <div class="selected-name">{{ selectedStore.storeName }}</div>
                    <div class="selected-detail">{{ fnCategoryName(selectedStore.sCategory) }} · {{ selectedStore.sAddr }}</div>
                </div>
            </div>

            <div class="signup-section">
                <div class="section-title">계정 정보</div>

                <div class="input-group">
                    <label>사업자 아이디</label>
                    <div class="inline-box">
                        <input type="text" class="input-field" v-model="userId" maxlength="20" placeholder="20자 이하" @input="fnResetIdCheck">
                        <button type="button" class="btn-sub" @click="fnCheckId">중복확인</button>
                    </div>
                    <div v-if="idMsg" class="info-text" :class="{ success: idChecked }">{{ idMsg }}</div>
                </div>

                <div class="input-group">
                    <label>비밀번호</label>
                    <input type="password" class="input-field" v-model="pwd" maxlength="20" placeholder="비밀번호">
                </div>

                <div class="input-group">
                    <label>비밀번호 확인</label>
                    <input type="password" class="input-field" v-model="pwdCheck" maxlength="20" placeholder="비밀번호 확인">
                    <div v-if="pwdCheck" class="info-text" :class="{ success: pwd === pwdCheck }">
                        {{ pwd === pwdCheck ? '비밀번호가 일치합니다.' : '비밀번호가 일치하지 않습니다.' }}
                    </div>
                </div>

                <div class="input-group">
                    <label>대표자명</label>
                    <input type="text" class="input-field" v-model="userName" placeholder="대표자명을 입력해주세요">
                </div>

                <div class="input-group">
                    <label>사업자등록증</label>
                    <input type="file" class="input-field file-field" @change="fnHandleFile" accept=".jpg,.jpeg,.png,.pdf">
                    <div class="info-text">JPG, PNG, PDF 형식만 업로드 가능합니다. (최대 5MB)</div>
                </div>
            </div>

            <button type="button" class="btn-submit" @click="fnSignupBiz">사업자 회원가입</button>
        </div>
    </div>

    <jsp:include page="/WEB-INF/footer/footer.jsp" />

</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                searchKeyword: "",
                searchRegion: "",
                searchCategory: "",
                storeList: [],
                selectedStore: null,
                isSearched: false,

                userId: "",
                pwd: "",
                pwdCheck: "",
                userName: "",
                bizFile: null,

                idChecked: false,
                idMsg: ""
            };
        },
        methods: {
            // 업체 검색
            fnSearchStore: function () {
                let self = this;

                if (!self.searchKeyword || self.searchKeyword.trim() === "") {
                    alert("업체명을 입력해주세요.");
                    return;
                }

                const param = {
                    keyword: self.searchKeyword.trim(),
                    region: self.searchRegion.trim(),
                    sCategory: self.searchCategory
                };

                $.ajax({
                    url: "/user/external-store/list.dox",
                    type: "POST",
                    dataType: "json",
                    data: param,
                    success: function (data) {
                        if (data.result === "success") {
                            self.storeList = data.list || [];
                            self.selectedStore = null;
                            self.isSearched = true;
                        } else {
                            alert(data.message || "업체 검색 중 오류가 발생했습니다.");
                        }
                    },
                    error: function () {
                        alert("업체 검색 중 오류가 발생했습니다.");
                    }
                });
            },

            // 업체 선택
            fnSelectStore: function (item) {
                this.selectedStore = item;
            },

            // 업종명 변환
            fnCategoryName: function (category) {
                if (category === "HOS") {
                    return "병원";
                } else if (category === "SAL") {
                    return "미용";
                } else if (category === "BRD") {
                    return "위탁시설";
                }
                return "기타";
            },

            // 아이디 중복확인 상태 초기화
            fnResetIdCheck: function () {
                this.idChecked = false;
                this.idMsg = "";
            },

            // 아이디 중복확인
            fnCheckId: function () {
                let self = this;

                if (!self.userId || self.userId.trim() === "") {
                    alert("아이디를 입력해주세요.");
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

            // 사업자등록증 파일 선택
            fnHandleFile: function (e) {
                this.bizFile = e.target.files[0];
            },

            // 사업자 회원가입 신청
            fnSignupBiz: function () {
                let self = this;

                if (!self.selectedStore) {
                    alert("신청할 업체를 선택해주세요.");
                    return;
                }

                if (!self.userId || !self.pwd || !self.userName) {
                    alert("아이디, 비밀번호, 대표자명은 필수입니다.");
                    return;
                }

                if (!self.idChecked) {
                    alert("아이디 중복확인을 해주세요.");
                    return;
                }

                if (self.pwd !== self.pwdCheck) {
                    alert("비밀번호가 일치하지 않습니다.");
                    return;
                }

                if (!self.bizFile) {
                    alert("사업자등록증 파일을 첨부해주세요.");
                    return;
                }

                const formData = new FormData();
                formData.append("storeNo", self.selectedStore.storeNo);
                formData.append("userId", self.userId.trim());
                formData.append("pwd", self.pwd);
                formData.append("userName", self.userName);
                formData.append("bizFile", self.bizFile);

                $.ajax({
                    url: "/user/signupBiz.dox",
                    type: "POST",
                    data: formData,
                    processData: false,
                    contentType: false,
                    dataType: "json",
                    success: function (data) {
                        alert(data.message);
                        if (data.result) {
                            location.href = "/user/login.do";
                        }
                    },
                    error: function () {
                        alert("사업자 회원가입 중 오류가 발생했습니다.");
                    }
                });
            }
        }
    });

    app.mount("#app");
</script>
