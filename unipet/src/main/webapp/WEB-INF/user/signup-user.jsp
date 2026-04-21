<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>일반 회원가입</title>

    <!-- jQuery -->
    <script src="https://code.jquery.com/jquery-3.7.1.js"
        integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>

    <!-- Vue -->
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

    <!-- 다음 주소 API -->
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f8f8f8;
            margin: 0;
            padding: 30px 0;
        }

        .join-wrap {
            width: 600px;
            margin: 0 auto;
            background: #fff;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.08);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
        }

        .form-row {
            margin-bottom: 16px;
        }

        .form-row label {
            display: inline-block;
            width: 120px;
            font-weight: bold;
            vertical-align: top;
            padding-top: 10px;
        }

        .form-row input,
        .form-row select {
            width: 320px;
            height: 40px;
            padding: 0 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
        }

        .form-row button {
            height: 40px;
            margin-left: 8px;
            padding: 0 14px;
            border: none;
            background: #4a6cf7;
            color: white;
            border-radius: 6px;
            cursor: pointer;
        }

        .form-row button:hover {
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
            margin-top: 20px;
        }

        .submit-btn:hover {
            background: #000;
        }

        .info-text {
            font-size: 13px;
            color: #666;
            margin-left: 124px;
            margin-top: 5px;
        }

        .agree-wrap {
            margin-left: 124px;
        }

        .agree-wrap input[type="checkbox"] {
            width: auto;
            height: auto;
        }

        .agree-wrap label {
            display: flex;
            align-items: center;
            gap: 6px;
            white-space: nowrap;
            width: auto;
            padding-top: 0;
            font-weight: normal;
        }
    </style>
</head>

<body>
    <div id="app">
        <div class="join-wrap">
            <h2>일반 회원가입</h2>

            <!-- 아이디 입력 + 중복체크 -->
            <div class="form-row">
                <label>아이디</label>
                <input v-model="userId" maxlength="20" placeholder="아이디 입력">
                <button type="button" @click="fnCheck">중복체크</button>
            </div>

            <!-- 비밀번호 입력 -->
            <div class="form-row">
                <label>비밀번호</label>
                <input v-model="pwd" type="password" maxlength="15" placeholder="비밀번호 입력">
            </div>

            <!-- 비밀번호 확인 -->
            <div class="form-row">
                <label>비밀번호 확인</label>
                <input v-model="pwdCheck" type="password" maxlength="15" placeholder="비밀번호 다시 입력">
            </div>

            <!-- 비밀번호 실시간 체크 메시지 -->
            <div class="info-text" :style="{ color: pwd === pwdCheck && pwdCheck ? 'blue' : 'red' }">
                {{ pwdMsg }}
            </div>

            <!-- 이메일 입력 -->
            <div class="form-row">
                <label>이메일</label>
                <input v-model="email" placeholder="이메일 입력">
            </div>

            <!-- 닉네임 입력 -->
            <div class="form-row">
                <label>닉네임</label>
                <input v-model="userName" placeholder="닉네임 입력">
            </div>

            <!-- 휴대폰 번호 + 인증번호 발송 -->
            <div class="form-row">
                <label>휴대폰 번호</label>
                <input v-model="phone" placeholder="휴대폰 번호 입력">
                <button type="button" @click="fnSendSms">인증발송</button>
            </div>

            <!-- 인증번호 입력 + 인증확인 -->
            <div class="form-row">
                <label>인증번호</label>
                <input v-model="smsCode" placeholder="인증번호 입력">
                <button type="button" @click="fnVerifySms">인증확인</button>
            </div>
            <div class="info-text">{{ phoneAuthText }}</div>

            <!-- 주소 -->
            <div class="form-row">
                <label>우편번호</label>
                <input v-model="postcode" readonly placeholder="우편번호">
                <button type="button" @click="fnAddr">주소검색</button>
            </div>

            <div class="form-row">
                <label>기본주소</label>
                <input v-model="address" readonly placeholder="기본주소">
            </div>

            <div class="form-row">
                <label>상세주소</label>
                <input v-model="detailAddress" placeholder="상세주소 입력">
            </div>

            <!-- 마케팅 동의 -->
            <div class="form-row">
                <label>수신 동의</label>
                <div class="agree-wrap">
                    <label>
                        <input type="checkbox" v-model="marketingYn"> 마케팅 수신 동의
                    </label>
                </div>
            </div>

            <!-- 회원가입 -->
            <div class="form-row">
                <button type="button" class="submit-btn" @click="fnJoin">회원가입</button>
            </div>
        </div>
    </div>
</body>

</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 회원가입 입력값
                userId: "",
                pwd: "",
                pwdCheck: "",
                pwdMsg: "",
                email: "",
                nickname: "",
                userName: "",
                phone: "",
                smsCode: "",
                postcode: "",
                address: "",
                detailAddress: "",
                marketingYn: false,

                // 상태값
                idCheckYn: false,
                phoneAuthYn: false,
                phoneAuthText: "휴대폰 인증을 진행해주세요."
            };
        },

        watch: {
            pwd() {
                this.checkPwd();
            },
            pwdCheck() {
                this.checkPwd();
            },
            userId() {
                this.idCheckYn = false;
            },
            phone() {
                this.phoneAuthYn = false;
                this.phoneAuthText = "휴대폰 인증을 진행해주세요.";
            }
        },

        methods: {
            // 비밀번호 일치 여부 실시간 확인
            checkPwd() {
                if (this.pwd === "" && this.pwdCheck === "") {
                    this.pwdMsg = "";
                    return;
                }

                if (this.pwdCheck.length === 0) {
                    this.pwdMsg = "";
                    return;
                }

                if (this.pwd === this.pwdCheck) {
                    this.pwdMsg = "비밀번호가 일치합니다.";
                } else {
                    this.pwdMsg = "비밀번호가 일치하지 않습니다.";
                }
            },

            // 아이디 중복체크
            fnCheck() {
                let self = this;

                if (self.userId.trim() === "") {
                    alert("아이디를 입력해주세요.");
                    return;
                }

                $.ajax({
                    url: "/user/check.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        userId: self.userId
                    },
                    success: function (data) {
                        console.log("중복체크 응답:", data);

                        if (data.result) {
                            alert("사용 가능한 아이디입니다.");
                            self.idCheckYn = true;
                        } else {
                            alert("이미 사용중인 아이디입니다.");
                            self.idCheckYn = false;
                        }
                    },
                    error: function () {
                        alert("아이디 중복확인 중 오류가 발생했습니다.");
                    }
                });
            },

            // 휴대폰 인증번호 발송
            fnSendSms() {
                let self = this;

                if (self.phone.trim() === "") {
                    alert("휴대폰 번호를 입력해주세요.");
                    return;
                }

                $.ajax({
                    url: "/user/sendSms.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        phone: self.phone
                    },
                    success: function (data) {
                        alert(data.message);

                        if (data.result) {
                            self.phoneAuthYn = false;
                            self.phoneAuthText = "인증번호를 입력 후 인증확인을 눌러주세요.";
                        }
                    },
                    error: function () {
                        alert("인증번호 발송 중 오류가 발생했습니다.");
                    }
                });
            },

            // 인증번호 확인
            fnVerifySms() {
                let self = this;

                if (self.smsCode.trim() === "") {
                    alert("인증번호를 입력해주세요.");
                    return;
                }

                $.ajax({
                    url: "/user/checkSms.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        code: self.smsCode
                    },
                    success: function (data) {
                        alert(data.message);

                        if (data.result) {
                            self.phoneAuthYn = true;
                            self.phoneAuthText = "휴대폰 인증이 완료되었습니다.";
                        } else {
                            self.phoneAuthYn = false;
                            self.phoneAuthText = "휴대폰 인증이 완료되지 않았습니다.";
                        }
                    },
                    error: function () {
                        alert("휴대폰 인증 중 오류가 발생했습니다.");
                    }
                });
            },

            // 주소검색
            fnAddr() {
                let self = this;

                new daum.Postcode({
                    oncomplete: function (data) {
                        let addr = "";

                        if (data.userSelectedType === 'R') {
                            addr = data.roadAddress;
                        } else {
                            addr = data.jibunAddress;
                        }

                        self.postcode = data.zonecode;
                        self.address = addr;
                    }
                }).open();
            },

            // 회원가입
            fnJoin() {
                let self = this;

                if (self.userId.trim() === "") {
                    alert("아이디를 입력해주세요.");
                    return;
                }

                if (!self.idCheckYn) {
                    alert("아이디 중복체크를 해주세요.");
                    return;
                }

                if (self.pwd.trim() === "") {
                    alert("비밀번호를 입력해주세요.");
                    return;
                }

                if (self.pwd !== self.pwdCheck) {
                    alert("비밀번호가 일치하지 않습니다.");
                    return;
                }

                if (self.email.trim() === "") {
                    alert("이메일을 입력해주세요.");
                    return;
                }

                if (self.userName.trim() === "") {
                    alert("닉네임을 입력해주세요.");
                    return;
                }

                if (self.phone.trim() === "") {
                    alert("휴대폰 번호를 입력해주세요.");
                    return;
                }

                if (!self.phoneAuthYn) {
                    alert("휴대폰 인증을 완료해주세요.");
                    return;
                }

                let param = {
                    userId: self.userId,
                    pwd: self.pwd,
                    email: self.email,
                    userName: self.userName,
                    nickname: self.userName,
                    phone: self.phone,
                    userAddr: self.address,
                    fullAddr: self.detailAddress,
                    zipcode: self.postcode,
                    socialType: "NORMAL",
                    marketingYn: self.marketingYn ? "Y" : "N"
                };

                $.ajax({
                    url: "/user/signupUser.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log("회원가입 응답:", data);

                        if (data.result) {
                            location.href = "/user/login.do";
                        }
                    },
                    error: function () {
                        alert("회원가입 중 오류가 발생했습니다.");
                    }
                });
            }
        },

        mounted() {
            window.vueObj = this;
        }
    });

    app.mount('#app');
</script>