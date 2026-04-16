<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>UniPet - 상품 상세</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <style>
        .detail-container { max-width: 1000px; margin: 50px auto; display: flex; gap: 50px; }
        .detail-img { width: 500px; height: 500px; background: #f9f9f9; border-radius: 20px; }
        .detail-info { flex: 1; }
        .price { font-size: 24px; color: #ff5e00; font-weight: bold; margin: 20px 0; }
        .option-box { margin-bottom: 20px; padding: 15px; background: #f8f9fa; border-radius: 10px; }
        .btn-group { display: flex; gap: 10px; margin-top: 30px; }
        .btn-group button { flex: 1; padding: 15px; border-radius: 10px; border: none; font-weight: bold; cursor: pointer; }
        .btn-cart { background: #8FAADC; color: #fff; }
        .btn-buy { background: #78C3A8; color: #fff; }
    </style>
</head>
<body>
    <div id="app">
        <div class="detail-container">
            <div class="detail-img">
                <img :src="'/upload/' + info.fileName" style="width:100%; border-radius:20px;">
            </div>

            <div class="detail-info">
                <p style="color:#4F7057; font-weight:bold;">{{info.brand}}</p>
                <h2>{{info.productName}}</h2>
                <div class="price">{{info.productPrice.toLocaleString()}}원</div>

                <div class="option-box">
                    <label>옵션 선택</label>
                    <select v-model="selectedOption" style="width:100%; padding:10px; margin-top:10px;">
                        <option value="">-- 옵션을 선택하세요 --</option>
                        <option v-for="opt in options" :value="opt">{{opt.optionName}} (+{{opt.optionPrice}}원)</option>
                    </select>
                </div>

                <div class="btn-group">
                    <button class="btn-cart" @click="fnAddCart">장바구니</button>
                    <button class="btn-buy" @click="fnBuy">바로 구매</button>
                </div>
            </div>
        </div>

        <div style="max-width:1000px; margin: 50px auto;">
            <h3>사용자 구매 후기 ⭐️</h3>
            <hr>
            <div v-for="rev in reviews" style="padding:15px; border-bottom:1px solid #eee;">
                <strong>{{rev.userId}}</strong> (별점: {{rev.star}}점)
                <p>{{rev.content}}</p>
            </div>
        </div>
    </div>

    <script>
        const app = Vue.createApp({
            data() {
                return {
                    productNo: new URLSearchParams(location.search).get("productNo"),
                    info: {},
                    options: [],
                    reviews: [],
                    selectedOption: ''
                };
            },
            methods: {
                fnGetDetail() {
                    let self = this;
                    $.ajax({
                        url: "/product/detail.dox",
                        type: "POST",
                        contentType: "application/json",
                        data: JSON.stringify({ productNo: self.productNo }),
                        success: function(data) {
                            self.info = data.info;
                            self.options = data.options;
                            self.reviews = data.reviews;
                        }
                    });
                },
                fnAddCart() {
                    if(!this.selectedOption) return alert("옵션을 선택해주세요.");
                    // 장바구니 담기 AJAX 로직...
                    alert("장바구니에 담겼습니다!");
                    location.href = "/cart.do"; // 설계서 cart 페이지 연동
                }
            },
            mounted() { this.fnGetDetail(); }
        }).mount('#app');
    </script>
</body>
</html>