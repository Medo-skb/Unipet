<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/css/reservation/search.css" rel="stylesheet">
    <title>Reservation Search</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://npmcdn.com/flatpickr/dist/l10n/ko.js"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=2198e0ed2782e12a610e46213693750e"></script>
</head>
<body>
    <div id="app">
        <!-- html 코드는 id가 app인 태그 안에서 작업 -->
        <div id="container">
            <div id="top">
                <div id="sort-area">
                    <div class="s-button" :class="{ active: selectedType === '병원' }" @click="filterType('병원')">병원</div>
                    <div class="s-button" :class="{ active: selectedType === '미용실' }" @click="filterType('미용실')">미용실</div>
                    <div class="s-button" :class="{ active: selectedType === '위탁시설' }" @click="filterType('위탁시설')">위탁시설</div>
                    <div class="s-button" @click="filterType('')">전체보기</div>
                </div>
                <div id="search">
                    <div class="input-group">
                        <label>날짜</label>
                        <div class="input-box">
                            <input type="text" id="date-range" placeholder="시작일 ~ 종료일">
                        </div>
                    </div>
                    <div class="input-group">
                        <label>시간</label>
                        <div class="input-box">
                            <input type="text" id="start-time" placeholder="시작" style="width: 60px; text-align: center;">
                            <span style="margin: 0 5px;">~</span>
                            <input type="text" id="end-time" placeholder="종료" style="width: 60px; text-align: center;">
                        </div>
                    </div>
                </div>
            </div>
            <div id="bottom">
                <div id="left">
                    <div class="list-header">
                        주변 업체 <span class="count">{{ list.length }}</span>개
                    </div>

                    <div v-for="(item, index) in list" 
                        :key="index" 
                        class="store-card" 
                        @click="selectStore(item, index)">
                        
                        <div class="store-info">
                            <div class="info-top">
                                <span class="category">{{ item.storeType }}</span>
                            </div>
                            <h3 class="store-name">{{ item.storeName }}</h3>
                            <p class="store-addr">{{ item.sAddr }}</p>
                        </div>
                    </div>

                    <div v-if="list.length === 0" class="no-result">
                        현재 지도 영역 내에<br>등록된 업체가 없습니다.
                    </div>
                </div>
                <div id="right">
                    <div id="map">
                        <div id="my-location-btn" @click="getCurrentLocation" title="내 위치로 이동">
                            <img src="/img/reservation/map_ping.png" alt="내위치">
                        </div>
                    </div>
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
                map: null,
                markers: [],
                list: [],
                infowindow: null,
                selectedType: '',
                myMarker: null
            };
        },
        methods: {
            initMap() {
                const container = document.getElementById('map');
                const options = {
                    center: new kakao.maps.LatLng(37.5665, 126.9780),
                    level: 5
                };
                this.map = new kakao.maps.Map(container, options);

                this.map.addControl(new kakao.maps.MapTypeControl(), kakao.maps.ControlPosition.TOPRIGHT);
                this.map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);

                // 지도가 멈추면 데이터 호출
                kakao.maps.event.addListener(this.map, 'idle', () => {
                    this.fnStoreList();
                });

                this.getCurrentLocation();
            },

            getCurrentLocation() {
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition((pos) => {
                        const lat = pos.coords.latitude;
                        const lng = pos.coords.longitude;
                        const moveLatLon = new kakao.maps.LatLng(lat, lng);
                        this.map.panTo(moveLatLon);
                        this.showMyMarker(lat, lng); 
                    });
                }
            },

            showMyMarker(lat, lng) {
                if (this.myMarker) this.myMarker.setMap(null);
                const imageSize = new kakao.maps.Size(24, 24);
                const markerImage = new kakao.maps.MarkerImage('https://t1.daumcdn.net/localimg/localimages/07/2012/img/marker_p.png', imageSize);
                this.myMarker = new kakao.maps.Marker({
                    position: new kakao.maps.LatLng(lat, lng),
                    image: markerImage
                });
                this.myMarker.setMap(this.map);
            },

            filterType(type) {
                this.selectedType = type;
                this.fnStoreList();
            },

            fnStoreList() {
                const vm = this;
                const bounds = this.map.getBounds();
                const sw = bounds.getSouthWest();
                const ne = bounds.getNorthEast();

                $.ajax({
                    url: "http://localhost:8080/reservation/search.dox", 
                    dataType: "json",
                    type: "POST",
                    data: {
                        swLat: sw.getLat(),
                        swLng: sw.getLng(),
                        neLat: ne.getLat(),
                        neLng: ne.getLng(),
                        storeType: vm.selectedType
                    },
                    success: (res) => {
                        console.log("1. 서버 응답:", res);
                        const rawData = res.list || []; 

                        if (rawData.length > 0) {
                            // [수정] 중복 제거 기준을 더 넓히거나, 데이터가 확실하다면 잠시 주석 처리해보세요.
                            const uniqueData = rawData.filter((item, index, arr) =>
                                index === arr.findIndex((t) => (
                                    // storeId가 모두 같거나 없을 가능성이 있으므로 업체명과 좌표를 같이 비교
                                    (t.storeName === item.storeName && t.lat === item.lat && t.lng === item.lng)
                                ))
                            );
                            
                            // 만약 위 코드로도 1개만 나온다면, 중복 제거 없이 바로 넣어보세요:
                            // this.list = rawData; 
                            
                            this.list = uniqueData;
                            console.log("2. 화면에 뿌릴 리스트 개수:", this.list.length);

                            this.$nextTick(() => {
                                this.createMarkers();
                            });
                        } else {
                            this.list = [];
                            this.createMarkers();
                        }
                    }
                });
            },

            createMarkers() {
                // [1] self 선언: 이벤트 리스너(function) 내부에서 Vue 인스턴스에 접근하기 위해 반드시 필요합니다.
                const self = this;

                // [2] 기존 마커 제거: 지도가 지저분해지지 않도록 새로 그리기 전에 싹 지웁니다.
                if (this.markers && Array.isArray(this.markers)) {
                    this.markers.forEach(m => {
                        if (m) m.setMap(null);
                    });
                }
                this.markers = []; // 마커 배열 초기화

                // [3] 인포윈도우 초기화: 딱 하나만 만들어서 재사용합니다.
                if (!this.infowindow) {
                    this.infowindow = new kakao.maps.InfoWindow({ zIndex: 10 });
                }

                // [4] 예외 처리: 데이터가 없으면 함수 종료
                if (!this.list || this.list.length === 0) {
                    console.warn("지도에 표시할 업체 리스트가 없습니다.");
                    return;
                }

                console.log("마커 생성 시작 - 대상 개수:", this.list.length);

                // [5] 리스트를 돌며 마커 생성
                this.list.forEach((item, index) => {
                    // 좌표가 문자열로 들어올 경우를 대비해 숫자로 변환
                    const lat = parseFloat(item.lat);
                    const lng = parseFloat(item.lng);

                    if (isNaN(lat) || isNaN(lng)) {
                        console.error(`${index}번 업체 좌표 오류:`, item.storeName);
                        return; // 좌표가 이상하면 이번 루프는 건너뜀
                    }

                    const markerPosition = new kakao.maps.LatLng(lat, lng);
                    
                    // 마커 생성
                    const marker = new kakao.maps.Marker({
                        position: markerPosition,
                        map: self.map
                    });

                    // 중요: 마커 객체에 인덱스를 저장 (나중에 리스트 클릭 시 찾기 위함)
                    marker.listIndex = index;

                    // 말풍선(InfoWindow)에 들어갈 HTML 구성
                    const sName = String(item.storeName || "이름 없음");
                    const sAddr = String(item.sAddr || "주소 없음");
                    const content = 
                        '<div style="padding:10px; min-width:150px; background:#fff; border:1px solid #4A90E2; border-radius:5px;">' +
                        '    <div style="font-weight:bold; font-size:14px; color:#000; margin-bottom:5px;">' + sName + '</div>' +
                        '    <div style="font-size:12px; color:#666; line-height:1.4;">' + sAddr + '</div>' +
                        '</div>';

                    // [이벤트 1] 마우스 오버: 말풍선 열기
                    kakao.maps.event.addListener(marker, 'mouseover', function() {
                        self.infowindow.setContent(content);
                        self.infowindow.open(self.map, marker);
                    });

                    // [이벤트 2] 마우스 아웃: 말풍선 닫기
                    kakao.maps.event.addListener(marker, 'mouseout', function() {
                        self.infowindow.close();
                    });

                    // 생성된 마커를 배열에 담기 (나중에 관리하기 위함)
                    this.markers.push(marker);
                });

                console.log("마커 생성 완료 - 실제 생성 개수:", this.markers.length);
            },

            selectStore(item, index) {
                if (!this.infowindow || !this.markers[index]) {
                    console.error("인포윈도우나 마커를 찾을 수 없음", index);
                    return;
                }

                this.infowindow.close();
                const moveLatLon = new kakao.maps.LatLng(parseFloat(item.lat), parseFloat(item.lng));
                this.map.panTo(moveLatLon);

                const targetMarker = this.markers[index];
                const sName = String(item.storeName || "");
                const sAddr = String(item.sAddr || "");
                const content = '<div style="padding:10px; min-width:150px; background:#fff; border:1px solid #4A90E2;">' +
                                '    <div style="font-weight:bold; font-size:14px; color:#000; margin-bottom:5px;">' + sName + '</div>' +
                                '    <div style="font-size:12px; color:#666;">' + sAddr + '</div>' +
                                '</div>';

                this.infowindow.setContent(content);
                this.infowindow.open(this.map, targetMarker);
            }
        }, 
        mounted() {
            this.initMap();
        }
    });
    app.mount('#app');
</script>