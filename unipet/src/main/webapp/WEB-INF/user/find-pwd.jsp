<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <!-- <link href="/css/user/findpwd.css" rel="stylesheet"> -->
    <link href="/css/user/findpwd2.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <title>비밀번호 찾기</title>
</head>
<body>
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">

        <div class="row">
            <label for="userId">아이디</label>
            <input type="text" id="userId" placeholder="아이디를 입력해주세요">
        </div>

        <div class="row">
            <label for="phone">휴대폰 번호</label>
            <input type="text" id="phone" placeholder="휴대폰 번호를 입력해주세요">
        </div>

        <div class="row">
            <label for="code">인증번호</label>
            <input type="text" id="code" placeholder="인증번호를 입력해주세요">

            <div class="inline-btn">
                <button type="button" onclick="sendSms()">인증번호 발송</button>
                <button type="button" onclick="checkSms()">인증번호 확인</button>
            </div>
        </div>

        <div class="btn-box">
            <button type="button" onclick="checkUserForReset()">비밀번호 재설정 이동</button>
        </div>

    </div>

    <jsp:include page="/WEB-INF/footer/footer.jsp" />

<script>
function sendSms() {
    $.ajax({
        url: "/user/sendSms.dox",
        type: "POST",
        data: { phone: $("#phone").val() },
        success: function(res) {
            const data = JSON.parse(res);
            alert(data.message);
        }
    });
}

function checkSms() {
    $.ajax({
        url: "/user/checkSms.dox",
        type: "POST",
        data: { code: $("#code").val() },
        success: function(res) {
            const data = JSON.parse(res);
            alert(data.message);
        }
    });
}

function checkUserForReset() {
    $.ajax({
        url: "/user/checkUserForReset.dox",
        type: "POST",
        data: {
            userId: $("#userId").val()
        },
        success: function(res) {
            const data = JSON.parse(res);
            if (data.result) {
                location.href = "/user/new-pwd.do";
            } else {
                alert(data.message);
            }
        }
    });
}
</script>
</body>
</html>