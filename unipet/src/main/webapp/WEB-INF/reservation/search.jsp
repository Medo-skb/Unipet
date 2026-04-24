<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/css/reservation/search.css" rel="stylesheet">
    <title>업체 검색</title>
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
                        startDate: vm.searchDate.start,
                        endDate: vm.searchDate.end,
                        startTime: vm.searchTime.start ? vm.searchTime.start : '00:00',
                        endTime: vm.searchTime.end ? vm.searchTime.end : '23:59'
                    },
                    success: (res) => {
                        const rawData = res.list || [];
                        
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
                this.searchDate = { start: '', end: '' };
                this.searchTime = { start: '', end: '' };
                this.selectedType = '';

                document.getElementById('date-range')._flatpickr.clear();
                document.getElementById('start-time')._flatpickr.clear();
                document.getElementById('end-time')._flatpickr.clear();

                this.fnStoreList();
            },

            createMarkers() {
                const self = this;

                if (this.markers && Array.isArray(this.markers)) {
                    this.markers.forEach(m => {
                        if (m) m.setMap(null);
                    });
                }
                this.markers = []; 

                if (!this.infowindow) {
                    this.infowindow = new kakao.maps.InfoWindow({ zIndex: 10 });
                }

                if (!this.list || this.list.length === 0) {
                    return;
                }

                this.list.forEach((item, index) => {
                    const lat = parseFloat(item.lat);
                    const lng = parseFloat(item.lng);

                    if (isNaN(lat) || isNaN(lng)) return;

                    const markerPosition = new kakao.maps.LatLng(lat, lng);
                    
                    const marker = new kakao.maps.Marker({
                        position: markerPosition,
                        map: self.map
                    });

                    marker.listIndex = index;

                    const sName = item.storeName || "이름 없음";
                    const sAddr = item.sAddr || "주소 없음";
                    const badge = item.sStatus === 'GEN' ? '<span style="color:#4A90E2; font-size:10px; margin-left:5px; font-weight:bold;">(유니펫 회원사)</span>' : '';

                    const content = 
                        '<div style="padding:10px; min-width:150px; background:#fff; border:1px solid #4A90E2; border-radius:5px;">' +
                        '    <div style="font-weight:bold; font-size:14px; color:#000; margin-bottom:5px;">' + sName + badge + '</div>' +
                        '    <div style="font-size:12px; color:#666; line-height:1.4;">' + sAddr + '</div>' +
                        '</div>';

                    kakao.maps.event.addListener(marker, 'mouseover', function() {
                        self.infowindow.setContent(content);
                        self.infowindow.open(self.map, marker);
                    });

                    kakao.maps.event.addListener(marker, 'mouseout', function() {
                        self.infowindow.close();
                    });

                    this.markers.push(marker);
                });
            },

            selectStore(item, index) {
                if (!this.infowindow || !this.markers || !this.markers[index]) return;

                const moveLatLon = new kakao.maps.LatLng(parseFloat(item.lat), parseFloat(item.lng));
                this.map.panTo(moveLatLon);

                const targetMarker = this.markers[index];

                const sName = item.storeName || "이름 없음";
                const sAddr = item.sAddr || "주소 없음";
                const badge = item.sStatus === 'GEN' ? '<span style="color:#4A90E2; font-size:10px; margin-left:5px; font-weight:bold;">(유니펫 회원사)</span>' : '';

                const content = 
                    '<div style="padding:10px; min-width:150px; background:#fff; border:1px solid #4A90E2; border-radius:5px;">' +
                    '    <div style="font-weight:bold; font-size:14px; color:#000; margin-bottom:5px;">' + sName + badge + '</div>' +
                    '    <div style="font-size:12px; color:#666; line-height:1.4;">' + sAddr + '</div>' +
                    '</div>';

                this.infowindow.close();
                this.infowindow.setContent(content);
                this.infowindow.open(this.map, targetMarker);
            },

            fnGoDetail(item) {
                const self = this;

                if (!item) {
                    alert("업체 정보를 확인할 수 없습니다.");
                    return;
                }

                if (item.sStatus === 'GEN') {
                    if (item.storeNo) {
                        pageChange("/reservation/store-detail.do", { storeNo: item.storeNo });
                    } else {
                        alert("회원사 번호가 없습니다.");
                    }
                } 
                else {
                    let addrPart = "";
                    if (item.sAddr) {
                        const addrArray = item.sAddr.split(' ');
                        addrPart = addrArray.length > 1 ? addrArray[1] : addrArray[0];
                    }
                    
                    const keyword = addrPart + " " + item.storeName;
                    const naverMapUrl = "https://map.naver.com/v5/search/" + encodeURIComponent(keyword.trim());
                    
                    window.open(naverMapUrl, '_blank');
                }
            },
            formatDate(date) {
                if (!date) return ''; 
                const year = date.getFullYear();
                const month = String(date.getMonth() + 1).padStart(2, '0');
                const day = String(date.getDate()).padStart(2, '0');
                return `${year}-${month}-${day}`;
            }
        }, 
        
        mounted() {
            const vm = this;
            this.initMap();

            flatpickr("#date-range", {
                mode: "range",
                locale: "ko",
                dateFormat: "Y-m-d",
                onChange: function(selectedDates, dateStr, instance) {
                    if (selectedDates.length === 2) {
                        vm.searchDate.start = instance.formatDate(selectedDates[0], "Y-m-d");
                        vm.searchDate.end = instance.formatDate(selectedDates[1], "Y-m-d");
                    } else if (selectedDates.length === 0) {
                        vm.searchDate.start = '';
                        vm.searchDate.end = '';
                    }
                }
            });

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