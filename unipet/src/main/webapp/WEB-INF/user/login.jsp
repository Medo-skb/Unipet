<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>로그인</title>

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
    box-shadow: 0 2px 10px rgba(0,0,0,0.08);
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
    padding-top: 10px;
}

.form-row input {
    width: 320px;
    height: 40px;
    padding: 0 10px;
    border: 1px solid #ccc;
    border-radius: 6px;
}

.inline-box {
    display: inline-flex;
    align-items: center;
    gap: 8px;
}

.inline-box button {
    height: 40px;
    padding: 0 14px;
    border: none;
    background: #4a6cf7;
    color: white;
    border-radius: 6px;
    cursor: pointer;
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

.sub-link {
    text-align: center;
    margin-top: 12px;
}

.sub-link a {
    color: #666;
    text-decoration: none;
    margin: 0 6px;
}

.sub-link a:hover {
    text-decoration: underline;
}

.social-row {
    margin-top: 20px;
    display: flex;
    gap: 10px;
}

.social-btn {
    flex: 1;
    height: 44px;
    border: none;
    border-radius: 6px;
    cursor: pointer;
    font-weight: bold;
}

.kakao {
    background: #FEE500;
}

.naver {
    background: #03C75A;
    color: white;
}
</style>
</head>

<body>
<div id="app">
    <div class="join-wrap">
        <h2>로그인</h2>

        <!-- 회원 유형 -->
        <div class="form-row">
            <label>회원유형</label>
            <div class="inline-box">
                <button type="button" @click="loginType='USER'" :style="btnStyle('USER')">사용자</button>
                <button type="button" @click="loginType='BIZ'" :style="btnStyle('BIZ')">사업자</button>
            </div>
        </div>

        <!-- 아이디 -->
        <div class="form-row">
            <label>아이디</label>
            <input type="text" v-model="userId">
        </div>

        <!-- 비밀번호 -->
        <div class="form-row">
            <label>비밀번호</label>
            <input type="password" v-model="pwd" @keyup.enter="fnLogin">
        </div>

        <!-- 로그인 버튼 -->
        <div class="form-row">
            <button type="button" class="submit-btn" @click="fnLogin">로그인</button>
        </div>

        <!-- 링크 -->
        <div class="sub-link">
            <a href="/user/find-id.do">아이디 찾기</a> |
            <a href="/user/find-pwd.do">비밀번호 찾기</a>
        </div>

        <!-- 소셜 로그인 -->
        <div class="social-row" v-if="loginType === 'USER'">
            <button type="button" class="social-btn kakao" @click="fnKakaoLogin">카카오</button>
            <button type="button" class="social-btn naver" @click="fnNaverLogin">네이버</button>
        </div>

        <!-- 회원가입 -->
        <div class="form-row">
            <button type="button" class="submit-btn" @click="fnJoin">회원가입</button>
        </div>
    </div>
</div>

<script>
const app = Vue.createApp({
    data() {
        return {
            userId: "",
            pwd: "",
            loginType: "USER"
        };
    },

    methods: {
        btnStyle(type) {
            return {
                background: this.loginType === type ? "#4a6cf7" : "#ccc",
                color: "white"
            };
        },

        fnLogin() {
            const self = this;

            if (!self.userId) {
                alert("아이디 입력");
                return;
            }

            if (!self.pwd) {
                alert("비밀번호 입력");
                return;
            }

            $.ajax({
                url: "/user/login.dox",
                type: "POST",
                data: {
                    userId: self.userId,
                    pwd: self.pwd,
                    role: self.loginType
                },
                success: function(data) {
                    if (typeof data === "string") {
                        data = JSON.parse(data);
                    }

                    alert(data.message);

                    if (data.result) {
                        location.href = data.url;
                    }
                },
                error: function() {
                    alert("로그인 실패");
                }
            });
        },

        fnJoin() {
            location.href = "/user/join.do";
        },

        // SecurityConfig 없이 직접 OAuth 구현용
        fnKakaoLogin() {
            location.href = "/user/kakao/login";
        },

        fnNaverLogin() {
            location.href = "/user/naver/login";
        }
    }
});

app.mount("#app");
</script>
</body>
</html>