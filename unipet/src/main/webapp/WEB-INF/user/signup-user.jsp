<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일반 회원가입</title>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<style>
    body { font-family: Arial; margin: 30px; }
    .join-box { width: 450px; margin: auto; }
    .form-group { margin-bottom: 15px; }
    label { font-weight: bold; display: block; margin-bottom: 5px; }
    input, select { width: 100%; padding: 10px; }
    .inline { display: flex; gap: 10px; }
    .inline input { flex: 1; }
    button { padding: 10px; cursor: pointer; }
</style>

</head>
<body>

<div class="join-box">
<h2>일반 회원가입</h2>

<form id="userForm">

    <div class="form-group">
        <label>이메일</label>
        <div class="inline">
            <input type="text" id="email" name="email">
            
        </div>
    </div>
	<div class="form-group">
	        <label>아이디</label>
	        <div class="inline">
	            <input type="text" id="userId" name="userId">
		</div>

	

    <div class="form-group">
        <label>비밀번호</label>
        <input type="password" id="pwd" name="pwd">
    </div>

    <div class="form-group">
        <label>비밀번호 확인</label>
        <input type="password" id="pwdCheck">
    </div>

    <div class="form-group">
        <label>닉네임</label>
        <input type="text" id="nickname" name="nickname">
    </div>

    <div class="form-group">
        <label>휴대폰 번호</label>
        <input type="text" id="phone" name="phone">
    </div>

    <!-- 주소 API -->
    <div class="form-group">
        <label>주소</label>
        <div class="inline">
            <input type="text" id="postcode" name="postcode" placeholder="우편번호" readonly>
            <button type="button" onclick="execDaumPostcode()">검색</button>
        </div>
    </div>

    <div class="form-group">
        <input type="text" id="address" name="address" placeholder="기본주소" readonly>
    </div>

    <div class="form-group">
        <input type="text" id="detailAddress" name="detailAddress" placeholder="상세주소">
    </div>

    <div class="form-group">
        <label>활동 지역</label>
        <input type="text" id="region" name="region">
    </div>


    <div class="form-group">
        <label>
            <input type="checkbox" id="marketingYn" value="Y"> 마케팅 수신 동의
        </label>
    </div>

    <button type="button" onclick="signupUser()">회원가입</button>

</form>
</div>

<script>

// 주소 검색 API
function execDaumPostcode() {
    new daum.Postcode({
        oncomplete: function(data) {

            let addr = (data.userSelectedType === 'R') ? data.roadAddress : data.jibunAddress;

            $("#postcode").val(data.zonecode);
            $("#address").val(addr);
            $("#detailAddress").focus();
        }
    }).open();
}



// 회원가입
function signupUser(){

    if($("#pwd").val() != $("#pwdCheck").val()){
        alert("비밀번호가 일치하지 않습니다.");
        return;
    }

    let data = $("#userForm").serializeArray();
    let obj = {};

    $.each(data, function(i, item){
        obj[item.name] = item.value;
    });

    obj.marketingYn = $("#marketingYn").is(":checked") ? "Y" : "N";

    $.ajax({
        url: "/user/signupUser.dox",
        type: "POST",
        data: obj,
        success: function(res){
            alert(res.message);
            if(res.result){
                location.href="/user/login.do";
            }
        }
    });
}

</script>

</body>
</html>