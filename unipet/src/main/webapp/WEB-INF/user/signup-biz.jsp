<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>사업자 회원가입</title>

<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

<style>
body { font-family: Arial; background: #f8f8f8; }
.wrap { width: 600px; margin: 50px auto; background: #fff; padding: 30px; border-radius: 10px; }
.row { margin-bottom: 15px; }
label { display:inline-block; width:130px; }
input { height:35px; width:280px; }
button { height:35px; }
.submit { width:100%; height:45px; margin-top:20px; }
</style>
</head>

<body>
<div id="app">
    <div class="wrap">
        <h2>사업자 회원가입</h2>

        <!-- 아이디 -->
        <div class="row">
            <label>아이디</label>
            <input v-model="userId">
            <button @click="fnCheck">중복체크</button>
        </div>

        <!-- 비밀번호 -->
        <div class="row">
            <label>비밀번호</label>
            <input type="password" v-model="pwd">
        </div>

        <div class="row">
            <label>비밀번호 확인</label>
            <input type="password" v-model="pwd2">
        </div>

        <!-- 대표자명 -->
        <div class="row">
            <label>대표자명</label>
            <input v-model="userName">
        </div>

        <!-- 사업장명 -->
        <div class="row">
            <label>사업장명</label>
            <input v-model="bizName">
        </div>

        <!-- 사업자번호 -->
        <div class="row">
            <label>사업자번호</label>
            <input v-model="bizNo">
        </div>

        <!-- 연락처 -->
        <div class="row">
            <label>연락처</label>
            <input v-model="phone">
        </div>

        <!-- 이메일 -->
        <div class="row">
            <label>이메일</label>
            <input v-model="email">
        </div>

        <!-- 사업자등록증 파일 -->
        <div class="row">
            <label>사업자등록증</label>
            <input type="file" @change="fnFile">
        </div>

        <button class="submit" @click="fnJoin">회원가입</button>
    </div>
</div>

<script>
const app = Vue.createApp({
    data() {
        return {
            userId: "",
            pwd: "",
            pwd2: "",
            userName: "",
            bizName: "",
            bizNo: "",
            phone: "",
            email: "",
            bizFile: null,
            idCheckYn: false
        };
    },

    methods: {

        // 파일 선택
        fnFile(e) {
            this.bizFile = e.target.files[0];
        },

        // 아이디 중복체크
        fnCheck() {
            const self = this;

            if (!self.userId) {
                alert("아이디 입력");
                return;
            }

            $.ajax({
                url: "/user/checkBiz.dox",
                type: "POST",
                dataType: "json",
                data: { userId: self.userId },
                success: function(data) {
                    if (typeof data === "string") {
                        data = JSON.parse(data);
                    }

                    if (data.result) {
                        alert("사용가능");
                        self.idCheckYn = true;
                    } else {
                        alert("이미 존재");
                        self.idCheckYn = false;
                    }
                },
                error: function() {
                    alert("중복체크 오류");
                }
            });
        },

        // 회원가입 (파일 포함)
        fnJoin() {
            const self = this;

            if (!self.idCheckYn) {
                alert("아이디 중복체크 하세요");
                return;
            }

            if (!self.userId || !self.pwd || !self.userName) {
                alert("필수값 입력");
                return;
            }

            if (self.pwd !== self.pwd2) {
                alert("비밀번호 불일치");
                return;
            }

            let formData = new FormData();

            formData.append("userId", self.userId);
            formData.append("pwd", self.pwd);
            formData.append("userName", self.userName);
            formData.append("bizName", self.bizName);
            formData.append("bizNo", self.bizNo);
            formData.append("phone", self.phone);
            formData.append("email", self.email);

            if (self.bizFile) {
                formData.append("bizFile", self.bizFile);
            }

            $.ajax({
                url: "/user/signupBiz.dox",
                type: "POST",
                data: formData,
                processData: false,
                contentType: false,
                success: function(data) {
                    if (typeof data === "string") {
                        data = JSON.parse(data);
                    }

                    if (data.result) {
                        alert("회원가입 완료");
                        location.href = "/user/login.do";
                    } else {
                        alert("회원가입 실패");
                    }
                },
                error: function() {
                    alert("회원가입 오류");
                }
            });
        }
    }
});

app.mount("#app");
</script>

</body>
</html>