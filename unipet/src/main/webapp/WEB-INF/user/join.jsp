<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <link href="/css/user/join.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <title>회원가입 선택</title>
  
</head>
<body>
    <div id="app">
         <button onclick="location.href='/user/signup-user.do'">
             일반사용자
         </button>
         <button onclick="location.href='/user/signup-biz.do'">
             사업자
         </button>
    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
            };
        },
        methods: {
            fnList: function () {
                let self = this;
                let param = {};
                $.ajax({
                    url: "",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {

                    }
                });
            }
        },
        mounted() {
            let self = this;
        }
    });

    app.mount('#app');
</script>