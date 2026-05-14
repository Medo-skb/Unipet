<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <title>UNIPET</title>
    <link href="/css/reservation/confirm.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="/WEB-INF/header/header.jsp" />
    
    <div id="app">
        <div id="container">
            <div class="confirm-card">
                <div class="notice">다음과 같이 <span class="highlight">예약</span> 및 <span class="highlight">결제</span>를 진행하겠습니다.</div>
                <h3 class="card-title">예약 상세정보</h3>
                
                <div class="info-list">
                    <div class="info-item">
                        <span class="label">예약 일시:</span>
                        <span class="value">{{ info.date }} {{ info.time }}</span>
                    </div>
                    
                    <div class="info-item">
                        <span class="label">반려동물:</span>
                        <span class="value">
                            {{ info.pet?.petName }} 
                            <span class="sub-text">({{ info.pet?.species }} / {{ info.pet?.breed }})</span>
                        </span>
                    </div>
                    
                    <div class="info-item">
                        <div class="label">진료/서비스 명</div>
                        <div class="value" v-if="info.menus && info.menus.length > 0">
                            {{ info.menus[0].menuName }}
                        </div>
                    </div>
                    
                    <div class="info-item">
                        <div class="label">총 금액</div>
                        <div class="value">
                            <span>{{ info.totalPrice?.toLocaleString() }} 원</span>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="label highlight">선결제 예약금 (10%)</div>
                        <div class="value">
                            <span class="highlight">{{ info.reservationPrice?.toLocaleString() }} 원</span>
                        </div>
                    </div>

                    <div class="info-item">
                        <div class="label">현장 결제 금액</div>
                        <div class="value">
                            <span>{{ balancePrice.toLocaleString() }} 원</span>
                        </div>
                    </div>
                    
                    <div class="info-item align-center"> 
                        <span class="label">요청사항:</span>
                        <div class="value request-box">{{ info.request || '없음' }}</div>
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
                    <button class="btn-confirm" @click="fnSubmit">확인</button>
                    <button class="btn-cancel" @click="fnCancel">취소</button>
                </div>
            </div>
        </div>
    </div>
    
    <jsp:include page="/WEB-INF/footer/footer.jsp" />
</body>

<script>
    const app = Vue.createApp({
        data() {
            return {
                info: {},
                isNoticeOpen: false,
                isSubmitting: false,
                userId: '${sessionScope.sessionId}',
            };
        },
        computed: {
            // 현장 결제 금액 계산: 총 금액 - 선결제 예약금
            balancePrice() {
                const total = this.info.totalPrice || 0;
                const reserved = this.info.reservationPrice || 0;
                return total - reserved;
            }
        },
        methods: {
            fnSubmit() {
                const self = this;

                if (self.isSubmitting) return;

                const params = {
                    ...self.info,
                    menuNo: self.info.menuNo || (self.info.menus && self.info.menus[0] ? self.info.menus[0].menuNo : null),
                    petNo: self.info.petNo || (self.info.pet ? self.info.pet.petNo : null)
                };

                if (!params.menuNo || !params.petNo || !params.slotNo || !params.storeNo) {
                    alert("예약에 필요한 필수 정보가 누락되었습니다. 다시 시도해 주세요.");
                    return;
                }

                self.isSubmitting = true;

                $.ajax({
                    url: "/reservation/add-rsv.dox",
                    type: "POST",
                    data: params,
                    success: function(data) {
                        const res = typeof data === "string" ? JSON.parse(data) : data;

                        if (res.result === "success") {
                            const isConfirmed = confirm("예약은 결제 완료 후 최종 확정이 됩니다.\n" +
                                                        "결제가 완료되지 않은 예약신청은 10분 후 자동 취소 됩니다.\n" +
                                                        "결제 페이지로 이동 합니다.");
                            if(isConfirmed){
                                pageChange("/payment/pay-rsv.do", { rsvNo: res.rsvNo });
                            }
                        } else {
                            alert("예약 처리 중 오류가 발생했습니다: " + (res.message || "서버 응답 에러"));
                        }
                    },
                    error: function(xhr, status, error) {
                        alert("서버와 통신 중 문제가 발생했습니다. 관리자에게 문의하세요.");
                    },
                    complete: function() {
                        self.isSubmitting = false;
                    }
                });
            },
            fnCancel() {
                const self = this;
                
                if (confirm("예약을 취소하고 이전 예약 페이지로 돌아가시겠습니까?")) {
                    const sNo = self.info.storeNo;

                    if (sNo) {
                        pageChange("/reservation/book.do", { storeNo: sNo });
                    } else {
                        location.href = "/main.do";
                    }
                }
            }
        },
        mounted() {
            if (!this.userId) {
                alert("로그인이 필요한 서비스입니다.");
                location.href = "/user/login.do";
                return;
            }
            
            const savedData = localStorage.getItem("reserveTemp");
            
            if (!savedData) {
                alert("예약 정보가 없습니다. 이전 페이지로 돌아갑니다.");
                location.href = "/reservation/main.do";
                return;
            }

            try {
                this.info = JSON.parse(savedData);
            } catch (e) {
                alert("데이터를 읽어오는 중 오류가 발생했습니다.");
            }
        }
    }).mount('#app');
</script>
</html>