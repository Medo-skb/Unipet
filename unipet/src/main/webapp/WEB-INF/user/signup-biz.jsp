<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>사업자 회원가입</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

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

        .form-row input {
            width: 320px;
            height: 40px;
            padding: 0 10px;
            border: 1px solid #ccc;
            border-radius: 6px;
            box-sizing: border-box;
        }

        .form-row input[type="file"] {
            height: auto;
            padding: 8px 10px;
            background: #fff;
        }

        .inline-box {
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .inline-box input {
            width: 320px;
        }

        .inline-box button {
            height: 40px;
            padding: 0 14px;
            border: none;
            background: #4a6cf7;
            color: white;
            border-radius: 6px;
            cursor: pointer;
            white-space: nowrap;
        }

        .inline-box button:hover {
            background: #3451c6;
        }

        .info-text {
            font-size: 13px;
            margin-left: 124px;
            margin-top: 5px;
        }

        .file-name {
            margin-left: 124px;
            margin-top: 6px;
            font-size: 13px;
            color: #555;
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
    </style>
</head>
<body>
<div id="app">
    <div class="join-wrap">
        <h2>사업자 회원가입</h2>

        <div class="form-row">
            <label>아이디</label>
            <div class="inline-box">
                <input v-model="userId" maxlength="20" placeholder="아이디 입력">
                <button type="button" @click="fnCheck">중복체크</button>
            </div>
        </div>

        <div class="form-row">
            <label>비밀번호</label>
            <input v-model="pwd" type="password" maxlength="20" placeholder="비밀번호 입력">
        </div>

        <div class="form-row">
            <label>비밀번호 확인</label>
            <input v-model="pwdCheck" type="password" maxlength="20" placeholder="비밀번호 다시 입력">
        </div>

        <div class="info-text"
             :style="{ color: pwdMsg === '' ? '#666' : (pwd === pwdCheck ? 'green' : 'red') }">
            {{ pwdMsg }}
        </div>

        <div class="form-row">
            <label>업체명</label>
            <input v-model="bizName" placeholder="업체명 입력">
        </div>

        <div class="form-row">
            <label>대표자명</label>
            <input v-model="userName" placeholder="대표자명 입력">
        </div>

        <div class="form-row">
            <label>사업자번호</label>
            <input v-model="bizNo" placeholder="사업자등록번호 입력">
        </div>

        <div class="form-row">
            <label>사업자등록증</label>
            <input type="file" ref="bizFile" @change="fnFileChange" accept=".jpg,.jpeg,.png,.pdf">
        </div>

        <div class="file-name" v-if="bizFileName">
            선택된 파일: {{ bizFileName }}
        </div>

        <div class="form-row">
            <button type="button" class="submit-btn" @click="fnJoin">사업자 가입</button>
        </div>
    </div>
</div>

<script>
const app = Vue.createApp({
    data() {
        return {
            userId: "",
            pwd: "",
            pwdCheck: "",
            pwdMsg: "",
            userName: "",
            bizName: "",
            bizNo: "",
            bizFileName: "",
            idCheckYn: false
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
        }
    },

    methods: {
        checkPwd() {
            if (this.pwdCheck.length === 0) {
                this.pwdMsg = "";
                return;
            }

            this.pwdMsg = (this.pwd === this.pwdCheck)
                ? "비밀번호가 일치합니다."
                : "비밀번호가 일치하지 않습니다.";
        },

        fnFileChange() {
            const file = this.$refs.bizFile.files[0];
            this.bizFileName = file ? file.name : "";
        },

        fnCheck() {
            let self = this;

            if (!self.userId.trim()) {
                alert("아이디를 입력해주세요.");
                return;
            }

            $.ajax({
                url: "/user/check.dox",
                type: "POST",
                dataType: "json",
                data: { userId: self.userId },
                success: function(data) {
                    alert(data.message);
                    self.idCheckYn = !!data.result;
                },
                error: function() {
                    alert("아이디 중복확인 중 오류가 발생했습니다.");
                }
            });
        },

        fnJoin() {
            let self = this;

            if (!self.userId.trim()) {
                alert("아이디를 입력해주세요.");
                return;
            }

            if (!self.idCheckYn) {
                alert("아이디 중복체크를 해주세요.");
                return;
            }

            if (!self.pwd.trim()) {
                alert("비밀번호를 입력해주세요.");
                return;
            }

            if (self.pwd !== self.pwdCheck) {
                alert("비밀번호가 일치하지 않습니다.");
                return;
            }

            if (!self.bizName.trim()) {
                alert("업체명을 입력해주세요.");
                return;
            }

            if (!self.userName.trim()) {
                alert("대표자명을 입력해주세요.");
                return;
            }

            if (!self.bizNo.trim()) {
                alert("사업자등록번호를 입력해주세요.");
                return;
            }

            if (!self.$refs.bizFile.files[0]) {
                alert("사업자등록증 파일을 업로드해주세요.");
                return;
            }

            let formData = new FormData();
            formData.append("userId", self.userId);
            formData.append("pwd", self.pwd);
            formData.append("userName", self.userName);
            formData.append("bizName", self.bizName);
            formData.append("bizNo", self.bizNo);
            formData.append("bizFile", self.$refs.bizFile.files[0]);

            $.ajax({
                url: "/user/signupBiz.dox",
                type: "POST",
                processData: false,
                contentType: false,
                data: formData,
                success: function(data) {
                    if (typeof data === "string") {
                        try {
                            data = JSON.parse(data);
                        } catch (e) {}
                    }

                    alert(data.message);

                    if (data.result) {
                        location.href = "/user/login.do";
                    }
                },
                error: function() {
                    alert("사업자 회원가입 중 오류가 발생했습니다.");
                }
            });
        }
    }
});

app.mount("#app");
</script>
</body>
</html>