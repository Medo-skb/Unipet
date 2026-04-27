<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <!-- <link href="/css/user/findid.css" rel="stylesheet"> -->
    <link href="/css/user/findid2.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <title>아이디찾기</title>
</head>
<body>
   <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <div class="row">
            <label for="userName">이름</label>
            <input type="text" id="userName" placeholder="이름을 입력해주세요">
        </div>

        <div class="row">
            <label for="pwd">비밀번호</label>
            <input type="password" id="pwd" placeholder="비밀번호를 입력해주세요">
        </div>

        <div class="btn-box">
            <button type="button" onclick="findId()">아이디 찾기</button>
        </div>
    </div>

    <jsp:include page="/WEB-INF/footer/footer.jsp" />
<script>
function findId() {
    $.ajax({
        url: "/user/findId.dox",
        type: "POST",
        data: {
            userName: $("#userName").val(),
            pwd: $("#pwd").val()
        },
        success: function(res) {
            const data = JSON.parse(res);
            if (data.result) {
                alert("찾은 아이디 : " + data.userId);
            } else {
                alert(data.message);
            }
        },
        error: function() {
            alert("아이디 찾기 중 오류가 발생했습니다.");
        }
    });
}
</script>
</body>
</html>