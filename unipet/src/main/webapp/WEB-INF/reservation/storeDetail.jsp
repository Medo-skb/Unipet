<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/css/reservation/storeDetail.css" rel="stylesheet">
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=2198e0ed2782e12a610e46213693750e&libraries=services"></script>
    <title>업체 상세</title>
    <link href="/css/reservation/storeDetail2.css" rel="stylesheet">
    
</head>
<body>
    <jsp:include page="/WEB-INF/header/header.jsp" />
    
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div id="container">
            <div id="top">
                <div>{{ storeInfo.storeName }}</div>
                <div id="top-sub">
                    <div class="s-type">{{ storeInfo.storeType }}</div>
                    <div class="button" @click="fnRsv(storeInfo.storeNo)">예약하기</div>
                </div>
                
            </div>
            <div id="contents">
                <div class="img-area">
                    <div v-for="file in storeImgList" :key="file.fileNo" class="image-item" :data-fno="file.fileNo">
                        <img :src="file.filePath + file.fileName" 
                            :alt="file.originName" 
                            :class="{ 'main-img': file.isMain === 'Y' }">
                    </div>
                </div>
                <div class="intro">
                    <div>소개</div>
                    <hr>
                    <div>{{ storeInfo.sContents }}</div>
                </div>
                <div class="menu">
                    <div>가격표</div>
                    <hr>
                    <ul id="MenuList">
                        <li v-for="item in storeMenuList" :key="item.menuNo">
                            {{ item.menuName }} : {{ item.menuPrice.toLocaleString() }}원
                        </li>
                    </ul>
                </div>
                <div id="bottom">
                    <div class="review">
                        <div class="review-title">
                            방문자 리뷰 
                            <span v-if="reviewCount > 0" class="title-stats">
                                <span class="total-count">[총 {{ reviewCount }}개</span>
                                <span class="avg-score"> / 평균 ⭐ {{ reviewAvg }}]</span>
                            </span>
                        </div>
                        <hr>
                        <div class="review-list-container">
                            <div v-if="reviewList.length === 0" class="no-review">
                                작성된 리뷰가 없습니다.
                            </div>

                            <div v-for="rev in reviewList" :key="rev.rsvNo" class="rev-cont">
                                <div class="rev-header">
                                    <span class="nickname">{{ rev.nickname }}</span>
                                    <span class="date">{{ rev.cdate }}</span>
                                </div>
                                <div class="rev-star">
                                    {{ fnConvertStar(rev.rating) }}
                                </div>
                                <div class="rev-text">
                                    {{ rev.rContents }}
                                </div>
                            </div>
                            <div class="sub-text"> ** 리뷰는 최근 2건만 보여집니다.</div>
                        </div>
                    </div>
                    <div id="map"></div>
                </div>
                
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
                storeNo: '${map.storeNo}', 
                storeInfo: {}, 
                storeMenuList: [],
                storeImgList:[],
                reviewList: []
            };
        },
        methods: {
            fnGetStoreDetail() {
                const self = this;
                $.ajax({
                    url: "/reservation/store-detail.dox",
                    type: "POST",
                    data: { storeNo: self.storeNo }, 
                    success: function(data) {
                        console.log(data);
                        self.storeInfo = data.info;
                        self.storeMenuList = data.menuList;
                        self.storeImgList = data.imgList;
                        self.reviewList = data.reviewList;
                        self.reviewCount = data.reviewCount; 
                        self.reviewAvg = data.reviewAvg;
                        
                        setTimeout(() => {
                            self.drawMap();
                        }, 100);
                    }
                });
            },

            fnConvertStar(rating) {
                const num = Math.floor(Number(rating));
                return "⭐️".repeat(num);
            },

            drawMap: function() {
                // 1. 데이터 가져오기
                const name = this.storeInfo.storeName;
                const addr = this.storeInfo.sAddr;
                const lat = this.storeInfo.lat;
                const lng = this.storeInfo.lng;

                const container = document.getElementById('map');
                const moveLatLon = new kakao.maps.LatLng(lat, lng);
                
                const options = {
                    center: moveLatLon,
                    level: 3
                };
                const map = new kakao.maps.Map(container, options);

                const marker = new kakao.maps.Marker({
                    position: moveLatLon
                });
                marker.setMap(map);

                var content = 
                    '<div style="padding:10px; min-width:150px; background-color:white; border:1px solid #ccc; border-radius:5px; box-shadow: 2px 2px 5px rgba(0,0,0,0.1);">' +
                    '    <div style="font-weight:bold; color:#000; font-size:14px; margin-bottom:5px; text-align:center;">' + name + '</div>' +
                    '    <div style="font-size:12px; color:#333; line-height:1.4; text-align:center;">' + addr + '</div>' +
                    '</div>';

                const infowindow = new kakao.maps.InfoWindow({
                    content: content
                });
                
                infowindow.open(map, marker);
            },

            fnRsv(storeNo) {
                if (!storeNo) {
                    alert("업체 정보가 로드되지 않았습니다.");
                    return;
                }
                pageChange("/reservation/book.do", { storeNo: storeNo });
            },
        }, 
        mounted() {
            if (this.storeNo) {
                this.fnGetStoreDetail();
            }
        }
    });
    app.mount('#app');
</script>