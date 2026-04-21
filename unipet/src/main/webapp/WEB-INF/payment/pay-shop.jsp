<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNIPET | 주문 및 결제</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css">
    
    <style>
        /* UNIPET 전용 결제 페이지 스타일 */
        body { background-color: #f8f9fa; margin: 0; padding: 0; font-family: 'Pretendard', sans-serif; }
        .pay-container { max-width: 800px; margin: 50px auto; padding: 0 20px; }
        .pay-header { font-size: 26px; font-weight: bold; text-align: center; margin-bottom: 40px; color: #333; }

        /* 섹션 공통 */
        .pay-section { background: #fff; border-radius: 20px; padding: 30px; margin-bottom: 25px; box-shadow: 0 10px 30px rgba(0,0,0,0.05); }
        .section-title { font-size: 19px; font-weight: 700; margin-bottom: 20px; display: flex; align-items: center; color: #444; }
        .section-title::before { content: ""; width: 5px; height: 20px; background-color: #3BB1E5; margin-right: 12px; border-radius: 10px; }

        /* 상품 카드 리스트 */
        .item-card { display: flex; justify-content: space-between; align-items: center; padding: 15px 0; border-bottom: 1px solid #f1f1f1; }
        .item-card:last-child { border-bottom: none; }
        .item-name { font-weight: 600; font-size: 16px; color: #333; }
        .item-detail { color: #888; font-size: 14px; margin-top: 4px; }
        .item-total { font-weight: 700; font-size: 17px; color: #333; }

        /* 입력 폼 (UNIPET 라운드 스타일) */
        .input-group { margin-bottom: 20px; }
        .input-group label { display: block; font-size: 14px; font-weight: 600; margin-bottom: 8px; color: #666; }
        .input-field { 
            width: 100%; padding: 14px 20px; border: 1px solid #e1e1e1; border-radius: 30px; 
            box-sizing: border-box; font-size: 15px; transition: all 0.3s;
        }
        .input-field:focus { border-color: #3BB1E5; outline: none; box-shadow: 0 0 8px rgba(59, 177, 229, 0.2); }

        /* 금액 요약 박스 */
        .summary-box { background: #f9fbfd; padding: 25px; border-radius: 15px; }
        .summary-row { display: flex; justify-content: space-between; margin-bottom: 12px; color: #666; font-size: 15px; }
        .total-row { margin-top: 15px; padding-top: 15px; border-top: 2px dashed #e1e1e1; font-size: 22px; font-weight: 800; color: #3BB1E5; }

        /* 결제 버튼 */
        .btn-submit { 
            width: 100%; padding: 20px; background: #3BB1E5; color: white; border: none; 
            border-radius: 40px; font-size: 19px; font-weight: 700; cursor: pointer; 
            margin-top: 30px; transition: transform 0.2s, background 0.3s;
            box-shadow: 0 8px 20px rgba(59, 177, 229, 0.3);
        }
        .btn-submit:hover { background: #2a9cd1; transform: translateY(-2px); }
        .btn-submit:active { transform: translateY(0); }
    </style>
</head>
<body>

    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">q
        <div  class="pay-container">
            <div class="pay-header">주문 및 결제</div>

            <div class="pay-section">
                <div class="section-title">주문 상품 정보</div>
                <div v-for="(item, index) in orderList" :key="index" class="item-card">
                    <div class="item-info">
                        <div class="item-name">{{ item.itemName }}</div>
                        <div class="item-detail">{{ item.price.toLocaleString() }}원 / {{ item.qty }}개</div>
                    </div>
                    <div class="item-total">
                        {{ (item.price * item.qty).toLocaleString() }}원
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
                    <input type="text" class="input-field" v-model="info.userAddr" placeholder="도로명 주소를 입력해주세요">
                    <input type="text" class="input-field" v-model="info.fullAddr" placeholder="상세주소를 입력해주세요">
                </div>
                <div class="input-group">
                    <label>배송 요청사항 (선택)</label>
                    <input type="text" class="input-field" v-model="info.memo" placeholder="예: 문 앞에 놓아주세요">
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
                        <span>0원</span>
                    </div>
                    <div class="total-row">
                        <span>최종 결제금액</span>
                        <span>{{ totalPrice.toLocaleString() }}원</span>
                    </div>
                </div>
                <button class="btn-submit" @click="fnPay">결제하기</button>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/footer/footer.jsp" />

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    // 1. 주문 상품 데이터 (나중에 서버에서 받아오게 수정 가능)
                    orderList: [],
                    // 2. 입력 폼 데이터 바인딩
                    info: {
                        name: "",
                        phone: "",
                        address: "",
                        memo: ""
                    }
                };
            },
            computed: {
                // 3. 합계 금액 자동 계산기
                totalPrice() {
                    return this.orderList.reduce((acc, item) => acc + (item.price * item.qty), 0);
                }
            },
            methods: {
                // 4. 결제 로직 호출
                fnPay: function () {

                },
                fnGetOrderList: function () {
                    let self = this;
                    $.ajax({
                        url: "/payment/orderList.dox",
                        type: "POST",
                        dataType: "json",
                        // 보낼 데이터는 딱히 없음 (서버가 세션에서 꺼내 쓸 거니까)
                        success: function (data) {
                            if (data.result === "success") {
                                self.orderList = data.list; // 서버가 준 리스트를 Vue 변수에 꽂기
                                console.log(data);
                            } else {
                                alert(data.message);
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
                }
            },
            mounted() {
                let self = this;
                self.fnInfo();
                self.fnGetOrderList();
            }
        });

        app.mount('#app');
    </script>
</body>
</html>