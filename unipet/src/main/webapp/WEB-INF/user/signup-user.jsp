<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>일반 회원가입</title>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<style>
    * { box-sizing: border-box; }
    body {
        font-family: Arial, sans-serif;
        background-color: #f8f8f8;
        margin: 0;
        padding: 30px 0;
    }
    .join-wrap {
        width: 520px;
        margin: 0 auto;
        background: #fff;
        padding: 30px;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
    }
    h2 {
        text-align: center;
        margin-bottom: 25px;
    }
    .form-group {
        margin-bottom: 16px;
    }
    .form-group label {
        display: block;
        margin-bottom: 8px;
        font-weight: bold;
    }
    .form-group input,
    .form-group select {
        width: 100%;
        height: 42px;
        padding: 0 12px;
        border: 1px solid #ccc;
        border-radius: 6px;
    }
    .row {
        display: flex;
        gap: 8px;
    }
    .row input {
        flex: 1;
    }
    .row button {
        width: 120px;
        height: 42px;
        border: none;
        background: #4a6cf7;
        color: #fff;
        border-radius: 6px;
        cursor: pointer;
    }
    .row button:hover {
        background: #3451c6;
    }
    .submit-btn {
        width: 100%;
        height: 46px;
        border: none;
        background: #222;
        color: white;
        border-radius: 6px;
        cursor: pointer;
        font-size: 16px;
        margin-top: 10px;
    }
    .submit-btn:hover {
        background: #000;
    }
    .check-line {
        margin-top: 6px;
        font-size: 13px;
        color: #666;
    }
    .agree-box {
        display: flex;
        align-items: center;
        gap: 8px;
    }
    .agree-box input[type="checkbox"] {
        width: auto;
        height: auto;
    }
</style>
</head>
<body>

<div class="join-wrap">
    <h2>일반 회원가입</h2>

    <form id="userForm">

        <div class="form-group">
            <label for="userId">아이디</label>
            <div class="row">
                <input type="text" id="userId" name="userId" placeholder="아이디 입력">
                <button type="button" onclick="checkId()">중복확인</button>
            </div>
        </div>

        <div class="form-group">
            <label for="pwd">비밀번호</label>
            <input type="password" id="pwd" name="pwd" placeholder="비밀번호 입력">
        </div>

        <div class="form-group">
            <label for="pwdCheck">비밀번호 확인</label>
            <input type="password" id="pwdCheck" placeholder="비밀번호 다시 입력">
        </div>
		<div class="form-group">
		           <label for="email">이메일</label>
		           <input type="text" id="email" name="email" placeholder="이메일 입력">
		       </div>

        <div class="form-group">
            <label for="userName">닉네임</label>
            <input type="text" id="userName" name="userName" placeholder="닉네임 입력">
        </div>

        <div class="form-group">
            <label for="phone">휴대폰 번호</label>
            <div class="row">
                <input type="text" id="phone" name="phone" placeholder="휴대폰 번호 입력">
                <button type="button" onclick="sendSms()">인증발송</button>
            </div>
        </div>

        <div class="form-group">
            <label for="smsCode">인증번호</label>
            <div class="row">
                <input type="text" id="smsCode" placeholder="인증번호 입력">
                <button type="button" onclick="verifySms()">인증확인</button>
            </div>
            <div class="check-line" id="phoneAuthText">휴대폰 인증을 진행해주세요.</div>
        </div>

        <div class="form-group">
            <label for="postcode">우편번호</label>
            <div class="row">
                <input type="text" id="postcode" name="postcode" placeholder="우편번호" readonly>
                <button type="button" onclick="execDaumPostcode()">주소검색</button>
            </div>
        </div>

        <div class="form-group">
            <label for="address">기본주소</label>
            <input type="text" id="address" name="address" placeholder="기본주소" readonly>
        </div>

        <div class="form-group">
            <label for="detailAddress">상세주소</label>
            <input type="text" id="detailAddress" name="detailAddress" placeholder="상세주소 입력">
        </div>

       

        <div class="form-group agree-box">
            <input type="checkbox" id="marketingYn">
            <label for="marketingYn" style="margin:0;">마케팅 수신 동의</label>
        </div>

        <button type="button" class="submit-btn" onclick="signupUser()">회원가입</button>
    </form>
</div>

<script>
    let phoneAuthYn = false;
    let idCheckYn = false;

    function execDaumPostcode() {  
        new daum.Postcode({
            oncomplete: function(data) {
                let addr = "";

                if (data.userSelectedType === 'R') {
                    addr = data.roadAddress;
                } else {
                    addr = data.jibunAddress;
                }

                $("#postcode").val(data.zonecode);
                $("#address").val(addr);
                $("#detailAddress").focus();
            }
        }).open();
    }

    function checkId() { //아ㅣ이디 중복체크
        const userId = $("#userId").val().trim();

        if (userId === "") {
            alert("아이디를 입력해주세요.");
            return;
        }

        $.ajax({
            url: "/user/check.dox",
            type: "POST",
            dataType: "json",
            data: { userId: userId },
            success: function(res) {
                alert(res.message);
                idCheckYn = !!res.result;
            },
            error: function() {
                alert("아이디 중복확인 중 오류가 발생했습니다.");
            }
        });
    }

    function sendSms() { //휴대폰인증번호 발송
        const phone = $("#phone").val().trim();

        if (phone === "") {
            alert("휴대폰 번호를 입력해주세요.");
            return;
        }

        $.ajax({
            url: "/user/sendSms.dox",
            type: "POST",
            dataType: "json",
            data: { phone: phone },
            success: function(res) {
                alert(res.message);
                phoneAuthYn = false;
                $("#phoneAuthText").text("인증번호를 입력 후 인증확인을 눌러주세요.");
            },
            error: function() {
                alert("인증번호 발송 중 오류가 발생했습니다.");
            }
        });
    }

    function verifySms() {  //인증번호 확인
        const smsCode = $("#smsCode").val().trim();

        if (smsCode === "") {
            alert("인증번호를 입력해주세요.");
            return;
        }

        $.ajax({
            url: "/user/verifySms.dox",
            type: "POST",
            dataType: "json",
            data: { smsCode: smsCode },
            success: function(res) {
                alert(res.message);

                if (res.result) {
                    phoneAuthYn = true;
                    $("#phoneAuthText").text("휴대폰 인증이 완료되었습니다.");
                } else {
                    phoneAuthYn = false;
                    $("#phoneAuthText").text("휴대폰 인증이 완료되지 않았습니다.");
                }
            },
            error: function() {
                alert("휴대폰 인증 중 오류가 발생했습니다.");
            }
        });
    }

    function signupUser() {
        const userId = $("#userId").val().trim();
        const email = $("#email").val().trim();
        const pwd = $("#pwd").val().trim();
        const pwdCheck = $("#pwdCheck").val().trim();
        const userName = $("#userName").val().trim();
        const phone = $("#phone").val().trim();

        if (userId === "") {
            alert("아이디를 입력해주세요.");
            $("#userId").focus();
            return;
        }

        if (!idCheckYn) {
            alert("아이디 중복확인을 해주세요.");
            return;
        }

        if (email === "") {
            alert("이메일을 입력해주세요.");
            $("#email").focus();
            return;
        }

        if (pwd === "") {
            alert("비밀번호를 입력해주세요.");
            $("#pwd").focus();
            return;
        }

        if (pwd !== pwdCheck) {
            alert("비밀번호가 일치하지 않습니다.");
            $("#pwdCheck").focus();
            return;
        }

        if (userName === "") {
            alert("닉네임을 입력해주세요.");
            $("#userName").focus();
            return;
        }

        if (phone === "") {
            alert("휴대폰 번호를 입력해주세요.");
            $("#phone").focus();
            return;
        }

        if (!phoneAuthYn) {
            alert("휴대폰 인증을 완료해주세요.");
            return;
        }

        let formData = $("#userForm").serializeArray();
        let obj = {};

        $.each(formData, function(i, item) {
            obj[item.name] = item.value;
        });

        obj.marketingYn = $("#marketingYn").is(":checked") ? "Y" : "N";

        $.ajax({
            url: "/user/signupUser.dox",
            type: "POST",
            dataType: "json",
            data: obj,
            success: function(res) {
                alert(res.message);

                if (res.result) {
                    location.href = "/user/login.do";
                }
            },
            error: function() {
                alert("회원가입 중 오류가 발생했습니다.");
            }
        });
    }

    $("#userId").on("input", function() {
        idCheckYn = false;
    });
</script>

</body>
</html>