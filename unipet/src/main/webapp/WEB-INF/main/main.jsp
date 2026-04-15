<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <!-- css 추가 -->
    <link rel="stylesheet" href="/css/main.css">
</head>
<body>
    <!-- 헤더 추가 -->
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <section class="main-banner-section">
            <div class="banner-slider" id="bannerSlider">

                <!-- 배너 1 -->
                <div class="banner-slide active">
                    <img src="${pageContext.request.contextPath}/img/banner_orange.png" alt="주황 배너" class="banner-image">
                </div>

                <!-- 배너 2 -->
                <div class="banner-slide">
                    <img src="${pageContext.request.contextPath}/img/banner_green.png" alt="초록 배너" class="banner-image">
                </div>

                <!-- 배너 3 -->
                <div class="banner-slide">
                    <img src="${pageContext.request.contextPath}/img/banner_red.png" alt="빨강 배너" class="banner-image">
                </div>

                <!-- 오른쪽 아래 버튼 -->
                <div class="banner-overlay-inner">
                    <div class="banner-controls">
                        <button type="button" class="banner-btn prev-btn" id="prevBtn">‹</button>
                        <button type="button" class="banner-btn next-btn" id="nextBtn">›</button>
                    </div>
                </div>

                <!-- 하단 dot -->
                <div class="banner-dots">
                    <span class="banner-dot active" data-index="0"></span>
                    <span class="banner-dot" data-index="1"></span>
                    <span class="banner-dot" data-index="2"></span>
                </div>
            </div>
        </div>
    </section>
        <div id="app">
            <div class="container-main">

            </div>
        </div>
    <!-- main.js 연결 -->
    <script src="/js/main.js"></script>
    <div style="height: 1000px;"></div>
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