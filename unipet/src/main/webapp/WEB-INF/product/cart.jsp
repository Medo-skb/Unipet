<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<title>장바구니</title>

		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

		<style>
			* {
				box-sizing: border-box;
			}

			body {
				margin: 0;
				font-family: 'Malgun Gothic';
				background: #f5f6f8;
				color: #222;
			}

			.wrap {
				width: 1200px;
				margin: 40px auto;
			}

			.page-title {
				font-size: 32px;
				font-weight: bold;
				margin-bottom: 10px;
			}

			.page-sub {
				color: #888;
				margin-bottom: 25px;
			}

			.cart-layout {
				display: flex;
				gap: 25px;
				align-items: flex-start;
			}

			.cart-left {
				flex: 1;
			}

			.cart-right {
				width: 340px;
				position: sticky;
				top: 20px;
			}

			.cart-box {
				background: #fff;
				border-radius: 16px;
				padding: 20px;
				box-shadow: 0 4px 14px rgba(0, 0, 0, 0.05);
			}

			.cart-top {
				display: flex;
				justify-content: space-between;
				align-items: center;
				padding-bottom: 15px;
				border-bottom: 1px solid #eee;
				margin-bottom: 10px;
			}

			.cart-top-left {
				display: flex;
				align-items: center;
				gap: 10px;
				font-size: 15px;
			}

			.cart-top-right button {
				border: 1px solid #ddd;
				background: #fff;
				padding: 8px 14px;
				border-radius: 8px;
				cursor: pointer;
				font-size: 14px;
			}

			.cart-top-right button:hover {
				background: #f8f8f8;
			}

			.item {
				display: flex;
				align-items: center;
				gap: 15px;
				padding: 20px 0;
				border-bottom: 1px solid #f0f0f0;
			}

			.item:last-child {
				border-bottom: none;
			}

			.check-area {
				width: 30px;
				text-align: center;
			}

			.image-area {
				width: 100px;
				height: 100px;
				border-radius: 12px;
				overflow: hidden;
				background: #f3f3f3;
				border: 1px solid #eee;
				flex-shrink: 0;
			}

			.image-area img {
				width: 100%;
				height: 100%;
				object-fit: cover;
				display: block;
			}

			.info-area {
				flex: 1;
			}

			.product-name {
				font-size: 17px;
				font-weight: bold;
				margin-bottom: 8px;
			}

			.product-desc {
				font-size: 13px;
				color: #888;
				margin-bottom: 10px;
			}

			.product-price {
				font-size: 15px;
				font-weight: bold;
				color: #333;
			}

			.action-area {
				width: 220px;
				text-align: right;
			}

			.qty-box {
				display: inline-flex;
				align-items: center;
				border: 1px solid #ddd;
				border-radius: 10px;
				overflow: hidden;
				margin-bottom: 12px;
				background: #fff;
			}

			.qty-box button {
				width: 36px;
				height: 36px;
				border: none;
				background: #fff;
				cursor: pointer;
				font-size: 18px;
			}

			.qty-box button:hover {
				background: #f7f7f7;
			}

			.qty-value {
				width: 42px;
				text-align: center;
				font-size: 15px;
				font-weight: bold;
			}

			.item-total {
				font-size: 18px;
				font-weight: bold;
				margin-bottom: 10px;
			}

			.delete-btn {
				border: none;
				background: #f1f1f1;
				color: #555;
				padding: 8px 14px;
				border-radius: 8px;
				cursor: pointer;
				font-size: 13px;
			}

			.delete-btn:hover {
				background: #e7e7e7;
			}

			.summary-box {
				background: #fff;
				border-radius: 16px;
				padding: 22px;
				box-shadow: 0 4px 14px rgba(0, 0, 0, 0.05);
			}

			.summary-title {
				font-size: 20px;
				font-weight: bold;
				margin-bottom: 20px;
			}

			.summary-row {
				display: flex;
				justify-content: space-between;
				align-items: center;
				margin-bottom: 14px;
				font-size: 15px;
			}

			.summary-row.total {
				margin-top: 18px;
				padding-top: 18px;
				border-top: 1px solid #eee;
				font-size: 20px;
				font-weight: bold;
			}

			.order-btn {
				width: 100%;
				height: 52px;
				background: #ff7a00;
				color: #fff;
				border: none;
				border-radius: 12px;
				font-size: 17px;
				font-weight: bold;
				cursor: pointer;
				margin-top: 20px;
			}

			.order-btn:hover {
				background: #eb6f00;
			}

			.order-btn:disabled {
				background: #ccc;
				cursor: not-allowed;
			}

			.notice-box {
				margin-top: 14px;
				padding: 14px;
				background: #fff7f0;
				border-radius: 12px;
				font-size: 13px;
				color: #9a5a1a;
				line-height: 1.6;
			}

			.empty-box {
				background: #fff;
				border-radius: 16px;
				padding: 80px 20px;
				text-align: center;
				box-shadow: 0 4px 14px rgba(0, 0, 0, 0.05);
			}

			.empty-box .empty-title {
				font-size: 24px;
				font-weight: bold;
				margin-bottom: 10px;
			}

			.empty-box .empty-text {
				color: #888;
				margin-bottom: 25px;
			}

			.empty-box button {
				background: #ff7a00;
				color: #fff;
				border: none;
				padding: 12px 24px;
				border-radius: 10px;
				cursor: pointer;
				font-size: 15px;
				font-weight: bold;
			}

			input[type="checkbox"] {
				width: 18px;
				height: 18px;
				cursor: pointer;
			}
			
			.header {
				width: 100%;
				height: 70px;
				background: #ffffff;
				border-bottom: 1px solid #eee;
				display: flex;
				align-items: center;
				padding: 0 40px;
				position: sticky;
				top: 0;
				z-index: 999;
				box-shadow: 0 2px 8px rgba(0, 0, 0, 0.05);
			}

			.logo {
				font-size: 24px;
				font-weight: bold;
				color: #ff7a00;
				cursor: pointer;
				display: flex;
				align-items: baseline;
				gap: 6px;
			}

			.logo-sub {
				font-size: 12px;
				color: #999;
				font-weight: normal;
			}
		</style>
	</head>

	<body>

		<div id="app">
			<div class="header">
				<div class="logo" @click="fnMoveProduct()">
					UniPet <span class="logo-sub">shop</span>
				</div>
			</div>
			<div class="wrap">
				<div class="page-title">장바구니</div>
				<div class="page-sub">담아둔 상품을 확인하고 주문할 수 있어요.</div>

				<!-- 장바구니 비어있을 때 -->
				<div v-if="cartList.length == 0" class="empty-box">
					<div class="empty-title">장바구니가 비어 있습니다</div>
					<div class="empty-text">원하는 상품을 담아보세요.</div>
					<button @click="fnMoveProduct()">쇼핑하러 가기</button>
				</div>

				<!-- 장바구니 있을 때 -->
				<div v-if="cartList.length > 0" class="cart-layout">
					<div class="cart-left">
						<div class="cart-box">
							<div class="cart-top">
								<div class="cart-top-left">
									<input type="checkbox" v-model="allChecked" @change="fnToggleAll">
									<div>
										전체선택
										(<span>{{selectedCount}}</span> / <span>{{cartList.length}}</span>)
									</div>
								</div>

								<div class="cart-top-right">
									<button @click="fnDeleteSelected">선택삭제</button>
								</div>
							</div>

							<div v-for="item in cartList" class="item">
								<div class="check-area">
									<input type="checkbox" v-model="item.checked" @change="fnCheckItem">
								</div>

								<div class="image-area">
									<img :src="item.MAIN_IMG">
								</div>

								<div class="info-area">
									<div class="product-name">{{item.PRODUCT_NAME}}</div>
									<div class="product-desc">상품번호 : {{item.PRODUCT_NO}}</div>
									<div class="product-price">개당 {{formatPrice(item.PRODUCT_PRICE)}}원</div>
								</div>

								<div class="action-area">
									<div class="qty-box">
										<button @click="fnQty(item,-1)">-</button>
										<div class="qty-value">{{item.QTY}}</div>
										<button @click="fnQty(item,1)">+</button>
									</div>

									<div class="item-total">
										{{formatPrice(item.PRODUCT_PRICE * item.QTY)}}원
									</div>

									<button class="delete-btn" @click="fnDelete(item.CART_NO)">삭제</button>
								</div>
							</div>
						</div>
					</div>

					<div class="cart-right">
						<div class="summary-box">
							<div class="summary-title">주문 요약</div>

							<div class="summary-row">
								<div>선택 상품 수</div>
								<div>{{selectedCount}}개</div>
							</div>

							<div class="summary-row">
								<div>상품 금액</div>
								<div>{{formatPrice(selectedProductTotal)}}원</div>
							</div>

							<div class="summary-row">
								<div>배송비</div>
								<div>{{formatPrice(deliveryPrice)}}원</div>
							</div>

							<div class="summary-row total">
								<div>총 결제금액</div>
								<div>{{formatPrice(finalTotal)}}원</div>
							</div>

							<button class="order-btn" @click="fnOrder()" :disabled="selectedCount == 0">
								결제하기
							</button>

							<div class="notice-box">
								- 30,000원 이상 구매 시 배송비 무료<br>
								- 선택한 상품만 주문됩니다
							</div>
						</div>
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
					cartList: [],
					cartCount: 0,

					selectedProductTotal: 0,
					deliveryPrice: 0,
					finalTotal: 0,
					selectedCount: 0,
					allChecked: false
				};
			},

			methods: {

				// 장바구니 조회
				fnGetCartList() {
					let self = this;

					$.ajax({
						url: "/cart/list.dox",
						dataType: "json",
						type: "POST",
						data: {},
						success: function (data) {
							if (data.result == "success") {
								self.cartList = data.list;

								for (let i = 0; i < self.cartList.length; i++) {
									self.cartList[i].checked = true;
								}

								self.allChecked = true;
								self.fnCalcTotal();
							}
						}
					});
				},

				// 전체선택
				fnToggleAll() {
					let self = this;

					for (let i = 0; i < self.cartList.length; i++) {
						self.cartList[i].checked = self.allChecked;
					}

					self.fnCalcTotal();
				},

				// 개별 체크 변경
				fnCheckItem() {
					let self = this;
					let checkedCnt = 0;

					for (let i = 0; i < self.cartList.length; i++) {
						if (self.cartList[i].checked) {
							checkedCnt++;
						}
					}

					if (self.cartList.length > 0 && checkedCnt == self.cartList.length) {
						self.allChecked = true;
					} else {
						self.allChecked = false;
					}

					self.fnCalcTotal();
				},

				// 수량 변경
				fnQty(item, num) {
					let self = this;

					let newQty = item.QTY + num;
					if (newQty < 1) {
						return;
					}

					$.ajax({
						url: "/cart/update.dox",
						dataType: "json",
						type: "POST",
						data: {
							cartNo: item.CART_NO,
							qty: newQty
						},
						success: function (data) {
							if (data.result == "success") {
								item.QTY = newQty;
								self.fnCalcTotal();
								self.fnGetCartCount();
							}
						}
					});
				},

				// 개별 삭제
				fnDelete(cartNo) {
					let self = this;

					$.ajax({
						url: "/cart/remove.dox",
						dataType: "json",
						type: "POST",
						data: {cartNo: cartNo},
						success: function (data) {
							if (data.result == "success") {
								self.fnGetCartList();
								self.fnGetCartCount();
							}
						}
					});
				},

				// 선택 삭제
				fnDeleteSelected() {
					let self = this;
					let selectedList = [];

					for (let i = 0; i < self.cartList.length; i++) {
						if (self.cartList[i].checked) {
							selectedList.push(self.cartList[i].CART_NO);
						}
					}

					if (selectedList.length == 0) {
						alert("삭제할 상품을 선택해주세요.");
						return;
					}

					if (!confirm("선택한 상품을 삭제하시겠습니까?")) {
						return;
					}

					let deleteCnt = 0;

					for (let i = 0; i < selectedList.length; i++) {
						$.ajax({
							url: "/cart/remove.dox",
							dataType: "json",
							type: "POST",
							data: {cartNo: selectedList[i]},
							success: function (data) {
								deleteCnt++;

								if (deleteCnt == selectedList.length) {
									self.fnGetCartList();
									self.fnGetCartCount();
								}
							}
						});
					}
				},

				// 총금액 계산
				fnCalcTotal() {
					let self = this;

					let total = 0;
					let count = 0;

					for (let i = 0; i < self.cartList.length; i++) {
						if (self.cartList[i].checked) {
							total += self.cartList[i].PRODUCT_PRICE * self.cartList[i].QTY;
							count++;
						}
					}

					self.selectedProductTotal = total;
					self.selectedCount = count;

					if (total == 0) {
						self.deliveryPrice = 0;
					} else if (total >= 30000) {
						self.deliveryPrice = 0;
					} else {
						self.deliveryPrice = 3000;
					}

					self.finalTotal = self.selectedProductTotal + self.deliveryPrice;

					if (self.cartList.length > 0 && count == self.cartList.length) {
						self.allChecked = true;
					} else {
						self.allChecked = false;
					}
				},

				// 장바구니 개수
				fnGetCartCount() {
					let self = this;

					$.ajax({
						url: "/cart/count.dox",
						dataType: "json",
						type: "POST",
						data: {},
						success: function (data) {
							if (data.result == "success") {
								self.cartCount = data.cartCount;
							}
						}
					});
				},

				fnMoveProduct() {
					location.href = "/product.do";
				},

				// 결제
				fnOrder() {
					let self = this;
					let cartNoList = [];

					for (let i = 0; i < self.cartList.length; i++) {
						if (self.cartList[i].checked) {
							cartNoList.push(self.cartList[i].CART_NO);
						}
					}

					if (cartNoList.length == 0) {
						alert("주문할 상품을 선택해주세요.");
						return;
					}
					console.log("저장할 cartNoList :", cartNoList);
					
					sessionStorage.setItem("cartNoList", JSON.stringify(cartNoList));

					location.href = "/payment/pay-shop.do";
				},
				
				formatPrice(price) {
					return Number(price).toLocaleString();
				}
			},

			mounted() {
				this.fnGetCartList();
				this.fnGetCartCount();
			}
		});

		app.mount('#app');
	</script>