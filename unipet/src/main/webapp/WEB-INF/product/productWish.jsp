<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>UNIPET - 찜한 상품</title>

		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-change.js"></script>
		<link rel="stylesheet" href="/css/product/productWish.css">
	</head>

	<body>
		<jsp:include page="/WEB-INF/header/header.jsp" />

		<div id="app">
			<div class="wrap">
				<div class="top-box">
					<div>
						<div class="page-title">찜한 상품</div>
						<div class="page-desc">관심 있는 상품을 한곳에서 확인할 수 있어요.</div>
					</div>

					<div class="top-btn-area">
						<button type="button" class="top-btn light" @click="fnMoveProductList()">상품 목록</button>
					</div>
				</div>

				<div v-if="loading" class="empty-box">
					찜한 상품을 불러오는 중입니다.
				</div>

				<div v-if="!loading && wishList.length == 0" class="empty-box">
					<div class="empty-title">아직 찜한 상품이 없습니다.</div>
					<div class="empty-desc">마음에 드는 상품을 찜해두면 여기에서 다시 볼 수 있어요.</div>
					<button type="button" class="empty-btn" @click="fnMoveProductList()">상품 보러가기</button>
				</div>

				<div v-if="!loading && wishList.length > 0">
					<div class="count-box">
						총 <strong>{{wishList.length}}</strong>개의 찜한 상품
					</div>

					<div class="product-list">
						<div class="product-card" v-for="item in pagedWishList" :key="item.productNo"
							@click="fnMoveDetail(item.productNo)">

							<div class="product-image-box">
								<div class="product-sale-badge" v-if="fnHasDiscount(item)">
									{{fnDiscountRate(item)}}%
								</div>

								<img v-if="item.img != null && item.img != ''" :src="item.img" class="product-image">
								<img v-else src="/img/product/no-image.png" class="product-image">
							</div>

							<div class="product-card-body">
								<div class="product-title-line">
									<div class="product-name">{{item.productName}}</div>

									<div class="product-title-rating" v-if="fnGetReviewCnt(item) > 0">
										<span class="product-star">★</span>
										<span>{{fnFormatRating(item.avgRating)}}</span>
										<span class="product-review-count">({{fnGetReviewCnt(item)}})</span>
									</div>
								</div>

								<div class="product-tag-row">
									<span class="product-tag">{{item.brand == null ? '브랜드 미등록' : item.brand}}</span>
									<span class="product-tag">{{item.aSubType}}</span>
									<span class="product-tag">{{item.iSubType}}</span>
								</div>

								<div class="product-price-wrap">
									<div class="product-original-price" v-if="fnHasDiscount(item)">
										{{fnFormatPrice(fnOriginalPrice(item))}}원
									</div>

									<div class="product-sale-row">
										<span class="product-discount-rate" v-if="fnHasDiscount(item)">
											{{fnDiscountRate(item)}}%
										</span>
										<span class="product-price">{{fnFormatPrice(fnSalePrice(item))}}원</span>
									</div>

									<div class="product-save-price" v-if="fnHasDiscount(item)">
										{{fnFormatPrice(fnDiscountAmount(item))}}원 할인
									</div>
								</div>

								<div class="product-benefit-row">
									<span>적립 {{fnFormatPrice(fnPointAmount(item))}}원</span>
									<span v-if="fnIsFreeDelivery(item)">무료배송</span>
									<span v-else>3만원 이상 무료배송</span>
								</div>

								<div class="product-sub-info">
									♡ {{fnGetWishCount(item)}}명이 찜했어요
								</div>

								<div class="card-btn-row">
									<button type="button" class="card-btn cart" @click.stop="fnAddCart(item)">
										장바구니
									</button>
									<button type="button" class="card-btn remove" @click.stop="fnRemoveWish(item)">
										찜 해제
									</button>
								</div>
							</div>
						</div>
					</div>

					<div class="pagination" v-if="wishList.length > pageSize">
						<button type="button" @click="fnGoPage(1)" v-if="currentPage > 1">
							&lt;&lt;
						</button>

						<button type="button" @click="fnGoPage(currentPage - 1)" v-if="currentPage > 1">
							&lt;
						</button>

						<button type="button" v-for="page in pageList" :key="'page' + page"
							:class="{active : currentPage == page}" @click="fnGoPage(page)">
							{{page}}
						</button>

						<button type="button" @click="fnGoPage(currentPage + 1)" v-if="currentPage < totalPage">
							&gt;
						</button>

						<button type="button" @click="fnGoPage(totalPage)" v-if="currentPage < totalPage">
							&gt;&gt;
						</button>
					</div>
				</div>
			</div>
		</div>

		<script>
			const app = Vue.createApp({
				data() {
					return {
						wishList: [],
						pagedWishList: [],
						loading: true,

						defaultDiscountRateList: [7, 9, 12, 15, 18, 20, 23, 25],
						pointRate: 1,

						currentPage: 1,
						pageSize: 8,
						totalPage: 1,
						pageList: [],
						pageBlockSize: 5
					};
				},

				methods: {
					fnGetWishList: function () {
						let self = this;

						self.loading = true;

						$.ajax({
							url: "/product/wish/list.dox",
							dataType: "json",
							type: "POST",
							data: {},
							success: function (data) {
								self.loading = false;

								if (data.result == "success") {
									self.wishList = data.list || [];
									self.currentPage = 1;
									self.fnSetPaging();

								} else if (data.result == "login") {
									alert("로그인이 필요한 서비스입니다.");
									location.href = "/user/login.do";

								} else {
									alert(data.message == null ? "찜한 상품 조회 실패" : data.message);
									pageChange("/product.do", {});
								}
							},
							error: function () {
								self.loading = false;
								alert("찜한 상품 조회 중 오류가 발생했습니다.");
							}
						});
					},

					fnSetPaging: function () {
						let self = this;

						self.totalPage = Math.ceil(self.wishList.length / self.pageSize);

						if (self.totalPage == 0) {
							self.totalPage = 1;
						}

						if (self.currentPage > self.totalPage) {
							self.currentPage = self.totalPage;
						}

						let start = (self.currentPage - 1) * self.pageSize;
						let end = start + self.pageSize;

						self.pagedWishList = self.wishList.slice(start, end);

						self.fnSetPageList();
					},

					fnSetPageList: function () {
						let self = this;

						self.pageList = [];

						let startPage = Math.floor((self.currentPage - 1) / self.pageBlockSize) * self.pageBlockSize + 1;
						let endPage = startPage + self.pageBlockSize - 1;

						if (endPage > self.totalPage) {
							endPage = self.totalPage;
						}

						for (let i = startPage; i <= endPage; i++) {
							self.pageList.push(i);
						}
					},

					fnGoPage: function (page) {
						if (page < 1) {
							page = 1;
						}

						if (page > this.totalPage) {
							page = this.totalPage;
						}

						this.currentPage = page;
						this.fnSetPaging();
						window.scrollTo(0, 0);
					},

					fnRemoveWish: function (item) {
						let self = this;

						if (!confirm("찜한 상품에서 삭제하시겠습니까?")) {
							return;
						}

						let param = {
							productNo: item.productNo
						};

						$.ajax({
							url: "/product/wish/toggle.dox",
							dataType: "json",
							type: "POST",
							data: param,
							success: function (data) {
								if (data.result == "success") {
									alert("찜한 상품에서 삭제되었습니다.");
									self.fnGetWishList();

								} else if (data.result == "login") {
									alert("로그인이 필요한 서비스입니다.");
									location.href = "/user/login.do";

								} else {
									alert(data.message == null ? "찜 해제 실패" : data.message);
								}
							},
							error: function () {
								alert("찜 해제 중 오류가 발생했습니다.");
							}
						});
					},

					fnAddCart: function (item) {
						let param = {
							productNo: item.productNo,
							qty: 1
						};

						$.ajax({
							url: "/cart/add.dox",
							dataType: "json",
							type: "POST",
							data: param,
							success: function (data) {
								if (data.result == "success") {
									if (confirm("장바구니에 담았습니다. 장바구니로 이동하시겠습니까?")) {
										pageChange("/cart.do", {});
									}

								} else if (data.result == "login") {
									alert("로그인이 필요한 서비스입니다.");
									location.href = "/user/login.do";

								} else {
									alert(data.message == null ? "장바구니 담기 실패" : data.message);
								}
							},
							error: function () {
								alert("장바구니 처리 중 오류가 발생했습니다.");
							}
						});
					},

					fnMoveDetail: function (productNo) {
						pageChange("/product/view.do", {
							productNo: productNo
						});
					},

					fnMoveProductList: function () {
						pageChange("/product.do", {});
					},

					fnFormatPrice: function (price) {
						if (price == null || price == undefined || price == "") {
							return "0";
						}

						return Number(price).toLocaleString();
					},

					fnFormatRating: function (rating) {
						if (rating == null || rating == "") {
							return "0.0";
						}

						return Number(rating).toFixed(1);
					},

					fnGetReviewCnt: function (item) {
						if (item.reviewCount == null || item.reviewCount == "") {
							return 0;
						}

						return Number(item.reviewCount);
					},

					fnDiscountRate: function (item) {
						if (item == null) {
							return 0;
						}

						if (item.discountRate != null && item.discountRate != "") {
							return Number(item.discountRate);
						}

						if (item.saleRate != null && item.saleRate != "") {
							return Number(item.saleRate);
						}

						let productNo = item.productNo == null || item.productNo == "" ? 0 : Number(item.productNo);
						let index = productNo % this.defaultDiscountRateList.length;

						return Number(this.defaultDiscountRateList[index]);
					},

					fnSalePrice: function (item) {
						if (item == null) {
							return 0;
						}

						if (item.salePrice != null && item.salePrice != "") {
							return Number(item.salePrice);
						}

						if (item.discountPrice != null && item.discountPrice != "") {
							return Number(item.discountPrice);
						}

						if (item.finalPrice != null && item.finalPrice != "") {
							return Number(item.finalPrice);
						}

						return Number(item.productPrice);
					},

					fnOriginalPrice: function (item) {
						if (item == null) {
							return 0;
						}

						if (item.originalPrice != null && item.originalPrice != "") {
							return Number(item.originalPrice);
						}

						if (item.consumerPrice != null && item.consumerPrice != "") {
							return Number(item.consumerPrice);
						}

						if (item.listPrice != null && item.listPrice != "") {
							return Number(item.listPrice);
						}

						let salePrice = this.fnSalePrice(item);
						let rate = this.fnDiscountRate(item);

						if (rate <= 0 || rate >= 100) {
							return salePrice;
						}

						return Math.round((salePrice / (1 - rate / 100)) / 10) * 10;
					},

					fnHasDiscount: function (item) {
						let salePrice = this.fnSalePrice(item);
						let originalPrice = this.fnOriginalPrice(item);
						let rate = this.fnDiscountRate(item);

						if (rate <= 0) {
							return false;
						}

						if (originalPrice <= salePrice) {
							return false;
						}

						return true;
					},

					fnDiscountAmount: function (item) {
						let amount = this.fnOriginalPrice(item) - this.fnSalePrice(item);

						if (amount < 0) {
							return 0;
						}

						return amount;
					},

					fnPointAmount: function (item) {
						return Math.floor(Number(this.fnSalePrice(item)) * Number(this.pointRate) / 100);
					},

					fnIsFreeDelivery: function (item) {
						return this.fnSalePrice(item) >= 30000;
					},

					fnGetWishCount: function (item) {
						if (item == null) {
							return 0;
						}

						if (item.wishCount == null || item.wishCount == "") {
							return 0;
						}

						return Number(item.wishCount);
					}
				},

				mounted() {
					this.fnGetWishList();
				}
			});

			app.mount("#app");
		</script>

		<jsp:include page="/WEB-INF/footer/footer.jsp" />
	</body>

	</html>