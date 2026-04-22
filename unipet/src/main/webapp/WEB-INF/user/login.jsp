<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>로그인</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>

    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; }
        .wrap { width: 400px; margin: 80px auto; background: white; padding: 30px; border-radius: 10px; }
        .title { text-align: center; margin-bottom: 20px; }
        .tab-box { display: flex; margin-bottom: 15px; }
        .tab-box button { flex: 1; height: 40px; border: 1px solid #ddd; background: #fff; cursor: pointer; }
        .tab-box button.active { background: #4CAF50; color: white; }
        .input-box { margin-bottom: 10px; }
        .input-box input { width: 100%; height: 40px; padding: 0 10px; }
        .btn-box button { width: 100%; height: 45px; background: #4CAF50; color: white; border: none; cursor: pointer; }
        .link-box { text-align: center; margin-top: 15px; }
        .link-box a { margin: 0 6px; }
        .social-box { margin-top: 20px; text-align: center; }
        .social-box button { width: 100%; height: 42px; margin-bottom: 8px; border: none; cursor: pointer; }
        .kakao { background: #FEE500; }
        .naver { background: #03C75A; color: white; }
    </style>
</head>
<body>
<div class="wrap">
    <h2 class="title">로그인</h2>

    <div class="tab-box">
        <button type="button" id="userTab" class="active">일반회원</button>
        <button type="button" id="bizTab">사업자회원</button>
    </div>

    <div class="input-box">
        <input type="text" id="userId" placeholder="아이디">
    </div>

    <div class="input-box">
        <input type="password" id="pwd" placeholder="비밀번호">
    </div>

    <div class="btn-box">
        <button type="button" id="loginBtn">로그인</button>
    </div>

    <div class="link-box">
        <a href="/user/find-id.do">아이디 찾기</a>
        <a href="/user/find-pwd.do">비밀번호 찾기</a>
        <a href="/user/join.do">회원가입</a>
    </div>

    <div class="social-box" id="socialBox">
        <button type="button" class="kakao" onclick="location.href='/user/kakao/login'">카카오 로그인</button>
        <button type="button" class="naver" onclick="location.href='/user/naver/login'">네이버 로그인</button>
    </div>
</div>

<script>
    let loginType = "USER";

    $("#userTab").on("click", function() {
        loginType = "USER";
        $("#userTab").addClass("active");
        $("#bizTab").removeClass("active");
        $("#socialBox").show();
    });

    $("#bizTab").on("click", function() {
        loginType = "BIZ";
        $("#bizTab").addClass("active");
        $("#userTab").removeClass("active");
        $("#socialBox").hide();
    });

    $("#loginBtn").on("click", function() {
        fnLogin();
    });

    $("#userId, #pwd").on("keyup", function(e) {
        if (e.key === "Enter") {
            fnLogin();
        }
    });

    function fnLogin() {
        let userId = $("#userId").val().trim();
        let pwd = $("#pwd").val().trim();

        if (userId === "") {
            alert("아이디를 입력해주세요.");
            $("#userId").focus();
            return;
        }

        if (pwd === "") {
            alert("비밀번호를 입력해주세요.");
            $("#pwd").focus();
            return;
        }

        let url = (loginType === "USER") ? "/user/login.dox" : "/user/loginBiz.dox";

        $.ajax({
            url: url,
            type: "POST",
            data: {
                userId: userId,
                pwd: pwd
            },
            success: function(res) {
                let data = (typeof res === "string") ? JSON.parse(res) : res;

                if (data.result) {
                    alert(data.message);
                    location.href = "/main.do";
                } else {
                    alert(data.message);
                }
            },
            error: function() {
                alert("로그인 중 오류가 발생했습니다.");
            }
        });
    }
</script>
</body>
</html>