<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>새 비밀번호 설정</title>

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
        <h2>새 비밀번호 설정</h2>

        <div class="form-row">
            <label>새 비밀번호</label>
            <input type="password" v-model="pwd" placeholder="새 비밀번호 입력">
        </div>

        <div class="form-row">
            <label>비밀번호 확인</label>
            <input type="password" v-model="pwdCheck" placeholder="비밀번호 다시 입력">
        </div>

        <div class="info-text"
             :style="{ color: pwdMsg === '' ? '#666' : (pwd === pwdCheck ? 'green' : 'red') }">
            {{ pwdMsg }}
        </div>

        <div class="form-row">
            <button type="button" class="submit-btn" @click="fnResetPwd">비밀번호 변경</button>
        </div>

        <div class="sub-link">
            <a href="/user/login.do">로그인</a>
        </div>
    </div>
</div>

<script>
const app = Vue.createApp({
    data() {
        return {
            pwd: "",
            pwdCheck: "",
            pwdMsg: ""
        };
    },
    watch: {
        pwd() {
            this.checkPwd();
        },
        pwdCheck() {
            this.checkPwd();
        }
    },
    methods: {
        checkPwd() {
            if (this.pwdCheck.length === 0) {
                this.pwdMsg = "";
                return;
            }

            this.pwdMsg = (this.pwd === this.pwdCheck)
                ? "비밀번호가 일치합니다."
                : "비밀번호가 일치하지 않습니다.";
        },

        fnResetPwd() {
            let self = this;
            let userId = sessionStorage.getItem("resetUserId");

            if (!userId) {
                alert("비밀번호 재설정 대상 정보가 없습니다.");
                location.href = "/user/find-pwd.do";
                return;
            }

            if (!self.pwd.trim()) {
                alert("새 비밀번호를 입력해주세요.");
                return;
            }

            if (self.pwd !== self.pwdCheck) {
                alert("비밀번호가 일치하지 않습니다.");
                return;
            }

            $.ajax({
                url: "/user/resetPwd.dox",
                type: "POST",
                dataType: "json",
                data: {
                    userId: userId,
                    pwd: self.pwd
                },
                success: function(data) {
                    alert(data.message);

                    if (data.result) {
                        sessionStorage.removeItem("resetUserId");
                        location.href = "/user/login.do";
                    }
                },
                error: function() {
                    alert("비밀번호 변경 중 오류가 발생했습니다.");
                }
            });
        }
    }
});

app.mount("#app");
</script>
</body>
</html>