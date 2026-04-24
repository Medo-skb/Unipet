<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>사업자 회원가입</title>

<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<style>
body {
    margin: 0;
    padding: 60px 0;
    background: #f4f6fb;
    font-family: Arial, sans-serif;
}

#app {
    width: 520px;
    margin: 0 auto;
    background: #f0f4f5;
    border: 1px solid #3b82f6;
    border-radius: 16px;
    box-shadow: 0 8px 24px rgba(0,0,0,0.08);
    padding: 28px 24px;
}

#app::before {
    content: "사업자 회원가입";
    display: block;
    text-align: center;
    font-size: 22px;
    font-weight: 700;
    margin-bottom: 24px;
}

.row {
    margin-bottom: 12px;
}

.row input,
.row select {
    width: 100%;
    height: 42px;
    border: 1px solid #cfd8e3;
    border-radius: 10px;
    padding: 0 12px;
    box-sizing: border-box;
    font-size: 14px;
    background: white;
}

.inline-box {
    display: flex;
    gap: 8px;
}

.inline-box input {
    flex: 1;
}

.inline-box button {
    width: 120px;
    height: 42px;
    border-radius: 10px;
    border: 1px solid #8ea8d8;
    background: #eef4ff;
    font-weight: 700;
    cursor: pointer;
}

.info-text {
    font-size: 12px;
    margin-top: 5px;
}

.btn-box {
    margin-top: 20px;
}

.btn-box button {
    width: 100%;
    height: 46px;
    border-radius: 12px;
    cursor: pointer;
    font-size: 16px;
    font-weight: 700;
    border: 2px solid #8ea8d8;
    background: #eef4ff;
}

.btn-box button:hover,
.inline-box button:hover {
    opacity: 0.9;
}
</style>
</head>

<body>
<div id="app">

    <!-- 아이디 -->
    <div class="row">
        <div class="inline-box">
            <input v-model="userId" maxlength="20" placeholder="사업자 아이디 (20자 이하)" @input="resetIdCheck">
            <button type="button" @click="checkId">중복확인</button>
        </div>
        <div v-if="idMsg" class="info-text" :style="{color:idChecked?'green':'red'}">
            {{ idMsg }}
        </div>
    </div>

    <!-- 비밀번호 -->
    <div class="row">
        <input type="password" v-model="pwd" maxlength="20" placeholder="비밀번호">
    </div>

    <!-- 비밀번호 확인 -->
    <div class="row">
        <input type="password" v-model="pwdCheck" maxlength="20" placeholder="비밀번호 확인">
        <div v-if="pwdCheck" class="info-text" :style="{color: pwd === pwdCheck ? 'green' : 'red'}">
            {{ pwd === pwdCheck ? '비밀번호가 일치합니다.' : '비밀번호가 일치하지 않습니다.' }}
        </div>
    </div>

    <!-- 대표자명 -->
    <div class="row">
        <input v-model="userName" placeholder="대표자명">
    </div>

    <!-- 사업자등록증 파일 -->
    <div class="row">
        <input type="file" @change="handleFile">
    </div>

    <!-- 업체명 -->
    <div class="row">
        <input v-model="storeName" placeholder="업체명">
    </div>

    <!-- 매장분류 -->
    <div class="row">
        <select v-model="sCategory">
            <option value="">매장분류 선택</option>
            <option value="HOS">병원</option>
            <option value="SAL">미용</option>
            <option value="B">위탁시설</option>
        </select>
    </div>

    <!-- 주소 -->
    <div class="row">
        <div class="inline-box">
            <input v-model="sAddr" placeholder="기본주소" readonly>
            <button type="button" @click="openPostcode">주소검색</button>
        </div>
    </div>

    <!-- 상세주소 -->
    <div class="row">
        <input v-model="sFullAddr" placeholder="상세주소">
    </div>

    <!-- 가입 -->
    <div class="btn-box">
        <button type="button" @click="signupBiz">사업자 회원가입</button>
    </div>

</div>

<script>
Vue.createApp({
    data() {
        return {
            userId: "",
            pwd: "",
            pwdCheck: "",
            userName: "",
            bizFile: null,

            storeName: "",
            sCategory: "",
            sAddr: "",
            sFullAddr: "",
            lat: "",
            lng: "",
            sStatus: "PND",

            idChecked: false,
            idMsg: ""
        };
    },

    methods: {
        resetIdCheck() {
            this.idChecked = false;
            this.idMsg = "";
        },

        checkId() {
            if (!this.userId) {
                alert("아이디를 입력해주세요.");
                return;
            }

            $.post("/user/checkBiz.dox", { userId: this.userId.trim() }, (res) => {
                if (res.count > 0) {
                    this.idChecked = false;
                    this.idMsg = "이미 사용 중인 아이디입니다.";
                    alert("이미 사용 중인 아이디입니다.");
                } else {
                    this.idChecked = true;
                    this.idMsg = "사용 가능한 아이디입니다.";
                    alert("사용 가능한 아이디입니다.");
                }
            }, "json");
        },

        handleFile(e) {
            this.bizFile = e.target.files[0];
        },

        openPostcode() {
            new daum.Postcode({
                oncomplete: (data) => {
                    this.sAddr = data.roadAddress || data.address;
                }
            }).open();
        },

        signupBiz() {
            if (!this.userId || !this.pwd || !this.userName) {
                alert("아이디, 비밀번호, 대표자명은 필수입니다.");
                return;
            }

            if (!this.idChecked) {
                alert("아이디 중복확인을 해주세요.");
                return;
            }

            if (this.pwd !== this.pwdCheck) {
                alert("비밀번호가 일치하지 않습니다.");
                return;
            }

            if (!this.bizFile) {
                alert("사업자등록증 파일을 첨부해주세요.");
                return;
            }

            if (!this.storeName) {
                alert("업체명을 입력해주세요.");
                return;
            }

            if (!this.sCategory) {
                alert("매장분류를 선택해주세요.");
                return;
            }

            if (!this.sAddr) {
                alert("주소를 입력해주세요.");
                return;
            }

            const formData = new FormData();

            formData.append("userId", this.userId.trim());
            formData.append("pwd", this.pwd);
            formData.append("userName", this.userName);
            formData.append("bizFile", this.bizFile);

            formData.append("storeName", this.storeName);
            formData.append("sCategory", this.sCategory);
            formData.append("sAddr", this.sAddr);
            formData.append("sFullAddr", this.sFullAddr);

            formData.append("lat", this.lat);
            formData.append("lng", this.lng);
            formData.append("sStatus", this.sStatus);

            $.ajax({
                url: "/user/signupBiz.dox",
                type: "POST",
                data: formData,
                processData: false,
                contentType: false,
                dataType: "json",
                success: (res) => {
                    alert(res.message);
                    if (res.result) {
                        location.href = "/user/login.do";
                    }
                },
                error: () => {
                    alert("사업자 회원가입 중 오류가 발생했습니다.");
                }
            });
        }
    }
}).mount("#app");
</script>

</body>
</html>