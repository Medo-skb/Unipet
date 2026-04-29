<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ko">

<head>
	<meta charset="UTF-8">
	<title>UNIPET</title>

	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<script src="/js/page-change.js"></script>

	<!-- <link rel="stylesheet" href="/css/product/cart.css"> -->
	<link rel="stylesheet" href="/css/product/cart2.css">
</head>

<body>
	<jsp:include page="/WEB-INF/header/header.jsp" />

	<div id="app">

		<div class="wrap">
			<div class="page-title">장바구니</div>
			<div class="page-sub">담아둔 상품을 확인하고 주문할 수 있어요.</div>

			<div class="cart-nav">
				<button @click="fnMoveProduct()">← 쇼핑 계속하기</button>
			</div>

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
								<button @click="fnDeleteSelected()">선택삭제</button>
							</div>
						</div>

						<div v-for="item in cartList" :key="item.cartNo" class="item">
							<div class="check-area">
								<input type="checkbox" v-model="item.checked" @change="fnCheckItem()">
							</div>

							<div class="image-area" @click="fnMoveDetail(item.productNo)">
								<img v-if="item.img != null && item.img != ''" :src="item.img">
								<img v-else src="/img/board/unipet_logo.png">
							</div>

							<div class="info-area">
								<div class="product-name">{{item.productName}}</div>
								<div class="product-price">개당 {{formatPrice(item.productPrice)}}원</div>
							</div>

							<div class="action-area">
								<div class="qty-box">
									<button @click="fnQty(item, -1)">-</button>

									<input type="number" class="qty-input" v-model="item.qty"
										@change="fnChangeQty(item)" min="1">

									<button @click="fnQty(item, 1)">+</button>
								</div>

								<div class="item-total">
									{{formatPrice(item.productPrice * item.qty)}}원
								</div>

								<button class="delete-btn" @click="fnDelete(item.cartNo)">삭제</button>
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
				fnGetCartList: function () {
					let self = this;
					let param = {};

					$.ajax({
						url: "/cart/list.dox",
						dataType: "json",
						type: "POST",
						data: param,
						success: function (data) {
							if (data.result == "success") {
								self.cartList = data.list || [];
								console.log("장바구니 목록", self.cartList);

								for (let i = 0; i < self.cartList.length; i++) {
									self.cartList[i].checked = true;
								}

								self.allChecked = true;
								self.fnCalcTotal();

							} else if (data.result == "login") {
								alert("로그인이 필요합니다.");
								location.href = "/user/login.do";

							} else {
								alert(data.message);
							}
						}
					});
				},

				// 전체선택
				fnToggleAll: function () {
					let self = this;

					for (let i = 0; i < self.cartList.length; i++) {
						self.cartList[i].checked = self.allChecked;
					}

					self.fnCalcTotal();
				},

				// 개별 체크 변경
				fnCheckItem: function () {
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

				// 수량 버튼 변경
				fnQty: function (item, num) {
					let self = this;

					let newQty = Number(item.qty) + num;

					if (newQty < 1) {
						return;
					}

					if (newQty > item.stockQty) {
						alert("재고수량을 초과할 수 없습니다.");
						return;
					}

					let param = {
						cartNo: item.cartNo,
						qty: newQty
					};

					$.ajax({
						url: "/cart/update.dox",
						dataType: "json",
						type: "POST",
						data: param,
						success: function (data) {
							if (data.result == "success") {
								item.qty = newQty;
								item.cartQty = newQty;
								self.fnCalcTotal();
								self.fnGetCartCount();

							} else if (data.result == "login") {
								alert("로그인이 필요합니다.");
								location.href = "/user/login.do";

							} else {
								alert(data.message);
							}
						}
					});
				},

				// 수량 직접 입력 변경
				fnChangeQty: function (item) {
					let self = this;
					let newQty = Number(item.qty);

					if (newQty < 1 || isNaN(newQty)) {
						alert("수량은 1개 이상 입력해주세요.");
						item.qty = 1;
						newQty = 1;
					}

					if (newQty > item.stockQty) {
						alert("재고수량을 초과할 수 없습니다.");
						item.qty = item.stockQty;
						newQty = item.stockQty;
					}

					let param = {
						cartNo: item.cartNo,
						qty: newQty
					};

					$.ajax({
						url: "/cart/update.dox",
						dataType: "json",
						type: "POST",
						data: param,
						success: function (data) {
							if (data.result == "success") {
								item.qty = newQty;
								item.cartQty = newQty;
								self.fnCalcTotal();
								self.fnGetCartCount();

							} else if (data.result == "login") {
								alert("로그인이 필요합니다.");
								location.href = "/user/login.do";

							} else {
								alert(data.message);
							}
						}
					});
				},

				// 개별 삭제
				fnDelete: function (cartNo) {
					let self = this;

					let param = {
						cartNo: cartNo
					};

					$.ajax({
						url: "/cart/remove.dox",
						dataType: "json",
						type: "POST",
						data: param,
						success: function (data) {
							if (data.result == "success") {
								self.fnGetCartList();
								self.fnGetCartCount();

							} else if (data.result == "login") {
								alert("로그인이 필요합니다.");
								location.href = "/user/login.do";

							} else {
								alert(data.message);
							}
						}
					});
				},

				// 선택 삭제
				fnDeleteSelected: function () {
					let self = this;
					let selectedList = [];

					for (let i = 0; i < self.cartList.length; i++) {
						if (self.cartList[i].checked) {
							selectedList.push(self.cartList[i].cartNo);
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
						let param = {
							cartNo: selectedList[i]
						};

						$.ajax({
							url: "/cart/remove.dox",
							dataType: "json",
							type: "POST",
							data: param,
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
				fnCalcTotal: function () {
					let self = this;

					let total = 0;
					let count = 0;

					for (let i = 0; i < self.cartList.length; i++) {
						if (self.cartList[i].checked) {
							total += self.cartList[i].productPrice * self.cartList[i].qty;
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
				fnGetCartCount: function () {
					let self = this;
					let param = {};

					$.ajax({
						url: "/cart/count.dox",
						dataType: "json",
						type: "POST",
						data: param,
						success: function (data) {
							if (data.result == "success") {
								self.cartCount = data.cartCount;
							}
						}
					});
				},

				fnMoveProduct: function () {
					pageChange("/product.do", {});
				},

				// 결제
				fnOrder: function () {
					let self = this;
					let cartNoList = [];

					for (let i = 0; i < self.cartList.length; i++) {
						if (self.cartList[i].checked) {
							cartNoList.push(self.cartList[i].cartNo);
						}
					}

					for (let i = 0; i < self.cartList.length; i++) {
						if (self.cartList[i].checked && self.cartList[i].qty > self.cartList[i].stockQty) {
							alert(self.cartList[i].productName + " 상품의 재고가 부족합니다.");
							return;
						}
					}

					if (cartNoList.length == 0) {
						alert("주문할 상품을 선택해주세요.");
						return;
					}

					console.log("저장할 cartNoList :", cartNoList);

					sessionStorage.setItem("cartNoList", JSON.stringify(cartNoList));

					pageChange("/payment/pay-shop.do", {});
				},

				formatPrice: function (price) {
					return Number(price).toLocaleString();
				},

				fnMoveDetail: function (productNo) {
					pageChange("/product/view.do", {
						productNo: productNo
					});
				}
			}, // methods

			mounted() {
				// 처음 시작할 때 실행되는 부분
				let self = this;
				self.fnGetCartList();
				self.fnGetCartCount();
			}
		});

		app.mount('#app');
	</script>

	<jsp:include page="/WEB-INF/footer/footer.jsp" />
</body>

</html>