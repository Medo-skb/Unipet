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
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/bizMyPage/bizCommon.css">
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <div class="biz-page-wrap">
            <div class="biz-page-container">

                <aside class="biz-sidebar">
                    <div class="sidebar-title">나의 업체관리</div>

                    <ul class="sidebar-menu">
                        <li class="menu-item">
                            <a href="/biz/MyPage.do">홈</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/storeEdit.do">업체 소개 수정</a>
                        </li>
                        <li class="menu-item active">
                            <a href="/biz/myInfo.do">내 정보 수정</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/reservation.do">예약 현황</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/review.do">리뷰 관리</a>
                        </li>
                        <li class="menu-item">
                            <a href="/biz/sales.do">매출 현황</a>
                        </li>
                    </ul>
                </aside>

                <section class="biz-content">
                    <div class="content-header">
                        <h1>내 정보 수정</h1>
                    </div>

                    <div class="content-section">
                        <div class="section-header">
                            <h2>기본 정보</h2>
                        </div>

                        <div class="info-list">
                            <div class="info-row">
                                <div class="info-label">아이디</div>
                                <div class="info-value">sampleBiz01</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">대표자명</div>
                                <div class="info-value">홍길동</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">이메일</div>
                                <div class="info-value">sample@naver.com</div>
                            </div>
                            <div class="info-row">
                                <div class="info-label">휴대폰 번호</div>
                                <div class="info-value">010-1234-5678</div>
                            </div>
                        </div>

                        <div class="section-btn-area">
                            <button type="button" class="edit-btn">수정하기</button>
                        </div>
                    </div>

                    <div class="content-section">
                        <div class="section-header">
                            <h2>계정 관리</h2>
                        </div>

                        <div class="simple-card-list">
                            <div class="simple-card-item">
                                <div class="simple-card-title">비밀번호 변경</div>
                                <div class="simple-card-desc">현재 비밀번호 확인 후 새 비밀번호로 변경합니다.</div>
                            </div>
                            <div class="simple-card-item">
                                <div class="simple-card-title">알림 설정</div>
                                <div class="simple-card-desc">예약, 리뷰, 정산 관련 알림 수신 여부를 설정합니다.</div>
                            </div>
                        </div>
                    </div>
                </section>
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