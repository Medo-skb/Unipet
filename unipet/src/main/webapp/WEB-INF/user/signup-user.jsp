<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<link href="/css/user/signupuser.css" rel="stylesheet">
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<title>사용자 회원가입</title>
</head>

<body>
<div id="app">

    <div class="row">
        <div class="inline-box">
            <input v-model="userId" maxlength="20" placeholder="아이디 (20자 이하)" @input="resetIdCheck">
            <button type="button" @click="checkId">중복확인</button>
        </div>
        <div v-if="idMsg" class="info-text" :style="{color:idChecked?'green':'red'}">
            {{ idMsg }}
        </div>
    </div>

    <div class="row">
        <input type="password" v-model="pwd" maxlength="20" placeholder="비밀번호">
    </div>

    <div class="row">
        <input type="password" v-model="pwdCheck" maxlength="20" placeholder="비밀번호 확인">
        <div v-if="pwdCheck" class="info-text"
             :style="{color: pwd===pwdCheck?'green':'red'}">
            {{ pwd===pwdCheck ? '비밀번호가 일치합니다.' : '비밀번호가 일치하지 않습니다.' }}
        </div>
    </div>

    <div class="row">
        <input v-model="email" placeholder="이메일">
    </div>

    <div class="row">
        <input v-model="userName" placeholder="이름">
    </div>

    <div class="row">
        <input v-model="nickname" placeholder="닉네임">
    </div>

    <div class="row">
        <div class="inline-box">
            <input v-model="phone" placeholder="휴대폰 번호">
            <button type="button" @click="sendSms">인증요청</button>
        </div>
    </div>

    <div class="row">
        <div class="inline-box">
            <input v-model="smsCode" placeholder="인증번호">
            <button type="button" @click="checkSms">확인</button>
        </div>
        <div v-if="smsMsg" class="info-text"
             :style="{color: smsChecked?'green':'red'}">
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

<script>
Vue.createApp({
    data(){
        return{
            userId:"",
            pwd:"",
            pwdCheck:"",
            userName:"",
            nickname:"",
            phone:"",
            email:"",
            userAddr:"",
            fullAddr:"",
            zipcode:"",

            idChecked:false,
            idMsg:"",

            smsCode:"",
            smsChecked:false,
            smsMsg:"",

            agree:false
        }
    },

    methods:{
        resetIdCheck(){
            this.idChecked = false;
            this.idMsg = "";
        },

        checkId(){
            if(!this.userId){
                alert("아이디를 입력해주세요.");
                return;
            }

            $.post("/user/check.dox", {userId:this.userId.trim()}, (res)=>{
                if(res.count > 0){
                    this.idChecked = false;
                    this.idMsg = "이미 사용 중인 아이디입니다.";
                    alert("이미 사용 중인 아이디입니다.");
                }else{
                    this.idChecked = true;
                    this.idMsg = "사용 가능한 아이디입니다.";
                    alert("사용 가능한 아이디입니다.");
                }
            }, "json");
        },

        sendSms(){
            if(!this.phone){
                alert("휴대폰 번호를 입력해주세요.");
                return;
            }

            $.post("/user/sendSms.dox", {phone:this.phone}, (res)=>{
                alert(res.message);
            }, "json");
        },

        checkSms(){
            if(!this.smsCode){
                alert("인증번호를 입력해주세요.");
                return;
            }

            $.post("/user/checkSms.dox", {code:this.smsCode}, (res)=>{
                this.smsChecked = res.result;
                this.smsMsg = res.message;
            }, "json");
        },

        openPostcode(){
            new daum.Postcode({
                oncomplete:(data)=>{
                    this.zipcode = data.zonecode;
                    this.userAddr = data.roadAddress || data.address;
                }
            }).open();
        },

        signup(){
            if(!this.userId || !this.pwd || !this.userName){
                alert("아이디, 비밀번호, 이름은 필수입니다.");
                return;
            }

            if(!this.idChecked){
                alert("아이디 중복확인을 해주세요.");
                return;
            }

            if(this.pwd !== this.pwdCheck){
                alert("비밀번호가 일치하지 않습니다.");
                return;
            }

            if(!this.phone){
                alert("휴대폰 번호를 입력해주세요.");
                return;
            }

            if(!this.smsChecked){
                alert("휴대폰 인증을 완료해주세요.");
                return;
            }

            $.post("/user/signupUser.dox", {
                userId:this.userId.trim(),
                pwd:this.pwd,
                userName:this.userName,
                nickname:this.nickname,
                phone:this.phone,
                email:this.email,
                userAddr:this.userAddr,
                fullAddr:this.fullAddr,
                zipcode:this.zipcode
            }, (res)=>{
                alert(res.message);
                if(res.result){
                    location.href="/user/login.do";
                }
            }, "json");
        }
    }

}).mount("#app");
</script>

</body>
</html>