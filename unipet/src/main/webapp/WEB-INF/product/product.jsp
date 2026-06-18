<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>UNIPET</title>

		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-change.js"></script>
		<link rel="stylesheet" href="/css/product/product.css">
	</head>

	<body>
		<jsp:include page="/WEB-INF/header/header.jsp" />

		<div id="app">

			<div class="wrap">
				<div class="container">

					<div class="sidebar">
						<div class="category-tab-wrap">
							<button type="button" class="category-tab" :class="{active : categoryTab == 'animal'}"
								@click="fnShowCategoryTab('animal')">
								동물별
							</button>

							<button type="button" class="category-tab" :class="{active : categoryTab == 'item'}"
								@click="fnShowCategoryTab('item')">
								상품별
							</button>
						</div>

						<div id="animalPanel" class="category-panel" :class="{active : categoryTab == 'animal'}">
							<div class="category-title">동물 카테고리</div>

							<div class="category-all" :class="{active : selectedAMainNo == '' && selectedASubNo == ''}"
								@click="fnSelectAnimalAll()">
								동물 전체보기
							</div>

							<div v-for="main in animalMainList" :key="'animalMain' + main.aMainNo">
								<div class="main-category" :class="{active : selectedAMainNo == String(main.aMainNo)}"
									@click="fnToggleAnimalSub(main.aMainNo)">
									<span>{{main.aMainType}}</span>
									<span>+</span>
								</div>

								<div class="sub-list" :class="{show : openAnimalMainNo == main.aMainNo}">
									<div class="sub-item"
										:class="{active : selectedAMainNo == String(main.aMainNo) && selectedASubNo == ''}"
										@click.stop="fnSelectAnimalMain(main.aMainNo, main.aMainType)">
										{{main.aMainType}} 전체보기
									</div>

									<div v-for="sub in animalSubList.filter(s => s.aMainNo == main.aMainNo)"
										:key="'animalSub' + sub.aSubNo" class="sub-item"
										:class="{active : selectedASubNo == String(sub.aSubNo)}"
										@click="fnSelectAnimalSub(sub.aMainNo, sub.aSubNo, sub.aSubType)">
										{{sub.aSubType}}
									</div>
								</div>
							</div>
						</div>

						<div id="itemPanel" class="category-panel" :class="{active : categoryTab == 'item'}">
							<div class="category-title">상품 카테고리</div>

							<div class="category-all" :class="{active : selectedIMainNo == '' && selectedISubNo == ''}"
								@click="fnSelectItemAll()">
								상품 전체보기
							</div>

							<div v-for="main in itemMainList" :key="'itemMain' + main.iMainNo">
								<div class="main-category" :class="{active : selectedIMainNo == String(main.iMainNo)}"
									@click="fnToggleItemSub(main.iMainNo)">
									<span>{{main.iMainType}}</span>
									<span>+</span>
								</div>

								<div class="sub-list" :class="{show : openItemMainNo == main.iMainNo}">
									<div class="sub-item"
										:class="{active : selectedIMainNo == String(main.iMainNo) && selectedISubNo == ''}"
										@click.stop="fnSelectItemMain(main.iMainNo, main.iMainType)">
										{{main.iMainType}} 전체보기
									</div>

									<div v-for="sub in itemSubList.filter(s => s.iMainNo == main.iMainNo)"
										:key="'itemSub' + sub.iSubNo" class="sub-item"
										:class="{active : selectedISubNo == String(sub.iSubNo)}"
										@click="fnSelectItemSub(sub.iMainNo, sub.iSubNo, sub.iSubType)">
										{{sub.iSubType}}
									</div>
								</div>
							</div>
						</div>
					</div>

					<div class="content">
						<div class="selected-filter-box">
							<span class="filter-label">선택 필터</span>
							<span class="filter-tag">{{selectedAnimalText}}</span>
							<span class="filter-tag">{{selectedItemText}}</span>
							<button type="button" class="filter-reset-btn" @click="fnResetFilter()">전체 초기화</button>
						</div>

						<div class="search-box">
							<input type="text" v-model="keyword" placeholder="상품명 검색" @keyup.enter="fnGetProductList()">

							<select v-model="sort" @change="fnGetProductList()">
								<option value="">최신순</option>
								<option value="priceAsc">가격 낮은순</option>
								<option value="priceDesc">가격 높은순</option>
								<option value="reviewDesc">리뷰 많은순</option>
								<option value="ratingDesc">평점 높은순</option>
							</select>

							<button type="button" @click="fnGetProductList()">검색</button>
						</div>

						<div v-if="productList.length == 0" class="empty-box">
							조회된 상품이 없습니다.
						</div>

						<div v-else class="product-list">
							<div class="product-card" v-for="item in pagedProductList" :key="item.productNo"
								@click="fnMoveDetail(item.productNo)">

								<div class="product-image-box">
									<img v-if="item.img != null && item.img != ''" :src="item.img"
										class="product-image">

									<img v-else src="/img/product/no-image.png" class="product-image">
								</div>

								<div class="product-card-body">
									<div class="product-name">{{item.productName}}</div>
									<div class="product-info">브랜드 : {{item.brand == null ? '-' : item.brand}}</div>
									<div class="product-info">동물 : {{item.aSubType}}</div>
									<div class="product-info">상품 : {{item.iSubType}}</div>

									<div class="product-review-row" v-if="fnGetReviewCnt(item) > 0">
										<span class="product-star">★</span>
										<span>{{fnFormatRating(item.avgRating)}}점</span>
										<span class="product-review-count">리뷰 {{fnGetReviewCnt(item)}}개</span>
									</div>

									<div class="product-review-row no-review" v-else>
										리뷰 없음
									</div>

									<div class="product-price">{{fnFormatPrice(item.productPrice)}}원</div>
								</div>
							</div>
						</div>

						<div class="pagination" v-if="productList.length > pageSize">
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

		</div>

		<jsp:include page="/WEB-INF/footer/footer.jsp" />

		<script>
			const app = Vue.createApp({
				data() {
					return {
						// 카테고리
						categoryTab: "animal",
						animalMainList: [],
						animalSubList: [],
						itemMainList: [],
						itemSubList: [],

						// 상품 목록
						productList: [],
						pagedProductList: [],
						recommendList: [],

						// 카테고리 열림/선택
						openAnimalMainNo: "",
						openItemMainNo: "",
						selectedAMainNo: "",
						selectedASubNo: "",
						selectedIMainNo: "",
						selectedISubNo: "",
						selectedAnimalText: "동물 전체",
						selectedItemText: "상품 전체",

						// 검색/정렬
						keyword: "",
						sort: "",

						// 장바구니
						cartCount: 0,

						// 페이징
						currentPage: 1,
						pageSize: 8,
						totalPage: 1,
						pageList: [],
						pageBlockSize: 5
					};
				},

				methods: {
					fnSaveProductFilter: function () {
						let self = this;

						let filter = {
							categoryTab: self.categoryTab,
							openAnimalMainNo: self.openAnimalMainNo,
							openItemMainNo: self.openItemMainNo,
							selectedAMainNo: self.selectedAMainNo,
							selectedASubNo: self.selectedASubNo,
							selectedIMainNo: self.selectedIMainNo,
							selectedISubNo: self.selectedISubNo,
							selectedAnimalText: self.selectedAnimalText,
							selectedItemText: self.selectedItemText,
							keyword: self.keyword,
							sort: self.sort,
							currentPage: self.currentPage
						};

						sessionStorage.setItem("unipetProductFilter", JSON.stringify(filter));
					},

					fnLoadProductFilter: function () {
						let self = this;
						let saved = sessionStorage.getItem("unipetProductFilter");

						if (saved == null || saved == "") {
							return;
						}

						try {
							let filter = JSON.parse(saved);

							self.categoryTab = filter.categoryTab || "animal";
							self.openAnimalMainNo = filter.openAnimalMainNo || "";
							self.openItemMainNo = filter.openItemMainNo || "";
							self.selectedAMainNo = filter.selectedAMainNo || "";
							self.selectedASubNo = filter.selectedASubNo || "";
							self.selectedIMainNo = filter.selectedIMainNo || "";
							self.selectedISubNo = filter.selectedISubNo || "";
							self.selectedAnimalText = filter.selectedAnimalText || "동물 전체";
							self.selectedItemText = filter.selectedItemText || "상품 전체";
							self.keyword = filter.keyword || "";
							self.sort = filter.sort || "";
							self.currentPage = filter.currentPage == null || filter.currentPage == "" ? 1 : Number(filter.currentPage);

						} catch (e) {
							sessionStorage.removeItem("unipetProductFilter");
						}
					},

					fnShowCategoryTab: function (type) {
						this.categoryTab = type;
						this.fnSaveProductFilter();
					},

					fnToggleAnimalSub: function (aMainNo) {
						if (this.openAnimalMainNo == aMainNo) {
							this.openAnimalMainNo = "";
						} else {
							this.openAnimalMainNo = aMainNo;
						}

						this.fnSaveProductFilter();
					},

					fnToggleItemSub: function (iMainNo) {
						if (this.openItemMainNo == iMainNo) {
							this.openItemMainNo = "";
						} else {
							this.openItemMainNo = iMainNo;
						}

						this.fnSaveProductFilter();
					},

					fnGetCategoryList: function () {
						let self = this;
						let param = {};

						$.ajax({
							url: "/productCategory.dox",
							dataType: "json",
							type: "POST",
							data: param,
							success: function (data) {
								if (data.result == "success") {
									self.animalMainList = data.animalMainList || [];
									self.animalSubList = data.animalSubList || [];
									self.itemMainList = data.itemMainList || [];
									self.itemSubList = data.itemSubList || [];
								} else {
									alert("카테고리 조회 실패");
								}
							}
						});
					},

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

					fnSelectAnimalAll: function () {
						this.selectedAMainNo = "";
						this.selectedASubNo = "";
						this.selectedAnimalText = "동물 전체";
						this.fnGetProductList();
					},

					fnSelectAnimalMain: function (aMainNo, aMainType) {
						this.selectedAMainNo = String(aMainNo);
						this.selectedASubNo = "";
						this.selectedAnimalText = aMainType + " 전체";
						this.fnGetProductList();
					},

					fnSelectAnimalSub: function (aMainNo, aSubNo, aSubType) {
						this.selectedAMainNo = String(aMainNo);
						this.selectedASubNo = String(aSubNo);
						this.selectedAnimalText = aSubType;
						this.fnGetProductList();
					},

					fnSelectItemAll: function () {
						this.selectedIMainNo = "";
						this.selectedISubNo = "";
						this.selectedItemText = "상품 전체";
						this.fnGetProductList();
					},

					fnSelectItemMain: function (iMainNo, iMainType) {
						this.selectedIMainNo = String(iMainNo);
						this.selectedISubNo = "";
						this.selectedItemText = iMainType + " 전체";
						this.fnGetProductList();
					},

					fnSelectItemSub: function (iMainNo, iSubNo, iSubType) {
						this.selectedIMainNo = String(iMainNo);
						this.selectedISubNo = String(iSubNo);
						this.selectedItemText = iSubType;
						this.fnGetProductList();
					},

					fnResetFilter: function () {
						this.categoryTab = "animal";
						this.openAnimalMainNo = "";
						this.openItemMainNo = "";
						this.selectedAMainNo = "";
						this.selectedASubNo = "";
						this.selectedIMainNo = "";
						this.selectedISubNo = "";
						this.selectedAnimalText = "동물 전체";
						this.selectedItemText = "상품 전체";
						this.keyword = "";
						this.sort = "";
						this.currentPage = 1;
						sessionStorage.removeItem("unipetProductFilter");
						this.fnGetProductList();
					},

					fnGetProductList: function (isResetPage) {
						let self = this;

						if (isResetPage == null) {
							isResetPage = true;
						}

						let param = {
							keyword: self.keyword,
							aMainNo: self.selectedAMainNo,
							aSubNo: self.selectedASubNo,
							iMainNo: self.selectedIMainNo,
							iSubNo: self.selectedISubNo,
							sort: self.sort
						};

						$.ajax({
							url: "/productList.dox",
							dataType: "json",
							type: "POST",
							data: param,
							success: function (data) {
								if (data.result == "success") {
									self.productList = data.list || [];

									if (isResetPage) {
										self.currentPage = 1;
									}

									self.fnSetPaging();
									self.fnSaveProductFilter();

								} else {
									alert("상품 목록 조회 실패");
								}
							},
							error: function (xhr) {
								console.log(xhr.responseText);
								alert("상품 목록 조회 중 오류가 발생했습니다.");
							}
						});
					},

					// 페이징 계산
					fnSetPaging: function () {
						let self = this;

						self.totalPage = Math.ceil(self.productList.length / self.pageSize);

						if (self.totalPage == 0) {
							self.totalPage = 1;
						}

						if (self.currentPage > self.totalPage) {
							self.currentPage = self.totalPage;
						}

						let start = (self.currentPage - 1) * self.pageSize;
						let end = start + self.pageSize;

						self.pagedProductList = self.productList.slice(start, end);

						self.fnSetPageList();
					},

					// 화면에 보여줄 페이지 번호 만들기
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

					// 페이지 이동
					fnGoPage: function (page) {
						let self = this;

						if (page < 1) {
							page = 1;
						}

						if (page > self.totalPage) {
							page = self.totalPage;
						}

						self.currentPage = page;
						self.fnSetPaging();
						self.fnSaveProductFilter();

						window.scrollTo(0, 0);
					},

					fnMoveDetail: function (productNo) {
						this.fnSaveProductFilter();

						pageChange("/product/view.do", {
							productNo: productNo
						});
					},

					fnMoveCart: function () {
						location.href = "/cart.do";
					},

					fnFormatPrice: function (price) {
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

					fnMoveMain: function () {
						location.href = "/product.do";
					},

					fnGetRecommend: function () {
						let self = this;

						$.ajax({
							url: "/product/recommend.dox",
							type: "POST",
							dataType: "json",
							success: function (data) {
								self.recommendList = data.list || [];
							}
						});
					}
				}, // methods

				mounted() {
					// 처음 시작할 때 실행되는 부분
					let self = this;
					self.fnLoadProductFilter();
					self.fnGetCategoryList();
					self.fnGetProductList(false);
					self.fnGetCartCount();
					self.fnGetRecommend();
				}
			});

			app.mount('#app');
		</script>
	</body>

	</html>