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
            <!-- [수정] 인증 완료 시 입력창 비활성화 -->
            <input type="text" v-model="userId" placeholder="아이디를 입력해주세요" :disabled="isSmsVerified">
        </div>

        <!-- 2. 휴대폰 번호 입력 + 발송 버튼 -->
        <div class="row">
            <label for="phone">휴대폰 번호</label>
            <div class="input-group">
                <!-- [수정] 인증 완료 시 입력창 비활성화 -->
                <input type="text" v-model="phone" placeholder="휴대폰 번호를 입력해주세요 ( ' - ' 없이 입력 )" :disabled="isSmsVerified">
                <button type="button" class="side-btn" 
                        @click="fnSendSms" 
                        :disabled="isSmsVerified"
                        :class="{'btn-disabled': isSmsVerified}">
                    {{ isSmsSent ? '인증번호 재발송' : '인증번호 발송' }}
                </button>
            </div>
            <!-- <p class="help-text">* 번호는 010-0000-0000과 같은 형식으로 입력해주십시오.</p> -->
        </div>

        <!-- 3. 인증번호 입력 + 확인 버튼 -->
        <div class="row">
            <label for="code">인증번호</label>
            <div class="input-group">
                <div style="position: relative; flex: 1;">
                    <!-- [수정] 인증 완료 시 입력창 비활성화 -->
                    <input type="text" v-model="code" placeholder="인증번호를 입력해주세요" :disabled="isSmsVerified">
                    <span v-if="timerActive" class="timer-text">{{ timerStr }}</span>
                </div>
                <button type="button" class="side-btn" 
                        @click="fnCheckSms" 
                        :disabled="isSmsVerified"
                        :class="{'btn-disabled': isSmsVerified}">
                    인증번호 확인
                </button>
            </div>
        </div>

        <!-- 4. 재설정 이동 버튼 -->
        <div class="btn-box">
            <button type="button" 
                    id="resetBtn" 
                    :class="{'btn-disabled': !isSmsVerified}" 
                    :disabled="!isSmsVerified"
                    @click="fnCheckUserForReset">
                비밀번호 변경 이동
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
                isSmsSent: false,
                isSmsVerified: false, // 인증 완료 상태값

                timerCount: 180,    // 3분 (180초)
                timerInterval: null,
                timerActive: false
            };
        },
        computed: {
            // 초 단위를 00:00 형식으로 변환
            timerStr() {
                let min = Math.floor(this.timerCount / 60);
                let sec = this.timerCount % 60;
                return (min < 10 ? "0" + min : min) + ":" + (sec < 10 ? "0" + sec : sec);
            }
        },
        methods: {
            // 1. 인증번호 발송 (사전 검증 로직 추가)
            fnSendSms() {
                let self = this;
                // [추가] 보안을 위해 아이디 입력 여부 먼저 체크
                if(!self.userId.trim()) { alert("아이디를 입력해주세요."); return; }
                if(!self.phone.trim()) { alert("전화번호를 입력해주세요."); return; }
                
                const cleanPhone = self.phone.replace(/[^0-9]/g, "");
                self.isSmsVerified = false; // 재발송 시 인증 초기화

                // [수정] 문자 발송 전, 회원 DB에 존재하는지 먼저 검증 (checkUserExist.dox)
                $.ajax({
                    url: "/user/checkUserExist.dox",
                    dataType: "json",
                    type: "POST",
                    data: { 
                        userId: self.userId,
                        phone: cleanPhone 
                    },
                    success: function (data) {
                        if (data.result === true || data.result === "true") {
                            // 회원이 맞으면 실제 문자 발송 함수 호출
                            self.executeSendSms(cleanPhone);
                        } else {
                            alert(data.message || "일치하는 회원 정보가 없습니다.");
                        }
                    },
                });
            },

            // [추가] 실제 SMS 발송만 담당하는 함수 분리
            executeSendSms(cleanPhone) {
                let self = this;
                $.ajax({
                    url: "/user/sendSms.dox",
                    dataType: "json",
                    type: "POST",
                    data: { phone: cleanPhone },
                    success: function (data) {
                        alert(data.message);
                        if(data.result === true || data.result === "true") {
                            self.isSmsSent = true; // [수정] 이 값이 true가 되어야 버튼 글씨가 '재발송'으로 바뀝니다!
                            self.fnStartTimer(); 
                        }
                    }
                });
            },

            // 2. 인증번호 확인
            fnCheckSms: function () {
                let self = this;
                if(!self.timerActive) { alert("인증 시간이 만료되었거나 발송되지 않았습니다."); return; }
                if(!self.code.trim()) { alert("인증번호를 입력해주세요."); return; }

                $.ajax({
                    url: "/user/checkSms.dox",
                    dataType: "json",
                    type: "POST",
                    data: { code: self.code },
                    success: function (data) {
                        if (data.result === true || data.result === "true") {
                            alert("인증에 성공하였습니다.");
                            self.isSmsVerified = true; // [핵심] 이 값이 true가 되면서 모든 인풋/버튼이 비활성화됨
                            self.fnStopTimer(); 
                        } else {
                            alert(data.message);
                        }
                    }
                });
            },

            // 3. 사용자 정보 확인 후 재설정 페이지 이동
            fnCheckUserForReset() {
                if (!this.isSmsVerified) {
                    alert("휴대폰 인증 후 이용해주세요.");
                    return;
                }
                
                let self = this;
                $.ajax({
                    url: "/user/checkUserForReset.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        userId: self.userId,
                        phone: self.phone.replace(/[^0-9]/g, "")
                    },
                    success: function (data) {
                        if (data.result === true || data.result === "true") {
                            location.href = "/user/new-pwd.do";
                        } else {
                            alert(data.message);
                        }
                    }
                });
            },
            fnStartTimer() {
                this.fnStopTimer(); // 기존 타이머 중지
                this.timerCount = 180;
                this.timerActive = true;
                
                this.timerInterval = setInterval(() => {
                    if (this.timerCount > 0) {
                        this.timerCount--;
                    } else {
                        this.fnStopTimer();
                        alert("인증 시간이 만료되었습니다. 다시 발송해주세요.");
                    }
                }, 1000);
            },
            fnStopTimer() {
                clearInterval(this.timerInterval);
                this.timerActive = false;
            },
        },
        mounted() {
        },
        beforeUnmount() {
            this.fnStopTimer(); 
        }
    });

    app.mount('#app');
</script>