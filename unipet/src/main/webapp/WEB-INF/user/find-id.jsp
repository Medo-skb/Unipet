<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <!-- <link href="/css/user/findid.css" rel="stylesheet"> -->
    <link href="/css/user/findid2.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <title>UNIPET</title>
</head>

<body>

   <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <div class="row">
            <label>이름</label>
            <input type="text" v-model="userName" placeholder="이름을 입력해주세요">
        </div>

        <div class="row">
            <label>휴대폰 번호</label>
            <input type="text" v-model="phone" placeholder="010-0000-0000">
        </div>

        <div class="btn-box">
            <button type="button" @click="fnFindId" :disabled="isProcessing">
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
                // 변수 - (key : value)
                userName: "",
                phone: "",
                isProcessing: false
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnFindId: function () {
                let self = this;

                // 유효성 검사
                if (!self.userName.trim()) { alert("이름을 입력해주세요."); return; }
                if (!self.phone.trim()) { alert("휴대폰 번호를 입력해주세요."); return; }

                // 광클 방지 시작
                self.isProcessing = true;

                const cleanPhone = self.phone.replace(/[^0-9]/g, "");

                let param = {
                    userName: self.userName,
                    phone: cleanPhone
                };  

                $.ajax({
                    url: "/user/findId.dox", // 컨트롤러 매핑 주소 확인
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {

                        if (data.result) {
                            alert("찾으시는 아이디는 [" + data.userId + "] 입니다.");
                        } else {
                            alert(data.message || "일치하는 정보가 없습니다.");
                        }
                        self.isProcessing = false;
                    },
                    error: function() {
                        alert("서버 통신 중 오류가 발생했습니다.");
                        self.isProcessing = false;
                    }
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>
