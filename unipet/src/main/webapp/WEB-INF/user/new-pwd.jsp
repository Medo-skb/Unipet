<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link href="/css/user/new-pwd.css" rel="stylesheet">
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <title>UNIPET</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css">
</head>
<body>
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <!-- [수정] Vue가 제어할 수 있도록 id="app" 추가 -->
    <div class="reset-wrap" id="app">
        <div class="reset-box">
            <h2 class="title">새 비밀번호 설정</h2>

            <div class="row">
                <label>새 비밀번호</label>
                <!-- [수정] id 대신 v-model 사용 -->
                <input type="password" v-model="pwd" placeholder="새 비밀번호 입력">
            </div>

            <div class="row">
                <label>비밀번호 확인</label>
                <!-- [수정] v-model 사용 & 엔터키 치면 바로 변경 함수 실행되도록 UX 추가 -->
                <input type="password" v-model="pwdCheck" @keyup.enter="resetPwd" placeholder="비밀번호 다시 입력">
            </div>

            <div class="btn-box">
                <!-- [수정] onclick 대신 @click 사용 -->
                <button type="button" @click="resetPwd">변경하기</button>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/footer/footer.jsp" />
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 사용자가 입력할 값을 담을 변수
                pwd: "",
                pwdCheck: ""
            };
        },
        methods: {
            resetPwd() {
                // this를 통해 data()에 정의된 변수들에 접근합니다.
                let self = this;

                // 1. 빈 값 체크 (.trim()으로 의미 없는 공백 입력 방지)
                if (!self.pwd.trim() || !self.pwdCheck.trim()) {
                    alert("비밀번호를 입력해주세요.");
                    return;
                }

                // 2. 일치 여부 체크
                if (self.pwd !== self.pwdCheck) {
                    alert("비밀번호가 일치하지 않습니다.");
                    return;
                }

                // 3. 서버 통신 (jQuery Ajax 활용)
                $.ajax({
                    url: "/user/resetPwd.dox",
                    type: "POST",
                    dataType: "json", // [개선] 응답을 자동으로 JSON 객체로 변환해줍니다.
                    data: { 
                        pwd: self.pwd 
                    },
                    success: function (data) {
                        // dataType: "json"을 썼기 때문에 JSON.parse(res)를 생략해도 됩니다.
                        alert(data.message);

                        if (data.result === true || data.result === "true") {
                            location.href = "/user/login.do";
                        }
                    },
                    error: function (request, status, error) {
                        // 통신 에러 발생 시 디버깅용
                        console.error("상태 코드:", request.status);
                        console.error("에러 메시지:", error);
                        alert("비밀번호 변경 중 서버 오류가 발생했습니다.");
                    }
                });
            }
        }
    });

    app.mount('#app');
</script>