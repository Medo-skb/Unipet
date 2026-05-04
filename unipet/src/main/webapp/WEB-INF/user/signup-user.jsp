<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="ko">

    <head>
        <meta charset="UTF-8">
        <title>UNIPET</title>
        <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
        <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
        <!-- <link href="/css/user/signupuser.css" rel="stylesheet"> -->
        <link href="/css/user/signupuser2.css" rel="stylesheet">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css">
    </head>

    <body>

        <jsp:include page="/WEB-INF/header/header.jsp" />

        <div id="app">
            <title>사용자 회원가입</title>
            <div class="row">
                <div class="inline-box">
                    <input v-model="userId" 
                        maxlength="20" 
                        placeholder="아이디 (영문 소문자, 숫자)" 
                        @input="handleIdInput">
                    <button type="button" @click="checkId">중복확인</button>
                </div>
                <div v-if="idMsg" class="info-text" :style="{color:idChecked?'green':'red'}">
                    {{ idMsg }}
                </div>
            </div>

            <div class="row">
                <input type="password" v-model="pwd" maxlength="20" placeholder="비밀번호 (8~20자)">
            </div>

            <div class="row">
                <input type="password" v-model="pwdCheck" maxlength="20" placeholder="비밀번호 확인">
                <div v-if="pwdCheck" class="info-text" :style="{color: pwd===pwdCheck?'green':'red'}">
                    {{ pwd===pwdCheck ? '비밀번호가 일치합니다.' : '비밀번호가 일치하지 않습니다.' }}
                </div>
            </div>

            <div class="row">
                <input v-model="email" 
                    placeholder="이메일" 
                    @input="handleEmailInput">
            </div>

            <div class="row">
                <input v-model="userName" placeholder="이름">
            </div>

            <div class="row">
                <input v-model="nickname" placeholder="닉네임">
            </div>

            <div class="row">
                <div class="inline-box">
                    <input v-model="phone" placeholder="휴대폰 번호 ( ' - ' 없이 입력 )">
                    <button type="button" 
                            @click="sendSms" 
                            :disabled="smsChecked"
                            :class="{'btn-disabled': smsChecked}">
                        {{ smsRequested ? '인증재요청' : '인증요청' }}
                    </button>
                </div>
                <!-- <div class="info-text">
                    휴대전화 번호는 010xxxxxxxx 또는 010-xxxx-xxxx 형식으로 입력해주세요.
                </div> -->
            </div>

            <div class="row">
            <div class="inline-box sms-box">
                <div class="input-wrap">
                    <!-- [수정] 타이머가 끝나거나 인증이 완료되면 입력창 비활성화 -->
                    <input v-model="smsCode" placeholder="인증번호" :disabled="smsChecked || (!timerActive && smsRequested)">

                    <!-- [수정] 타이머 활성화 여부에 따라 시간초과 텍스트 및 색상 변경 -->
                    <span v-if="smsRequested && !smsChecked" class="timer-text" :style="{color: timerActive ? '' : 'red'}">
                        {{ timerActive ? timerMsg : '시간초과' }}
                    </span>
                </div>

                <!-- [수정] 인증 요청 전이거나, 타이머가 끝났거나, 인증 완료되면 버튼 비활성화 -->
                <button type="button" 
                        class="side-btn" 
                        @click="checkSms" 
                        :disabled="!timerActive || smsChecked"
                        :class="{'btn-disabled': !timerActive || smsChecked}">
                    확인
                </button>
            </div>

                <!-- ⭐ 이 위치 중요 -->
                <div v-if="smsMsg" class="info-text" :style="{color: smsChecked?'green':'red'}">
                    {{ smsMsg }}
                </div>
            </div>





            <div class="row">
                <div class="inline-box">
                    <input v-model="zipcode" placeholder="우편번호" readonly>
                    <button type="button" @click="openPostcode">주소검색</button>
                </div>
            </div>

            <div class="row">
                <input v-model="userAddr" placeholder="주소" readonly>
            </div>

            <div class="row">
                <input v-model="fullAddr" placeholder="상세주소">
            </div>

            <div class="row agree-wrap">
                <label class="agree-label">
                    <input type="checkbox" v-model="agree">
                    <span><strong>[선택]</strong> 마케팅 정보 수신에 동의합니다.</span>
                </label>
            </div>

            <div class="btn-box">
                <button type="button" @click="signup">회원가입</button>
            </div>

        </div>

        <jsp:include page="/WEB-INF/footer/footer.jsp" />

        <script>
            Vue.createApp({
                data() {
                    return {
                        userId: "",
                        pwd: "",
                        pwdCheck: "",
                        userName: "",
                        nickname: "",
                        phone: "",
                        email: "",
                        userAddr: "",
                        fullAddr: "",
                        zipcode: "",

                        idChecked: false,
                        idMsg: "",

                        smsCode: "",
                        smsChecked: false,
                        smsMsg: "",

                        agree: false,
                        smsTimer: 180,       // 3분
                        smsInterval: null,
                        timerMsg: "",
                        smsRequested: false,

                        timerActive: false
                    }
                },

                methods: {
                    resetIdCheck() {
                        this.idChecked = false;
                        this.idMsg = "";
                    },

                    // 1. 아이디 중복확인 시 정규식 검사 추가
                    checkId() {
                        if (!this.userId) {
                            alert("아이디를 입력해주세요.");
                            return;
                        }

                        // ⭐ 아이디 정규식: 영문 소문자만 1글자 이상
                        // (만약 숫자도 섞게 하고 싶다면 /^[a-z0-9]+$/ 로 변경하세요)
                        const idRegex = /^[a-z0-9]+$/;
                        if (!idRegex.test(this.userId.trim())) {
                            alert("아이디는 영문 소문자, 숫자만 사용할 수 있습니다. (특수문자, 한글 불가)");
                            return;
                        }

                        $.post("/user/check.dox", { userId: this.userId.trim() }, (res) => {
                            if (res.count > 0) {
                                this.idChecked = false;
                                this.idMsg = "이미 사용 중인 아이디입니다.";
                                alert("이미 사용 중인 아이디입니다.");
                            } else {
                                this.idChecked = true;
                                this.idMsg = "사용 가능한 아이디입니다.";
                                alert("사용 가능한 아이디입니다.");
                            }
                        }, "json");
                    },
                    sendSms() {
                        if (this.smsChecked) {
                            alert("이미 휴대폰 인증이 완료되었습니다.");
                            return;
                        }

                        if (!this.phone) {
                            alert("휴대폰 번호를 입력해주세요.");
                            return;
                        }

                        const phoneRegex = /^010-?\d{4}-?\d{4}$/;
                        if (!phoneRegex.test(this.phone)) {
                            alert("휴대전화 번호 형식이 올바르지 않습니다.");
                            return;
                        }

                        $.post("/user/sendSms.dox", { phone: this.phone }, (res) => {
                            console.log("SMS 응답:", res);

                            if (res.result === true || res.result === "true" || res.result === "success") {
                                alert(res.message || "인증번호가 발송되었습니다.");

                                this.smsRequested = true;
                                this.smsChecked = false;
                                this.smsCode = "";

                                this.smsTimer = 180;
                                this.timerActive = true;
                                
                                this.updateTimerMsg();
                                this.startTimer();
                            } else {
                                alert(res.message || "인증번호 발송 실패");
                            }
                        }, "json").fail(() => {
                            alert("SMS 요청 실패: /user/sendSms.dox 경로를 확인하세요.");
                        });
                    },
                    startTimer() {
                        if (this.smsInterval) {
                            clearInterval(this.smsInterval);
                        }

                        this.smsInterval = setInterval(() => {
                            this.smsTimer--;
                            this.updateTimerMsg();

                            if (this.smsTimer <= 0) {
                                clearInterval(this.smsInterval);
                                this.smsInterval = null;
                                this.timerMsg = "시간초과";

                                this.timerActive = false;
                            }
                        }, 1000);
                    },
                    updateTimerMsg() {
                        const min = String(Math.floor(this.smsTimer / 60)).padStart(2, "0");
                        const sec = String(this.smsTimer % 60).padStart(2, "0");
                        this.timerMsg = min + ":" + sec;
                    },




                    checkSms() {
                        let self = this; // Vue 인스턴스 범위를 명확히 함

                        if (!self.timerActive) {
                            alert("인증 시간이 만료되었거나 발송되지 않았습니다.");
                            return;
                        }

                        if (!self.smsCode) {
                            alert("인증번호를 입력해주세요.");
                            return;
                        }

                        $.post("/user/checkSms.dox", { code: self.smsCode }, function(res) {
                            const isSuccess = (res.result === true || res.result === "true" || res.result === "success");

                            if (isSuccess) {
                                // [핵심] 이 두 값이 변해야 HTML의 :disabled가 작동함
                                self.smsChecked = true;    // 재발송 버튼 차단
                                self.timerActive = false;  // 확인 버튼 차단 및 입력창 차단
                                
                                self.timerMsg = "인증 완료";
                                self.smsMsg = res.message || "인증에 성공했습니다.";

                                // 타이머 인터벌 제거
                                if (self.smsInterval) {
                                    clearInterval(self.smsInterval);
                                    self.smsInterval = null;
                                }
                                alert("휴대폰 인증이 완료되었습니다.");
                            } else {
                                self.smsChecked = false;
                                self.smsMsg = res.message || "인증번호가 일치하지 않습니다.";
                                alert(self.smsMsg);
                            }
                        }, "json");
                    },
                    handleIdInput(e) {
                        // 영문 소문자와 숫자만 허용하는 정규식 (그 외 모든 문자는 삭제)
                        // 만약 대문자도 허용하려면 a-z를 a-zA-Z로 바꾸세요.
                        const originalValue = e.target.value;
                        const cleanedValue = originalValue.replace(/[^a-z0-9]/g, '');
                        
                        this.userId = cleanedValue;
                        this.resetIdCheck(); // 아이디가 바뀌면 중복확인 상태 초기화
                    },

                    // 이메일 입력 실시간 제어
                    handleEmailInput(e) {
                        // 이메일에 허용되는 문자(영문, 숫자, 특수기호 . _ - @) 외에는 삭제
                        // 한글 입력 시 즉시 제거됨
                        const originalValue = e.target.value;
                        const cleanedValue = originalValue.replace(/[ㄱ-ㅎㅏ-ㅣ가-힣]/g, '');
                        
                        this.email = cleanedValue;
                    },

                    openPostcode() {
                        new daum.Postcode({
                            oncomplete: (data) => {
                                this.zipcode = data.zonecode;
                                this.userAddr = data.roadAddress || data.address;
                            }
                        }).open();
                    },

                    signup() {
                        // [검사 1] 빈 값 체크
                        if (!this.userId || !this.pwd || !this.userName || !this.email) {
                            alert("아이디, 비밀번호, 이름, 이메일은 필수입니다.");
                            return;
                        }

                        // [검사 2] 아이디 영문 소문자 체크 (혹시 중복확인 후 다시 바꿨을까봐 한 번 더 체크)
                        const idRegex = /^[a-z]+$/;
                        if (!idRegex.test(this.userId.trim())) {
                            alert("아이디는 영문 소문자만 사용할 수 있습니다.");
                            return;
                        }

                        if (!this.idChecked) {
                            alert("아이디 중복확인을 해주세요.");
                            return;
                        }

                        // [검사 3] 비밀번호 길이 및 일치 체크 (8 ~ 30자리)
                        if (this.pwd.length < 8 || this.pwd.length > 20) {
                            alert("비밀번호는 최소 8자리, 최대 20자리로 입력해주세요.");
                            return;
                        }

                        if (this.pwd !== this.pwdCheck) {
                            alert("비밀번호가 일치하지 않습니다.");
                            return;
                        }

                        // [검사 4] 이메일 형식 및 한글 차단 체크
                        // 영문/숫자/기호 + @ + 영문/숫자/기호 + . + 영문자 2글자 이상
                        const emailRegex = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/;
                        if (!emailRegex.test(this.email.trim())) {
                            alert("올바른 이메일 형식이 아닙니다. (예: unipet@example.com, 한글 입력 불가)");
                            return;
                        }

                        // [검사 5] 휴대폰 인증 체크
                        if (!this.phone) {
                            alert("휴대폰 번호를 입력해주세요.");
                            return;
                        }

                        if (!this.smsChecked) {
                            alert("휴대폰 인증을 완료해주세요.");
                            return;
                        }

                        // 모든 검사 통과 시 서버로 데이터 전송
                        $.post("/user/signupUser.dox", {
                            userId: this.userId.trim(),
                            pwd: this.pwd,
                            userName: this.userName,
                            nickname: this.nickname,
                            phone: this.phone,
                            email: this.email.trim(), // 이메일도 공백 제거해서 보내는 것이 좋습니다
                            userAddr: this.userAddr,
                            fullAddr: this.fullAddr,
                            zipcode: this.zipcode
                        }, (res) => {
                            alert(res.message);
                            if (res.result) {
                                location.href = "/user/login.do";
                            }
                        }, "json");
                    }
                },
                mounted() {

                }

            }).mount("#app");
        </script>

    </body>

    </html>