<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/css/reservation.css" rel="stylesheet">
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
                    <div class="s-button">병원</div>
                    <div class="s-button">미용</div>
                    <div class="s-button">호텔</div>
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

                </div>
                <div id="right">
                    <div id="map"></div>
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
                // 변수 - (key : value)
                map: null,
                markers: [], // 생성된 마커들을 관리할 배열
                list: []     // DB에서 받아온 업체 목록 저장
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            // 1. 지도 초기화
            initMap() {
                const container = document.getElementById('map');
                const options = {
                    center: new kakao.maps.LatLng(37.5665, 126.9780), // 기본 서울 중심
                    level: 5
                };
                this.map = new kakao.maps.Map(container, options);

                // 컨트롤 추가
                this.map.addControl(new kakao.maps.MapTypeControl(), kakao.maps.ControlPosition.TOPRIGHT);
                this.map.addControl(new kakao.maps.ZoomControl(), kakao.maps.ControlPosition.RIGHT);

                // 내 위치 찾기 (선택사항)
                this.getCurrentLocation();
                
                // 지도 초기화 후 바로 DB 데이터 불러오기
                this.fnStoreList();
            },

            // 2. 내 위치 가져오기
            getCurrentLocation() {
                if (navigator.geolocation) {
                    navigator.geolocation.getCurrentPosition((pos) => {
                        const moveLatLon = new kakao.maps.LatLng(pos.coords.latitude, pos.coords.longitude);
                        this.map.setCenter(moveLatLon);
                    });
                }
            },

            // 3. DB에서 업체 데이터 가져오기 (AJAX)
            fnStoreList() {
                const self = this;
                $.ajax({
                    url: "http://localhost:8080/reservation/search.dox", // 본인의 서버 URL로 수정하세요
                    dataType: "json",
                    type: "POST",
                    success: function (data) {
                        // data는 [{name: '병원A', lat: 37.123, lng: 126.123}, ...] 형태라고 가정
                        console.log(data);
                        self.list = data.list;
                        self.createMarkers(); // 데이터를 다 받으면 마커 생성 함수 실행
                    }
                });
            },

            // 4. 받아온 데이터를 바탕으로 마커 생성
            createMarkers() {
                // 기존 마커가 있다면 제거 (필터링 기능 추가 시 필요)
                this.markers.forEach(marker => marker.setMap(null));
                this.markers = [];

                this.list.forEach((item) => {
                    // 마커가 표시될 위치
                    const markerPosition = new kakao.maps.LatLng(item.lat, item.lng);

                    // 마커 생성
                    const marker = new kakao.maps.Marker({
                        position: markerPosition,
                        title: item.name // 마커에 마우스를 올렸을 때 나타나는 이름
                    });

                    // 지도에 마커 표시
                    marker.setMap(this.map);

                    // 생성된 마커를 배열에 보관
                    this.markers.push(marker);

                    // (선택) 마커 클릭 시 업체명 인포윈도우 표시
                    const iwContent = `<div style="padding:5px; font-size:12px;">${item.name}</div>`;
                    const infowindow = new kakao.maps.InfoWindow({
                        content: iwContent,
                        removable: true
                    });

                    kakao.maps.event.addListener(marker, 'click', () => {
                        infowindow.open(this.map, marker);
                    });
                });
            }
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            // 1. 날짜 선택기 설정
            flatpickr("#date-range", {
                locale: "ko",
                mode: "range",        // 범위 선택 모드 활성화
                dateFormat: "m.d",
                disableMobile: true,
                onClose: (selectedDates, dateStr) => {
                    this.selectedDateRange = dateStr; // "04.10 ~ 04.12" 형태로 저장됨
                }
            });

           // 2. 시작 시간 선택
            const startTimeConfig = {
                enableTime: true,
                noCalendar: true,
                dateFormat: "H:i",
                time_24hr: true,
                disableMobile: true,
                onChange: (selectedDates, dateStr) => {
                    this.startTime = dateStr;
                    // 시작 시간이 선택되면 종료 시간의 최소 시간을 제한 (선택 사항)
                    endPicker.set('minTime', dateStr);
                }
            };
            flatpickr("#start-time", startTimeConfig);

            // 3. 종료 시간 선택
            const endPicker = flatpickr("#end-time", {
                enableTime: true,
                noCalendar: true,
                dateFormat: "H:i",
                time_24hr: true,
                disableMobile: true,
                onChange: (selectedDates, dateStr) => {
                    this.endTime = dateStr;
                }
            });
            // --- 4. 카카오 지도 실행 ---
            // DOM이 모두 그려진 후(mounted) 지도를 호출해야 에러가 나지 않습니다.
            this.initMap();
        },

    });

    app.mount('#app');

    
</script>