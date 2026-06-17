<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/css/reservation/success.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <title>Success</title>
    
</head>
<body>
    <div id="app">
        <div id="container">
            <div class="success-card" v-if="info">
                <div>다음과 같이 예약 및 결제가 완료 되었습니다.</div>
                <h3 class="card-title">예약 상세정보</h3>
                
                <div class="info-list">
                    <div class="info-item">
                        <span class="label">예약 번호:</span>
                        <span class="value">{{ info.rsvNo }} </span>
                    </div>

                    <div class="info-item">
                        <span class="label">예약 일시:</span>
                        <span class="value">{{ info.slotDate }} {{ info.slotTime }}</span>
                    </div>
                    
                    <div class="info-item">
                        <span class="label">반려동물:</span>
                        <span class="value">
                             {{ info.petName }}
                            <span class="sub-text">({{ info.species }} / {{ info.breed }})</span>
                        </span>
                    </div>
                    
                    <div class="info-item">
                        <div class="label">진료/서비스 명</div>
                        <div class="value">{{ info.menuName }}</div>
                    </div>
                    
                    <div class="info-item">
                        <div class="label">예약 결제 금액</div>
                        <div class="value" style="color: #ff4757; font-weight: bold;">
                            {{ info.menuPrice?.toLocaleString() }}원
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <span class="label">요청사항:</span>
                        <div class="value request-box"> {{ info.request || '없음' }}</div>
                    </div>
                    <div class="notice-area">
                        <div class="notice-header" @click="isNoticeOpen = !isNoticeOpen">
                            <div class="header-left">
                                <span class="arrow">{{ isNoticeOpen ? '▼' : '▶' }}</span>
                                <span class="notice-title">취소 및 환불규정</span>
                            </div>
                        </div>
                        
                        <transition name="fade">
                            <div class="notice-content" v-show="isNoticeOpen">
                                <ul>
                                    <li><strong>방문 3일 전:</strong> 예약 결제 금액의 100% 환불</li>
                                    <li><strong>방문 1일 전 ~ 2일 전:</strong> 예약 결제 금액의 50% 환불</li>
                                    <li><strong>방문 당일 및 노쇼:</strong> 환불 불가</li>
                                    <li>예약 시간보다 15분 이상 늦으실 경우 노쇼로 간주되어 자동 취소될 수 있습니다.</li>
                                </ul>
                            </div>
                        </transition>
                    </div>
                    
                </div>

                <div class="confirm-buttons">
                    <button class="btn-myPage" @click="goMyPage">마이페이지</button>
                    <button class="btn-cancel" @click="fnCancel">예약취소</button>
                </div>
            </div>
        </div>
    </div>
</body>

<script>
    const app = Vue.createApp({
        data() {
            return {
                rsvNo: '${map.rsvNo}', // 컨트롤러에서 request.setAttribute("map", map) 한 값
                info: null,            // DB에서 가져온 상세 정보 저장
                isNoticeOpen: false
            };
        },
        methods: {
            fnGetDetail() {
                const self = this;
                $.ajax({
                    url: "/reservation/info.dox", // 상세 조회용 API
                    type: "POST",
                    data: { rsvNo: self.rsvNo },
                    success: function(data) {
                        if (data && data.info) {
                            self.info = data.info;
                        } else {
                            console.error("데이터 구조가 올바르지 않습니다.");
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("AJAX 호출 실패:", status, error);
                        alert("예약 정보를 불러오는 데 실패했습니다.");
                    }
                });
            },
            goMyPage() {
                location.href = " ";
            },
            fnCancel() {
                const self = this;
                if (!confirm("예약을 취소하시겠습니까?")) return;

                $.ajax({
                    url: "/reservation/cancel.dox",
                    type: "POST",
                    data: { 
                        rsvNo: self.rsvNo,
                        slotNo: self.info.slotNo, // 혹은 info.slotNo (서버 응답 필드명 확인)
                        userId: self.info.userId   // 상세 정보에서 가져온 아이디를 그대로 전달
                    },
                    success: function(data) {
                        if (data.result === "success") {
                            alert("예약이 정상적으로 취소되었습니다.");
                            location.href = "/reservation/search.do";
                        } else {
                            alert("취소 처리 중 오류가 발생했습니다.");
                        }
                    }
                });
            }
        },
        mounted() {
            this.fnGetDetail();
            
        }
    }).mount('#app');
</script>
</html>