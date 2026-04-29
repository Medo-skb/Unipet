<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <link href="/css/user/login2.css" rel="stylesheet">
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <title>로그인</title>
</head>

<body>

<jsp:include page="/WEB-INF/header/header.jsp" />

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
        <p class="social-title">간편 로그인</p>

        <div class="social-btn-list">
            <button type="button" class="social-btn kakao" onclick="location.href='/user/kakao/login'">
                <img src="${pageContext.request.contextPath}/img/user/kakao.png">
            </button>

            <button type="button" class="social-btn naver" onclick="location.href='/user/naver/login'">
                <span>N</span>
            </button>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/footer/footer.jsp" />

<script>
    let loginType = "USER";

    $("#userTab").on("click", function () {
        loginType = "USER";
        $("#userTab").addClass("active");
        $("#bizTab").removeClass("active");
        $("#socialBox").css("visibility", "visible");
    });

    $("#bizTab").on("click", function () {
        loginType = "BIZ";
        $("#bizTab").addClass("active");
        $("#userTab").removeClass("active");
        $("#socialBox").css("visibility", "hidden");
    });

    $("#loginBtn").on("click", function () {
        fnLogin();
    });

    $("#userId, #pwd").on("keyup", function (e) {
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
            success: function (res) {
                console.log("로그인 응답:", res);

                let data = (typeof res === "string") ? JSON.parse(res) : res;

                if (data.result === true || data.result === "success") {
                    alert(data.message);
                    location.href = "/main.do";
                } else {
                    alert(data.message || "아이디 또는 비밀번호를 확인해주세요.");
                    console.log(pwd)
                }
            },
            error: function () {
                alert("로그인 중 오류가 발생했습니다.");
            }
        });
    }
</script>

</body>
</html>