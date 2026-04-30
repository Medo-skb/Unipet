<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNIPET - 비밀번호 찾기</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/findpwd.css">
</head>
<body>
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <!-- 1. 아이디 입력 -->
        <div class="row">
            <label for="userId">아이디</label>
            <input type="text" v-model="userId" placeholder="아이디를 입력해주세요">
        </div>

        <!-- 2. 휴대폰 번호 입력 + 발송 버튼 -->
        <div class="row">
            <label for="phone">휴대폰 번호</label>
            <div class="input-group">
                <input type="text" v-model="phone" placeholder="휴대폰 번호를 입력해주세요">
                <button type="button" class="side-btn" @click="fnSendSms">인증번호 발송</button>
            </div>
        </div>

        <!-- 3. 인증번호 입력 + 확인 버튼 -->
        <div class="row">
            <label for="code">인증번호</label>
            <div class="input-group">
                <input type="text" v-model="code" placeholder="인증번호를 입력해주세요">
                <button type="button" class="side-btn" @click="fnCheckSms">인증번호 확인</button>
            </div>
        </div>

        <!-- 4. 재설정 이동 버튼 -->
        <div class="btn-box">
            <button type="button" 
                    id="resetBtn" 
                    :class="{'btn-disabled': !isSmsVerified}" 
                    :disabled="!isSmsVerified"
                    @click="fnCheckUserForReset">
                비밀번호 재설정 이동
            </button>
        </div>
    </div>

    <jsp:include page="/WEB-INF/footer/footer.jsp" />
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                userId: "",
                phone: "",
                code: "",
                isSmsVerified: false, // 인증 완료 상태값
            };
        },
        methods: {
            // 1. 인증번호 발송
            fnSendSms: function () {
                let self = this;
                if(!self.phone.trim()) { alert("전화번호를 입력해주세요."); return; }

                // 휴대폰 번호 숫자만 정제
                const cleanPhone = self.phone.replace(/[^0-9]/g, "");
                
                self.isSmsVerified = false; // 발송 시 인증 상태 초기화

                $.ajax({
                    url: "/user/sendSms.dox",
                    dataType: "json",
                    type: "POST",
                    data: { phone: cleanPhone },
                    success: function (data) {
                        alert(data.message);
                    }
                });
            },

            // 2. 인증번호 확인
            fnCheckSms: function () {
                let self = this;
                if(!self.code.trim()) { alert("인증번호를 입력해주세요."); return; }

                $.ajax({
                    url: "/user/checkSms.dox",
                    dataType: "json",
                    type: "POST",
                    data: { code: self.code },
                    success: function (data) {
                        alert(data.message);
                        if (data.result === true) {
                            self.isSmsVerified = true; // 인증 성공 시 상태값 변경
                        }
                    }
                });
            },

            // 3. 사용자 정보 확인 후 재설정 페이지 이동
            fnCheckUserForReset: function () {
                let self = this;

                // 혹시 모르니 다시 한번 체크
                if (!self.isSmsVerified) {
                    alert("휴대폰 인증 후 이용해주세요.");
                    return;
                }
                if (!self.userId.trim()) {
                    alert("아이디를 입력해주세요.");
                    return;
                }

                $.ajax({
                    url: "/user/checkUserForReset.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        userId: self.userId,
                        phone: self.phone.replace(/[^0-9]/g, "")
                    },
                    success: function (data) {
                        if (data.result) {
                            // 인증 성공 시 비밀번호 재설정 페이지로 이동
                            location.href = "/user/new-pwd.do";
                        } else {
                            alert(data.message);
                        }
                    }
                });
            }
        },
        mounted() {
            // 초기화 로직이 필요할 경우 작성
        }
    });

    app.mount('#app');
</script>