<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>새 비밀번호 설정</title>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
</head>
<body>
    <h2>새 비밀번호 설정</h2>

    새 비밀번호 : <input type="password" id="pwd"><br>
    비밀번호 확인 : <input type="password" id="pwdCheck"><br>

    <button type="button" onclick="resetPwd()">변경하기</button>

<script>
function resetPwd() {
    const pwd = $("#pwd").val();
    const pwdCheck = $("#pwdCheck").val();

    if (pwd === "" || pwdCheck === "") {
        alert("비밀번호를 입력하세요.");
        return;
    }

    if (pwd !== pwdCheck) {
        alert("비밀번호가 일치하지 않습니다.");
        return;
    }

    $.ajax({
        url: "/user/resetPwd.dox",
        type: "POST",
        data: { pwd: pwd },
        success: function(res) {
            const data = JSON.parse(res);
            alert(data.message);

            if (data.result) {
                location.href = "/user/login.do";
            }
        }
    });
}
</script>
</body>
</html>