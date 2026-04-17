<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
   <style>
    body {
        margin: 0;
        padding: 60px 0;
        background: #f4f6fb;
        font-family: Arial, sans-serif;
    }

    #app {
        width: 420px;
        margin: 0 auto;
        background: #f0f4f5;
        border: 1px solid hsl(205, 89%, 51%);
        border-radius: 16px;
        box-shadow: 0 8px 24px rgba(0, 0, 0, 0.08);
        padding: 28px 24px 24px;
        text-align: center;
    }

    #app::before {
        content: "회원가입 유형 선택";
        display: block;
        font-size: 22px;
        font-weight: 700;
        color: #222;
        margin-bottom: 24px;
    }

    button {
        width: 170px;
        height: 180px;
        border-radius: 12px;
        cursor: pointer;
        font-size: 18px;
        font-weight: 700;
        line-height: 1.4;
        transition: all 0.2s ease;
        margin: 0 7px;
        vertical-align: top;
    }

    button:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.08);
    }

    button:first-of-type {
        border: 2px solid #8ea8d8;
        background: #eef4ff;
        color: #2b2b2b;
    }

    button:last-of-type {
        border: 1px solid #dfd7cf;
        background: #f7f2ed;
        color: #2b2b2b;
    }

    table, tr, td, th {
        border: 1px solid black;
        border-collapse: collapse;
        padding: 5px 10px;
        text-align: center;
    }

    th {
        background-color: beige;
    }

    tr:nth-child(even) {
        background-color: azure;
    }
</style>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
         <button onclick="location.href='/user/SignupUser.do'">
             일반사용자
         </button>
          <button onclick="location.href='/user/SignupBiz.do'">
             사업자
         </button>


    </div>
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
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
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        }
    });

    app.mount('#app');
</script>