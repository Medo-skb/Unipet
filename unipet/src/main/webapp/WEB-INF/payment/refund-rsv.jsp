<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <title>UNIPET</title>
    <!-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css"> -->
    <!-- <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment/refund.css"> -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment/refund2.css">
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
                        </div>
                    </div>
                    <div class="item-total-price" style="font-size: 1.4rem; color: #333; font-weight: bold;">
                        결제 금액: {{ info.totalPrice?.toLocaleString() }}원
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
                    <textarea class="input-field" v-model="refundDetail" placeholder="사유를 상세히 적어주세요." style="height: 100px; resize: none;"></textarea>
                </div>
            </div>

            <div class="pay-section" v-if="info.totalPrice">
                <div class="section-title">환불 예정 내용</div>
                <div class="summary-box">
                    <div class="policy-msg" :class="refundPolicy.canRefund ? 'text-blue' : 'text-red'">
                        {{ refundPolicy.message }}
                    </div>

                    <div class="summary-row">
                        <span>환불 예정 금액</span>
                        <span class="text-discount" style="font-weight: bold; font-size: 1.3rem;">
                            {{ refundPolicy.amount?.toLocaleString() }}원
                        </span>
                    </div>
                    <div class="point-info" style="margin-top:10px; font-size: 0.85rem; color:#888;">
                        * 3일 전: 100% / 1~2일 전: 50% / 당일: 환불 불가<br>
                        * 환불은 기존 결제 수단으로 진행됩니다.
                    </div>
                </div>
            </div>

            <div class="btn-group">
                <button class="btn-secondary" @click="fnGoBack">돌아가기</button>
                <button class="btn-primary" 
                        @click="fnSubmitReservationRefund" 
                        :disabled="!refundPolicy.canRefund || isProcessing">
                    {{ isProcessing ? '처리 중...' : (refundPolicy.canRefund ? '예약 취소하기' : '환불 불가') }}
                </button>
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
                rsvNo: "${rsvNo}", 
                userId : "${sessionId}",
                info: {},           // 예약 정보
                refundReason: "",   
                refundDetail: "",   
                isProcessing: false // 광클 방지 상태값
            };
        },
        computed: {
            // 날짜 차이에 따른 환불 정책 계산
            refundPolicy() {
                // 데이터가 없으면 즉시 리턴
                if (!this.info || !this.info.rsvDate || !this.info.totalPrice) {
                    return { amount: 0, rate: 0, message: "예약 정보를 불러오는 중입니다...", canRefund: false };
                }

                const today = new Date();
                today.setHours(0, 0, 0, 0);

                // [날짜 보정 로직]
                let dateSource = this.info.rsvDate;
                let rsvDate;

                if (typeof dateSource === 'string') {
                    // 1. 만약 "5월 15, 2026" 처럼 온다면 표준 포맷으로 변경 시도
                    // (가장 안전한 방법은 '-' 나 '/' 로 구분된 숫자 형식입니다)
                    // 아래는 일반적인 DB 날짜 포맷(2026-05-15...)을 안정적으로 파싱합니다.
                    let cleanDate = dateSource.replace(/년|월/g, '-').replace(/일/g, '').replace(/\s/g, '');
                    rsvDate = new Date(cleanDate);
                } else {
                    // 숫자로 된 타임스탬프인 경우
                    rsvDate = new Date(dateSource);
                }

                // 여전히 날짜가 유효하지 않은 경우 최후의 수단 (날짜 문자열 직접 분해)
                if (isNaN(rsvDate.getTime())) {
                    // "2026-05-15" 같은 형식을 직접 잘라서 세팅
                    const parts = String(dateSource).match(/\d+/g);
                    if (parts && parts.length >= 3) {
                        rsvDate = new Date(parts[0], parts[1] - 1, parts[2]);
                    }
                }

                rsvDate.setHours(0, 0, 0, 0);

                // 다시 한번 체크 후 오류라면 리턴
                if (isNaN(rsvDate.getTime())) {
                    console.error("지원되지 않는 날짜 형식입니다:", dateSource);
                    return { amount: 0, rate: 0, message: "날짜 형식 오류", canRefund: false };
                }

                // 날짜 차이 계산
                const diffTime = rsvDate.getTime() - today.getTime();
                const diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));

                let rate = 0;
                let message = "";
                let canRefund = true;

                if (diffDays >= 3) {
                    rate = 1.0;
                    message = "방문 3일 전이므로 100% 환불 가능합니다.";
                } else if (diffDays >= 1) {
                    rate = 0.5;
                    message = "방문 1~2일 전이므로 50% 환불 가능합니다.";
                } else {
                    rate = 0;
                    message = "방문 당일 및 이후는 정책상 환불이 불가능합니다.";
                    canRefund = false;
                }

                return {
                    amount: this.info.totalPrice * rate,
                    rate: rate * 100,
                    message: message,
                    canRefund: canRefund
                };
            }
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
                    userId: self.userId,
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
                        userId: self.userId   // 상세 정보에서 가져온 아이디를 그대로 전달
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