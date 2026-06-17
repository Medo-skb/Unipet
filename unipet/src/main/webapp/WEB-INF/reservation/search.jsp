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
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">
    <link href="/css/reservation/search.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
    <script src="https://npmcdn.com/flatpickr/dist/l10n/ko.js"></script>
    
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoApiKey}"></script>
</head>
<body>
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <div id="container">
            <div id="top">
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
                    <div class="list-top-bar">
                        <div class="list-header">
                            주변 업체 <span class="count">{{ list.length }}</span>개
                        </div>
                        
                        <div class="header-right">
                            <select v-model="selectedType" @change="fnStoreList" class="filter-select">
                                <option value="">전체보기</option>
                                <option value="병원">병원</option>
                                <option value="미용실">미용실</option>
                                <option value="위탁시설">위탁시설</option>
                            </select>
                            
                            <select v-model="selectedSort" @change="sortList" class="filter-select">
                                <option value="distance">거리순</option>
                                <option value="rating">평점순</option>
                            </select>
                        </div>

                    </div>

                    <div v-for="(item, index) in list.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage)" 
                        :key="item.storeNo" 
                        :class="['store-card', { 'is-member': item.sStatus === 'GEN' }]" 
                        @click="selectStore(item)">
                        
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
                                    <span v-if="item.reviewCount > 0" class="store-rating">
                                        ⭐ {{ item.reviewAvg }}
                                    </span>
                                </div>
                                
                                <button class="detail-btn-sm" @click.stop="fnGoDetail(item)">
                                    상세보기
                                </button>
                            </div>

                            <div class="addr-wrap">
                                <p class="store-addr">{{ item.sAddr }}</p>
                                <span v-if="item.distanceStr" class="store-distance">[{{ item.distanceStr }}]</span>
                            </div>
                        </div>
                    </div>

                    <div v-if="list.length === 0" class="no-result">
                        현재 지도 영역 내에<br>등록된 업체가 없습니다.
                    </div>

                    <div class="pagination-wrap" v-if="totalPages > 1">
                        <button class="btn-prev" 
                                @click="fnChangePage(currentPage - 1)" 
                                :disabled="currentPage === 1">
                            &lt;
                        </button>
                        
                        <span v-for="page in totalPages" :key="page" 
                            :class="['page-num', { 'active': currentPage === page }]"
                            @click="fnChangePage(page)">
                            {{ page }}
                        </span>
                        
                        <button class="btn-next" 
                                @click="fnChangePage(currentPage + 1)" 
                                :disabled="currentPage === totalPages">
                            &gt;
                        </button>
                    </div>
                </div>
                <div id="right">
                    <div id="map">
                        <div id="research-btn" v-if="showResearchBtn" @click="fnResearchStore" class="research-btn-wrap">
                            <span>이 위치에서 재검색</span>
                        </div>

                        <div id="my-location-btn" @click="getCurrentLocation" title="내 위치로 이동">
                            <img src="/img/reservation/map_ping.png" alt="내위치">
                        </div>
                    </div>
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
                map: null,
                markers: [],
                list: [],
                infowindow: null,
                selectedType: '',
                selectedSort: 'distance',
                myMarker: null,
                searchDate: { start: '', end: '' },
                searchTime: { start: '', end: '' },
                myLat: null,
                myLng: null, 
                currentPage: 1,     
                itemsPerPage: 20,    
                showResearchBtn: false, 
            };
        },

        computed: {
            totalPages() {
                return Math.ceil(this.list.length / this.itemsPerPage);
            }
        },

        methods: {
            initMap() {
                const container = document.getElementById('map');
                const options = {
                    center: new kakao.maps.LatLng(37.5665, 126.9780),
                    level: 5
                };
                this.map = new kakao.maps.Map(container, options);

                this.infowindow = new kakao.maps.InfoWindow({ zIndex: 3 });

                this.map.addControl(new kakao.maps.MapTypeControl(), kakao.maps.ControlPosition.TOPRIGHT);
                this.map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);

                kakao.maps.event.addListener(this.map, 'idle', () => {
                    this.showResearchBtn = true;
                });

                this.getCurrentLocation();
            },

            fnResearchStore() {
                this.showResearchBtn = false;
                this.fnStoreList();
            },

            getCurrentLocation() {
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition((pos) => {
                        this.myLat = pos.coords.latitude;
                        this.myLng = pos.coords.longitude;
                        
                        const moveLatLon = new kakao.maps.LatLng(this.myLat, this.myLng);
                        this.map.panTo(moveLatLon);
                        this.showMyMarker(this.myLat, this.myLng); 
                        
                        this.showResearchBtn = false; 
                        this.fnStoreList();
                    });
                }
            },

            getDistance(lat1, lng1, lat2, lng2) {
                function deg2rad(deg) { return deg * (Math.PI / 180); }
                const R = 6371; // 지구 반지름 (km)
                const dLat = deg2rad(lat2 - lat1);
                const dLon = deg2rad(lng2 - lng1);
                const a = Math.sin(dLat/2) * Math.sin(dLat/2) +
                        Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
                        Math.sin(dLon/2) * Math.sin(dLon/2);
                const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
                return R * c; // 계산된 거리 (km)
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
            sortList() {
                this.list.sort((a, b) => {
                    const aS = a.sStatus ? a.sStatus.toLowerCase() : '';
                    const bS = b.sStatus ? b.sStatus.toLowerCase() : '';
                    
                    if (aS === 'gen' && bS !== 'gen') return -1;
                    if (aS !== 'gen' && bS === 'gen') return 1;
                    
                    if (this.selectedSort === 'rating') {
                        const ratingA = parseFloat(a.reviewAvg) || 0;
                        const ratingB = parseFloat(b.reviewAvg) || 0;
                        return ratingB - ratingA;
                    } else {
                        const distA = parseFloat(a.distValue) || 0;
                        const distB = parseFloat(b.distValue) || 0;
                        return distA - distB;
                    }
                });

                this.currentPage = 1;
                const listContainer = document.querySelector('#left');
                if (listContainer) listContainer.scrollTop = 0;
            },

            fnStoreList() {
                this.showResearchBtn = false;
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

                        uniqueData.forEach(item => {
                            if (this.myLat && this.myLng && item.lat && item.lng) {
                                const distKm = this.getDistance(this.myLat, this.myLng, parseFloat(item.lat), parseFloat(item.lng));
                                
                                item.distValue = distKm; 

                                if (distKm < 1) {
                                    item.distanceStr = Math.round(distKm * 1000) + "m";
                                } else {
                                    item.distanceStr = distKm.toFixed(1) + "km";
                                }
                            } else {
                                item.distValue = 99999; 
                                item.distanceStr = "";
                            }
                        });
                        
                        this.list = uniqueData;
                        this.sortList(); 

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

            createMarkers: function() {
                const self = this;
                if (self.markers && self.markers.length > 0) {
                    self.markers.forEach(marker => marker.setMap(null));
                }
                self.markers = [];

                self.list.forEach(item => {
                    const lat = parseFloat(item.lat);
                    const lng = parseFloat(item.lng);
                    if (!lat || !lng) return;

                    const marker = new kakao.maps.Marker({
                        position: new kakao.maps.LatLng(lat, lng),
                        map: self.map
                    });

                    marker.storeNo = item.storeNo;
                    self.markers.push(marker);

                    kakao.maps.event.addListener(marker, 'click', function() {
                        self.displayInfoWindow(marker, item);
                    });
                });
            },

            selectStore(item) {
                const self = this;
                
                const targetMarker = self.markers.find(m => m.storeNo === item.storeNo);

                if (targetMarker) {
                    const moveLatLon = new kakao.maps.LatLng(parseFloat(item.lat), parseFloat(item.lng));
                    self.map.panTo(moveLatLon);

                    self.displayInfoWindow(targetMarker, item);
                }
            },

            getStoreContent: function(item) {
                const name = (item.storeName || item.S_NAME || "이름없음").trim();
                const addr = (item.sAddr || item.S_ADDR || "주소없음").trim();
                const type = (item.storeType || item.S_TYPE || "").trim();
                const status = String(item.sStatus || item.S_STATUS || "").toUpperCase();

                let parts = [];
                parts.push('<div style="padding:6px 8px; width:150px; background:#fff; font-family:sans-serif; letter-spacing:-0.5px; border-radius:8px;">');
                
                parts.push('  <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:4px;">');
                if(type) {
                    parts.push('    <span style="font-size:10px; color:#777; background:#f4f4f4; padding:1px 4px; border-radius:3px; font-weight:600;">' + type + '</span>');
                } else {
                    parts.push('    <div></div>');
                }

                if(status === 'GEN') {
                    parts.push('    <span style="font-size:10px; color:#ff4b82; background:#fff; border:1px solid #ffdae9; padding:1px 4px; border-radius:3px; font-weight:700;">유니펫 회원사</span>');
                }
                parts.push('  </div>');

                parts.push('  <div style="margin-bottom:2px; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">');
                parts.push('    <strong style="font-size:15px; color:#111; font-weight:700;">' + name + '</strong>');
                parts.push('  </div>');
                
                parts.push('  <div style="font-size:11px; color:#888; line-height:1.3; overflow:hidden; text-overflow:ellipsis; white-space:nowrap;">');
                parts.push(     addr);
                parts.push('  </div>');
                
                parts.push('</div>');

                return parts.join('');
            },

            displayInfoWindow: function(marker, item) {
                const self = this;
                if (!self.infowindow) return;

                const content = self.getStoreContent(item);
                
                self.infowindow.setContent(content);
                self.infowindow.open(self.map, marker);
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
            },
            fnChangePage(page) {
                if (page < 1 || page > this.totalPages) return;
                this.currentPage = page;
                const listContainer = document.querySelector('#left');
                if (listContainer) listContainer.scrollTop = 0;
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