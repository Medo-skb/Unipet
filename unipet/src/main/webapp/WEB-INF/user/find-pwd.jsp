<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
<style>
    body {
        font-family: Arial, sans-serif;
        background-color: #f8f8f8;
        margin: 0;
        padding: 30px 0;
    }

    .join-wrap {
        width: 600px;
        margin: 0 auto;
        background: #fff;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
    }

    h2 {
        text-align: center;
        margin-bottom: 25px;
    }

    .form-row {
        margin-bottom: 16px;
    }

    .form-row label {
        display: inline-block;
        width: 120px;
        font-weight: bold;
        vertical-align: top;
        padding-top: 10px;
    }

    .form-row input,
    .form-row select {
        width: 320px;
        height: 40px;
        padding: 0 10px;
        border: 1px solid #ccc;
        border-radius: 6px;
        box-sizing: border-box;
    }

    .inline-box {
        display: inline-flex;
        align-items: center;
        gap: 8px;
    }

    .inline-box input {
        width: 320px;
    }

    .inline-box button {
        height: 40px;
        padding: 0 14px;
        border: none;
        background: #4a6cf7;
        color: white;
        border-radius: 6px;
        cursor: pointer;
        white-space: nowrap;
    }

    .inline-box button:hover {
        background: #3451c6;
    }

    .submit-btn {
        width: 100%;
        height: 46px;
        border: none;
        background: #222;
        color: white;
        border-radius: 6px;
        cursor: pointer;
        font-size: 16px;
        margin-top: 20px;
    }

    .submit-btn:hover {
        background: #000;
    }

    .info-text {
        font-size: 13px;
        margin-left: 124px;
        margin-top: 5px;
        color: #666;
    }

    .result-box {
        margin-top: 20px;
        padding: 14px;
        border-radius: 8px;
        background: #f7f9fc;
        border: 1px solid #d9dee8;
        text-align: center;
        font-size: 15px;
    }

    .sub-link {
        text-align: center;
        margin-top: 14px;
        font-size: 13px;
    }

    .sub-link a {
        color: #666;
        text-decoration: none;
        margin: 0 6px;
    }

    .sub-link a:hover {
        text-decoration: underline;
    }
</style>
   
</head>
<body>
<div id="app">
    <div class="join-wrap">
        <h2>비밀번호 찾기</h2>

        <div class="form-row">
            <label>아이디</label>
            <input v-model="userId" placeholder="아이디 입력">
        </div>

        <div class="form-row">
            <label>휴대폰번호</label>
            <div class="inline-box">
                <input v-model="phone" placeholder="휴대폰번호 입력 (숫자만)">
                <button type="button" @click="fnSendSms">인증요청</button>
            </div>
        </div>

        <div class="form-row">
            <label>인증번호</label>
            <div class="inline-box">
                <input v-model="smsCode" placeholder="인증번호 입력">
                <button type="button" @click="fnVerifySms">인증확인</button>
            </div>
        </div>

        <div class="info-text">{{ authMsg }}</div>

        <div class="form-row">
            <button type="button" class="submit-btn" @click="fnNext">다음</button>
        </div>

        <div class="sub-link">
            <a href="/user/login.do">로그인</a> |
            <a href="/user/find-Id.do">아이디 찾기</a>
        </div>
    </div>
</div>

<script>
const app = Vue.createApp({
    data() {
        return {
            userId: "",
            phone: "",
            smsCode: "",
            authYn: false,
            authMsg: ""
        };
    },
    methods: {
        fnSendSms() {
            let self = this;

            if (!self.phone.trim()) {
                alert("휴대폰번호를 입력해주세요.");
                return;
            }

            $.ajax({
                url: "/user/sendSms.dox",
                type: "POST",
                dataType: "json",
                data: {
                    phone: self.phone
                },
                success: function(data) {
                    alert(data.message);
                },
                error: function() {
                    alert("인증번호 발송 중 오류가 발생했습니다.");
                }
            });
        },

        fnVerifySms() {
            let self = this;

            if (!self.smsCode.trim()) {
                alert("인증번호를 입력해주세요.");
                return;
            }

            $.ajax({
                url: "/user/verifySms.dox",
                type: "POST",
                dataType: "json",
                data: {
                    smsCode: self.smsCode
                },
                success: function(data) {
                    self.authYn = data.result;
                    self.authMsg = data.message;
                },
                error: function() {
                    alert("인증 확인 중 오류가 발생했습니다.");
                }
            });
        },

        fnNext() {
            let self = this;

            if (!self.userId.trim()) {
                alert("아이디를 입력해주세요.");
                return;
            }

            if (!self.phone.trim()) {
                alert("휴대폰번호를 입력해주세요.");
                return;
            }

            if (!self.authYn) {
                alert("휴대폰 인증을 완료해주세요.");
                return;
            }

            $.ajax({
                url: "/user/checkUserForReset.dox",
                type: "POST",
                dataType: "json",
                data: {
                    userId: self.userId,
                    phone: self.phone
                },
                success: function(data) {
                    if (data.result) {
                        sessionStorage.setItem("resetUserId", self.userId);
                        location.href = "/user/new-pwd.do";
                    } else {
                        alert(data.message);
                    }
                },
                error: function() {
                    alert("회원 확인 중 오류가 발생했습니다.");
                }
            });
        }
    }
});

app.mount("#app");
</script>
</body>
</html>