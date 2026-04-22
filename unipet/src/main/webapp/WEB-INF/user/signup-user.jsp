<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사용자 회원가입</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
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
            border: 1px solid hsl(205, 89%, 51%);
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
            padding: 28px 24px 24px;
        }

        #app::before {
            content: "사용자 회원가입";
            display: block;
            font-size: 22px;
            font-weight: 700;
            color: #222;
            margin-bottom: 24px;
            text-align: center;
        }

        .row {
            margin-bottom: 12px;
        }

        .row input {
            width: 100%;
            height: 42px;
            border: 1px solid #cfd8e3;
            border-radius: 10px;
            padding: 0 12px;
            font-size: 14px;
            box-sizing: border-box;
            background: white;
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
            color: #2b2b2b;
            transition: all 0.2s ease;
        }

        .btn-box button:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
        }

        .link-box {
            text-align: center;
            margin-top: 14px;
        }

        .link-box a {
            color: #333;
            text-decoration: none;
            margin: 0 6px;
            font-size: 14px;
        }
    </style>
</head>
<body>
<div id="app">
    <div class="row"><input type="text" v-model="userId" placeholder="아이디"></div>
    <div class="row"><input type="password" v-model="pwd" placeholder="비밀번호"></div>
    <div class="row"><input type="text" v-model="userName" placeholder="이름"></div>
    <div class="row"><input type="text" v-model="nickname" placeholder="닉네임"></div>
    <div class="row"><input type="text" v-model="phone" placeholder="휴대폰 번호"></div>
    <div class="row"><input type="text" v-model="email" placeholder="이메일"></div>
    <div class="row"><input type="text" v-model="userAddr" placeholder="주소"></div>
    <div class="row"><input type="text" v-model="fullAddr" placeholder="상세주소"></div>
    <div class="row"><input type="text" v-model="zipcode" placeholder="우편번호"></div>

    <div class="btn-box">
        <button @click="fnSignupUser">회원가입</button>
    </div>

    <div class="link-box">
        <a href="/user/login.do">로그인</a>
        <a href="/user/join.do">이전</a>
    </div>
</div>
</body>
</html>

<script>
const app = Vue.createApp({
    data() {
        return {
            userId: "",
            pwd: "",
            userName: "",
            nickname: "",
            phone: "",
            email: "",
            userAddr: "",
            fullAddr: "",
            zipcode: ""
        };
    },
    methods: {
        fnSignupUser() {
            let self = this;

            if (!self.userId || !self.pwd || !self.userName) {
                alert("아이디, 비밀번호, 이름은 필수입니다.");
                return;
            }

            $.ajax({
                url: "/user/signupUser.dox",
                dataType: "json",
                type: "POST",
                data: {
                    userId: self.userId,
                    pwd: self.pwd,
                    userName: self.userName,
                    nickname: self.nickname,
                    phone: self.phone,
                    email: self.email,
                    userAddr: self.userAddr,
                    fullAddr: self.fullAddr,
                    zipcode: self.zipcode
                },
                success: function(data) {
                    if (data.result) {
                        alert(data.message);
                        location.href = "/user/login.do";
                    } else {
                        alert(data.message);
                    }
                },
                error: function() {
                    alert("회원가입 중 오류가 발생했습니다.");
                }
            });
        }
    }
});

app.mount('#app');
</script>