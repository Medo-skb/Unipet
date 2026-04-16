<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/css/reservation/storeDetail.css" rel="stylesheet">
    <title>Store Detail</title>
    
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div id="container">
            <div id="top">
                <div>업체명</div>
                <div>업종</div>
                <div class="b-button">예약하기</div>
            </div>
            <div id="contents">
                <div class="img-area">
                    <div class="img">img1</div>
                    <div class="img">img2</div>
                </div>
                <div class="intro">
                    <div>소개</div>
                    <hr>
                    <div>소개합니다.</div>
                </div>
                <div class="menu">
                    <div>가격표</div>
                    <hr>
                    <ul>
                        <li>진료 10,000원</li>
                        <li>미용 15,000원</li>
                        <li>호텔 20,000원</li>
                    </ul>
                </div>
                <div id="bottom">
                    <div class="review">
                        <div>방문자 리뷰</div>
                        <hr>
                        <div class="rev-cont">
                            <div class="nickname">테스터</div>
                            <span class="rating">5.0</span>
                            <span>⭐️⭐️⭐️⭐️⭐️</span>
                            <div>정말 친절해요!!</div>
                        </div>
                        <div class="rev-cont">
                            <div class="nickname">강아지맘</div>
                            <span class="rating">5.0</span>
                            <span>⭐️⭐️⭐️⭐️⭐️</span>
                            <div>정말 잘해주세요!!</div>
                        </div>
                        

                    </div>
                    <div class="map">지도</div>
                </div>
                
            </div>
        </div>
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
           fnUserList: function () {
                $.ajax({
                    url: "",
                    dataType: "json",
                    type: "GET",
                    data: {},
                    success: function (data) {

                    }
                });
            }
        }, 
        mounted() {
        }
    });
    app.mount('#app');
</script>