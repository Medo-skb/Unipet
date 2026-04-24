<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/payment/pay-success.css">
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <div class="pay-container">
            <div class="pay-header">결제내역 확인</div>

            <div class="pay-section">
                <div class="success-icon-wrap">
                    <span class="success-icon">✓</span>
                </div>
                
                <div v-if="payFlg == 'SHOP'">
                    <div class="success-title">주문이 완료되었습니다!</div>
                    <p class="success-subtitle">유니펫을 이용해 주셔서 감사합니다.<br>소중한 상품을 빠르게 준비해서 보내드릴게요.</p>
                </div>
                <div v-else-if="payFlg == 'RSV'">
                    <div class="success-title">예약이 완료되었습니다!</div>
                    <p class="success-subtitle">유니펫 서비스를 선택해 주셔서 감사합니다.<br>방문 일정을 꼭 확인해 주세요.</p>
                </div>
            </div>

            <div class="pay-section" v-if="payFlg == 'SHOP' && list && list.length > 0">
                <div class="section-title">주문 상품 내역</div>
                
                <div v-for="item in list" :key="item.ordDetailNo" class="item-card">
                    <div class="item-content">
                        <img :src="item.filePath + item.fileName" class="item-img">
                        
                        <div class="item-info">
                            <div class="item-name">{{ item.productName }}</div>
                            <div class="item-detail">
                                수량: <b>{{ item.ordQty }}</b>개 | 가격: <b>{{ item.unitPrice }}</b>원
                            </div>
                        </div>
                    </div>
                    
                    <div class="item-total-price">
                        {{ (item.ordQty * item.unitPrice) }}원
                    </div>
                </div>
            </div>

            <div class="pay-section" v-if="payFlg == 'RSV' && info.rsvNo">
                <div class="section-title">예약 상세정보</div>
                
                <div class="item-card">
                    <div class="item-content">
                        <div class="item-img" style="display:flex; align-items:center; justify-content:center; font-size:30px;">🗓️</div>
                        <div class="item-info">
                            <div class="item-name">{{ info.storeName }} - {{ info.menuName }}</div>
                            <div class="item-detail">
                                예약일시: <b>{{ info.rsvDate }}</b> | 시간: <b>{{ info.rsvStartTime }} ~ {{info.rsvEndTime}}</b>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="pay-section" v-if="id">
                <div class="section-title">결제 및 상세 정보</div>
                
                <table class="info-table">
                    <tbody>
                        <tr>
                            <th>결제 종류</th>
                            <td>{{ payFlg == 'SHOP' ? '유니펫 쇼핑몰' : '유니펫 서비스 예약' }}</td>
                        </tr>
                        
                        <template v-if="payFlg == 'SHOP'">
                            <tr>
                                <th>배송지</th>
                                <td>{{ info.ordAddr || '정보 없음' }}</td>
                            </tr>
                        </template>

                        <tr class="price-detail-row">
                            <th>{{ payFlg == 'SHOP' ? '원래 금액' : '메뉴 가격' }}</th>
                            <td class="price-origin">
                                {{ payFlg == 'SHOP' ? (info.totalPrice + info.disPrice) : info.menuPrice }}원
                            </td>
                        </tr>

                        <tr class="price-detail-row">
                            <th>{{ payFlg == 'SHOP' ? '할인 금액' : '선결제 금액' }}</th>
                            <td class="price-discount">
                                - {{ payFlg == 'SHOP' ? (info.disPrice || 0) : (info.menuPrice * 0.1) }}원
                            </td>
                        </tr>
                        
                        <tr class="price-final-row">
                            <th>{{ payFlg == 'SHOP' ? '최종 결제금액' : '최종 결제액(선결제)' }}</th>
                            <td class="highlight">
                                {{ payFlg == 'SHOP' ? info.totalPrice : (info.menuPrice * 0.1) }}원
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <div class="btn-group">
                <a href="/main.do" class="btn-secondary">메인으로 이동</a>
                <button @click="fnGoHistory" class="btn-primary">
                    {{ payFlg == 'SHOP' ? '주문내역 확인' : '예약내역 확인' }}
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
                // 변수 - (key : value)
                ordNo : "${ordNo}" || 4,
                rsvNo: "${rsvNo}",

                payFlg: '', // 'SHOP' 또는 'RSV'
                info: {},    // 서버에서 받아올 상세 정보 객체
                list : [],
                id: ''       // 이전 페이지에서 넘어온 ordNo 또는 rsvNo
            };
        },
        methods: {
            fnGetDetail: function () {
                let self = this;
                let url = self.payFlg == 'SHOP' ? "/payment/getOrder.dox" : "/payment/getRsv.dox";
                
                $.ajax({
                    url: url,
                    dataType: "json",
                    type: "POST",
                    data: { id : self.id }, // 여기서 id는 ordNo 혹은 rsvNo
                    success: function (data) {
                        if(data.result === 'success') {
                            self.info = data.info;
                            self.list = data.list;
                            console.log(data);
                        }
                    }
                });
            },
            fnGoHistory: function() {
                // let url = this.payFlg == 'SHOP' ? "/myPage/orderList.do" : "/myPage/rsvList.do";
                // location.href = url;
            }
            }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
        
            // 1. 들어온 값이 주문번호인지 예약번호인지 판별
            if (self.ordNo !== "") {
                self.payFlg = 'SHOP';
                self.id = self.ordNo;
            } else if (self.rsvNo !== "") {
                self.payFlg = 'RSV';
                self.id = self.rsvNo;
            }
            console.log(self.id);
            // 2. id가 확보되면 상세 정보 조회
            if (self.id !== "") {
                self.fnGetDetail();
            } else {
                alert("정상적인 접근이 아닙니다.");
                location.href = "/main.do";
            }
        }
    });

    app.mount('#app');
</script>