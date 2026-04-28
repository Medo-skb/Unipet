<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>환불 요청</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment/refund.css">
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <div class="pay-container">
            <div class="pay-header">예약 취소 및 환불</div>

            <div class="pay-section" v-if="info.rsvNo">
                <div class="section-title">환불 대상 예약</div>
                <div class="item-card">
                    <div class="item-content">
                        <div class="item-info">
                            <div class="item-name" style="font-size: 1.3rem; color: #111; margin-bottom: 8px;">
                                <b>[{{ info.storeName }}]</b> {{ info.menuName }}
                            </div>
                            
                            <div class="item-detail" style="line-height: 1.6; color: #666;">
                                예약 일시: <span style="color: #333;"><b>{{ info.rsvDate }}</b> | {{ info.startTime }} ~ {{ info.endTime }}</span><br>
                                방문 주소: <span style="color: #333;">{{ info.storeAddr }}</span>
                            </div>

                            <div v-if="info.request" class="item-request" style="margin-top: 10px; font-size: 0.9rem; color: #888;">
                                내 요청사항: "{{ info.request }}"
                            </div>
                        </div>
                    </div>
                    
                    <div class="item-total-price" style="font-size: 1.4rem; color: #FF4D4F; font-weight: bold;">
                        {{ info.totalPrice?.toLocaleString() }}원
                    </div>
                </div>
            </div>

            <div class="pay-section">
                <div class="section-title">취소 사유 선택</div>
                <div class="input-group">
                    <label>취소하시는 이유가 무엇인가요?</label>
                    <select class="input-field" v-model="refundReason">
                        <option value="">사유를 선택해주세요</option>
                        <option value="일정 변경">일정이 변경되었습니다</option>
                        <option value="단순 변심">잘못 예약했습니다</option>
                        <option value="서비스 불만족">예약 과정이 만족스럽지 않습니다</option>
                        <option value="기타">기타 (직접 입력)</option>
                    </select>
                </div>

                <div class="input-group" style="margin-top: 20px;" v-if="refundReason === '기타'">
                    <label>상세 내용 <span style="color:#FF4D4F;">(필수)</span></label>
                    <textarea class="input-field" v-model="refundDetail" 
                              placeholder="사유를 상세히 적어주세요." 
                              style="height: 100px; resize: none;"></textarea>
                </div>
            </div>

            <div class="pay-section" v-if="info.totalPrice">
                <div class="section-title">환불 정책 안내</div>
                <div class="summary-box">
                    <div class="summary-row">
                        <span>환불 예정 금액</span>
                        <span class="text-discount" style="font-weight: bold; font-size: 1.3rem;">
                            {{ info.totalPrice?.toLocaleString() }}원
                        </span>
                    </div>
                    <div class="point-info">
                        * 예약 당일 취소는 업체 정책에 따라 제한될 수 있습니다.
                    </div>
                </div>
            </div>

            <div class="btn-group">
                <button class="btn-secondary" @click="fnGoBack">돌아가기</button>
                <button class="btn-primary" @click="fnSubmitReservationRefund">예약 취소하기</button>
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
                rsvNo: "${rsvNo}" || 1, 
                userId : "${sessionId}",
                info: {},           // 예약 정보
                refundReason: "",   
                refundDetail: ""   
            };
        },
        watch: {
            refundReason(newVal) {
                if (newVal !== '기타') {
                    this.refundDetail = "";
                }
            }
        },
        methods: {
            // [데이터 가져오기]
            fnGetInfo: function () {
                let self = this;

                const param = {
                    rsvNo : self.rsvNo,
                }

                $.ajax({
                    url: "/payment/getRsvDetail.dox",
                    type: "POST",
                    dataType: "json",
                    data: param,
                    success: function (data) {
                        if(data.info) {
                            self.info = data.info;
                        } else {
                            alert("예약 정보를 불러올 수 없습니다.");
                            self.fnGoBack();
                        }
                    }
                });
            },
            // [환불 요청] 예약 취소 실행
            fnSubmitReservationRefund: function () {
                let self = this;
                // 1. 유효성 검사
                if(!self.refundReason) {
                    alert("취소 사유를 선택해주세요.");
                    return; 
                }
                if(self.refundReason === '기타' && !self.refundDetail.trim()) {
                    alert("상세 사유를 입력해주세요.");
                    return;
                }
                // 2. 파라미터 세팅 (rsvNo 사용)
                const param = {
                    rsvNo: self.rsvNo,
                    payNo: self.info.payNo,
                    amount: self.info.totalPrice, 
                    reason: self.refundReason === '기타' ? "기타: " + self.refundDetail : self.refundReason
                };
                if(confirm("정말로 예약을 취소하시겠습니까?")) {
                    $.ajax({
                        url: "/payment/rsvRefund.dox",
                        type: "POST",
                        dataType: "json",
                        data: param,
                        success: function (data) {
                            if(data.result === "success") {
                                self.fnCancel();
                            } else {
                                alert("환불 실패: " + data.message);
                            }
                        }
                    });
                }
            },
            fnCancel() {
                const self = this;

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
                            location.href = "/user/mypage.do";
                        } else {
                            alert("취소 처리 중 오류가 발생했습니다.");
                            location.href = "/user/mypage.do";
                        }
                    }
                });
            },
            fnGoBack: function() { window.history.back(); }
        },
        mounted() {
            let self = this;
            self.fnGetInfo();
        }
    });

    app.mount('#app');
</script>