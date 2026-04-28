<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <link href="/css/user/new-pwd.css" rel="stylesheet">
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <title>새 비밀번호 설정</title>
    </head>

    <body>
        <body>
    <div class="reset-wrap">
        <div class="reset-box">
            <h2 class="title">새 비밀번호 설정</h2>

            <div class="row">
                <label>새 비밀번호</label>
                <input type="password" id="pwd">
            </div>

            <div class="row">
                <label>비밀번호 확인</label>
                <input type="password" id="pwdCheck">
            </div>

            <div class="btn-box">
                <button type="button" onclick="resetPwd()">변경하기</button>
            </div>
        </div>
    </div>

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
                success: function (res) {
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