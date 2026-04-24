<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNIPET | 주문 및 결제</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.iamport.kr/v1/iamport.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment/pay-shop.css">
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

<div id="app">
        <div class="pay-container">
            <div class="pay-header">주문 및 결제</div>

            <div class="pay-section">
                <div class="section-title">주문 상품 정보</div>
                <div v-for="(item, index) in orderList" :key="index" class="item-card">
                    <div class="item-info">
                        <div class="item-name">{{ item.PRODUCT_NAME }}</div>
                        <div class="item-detail">
                            {{ (item.PRODUCT_PRICE || 0).toLocaleString() }}원 / {{ item.QTY }}개
                        </div>
                    </div>
                    <div class="item-total">
                        {{ ((item.PRODUCT_PRICE || 0) * (item.QTY || 0)).toLocaleString() }}원
                    </div>
                </div>
                
                <div v-if="orderList.length === 0" style="text-align: center; color: #999; padding: 20px;">
                    주문하실 상품이 없습니다.
                </div>
            </div>

            <div class="pay-section">
                <div class="section-title">배송 정보</div>
                <div class="input-group">
                    <label>받는 분 성함</label>
                    <input type="text" class="input-field" v-model="info.userName" placeholder="실명을 입력해주세요">
                </div>
                <div class="input-group">
                    <label>휴대폰 번호</label>
                    <input type="text" class="input-field" v-model="info.phone" placeholder="010-0000-0000">
                </div>
                <div class="input-group">
                    <label>배송지 주소</label>
                    <input type="text" class="input-field" v-model="info.userAddr" placeholder="도로명 주소를 입력해주세요" style="margin-bottom: 8px;">
                    <input type="text" class="input-field" v-model="info.fullAddr" placeholder="상세주소를 입력해주세요">
                </div>
                <div class="input-group">
                    <label>배송 요청사항 (선택)</label>
                    <input type="text" class="input-field" v-model="info.memo" placeholder="예: 문 앞에 놓아주세요">
                </div>
            </div>

            <div class="pay-section">
                <div class="section-title">할인 혜택 선택</div>
                
                <div class="discount-option" :class="{ active: discountMode === 'coupon' }">
                    <label class="discount-label">
                        <input type="radio" v-model="discountMode" value="coupon"> 쿠폰 사용
                    </label>
                    <div v-if="discountMode === 'coupon'" class="option-content">
                        <select class="input-field" v-model="selectedCoupon">
                            <option :value="null">사용하실 쿠폰을 선택하세요</option>
                            <option v-for="c in couponList" :key="c.couponNo" :value="c">
                                {{ c.couponName }} ({{ c.deduceprice.toLocaleString() }}원 할인)
                            </option>
                        </select>
                    </div>
                </div>

            <div class="discount-option" :class="{ active: discountMode === 'point' }">
                <label class="discount-label">
                    <input type="radio" v-model="discountMode" value="point"> 포인트 사용
                </label>
                <div v-if="discountMode === 'point'" class="option-content">
                    <div class="point-wrap">
                        <input type="number" class="input-field" v-model.number="usedPoint" placeholder="0" min="0" step="100" @change="fnCheckPoint">
                        <button type="button" class="btn-sub" @click="fnAllPoint">전체사용</button>
                    </div>
                    <div class="point-info">보유 포인트: <b>{{ userPoint.toLocaleString() }}</b> P</div>
                </div>
            </div>

            <div class="pay-section">
                <div class="section-title">최종 결제 금액</div>
                <div class="summary-box">
                    <div class="summary-row">
                        <span>총 상품금액</span>
                        <span>{{ totalPrice.toLocaleString() }}원</span>
                    </div>
                    
                    <div class="summary-row">
                        <span>배송비</span>
                        <span v-if="shippingFee === 0">무료</span>
                        <span v-else>+ {{ shippingFee.toLocaleString() }}원</span>
                    </div>
                    <div class="summary-row" v-if="discountPrice > 0">
                        <span>할인 금액</span>
                        <span class="text-discount">- {{ discountPrice.toLocaleString() }}원</span>
                    </div>
                    <div class="total-row">
                        <span>최종 결제금액</span>
                        <span>{{ finalPrice.toLocaleString() }}원</span>
                    </div>
                </div>
                <button class="btn-submit" @click="fnPay">결제하기</button>
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
                userId : "${sessionId}",
                cartIds : JSON.parse(sessionStorage.getItem("cartNoList")) || [2, 15, 17],
                // 1.
                orderList: [],
                // 2. 입력 폼 데이터 바인딩
                info: {
                    name: "",
                    phone: "",
                    address: "",
                    memo: ""
                },
                discountMode: 'none', // 'none', 'coupon', 'point'
                couponList: [],
                selectedCoupon: null,
                userPoint: 0, 
                usedPoint: 0,
                isPremium: false,
            };
        },
        watch: {
            // 모드가 변경될 때 데이터가 꼬이지 않도록 초기화해주는 감시자 로직
            discountMode(newMode) {
                if (newMode === 'coupon') {
                    this.usedPoint = 0; // 포인트 초기화
                } else if (newMode === 'point') {
                    this.selectedCoupon = null; // 쿠폰 초기화
                } else {
                    this.usedPoint = 0;
                    this.selectedCoupon = null;
                }
            },
            
        },
        computed: {
            totalPrice() {
                return this.orderList.reduce((acc, item) => {
                    const price = item.PRODUCT_PRICE || 0;
                    const qty = item.QTY || 0;
                    return acc + (price * qty);
                }, 0);
            },
            // [추가] 계산된 할인 금액
            discountPrice() {
                if (this.discountMode === 'coupon' && this.selectedCoupon != null) {
                    return this.selectedCoupon.deduceprice;
                } else if (this.discountMode === 'point') {
                    return this.usedPoint || 0;
                }
                return 0;
            },
            // [추가] 진짜 결제할 최종 금액
            finalPrice() {
                // 👇 총 상품금액 - 할인금액 + 배송비(추가!)
                const result = this.totalPrice - this.discountPrice + this.shippingFee;
                
                // 결제 금액이 마이너스가 되지 않도록 방어 로직 (Math.max 사용)
                return Math.max(0, result);
            },
            shippingFee() {
                if (this.orderList.length === 0) return 0;
                if (this.isPremium) return 0; // 프리미엄 회원은 0원!
                return this.totalPrice >= 50000 ? 0 : 2000;
            },
        },
        methods: {
            fnAllPoint() {
                // 보유 포인트가 1250P라면 -> 1200P만 적용되도록 Math.floor 사용
                this.usedPoint = Math.floor(this.userPoint / 100) * 100;
                
                if (this.userPoint < 100) {
                    alert("포인트는 100P 이상부터 사용 가능합니다.");
                    this.usedPoint = 0;
                }
            },
            
            // 2. [추가] 직접 입력 후 검사 로직
            fnCheckPoint() {
                let Point = this.usedPoint || 0;
                // 1단계: 마이너스 입력 방지
                if (Point < 0) {
                    this.usedPoint = 0;
                    return;
                }
                // 2단계: 보유 포인트 초과 체크
                if (Point > this.userPoint) {
                    alert("보유하신 포인트(" + this.userPoint + "P)를 초과할 수 없습니다.");
                    Point = this.userPoint;
                }
                // 3단계: 100단위로 자르기 (나머지 버림)
                const flooredPoint = Math.floor(Point / 100) * 100;
                // 최종적으로 정제된 100단위 값을 다시 바인딩
                this.usedPoint = flooredPoint;
            },

            fnGetOrderList: function () {
                let self = this;

                const param = {
                    userId : self.userId,
                    list : self.cartIds
                }

                $.ajax({
                    url: "/payment/orderList.dox",
                    type: "POST",
                    dataType: "json",
                    contentType: "application/json; charset=utf-8",
                    data : JSON.stringify(param),
                    success: function (data) {
                        if (data.result === "success") {
                            console.log(param);
                            self.orderList = data.list; // 서버가 준 리스트를 Vue 변수에 꽂기
                            console.log(self.orderList);
                            if (!self.orderList || self.orderList.length == 0) {
                                alert("결제할 상품 정보가 없습니다. 메인 페이지로 이동합니다.");
                                // location.href = "/main.do";
                            } 
                        } else {
                            alert(data.message || "주문 정보를 불러올 수 없습니다.");
                            // location.href = "/main.do";
                        }
                    }
                });
            },
            fnInfo: function () {
                let self = this;
                $.ajax({
                    url: "/payment/info.dox",
                    type: "POST",
                    dataType: "json",
                    success: function (data) {
                        self.info = data.info;
                        console.log(data);
                    }
                });
            },
            fnGetBenefits: function() {
                let self = this;
                
                $.ajax({
                    url: "/payment/getBenefit.dox",
                    type: "POST",
                    dataType: "json",
                    success: function (data) {
                        if (data.result === "success") {
                            // 자바에서 넘겨준 키값("coupons", "Point")을 Vue 변수에 쏙 넣기
                            self.couponList = data.couponList;
                            self.userPoint = data.point;
                            self.isPremium = data.isPremium;
                        } else {
                            // 자바 catch 구문에서 보낸 에러 메시지(Message.MSG_SERVER_ERR) 출력
                            alert(data.message);
                        }
                    }
                });
            },
            fnGetOrderName: function() {
                let self = this;
                if (self.orderList.length === 0) return "UNIPET 주문";
                let name = self.orderList[0].PRODUCT_NAME;
                if (self.orderList.length > 1) {
                    name += " 외 " + (self.orderList.length - 1) + "건";
                }
                return name;
            },
            fnPay: function () {
                let self = this;

                // 1-1. 필수 입력값 검사
                if (!self.info.userName || !self.info.phone || !self.info.userAddr || !self.info.fullAddr) {
                    alert("배송지 정보를 모두 정확히 입력해주세요.");
                    return;
                }

                // 1-2. 주문명(name) 만들기 로직 (예: "상품A 외 2건")
                let orderName = self.orderList.length > 0 ? self.orderList[0].PRODUCT_NAME : "UNIPET 상품";
                if (self.orderList.length > 1) {
                    orderName += " 외 " + (self.orderList.length - 1) + "건";
                }

                // ★ 1-3. 전액 포인트/쿠폰 결제로 최종 금액이 0원일 경우 PG사 결제 생략!
                if (self.finalPrice === 0) {
                    if (confirm("전액 할인 적용되어 0원 결제됩니다. 주문을 완료하시겠습니까?")) {
                        // 결제창 안 띄우고 바로 DB 저장 로직으로 직행
                        self.fnSubmitOrder(null); 
                    }
                    return;
                }

                // 1-4. 포트원 결제창 호출
                const { IMP } = window;
                IMP.init("imp15084381"); // 사용자님의 가맹점 식별코드 유지

                IMP.request_pay({
                    pg: "html5_inicis.INIpayTest",
                    pay_method: "card",
                    merchant_uid: "unipet_shop_" + Date.now(), // rsv_ 에서 ord_ 로 변경
                    name: self.fnGetOrderName(),                          // "상품명 외 N건"
                    amount: self.finalPrice,                  // 최종 결제 금액!
                    buyer_name: self.info.userName,
                    buyer_tel: self.info.phone,
                    buyer_email: self.info.email
                }, function (rsp) {
                    // 예약 때는 실패해도 DB에 넣었지만, 쇼핑몰은 실패하면 주문을 생성하지 않는 것이 일반적입니다.
                    if (rsp.success) {
                        // 결제 성공 시 DB 저장 함수 호출
                        self.fnAddPayment(rsp);
                    } else {
                        alert("결제를 취소하셨거나 실패하였습니다: " + rsp.error_msg);
                    }
                });
            },   
            fnAddPayment : function(rsp){
                let self = this;
                
                const payStatus = 'PAY'; // 성공 시에만 호출되므로 'PAY'로 고정
                const orderName = self.fnGetOrderName(); // 공통 함수를 호출하여 주문명 생성

                const param = {
                    // 1. 사용자 및 상태 정보
                    userId: self.info.userId,       // 누가 샀나
                    payStatus: payStatus,              // 'PAY' (성공 여부)
                    payFlg: "SHOP",                 // 상점 결제 구분값

                    // 2. 배송 정보 (orders 테이블용)
                    userName: self.info.userName,   // 수령인 이름
                    phone: self.info.phone,         // 수령인 연락처
                    userAddr: self.info.userAddr,   // 도로명 주소
                    fullAddr: self.info.fullAddr,   // 상세 주소
                    memo: self.info.memo,           // 배송 메모

                    // 3. 할인 및 결제 금액 정보
                    usedPoint: self.usedPoint,      // 사용 포인트 (user_point 차감용)
                    ucpNo: self.selectedCoupon ? self.selectedCoupon.ucpNo : null,       // 사용 쿠폰 번호 (상태 변경용)
                    
                    discountPrice: self.discountPrice, // 총 할인 금액 (orders.DIS_PRICE용)
                    totalprice: self.finalPrice,     // 실제 결제 금액 (orders.TOTAL_PRICE & payment_master.TOTALPRICE용)

                    // 4. PG사 결제 결과 (payment_master 테이블용)
                    tid: rsp.imp_uid,               // 포트원 고유 번호
                    payMethod: rsp.pay_method,       // 결제 수단 (card, trans 등)
                    ordName: orderName,              // 주문명 (ex: 사료 외 2건)

                    // 5. 주문 상품 상세 리스트 (order_detail 반복문용)
                    orderList: self.orderList 
                };
                $.ajax({
                    url: "/payment/add.dox",
                    type: "POST",
                    contentType: "application/json; charset=utf-8", 
                    data: JSON.stringify(param), 
                    success: function(data) {
                        if (data.result === "success") {
                            alert(data.message);
                            console.log(data);
                            pageChange("/payment/pay-success.do", {ordNo : data.ordNo});
                        }
                    }
                });
            }
        },
        mounted() {
            let self = this;
            self.fnInfo();
            self.fnGetOrderList();
            self.fnGetBenefits();
            console.log(self.cartIds);
        }
    });
    app.mount('#app');
</script>
