<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사업자 회원가입</title>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>

<body>

<h2>사업자 회원가입</h2>

<form id="bizForm">

    아이디:
    <input type="text" id="userId" name="userId">
    <button type="button" onclick="checkId()">중복확인</button>
    <br><br>

    비밀번호:
    <input type="password" id="pwd" name="pwd">
    <br><br>

    사업자명:
    <input type="text" id="userName" name="userName">
    <br><br>

    <button type="button" onclick="signupBiz()">사업자 회원가입</button>

</form>

<script>

// =====================
// 아이디 체크 (공통)
// =====================
function checkId(){

    $.ajax({
        url: "/user/check.dox",
        type: "POST",
        data: {
            userId: $("#userId").val()
        },
        success: function(res){
            alert(res.message);
        }
    });

}

// =====================
// 사업자 회원가입
// =====================
function signupBiz(){

    $.ajax({
        url: "/user/signupBiz.dox",
        type: "POST",
        data: $("#bizForm").serialize(),
        success: function(res){

            alert(res.message);

            if(res.result == true){
                location.href = "/user/signupBiz.do";
            }
        }
    });

}

</script>

</body>
</html>