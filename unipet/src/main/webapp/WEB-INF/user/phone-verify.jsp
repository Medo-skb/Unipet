<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <!-- <link href="/css/user/phone-verify2.css" rel="stylesheet"> -->
    <link href="/css/user/phone-verify.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <title>UNIPET</title>
</head>

<body>
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div class="verify-page">
        <div class="verify-wrap">
            <h2>휴대폰 인증</h2>
            <p class="desc">연동을 위해 휴대폰 인증을 진행해주세요.</p>

            <div class="input-button-row">
                <input type="text" id="phone" placeholder="휴대폰 번호 입력 예: 01012345678">
                <button type="button" onclick="sendSms()">인증번호 발송</button>
            </div>

            <div id="codeBox">
                <div class="input-button-row">
                    <input type="text" id="code" placeholder="인증번호 입력">
                    <button type="button" onclick="checkSms()">인증 확인</button>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/footer/footer.jsp" />

<script>
    function sendSms() {
        const phone = $("#phone").val().trim();

        if (phone === "") {
            alert("휴대폰 번호를 입력해주세요.");
            return;
        }

        $.ajax({
            url: "/user/sendSms.dox",
            type: "POST",
            data: { phone: phone },
            success: function (res) {
                const data = typeof res === "string" ? JSON.parse(res) : res;

                alert(data.message);

                if (data.result === true) {
                    $("#codeBox").show();
                }
            }
        });
    }

    function checkSms() {
        const code = $("#code").val().trim();

        if (code === "") {
            alert("인증번호를 입력해주세요.");
            return;
        }

        $.ajax({
            url: "/user/checkSms.dox",
            type: "POST",
            data: { code: code },
            success: function (res) {
                const data = typeof res === "string" ? JSON.parse(res) : res;

                if (data.result === true) {
                    updatePhone();
                } else {
                    alert(data.message);
                }
            }
        });
    }

    function updatePhone() {
        const phone = $("#phone").val().trim();
        const currentUserId = "${sessionId}";

        let param = {
            phone : phone,
            userId : currentUserId
        }

        $.ajax({
            url: "/user/updateSms.dox",
            type: "POST",
            data: param,
            success: function (res) {
                const data = typeof res === "string" ? JSON.parse(res) : res;

                if (data.result === true) {
                    alert("휴대폰 연동이 완료되었습니다.");
                    location.href = "/main.do";
                } else {
                    alert(data.message);
                }
            }
        });
    }

    // 🔥 pagechange 함수
    function pageChange(url) {
        let form = document.createElement("form");
        form.method = "GET";
        form.action = url;
        document.body.appendChild(form);
        form.submit();
    }
</script>

</body>
</html>