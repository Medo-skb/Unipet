<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/css/reservation/search.css" rel="stylesheet">
    <title>Store Search</title>
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
                    <div id="search-area">
                        <div class="button-group">
                            <button type="button" @click="fnStoreList" class="search-btn">검색</button>
                            <button type="button" @click="fnReset" class="reset-btn">초기화</button>
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
                        :class="['store-card', { 'is-member': item.sStatus === 'GEN' }]" 
                        @click="selectStore(item, index)">
                        
                        <div class="store-info">
                            <div class="info-top">
                                <span class="category">{{ item.storeType }}</span>
                                <span v-if="item.sStatus === 'GEN'" class="member-badge">유니펫 회원사</span>
                            </div>

                            <div class="name-wrap">
                                <div class="title-area">
                                    <h3 class="store-name">
                                        {{ item.storeName }}
                                    </h3>
                                </div>
                                
                                <button class="detail-btn-sm" @click.stop="fnGoDetail(item)">
                                    상세보기
                                </button>
                            </div>

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
                myMarker: null,
                // 검색 조건 추가
                searchDate: { start: '', end: '' },
                searchTime: { start: '', end: '' }
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
                    url: "/reservation/search.dox", 
                    dataType: "json",
                    type: "POST",
                    data: {
                        swLat: sw.getLat(),
                        swLng: sw.getLng(),
                        neLat: ne.getLat(),
                        neLng: ne.getLng(),
                        storeType: vm.selectedType,
                        // 검색 조건 추가 (값이 없으면 빈 문자열로 전송되어 XML의 <if>문을 통과함)
                        startDate: vm.searchDate.start,
                        endDate: vm.searchDate.end,
                        // 시간이 '12:00' 형태일 때 정확한 비교를 위해 초 단위까지 고려하거나 포맷 확인
                        startTime: vm.searchTime.start ? vm.searchTime.start : '00:00',
                        endTime: vm.searchTime.end ? vm.searchTime.end : '23:59'
                    },
                    success: (res) => {
                        console.log("검색 결과:", res.list);
                        console.log(vm.searchDate, vm.searchTime)
                        const rawData = res.list || [];
                        
                        // 기존의 중복 제거 및 정렬 로직
                        const uniqueData = rawData.filter((item, index, arr) =>
                            index === arr.findIndex((t) => (
                                t.storeName === item.storeName && t.lat === item.lat && t.lng === item.lng
                            ))
                        );
                        
                        this.list = uniqueData.sort((a, b) => {
                            const aS = a.sStatus ? a.sStatus.toLowerCase() : '';
                            const bS = b.sStatus ? b.sStatus.toLowerCase() : '';
                            if (aS === 'gen' && bS !== 'gen') return -1;
                            if (aS !== 'gen' && bS === 'gen') return 1;
                            return 0;
                        });

                        this.$nextTick(() => {
                            this.createMarkers();
                        });
                    }
                });
            },

            fnReset() {
                // 1. Vue 데이터 초기화
                this.searchDate = { start: '', end: '' };
                this.searchTime = { start: '', end: '' };
                this.selectedType = '';

                // 2. 입력 필드(Flatpickr) 강제 초기화
                document.getElementById('date-range')._flatpickr.clear();
                document.getElementById('start-time')._flatpickr.clear();
                document.getElementById('end-time')._flatpickr.clear();

                // 3. 전체 목록 다시 불러오기 (날짜/시간이 빈 상태로 전송됨)
                this.fnStoreList();
            },

            createMarkers() {
                // [1] self 선언: 이벤트 리스너(function) 내부에서 Vue 인스턴스에 접근하기 위해 반드시 필요합니다.
                const self = this;

                // [2] 기존 마커 제거
                if (this.markers && Array.isArray(this.markers)) {
                    this.markers.forEach(m => {
                        if (m) m.setMap(null);
                    });
                }
                this.markers = []; // 마커 배열 초기화

                // [3] 인포윈도우 초기화: 딱 하나만 만들어서 재사용
                if (!this.infowindow) {
                    this.infowindow = new kakao.maps.InfoWindow({ zIndex: 10 });
                }

                // [4] 예외 처리: 데이터가 없으면 함수 종료
                if (!this.list || this.list.length === 0) {
                    return;
                }

                // [5] 리스트를 돌며 마커 생성
                this.list.forEach((item, index) => {
                    const lat = parseFloat(item.lat);
                    const lng = parseFloat(item.lng);

                    if (isNaN(lat) || isNaN(lng)) return;

                    const markerPosition = new kakao.maps.LatLng(lat, lng);
                    
                    // 마커 생성
                    const marker = new kakao.maps.Marker({
                        position: markerPosition,
                        map: self.map
                    });

                    // 마커 객체에 인덱스 저장
                    marker.listIndex = index;

                    // [어제 성공한 포인트] 이벤트 내부에서 직접 HTML 변수를 생성합니다.
                    const sName = item.storeName || "이름 없음";
                    const sAddr = item.sAddr || "주소 없음";
                    const badge = item.sStatus === 'GEN' ? '<span style="color:#4A90E2; font-size:10px; margin-left:5px; font-weight:bold;">(유니펫 회원사)</span>' : '';

                    const content = 
                        '<div style="padding:10px; min-width:150px; background:#fff; border:1px solid #4A90E2; border-radius:5px;">' +
                        '    <div style="font-weight:bold; font-size:14px; color:#000; margin-bottom:5px;">' + sName + badge + '</div>' +
                        '    <div style="font-size:12px; color:#666; line-height:1.4;">' + sAddr + '</div>' +
                        '</div>';

                    // [이벤트 1] 마우스 오버: 말풍선 열기 (self 사용)
                    kakao.maps.event.addListener(marker, 'mouseover', function() {
                        self.infowindow.setContent(content);
                        self.infowindow.open(self.map, marker);
                    });

                    // [이벤트 2] 마우스 아웃: 말풍선 닫기
                    kakao.maps.event.addListener(marker, 'mouseout', function() {
                        self.infowindow.close();
                    });

                    // 생성된 마커를 배열에 담기
                    this.markers.push(marker);
                });
            },

            selectStore(item, index) {
                // [1] 예외 처리
                if (!this.infowindow || !this.markers || !this.markers[index]) return;

                // [2] 지도 중심 이동
                const moveLatLon = new kakao.maps.LatLng(parseFloat(item.lat), parseFloat(item.lng));
                this.map.panTo(moveLatLon);

                // [3] 해당 마커 찾기
                const targetMarker = this.markers[index];

                // [4] 직접 HTML 생성 (createMarkers와 동일한 스타일)
                const sName = item.storeName || "이름 없음";
                const sAddr = item.sAddr || "주소 없음";
                const badge = item.sStatus === 'GEN' ? '<span style="color:#4A90E2; font-size:10px; margin-left:5px; font-weight:bold;">(유니펫 회원사)</span>' : '';

                const content = 
                    '<div style="padding:10px; min-width:150px; background:#fff; border:1px solid #4A90E2; border-radius:5px;">' +
                    '    <div style="font-weight:bold; font-size:14px; color:#000; margin-bottom:5px;">' + sName + badge + '</div>' +
                    '    <div style="font-size:12px; color:#666; line-height:1.4;">' + sAddr + '</div>' +
                    '</div>';

                // [5] 내용 교체 및 열기
                this.infowindow.close();
                this.infowindow.setContent(content);
                this.infowindow.open(this.map, targetMarker);
            },

            fnGoDetail(item) {
                const self = this;
                console.log("선택된 업체 데이터:", item);

                // 1. 데이터가 없는 경우 예외 처리
                if (!item) {
                    alert("업체 정보를 확인할 수 없습니다.");
                    return;
                }

                // 2. 회원사(GEN) 처리: 기존에 잘 작동하던 .do 페이지로 이동
                if (item.sStatus === 'GEN') {
                    if (item.storeNo) {
                        pageChange("/reservation/store-detail.do", { storeNo: item.storeNo });
                    } else {
                        alert("회원사 번호가 없습니다.");
                    }
                } 
                // 3. 비회원사 처리: 네이버 지도 검색결과로 이동
                else {
                    // 주소에서 '부평구' 같은 구 단위 추출 (안전한 방식)
                    let addrPart = "";
                    if (item.sAddr) {
                        const addrArray = item.sAddr.split(' ');
                        addrPart = addrArray.length > 1 ? addrArray[1] : addrArray[0];
                    }
                    
                    const keyword = addrPart + " " + item.storeName;
                    // 네이버 지도 검색 URL (가장 범용적인 query 방식 사용)
                    const naverMapUrl = "https://map.naver.com/v5/search/" + encodeURIComponent(keyword.trim());
                    
                    window.open(naverMapUrl, '_blank');
                }
            },
            formatDate(date) {
                if (!date) return ''; // 날짜가 없으면 빈 문자열 반환
                const year = date.getFullYear();
                const month = String(date.getMonth() + 1).padStart(2, '0');
                const day = String(date.getDate()).padStart(2, '0');
                return `${year}-${month}-${day}`;
            }
        }, 
        
        mounted() {
            const vm = this;
            this.initMap();

            // 날짜 선택 설정
            flatpickr("#date-range", {
                mode: "range",
                locale: "ko",
                dateFormat: "Y-m-d",
                onChange: function(selectedDates, dateStr, instance) {
                    // 날짜가 2개 다 선택되었을 때만 실행
                    if (selectedDates.length === 2) {
                        // instance.formatDate를 사용하면 시차/오류 걱정 없이 설정된 dateFormat대로 출력됩니다.
                        vm.searchDate.start = instance.formatDate(selectedDates[0], "Y-m-d");
                        vm.searchDate.end = instance.formatDate(selectedDates[1], "Y-m-d");
                    } else if (selectedDates.length === 0) {
                        vm.searchDate.start = '';
                        vm.searchDate.end = '';
                    }
                }
            });

            // 시간 선택 설정
            const timeConfig = {
                enableTime: true,
                noCalendar: true,
                dateFormat: "H:i",
                time_24hr: true,
                locale: "ko"
            };

            flatpickr("#start-time", { ...timeConfig, onChange: (d, str) => vm.searchTime.start = str });
            flatpickr("#end-time", { ...timeConfig, onChange: (d, str) => vm.searchTime.end = str });
        }
    });
    app.mount('#app');
</script>