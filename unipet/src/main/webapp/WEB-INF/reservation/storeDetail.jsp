<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=2198e0ed2782e12a610e46213693750e&libraries=services"></script>
    <title>UNIPET</title>
    <link href="/css/reservation/storeDetail.css" rel="stylesheet">
    
</head>
<body>
    <jsp:include page="/WEB-INF/header/header.jsp" />
    
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div id="container">
            <div id="top">
                <div class="top-wrapper">
                    <div>{{ storeInfo.storeName }}</div>
                    <div class="s-type">{{ storeInfo.storeType }}</div>
                </div>
                
                <div id="top-sub">
                    <div>{{ storeInfo.subTitle }}</div>
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
                    <div class="sContents">{{ storeInfo.sContents }}</div>
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
                            <div class="sub-text"> ** 리뷰는 최근 2건만 보여집니다.</div>
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
                reviewList: [],
                reviewCount: 0
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
                const self = this;
                const info = self.storeInfo;
                const container = document.getElementById('map');
                const geocoder = new kakao.maps.services.Geocoder();

                // 1. 좌표 우선 확인
                const lat = parseFloat(info.lat);
                const lng = parseFloat(info.lng);

                // 좌표가 유효하면 바로 지도 실행, 아니면 주소로 검색
                if (lat && lng && lat !== 0) {
                    const moveLatLon = new kakao.maps.LatLng(lat, lng);
                    self.renderMap(container, moveLatLon);
                } else {
                    // 주소에서 상세 내용(괄호) 제거 후 검색
                    let addr = (info.sAddr || "").split('(')[0].trim();
                    if (!addr) {
                        container.style.display = 'none';
                        return;
                    }
                    
                    geocoder.addressSearch(addr, (result, status) => {
                        if (status === kakao.maps.services.Status.OK) {
                            const moveLatLon = new kakao.maps.LatLng(result[0].y, result[0].x);
                            self.renderMap(container, moveLatLon);
                        } else {
                            container.style.display = 'none'; // 주소 검색 실패 시 지도 숨김
                        }
                    });
                }
            },

            // 실제 지도를 그리는 공통 로직 (방법 B: 문자열 결합 방식 적용)
            renderMap(container, latlng) {
                const options = { center: latlng, level: 3 };
                const map = new kakao.maps.Map(container, options);
                const marker = new kakao.maps.Marker({ position: latlng, map: map });

                const item = this.storeInfo;
                const status = String(item.sStatus || "").toUpperCase();

                // JSP EL 충돌 방지를 위해 문자열(+) 결합 사용
                var content = '<div style="padding:10px 12px; min-width:160px; background:#fff; font-family:sans-serif; letter-spacing:-0.5px;">';
                content += '    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px; gap:8px;">';
                
                // 업체 타입 (미용실 등)
                if (item.storeType) {
                    content += '    <span style="font-size:10px; color:#777; background:#f0f0f0; padding:2px 5px; border-radius:3px; font-weight:600;">' + item.storeType + '</span>';
                }
                
                // 유니펫 회원사 배지
                if (status === 'GEN') {
                    content += '    <span style="font-size:10px; color:#ff4b82; background:#fff0f5; border:1px solid #ffdae9; padding:1px 5px; border-radius:3px; font-weight:700; white-space:nowrap;">유니펫 회원사</span>';
                }
                
                content += '    </div>';
                content += '    <div style="margin-bottom:4px;">';
                content += '        <strong style="font-size:15px; color:#111; font-weight:700;">' + (item.storeName || '') + '</strong>';
                content += '    </div>';
                content += '    <div style="font-size:12px; color:#666; line-height:1.4;">' + (item.sAddr || '') + '</div>';
                content += '</div>';

                const infowindow = new kakao.maps.InfoWindow({ content: content });
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
            if (!this.storeNo) {
                alert("업체 선택이 필요합니다.");
                location.href = "/reservation/search.do";
                return;
            } else {
                this.fnGetStoreDetail();
            }
        }
    });
    app.mount('#app');
</script>