<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>비밀번호 찾기</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
    <h2>비밀번호 찾기</h2>

    아이디 : <input type="text" id="userId"><br>
    휴대폰 번호 : <input type="text" id="phone"><br>
    인증번호 : <input type="text" id="code"><br>

    <button type="button" onclick="sendSms()">인증번호 발송</button>
    <button type="button" onclick="checkSms()">인증번호 확인</button>
    <button type="button" onclick="checkUserForReset()">비밀번호 재설정 이동</button>

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