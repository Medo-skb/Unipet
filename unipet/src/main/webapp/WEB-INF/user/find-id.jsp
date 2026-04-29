<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>UNIPET</title>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
      <link href="/css/user/findid2.css" rel="stylesheet">

   
</head>

<body>

<jsp:include page="/WEB-INF/header/header.jsp" />

<div class="wrap">
    <h2 class="title">아이디 찾기</h2>

    <!-- 회원 유형 선택 -->
    <div class="type-box">
        <label>
            <input type="radio" name="findType" value="USER" checked>
            일반회원
        </label>

        <label>
            <input type="radio" name="findType" value="BIZ">
            사업자회원
        </label>
    </div>

    <!-- 일반회원: 이름 입력 / 사업자: 대표자명 입력 -->
    <div class="row">
        <input type="text" id="userName" placeholder="이름 또는 대표자명을 입력해주세요.">
        <input type="password" id="pwd" placeholder="비밀번호">
    </div>

    <div class="btn-box">
        <button type="button" onclick="findId()">아이디 찾기</button>
    </div>

    <!-- 결과 출력 영역 -->
    <div class="result-box" id="resultBox">
        <div id="resultText"></div>
    </div>

    <div class="link-box">
        <a href="/user/login.do">로그인</a>
        <a href="/user/find-pwd.do">비밀번호 재설정</a>
        <a href="/user/join.do">회원가입</a>
    </div>
</div>

<jsp:include page="/WEB-INF/footer/footer.jsp" />

<script>
    function findId() {
        const findType = $("input[name='findType']:checked").val();
        const userName = $("#userName").val().trim();

        if (userName === "") {
            alert("이름 또는 대표자명을 입력해주세요.");
            $("#userName").focus();
            return;
        }

        // 일반회원 / 사업자에 따라 호출 URL 분기
        let url = "";

        if (findType === "USER") {
            url = "/user/findId.dox";
        } else {
            url = "/user/findBizId.dox";
        }

        $.ajax({
            url: url,
            type: "POST",
            dataType: "json",
            data: {
                userName: userName
            },
            success: function (res) {
                if (res.result) {
                    $("#resultBox").show();
                    $("#resultText").html("찾은 아이디 : <b>" + res.userId + "</b>");
                } else {
                    $("#resultBox").show();
                    $("#resultText").text(res.message || "일치하는 정보가 없습니다.");
                }
            },
            error: function () {
                alert("아이디 찾기 중 오류가 발생했습니다.");
            }
        });
    }
</script>

</body>
</html>