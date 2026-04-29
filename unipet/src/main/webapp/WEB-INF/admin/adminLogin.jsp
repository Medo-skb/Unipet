<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNIPET</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/adminLogin.css">
</head>
<body>
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app" class="admin-login-page">
        <div class="admin-login-box">

            <div class="admin-login-header">
                <h1>UNIPET ADMIN</h1>
                <p>관리자 계정으로 로그인해주세요.</p>
            </div>

            <form action="${pageContext.request.contextPath}/admin/login.dox" method="post" class="admin-login-form">

                <div class="input-group">
                    <label for="adminId">아이디</label>
                    <input type="text" id="adminId" name="adminId" placeholder="관리자 아이디 입력">
                </div>

                <div class="input-group">
                    <label for="adminPwd">비밀번호</label>
                    <input type="password" id="adminPwd" name="adminPwd" placeholder="비밀번호 입력">
                </div>

                <c:if test="${not empty msg}">
                    <div class="login-error">${msg}</div>
                </c:if>
                <button type="submit" class="admin-login-btn">로그인</button>

            </form>

            <div class="admin-login-footer">
                <span>관리자 전용 페이지입니다.</span>
            </div>

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