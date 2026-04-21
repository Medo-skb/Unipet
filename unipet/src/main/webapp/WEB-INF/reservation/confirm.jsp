<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/css/reservation/confirm.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <title>Confirm</title>
    
</head>
<body>
    <div id="app">
        <div id="container">
            <div class="confirm-card">
                <div>다음과 같이 예약 및 결제를 진행하겠습니다.</div>
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
                        <div class="label">예약 결제 금액</div>
                        <div class="value" style="color: #ff4757; font-weight: bold;">
                            {{ info.reservationPrice?.toLocaleString() }} 원
                        </div>
                    </div>
                    
                    <div class="info-item">
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
</body>

<script>
    const app = Vue.createApp({
        data() {
            return {
                info: {},           // reservation에서 넘어온 전체 데이터
                isNoticeOpen: false // 유의사항 접고 펴기 상태
            };
        },
        methods: {
            // confirm.jsp 의 fnSubmit 메서드
            fnSubmit() {
                const self = this;

                // 1. 중복 클릭 방지: 전송 중이면 실행하지 않음
                if (self.isSubmitting) return;

                // 2. 데이터 추출 및 정제 (MyBatis 매핑용)
                // reservation.jsp에서 넘어온 info 객체와 추출한 PK들을 합칩니다.
                const params = {
                    ...self.info,
                    // 배열이나 객체 내부에 숨어있을 수 있는 ID값들을 최상위 레벨로 추출
                    menuNo: self.info.menuNo || (self.info.menus && self.info.menus[0] ? self.info.menus[0].menuNo : null),
                    petNo: self.info.petNo || (self.info.pet ? self.info.pet.petNo : null)
                };

                // 전송 전 최종 데이터 확인 (디버깅용)
                console.log("서버 전송 파라미터:", params);

                // 3. 필수 데이터 유효성 검사
                if (!params.menuNo || !params.petNo || !params.slotNo || !params.storeNo) {
                    alert("예약에 필요한 필수 정보가 누락되었습니다. 다시 시도해 주세요.");
                    console.error("누락 데이터 확인 ->", { 
                        menuNo: params.menuNo, 
                        petNo: params.petNo, 
                        slotNo: params.slotNo,
                        storeNo: params.storeNo
                    });
                    return;
                }

                // 전송 상태 활성화
                self.isSubmitting = true;

                // 4. AJAX 전송
                $.ajax({
                    url: "/reservation/add-reservation.dox",
                    type: "POST",
                    data: params,
                    success: function(data) {
                        // 서버 응답이 문자열일 경우를 대비해 안전하게 파싱
                        const res = typeof data === "string" ? JSON.parse(data) : data;

                        if (res.result === "success") {
                            alert("예약은 결제 완료 후 최종 확정이 됩니다. 결제페이지로 이동합니다.");
                            // 결제 페이지 이동 시 생성된 예약번호(rsvNo)를 활용할 수 있습니다.
                            // location.href = "/payment/process.do?rsvNo=" + res.rsvNo;
                        } else {
                            alert("예약 처리 중 오류가 발생했습니다: " + (res.message || "서버 응답 에러"));
                        }
                    },
                    error: function(xhr, status, error) {
                        console.error("AJAX 통신 에러:", error);
                        alert("서버와 통신 중 문제가 발생했습니다. 관리자에게 문의하세요.");
                    },
                    complete: function() {
                        // 성공/실패 여부와 상관없이 전송 상태 해제
                        self.isSubmitting = false;
                    }
                });
            },
            fnCancel() {
                const self = this;
                
                if (confirm("예약을 취소하고 이전 예약 페이지로 돌아가시겠습니까?")) {
                    // info 객체에 담긴 storeNo를 가져옵니다.
                    const sNo = self.info.storeNo;

                    if (sNo) {
                        // 해당 가게의 상세 페이지로 파라미터를 붙여서 이동
                        location.href = "/reservation/store-reservation.do?storeNo=" + sNo;
                    } else {
                        // 혹시라도 storeNo가 없는 경우를 대비한 예외 처리 (기본 목록으로)
                        location.href = "/reservation/main.do";
                    }
                }
            }
        },
        mounted() {
            // 데이터 로드
            const savedData = localStorage.getItem("reserveTemp");
            
            if (!savedData) {
                alert("예약 정보가 없습니다. 이전 페이지로 돌아갑니다.");
                location.href = "/reservation/main.do";
                return;
            }

            try {
                this.info = JSON.parse(savedData);
                console.log("로드된 정보:", this.info);
            } catch (e) {
                console.error("JSON 파싱 에러:", e);
                alert("데이터를 읽어오는 중 오류가 발생했습니다.");
            }
        }
    }).mount('#app');
</script>
</html>