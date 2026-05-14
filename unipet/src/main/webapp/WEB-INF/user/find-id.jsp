<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/css/user/findid.css" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <title>UNIPET</title>
</head>

<body>
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <!-- 1. 이름 입력 -->
        <div class="row">
            <label>이름</label>
            <input type="text" v-model="userName" placeholder="이름을 입력해주세요" :disabled="isSmsVerified">
        </div>

        <!-- 2. 휴대폰 번호 입력 + 발송 버튼 -->
        <div class="row">
            <label>휴대폰 번호</label>
            <div class="input-group">
                <input type="text" v-model="phone" placeholder="휴대폰 번호를 입력해주세요 ( ' - ' 없이 입력 )" :disabled="isSmsVerified">
                <button type="button" class="side-btn" 
                        @click="fnSendSms" 
                        :disabled="isSmsVerified"
                        :class="{'btn-disabled': isSmsVerified}">
                    {{ isSmsSent ? '인증번호 재발송' : '인증번호 발송' }}
                </button>
            </div>
        </div>

        <!-- 3. 인증번호 입력 + 확인 버튼 -->
        <div class="row">
            <label>인증번호</label>
            <div class="input-group">
                <div style="position: relative; flex: 1;">
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

        <!-- 4. 최종 아이디 찾기 버튼 -->
        <div class="btn-box">
            <!-- [핵심] 인증 전에는 버튼 비활성화 -->
            <button type="button" 
                    @click="fnFindId" 
                    :disabled="!isSmsVerified || isProcessing"
                    :class="{'btn-disabled': !isSmsVerified}">
                {{ isProcessing ? '찾는 중...' : '아이디 찾기' }}
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
                userName: "",
                phone: "",
                code: "",
                isProcessing: false,
                
                // SMS 인증 관련 변수들
                isSmsSent: false,
                isSmsVerified: false,
                timerCount: 180,
                timerInterval: null,
                timerActive: false
            };
        },
        computed: {
            timerStr() {
                let min = Math.floor(this.timerCount / 60);
                let sec = this.timerCount % 60;
                return (min < 10 ? "0" + min : min) + ":" + (sec < 10 ? "0" + sec : sec);
            }
        },
        methods: {
            // 1. SMS 발송
            fnSendSms() {
                let self = this;
                if(!self.userName.trim()) { alert("이름을 입력해주세요."); return; }
                if(!self.phone.trim()) { alert("전화번호를 입력해주세요."); return; }
                
                const cleanPhone = self.phone.replace(/[^0-9]/g, "");
                self.isSmsVerified = false; 

                // 아이디 찾기는 유저 존재 여부를 사전 체크할 필요 없이 바로 문자 발송
                $.ajax({
                    url: "/user/sendSms.dox",
                    dataType: "json",
                    type: "POST",
                    data: { phone: cleanPhone },
                    success: (data) => {
                        alert(data.message);
                        if(data.result === true || data.result === "true") {
                            self.isSmsSent = true; 
                            self.fnStartTimer(); 
                        }
                    }
                });
            },

            // 2. 인증번호 대조
            fnCheckSms() {
                let self = this;
                if(!self.timerActive) { alert("인증 시간이 만료되었거나 발송되지 않았습니다."); return; }
                if(!self.code.trim()) { alert("인증번호를 입력해주세요."); return; }

                $.ajax({
                    url: "/user/checkSms.dox",
                    dataType: "json",
                    type: "POST",
                    data: { code: self.code },
                    success: (data) => {
                        if (data.result === true || data.result === "true") {
                            alert("인증에 성공하였습니다.");
                            self.isSmsVerified = true; // 모든 창 비활성화 및 최종 버튼 오픈!
                            self.fnStopTimer(); 
                        } else {
                            alert(data.message);
                        }
                    }
                });
            },

            // 3. 최종 아이디 검색
            fnFindId() {
                let self = this;
                if (!self.isSmsVerified) { 
                    alert("휴대폰 인증을 먼저 진행해주세요."); 
                    return; 
                }

                self.isProcessing = true;
                const cleanPhone = self.phone.replace(/[^0-9]/g, "");

                $.ajax({
                    url: "/user/findId.dox", 
                    dataType: "json",
                    type: "POST",
                    data: {
                        userName: self.userName,
                        phone: cleanPhone
                    },
                    success: (data) => {
                        if (data.result) {
                            alert("찾으시는 아이디는 [" + data.userId + "] 입니다.");
                        } else {
                            alert(data.message || "일치하는 정보가 없습니다.");
                        }
                        self.isProcessing = false;
                    },
                    error: () => {
                        alert("서버 통신 중 오류가 발생했습니다.");
                        self.isProcessing = false;
                    }
                });
            },

            // 타이머 제어 함수들
            fnStartTimer() {
                this.fnStopTimer(); 
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
            }
        },
        beforeUnmount() {
            this.fnStopTimer(); 
        }
    });

    app.mount('#app');
</script>