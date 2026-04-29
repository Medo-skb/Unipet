<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNIPET</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/kindergarten.css">
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app" class="event-page">

        <!-- 상단 배너 -->
        <section class="event-hero">
            <img 
                src="${pageContext.request.contextPath}/img/main/kindergarten.png"
                alt="유치원 보내주개 배너"
                class="event-hero-img"
            >
        </section>

        <!-- 소개 문구 -->
        <section class="event-intro">
            <p class="event-label event-font">반려견을 위한 프리미엄 라이프</p>
            <h2>
                <span class="pink">유치원 </span>
                <span class="black">보내주개</span>
            </h2>
            <p class="event-desc">
                우리 아이가 즐겁고 안전하게 하루를 보낼 수 있는 유치원 업체를 만나보세요.
            </p>
        </section>

        <!-- 업체 리스트 -->
        <section class="store-section">
            <div class="section-title-wrap">
                <h3>
                    <span class="pink">유치원 </span>
                    <span class="black">추천 업체</span>
                </h3>
                <p>우리 아이가 즐겁게 뛰놀 수 있는 유치원을 찾아보세요!</p>
            </div>

            <div class="store-grid">
                <div 
                    class="store-card" 
                    v-for="store in storeList" 
                    :key="store.storeNo"
                    @click="fnGoDetail(store.storeNo)"
                >
                    <div class="store-img-box">
                        <img 
                            v-if="store.fileName"
                            :src="contextPath + store.filePath + store.fileName"
                            :alt="store.storeName"
                        >

                        <img 
                            v-else
                            :src="contextPath + '/img/main/no-image.png'"
                            alt="기본 이미지"
                        >
                    </div>

                    <div class="store-info">
                        <h4>{{ store.storeName }}</h4>

                        <p class="store-sub-title">
                            {{ store.subTitle }}
                        </p>

                        <p class="store-addr">
                            {{ store.sAddr }}
                        </p>
                    </div>
                </div>
            </div>
        </section>

    </div>

    <!-- 푸터 -->
    <jsp:include page="/WEB-INF/footer/footer.jsp" />
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                contextPath: '${pageContext.request.contextPath}',
                storeList: []
            };
        },
        methods: {
            fnList: function () {
                let self = this;
                let param = {};

                $.ajax({
                    url: "/main/kindergarten.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log("유치원 업체 응답:", data);
                        self.storeList = data.list;
                    }
                });
            },

            fnGoDetail: function (storeNo) {
                location.href = this.contextPath + "/reservation/store-detail.do?storeNo=" + storeNo;
            }
        },
        mounted() {
            this.fnList();
        }
    });

    app.mount('#app');
</script>