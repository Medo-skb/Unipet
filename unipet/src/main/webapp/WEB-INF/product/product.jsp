<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>UniPet Product</title>
		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-change.js"></script>
		<style>
			* {
				box-sizing: border-box;
			}

			body {
				margin: 0;
				font-family: 'Malgun Gothic', sans-serif;
				background-color: #f7f8fa;
				color: #333;
			}

			.wrap {
				width: 1400px;
				margin: 0 auto;
				padding: 30px 0;
			}

			.top-bar {
				display: flex;
				justify-content: space-between;
				align-items: center;
				margin-bottom: 20px;
			}

			.title {
				font-size: 30px;
				font-weight: bold;
			}

			.cart-icon-wrap {
				position: relative;
				cursor: pointer;
				font-size: 30px;
				background: #fff;
				border: 1px solid #ddd;
				width: 56px;
				height: 56px;
				border-radius: 50%;
				display: flex;
				align-items: center;
				justify-content: center;
			}

			.cart-count {
				position: absolute;
				top: -6px;
				right: -4px;
				min-width: 22px;
				height: 22px;
				padding: 0 6px;
				border-radius: 999px;
				background: #ff7a00;
				color: #fff;
				font-size: 12px;
				font-weight: bold;
				display: flex;
				align-items: center;
				justify-content: center;
			}

			.container {
				display: flex;
				gap: 20px;
				align-items: flex-start;
			}

			.sidebar {
				width: 250px;
				background: #fff;
				border: 1px solid #ddd;
				border-radius: 14px;
				padding: 16px;
				max-height: 780px;
				overflow-y: auto;
				flex-shrink: 0;
				position: sticky;
				top: 20px;
			}

			.category-tab-wrap {
				display: flex;
				gap: 8px;
				margin-bottom: 16px;
			}

			.category-tab {
				flex: 1;
				height: 40px;
				border: 1px solid #ddd;
				border-radius: 8px;
				background: #f8f9fa;
				cursor: pointer;
				font-weight: bold;
				font-size: 14px;
			}

			.category-tab.active {
				background: #ff7a00;
				color: #fff;
				border-color: #ff7a00;
			}

			.category-panel {
				display: none;
			}

			.category-panel.active {
				display: block;
			}

			.category-title {
				font-size: 17px;
				font-weight: bold;
				margin-bottom: 12px;
			}

			.category-all {
				padding: 10px 12px;
				background: #fff7ed;
				border: 1px solid #ffd8b0;
				border-radius: 8px;
				cursor: pointer;
				font-weight: bold;
				margin-bottom: 10px;
				font-size: 14px;
			}

			.category-all.active {
				background: #ffedd5;
				border-color: #ff7a00;
				color: #ff7a00;
			}

			.main-category {
				padding: 12px;
				background: #f1f3f5;
				border-radius: 8px;
				margin-top: 10px;
				cursor: pointer;
				font-weight: bold;
				display: flex;
				justify-content: space-between;
				align-items: center;
				font-size: 14px;
			}

			.main-category:hover {
				background: #e9ecef;
			}

			.main-category.active {
				background: #ffe8cc;
				color: #ff7a00;
				border: 1px solid #ffc078;
			}

			.main-btns {
				margin-top: 6px;
				padding-left: 4px;
			}

			.main-view-btn {
				display: inline-block;
				margin-top: 6px;
				padding: 6px 10px;
				background: #f8f9fa;
				border: 1px solid #ddd;
				border-radius: 6px;
				cursor: pointer;
				font-size: 12px;
			}

			.main-view-btn.active {
				background: #fff1e6;
				border-color: #ff7a00;
				color: #ff7a00;
				font-weight: bold;
			}

			.sub-list {
				display: none;
				padding: 8px 0 8px 10px;
			}

			.sub-list.show {
				display: block;
			}

			.sub-item {
				padding: 8px 10px;
				margin-top: 4px;
				border-radius: 6px;
				cursor: pointer;
				font-size: 13px;
			}

			.sub-item:hover {
				background: #fff1e6;
				color: #ff7a00;
			}

			.sub-item.active {
				background: #fff1e6;
				color: #ff7a00;
				font-weight: bold;
				border: 1px solid #ffd8b0;
			}

			.content {
				flex: 1;
				min-width: 0;
			}

			.selected-filter-box {
				background: #fff;
				border: 1px solid #ddd;
				border-radius: 12px;
				padding: 15px 20px;
				margin-bottom: 15px;
				display: flex;
				align-items: center;
				gap: 8px;
				flex-wrap: wrap;
			}

			.filter-label {
				font-size: 14px;
				font-weight: bold;
				color: #555;
				margin-right: 4px;
			}

			.filter-tag {
				display: inline-block;
				padding: 6px 12px;
				background: #fff1e6;
				color: #ff7a00;
				border-radius: 999px;
				font-size: 13px;
				font-weight: bold;
			}

			.filter-reset-btn {
				padding: 6px 12px;
				border: none;
				border-radius: 8px;
				background: #868e96;
				color: white;
				cursor: pointer;
				margin-left: auto;
			}

			.search-box {
				background: #fff;
				border: 1px solid #ddd;
				border-radius: 12px;
				padding: 20px;
				margin-bottom: 20px;
				display: flex;
				gap: 8px;
				flex-wrap: wrap;
				align-items: center;
			}

			.search-box input,
			.search-box select {
				height: 40px;
				padding: 0 12px;
				border: 1px solid #ccc;
				border-radius: 8px;
			}

			.search-box input {
				width: 260px;
			}

			.search-box button {
				height: 40px;
				padding: 0 16px;
				border: none;
				border-radius: 8px;
				background: #ff7a00;
				color: white;
				cursor: pointer;
				font-weight: bold;
			}

			.product-list {
				display: grid;
				grid-template-columns: repeat(4, 1fr);
				gap: 20px;
			}

			.product-card {
				background: #fff;
				border: 1px solid #ddd;
				border-radius: 12px;
				padding: 15px;
				cursor: pointer;
				transition: 0.2s;
			}

			.product-card:hover {
				transform: translateY(-3px);
				box-shadow: 0 6px 16px rgba(0, 0, 0, 0.08);
			}

			.product-card img {
				width: 100%;
				height: 220px;
				object-fit: cover;
				border-radius: 10px;
				background: #f3f3f3;
			}

			.product-name {
				font-size: 16px;
				font-weight: bold;
				margin-top: 10px;
			}

			.product-info {
				font-size: 13px;
				color: #666;
				margin-top: 5px;
			}

			.product-price {
				font-size: 18px;
				font-weight: bold;
				color: #ff7a00;
				margin-top: 10px;
			}

			.empty-box {
				background: #fff;
				border: 1px solid #ddd;
				border-radius: 12px;
				padding: 50px;
				text-align: center;
			}
		</style>
	</head>

	<body>
		<div id="app">
			<div class="header">
				<div class="wrap">
					<div class="container">
						<div class="sidebar">
							<div class="category-tab-wrap">
								<button type="button" class="category-tab" :class="{active : categoryTab == 'animal'}"
									@click="fnShowCategoryTab('animal')">동물별</button>

								<button type="button" class="category-tab" :class="{active : categoryTab == 'item'}"
									@click="fnShowCategoryTab('item')">상품별</button>
							</div>

							<div id="animalPanel" class="category-panel" :class="{active : categoryTab == 'animal'}">
								<div class="category-title">동물 카테고리</div>

								<div class="category-all"
									:class="{active : selectedAMainNo == '' && selectedASubNo == ''}"
									@click="fnSelectAnimalAll()">
									동물 전체보기
								</div>

								<div v-for="main in animalMainList" :key="'animalMain' + main.A_MAIN_NO">
									<div class="main-category"
										:class="{active : selectedAMainNo == String(main.A_MAIN_NO)}"
										@click="fnToggleAnimalSub(main.A_MAIN_NO)">
										<span>{{main.A_MAIN_TYPE}}</span>
										<span>+</span>
									</div>

									<div class="main-btns">
										<span class="main-view-btn"
											:class="{active : selectedAMainNo == String(main.A_MAIN_NO) && selectedASubNo == ''}"
											@click.stop="fnSelectAnimalMain(main.A_MAIN_NO, main.A_MAIN_TYPE)">
											{{main.A_MAIN_TYPE}} 전체보기
										</span>
									</div>

									<div class="sub-list" :class="{show : openAnimalMainNo == main.A_MAIN_NO}">
										<div v-for="sub in animalSubList.filter(s => s.A_MAIN_NO == main.A_MAIN_NO)"
											:key="'animalSub' + sub.A_SUB_NO" class="sub-item"
											:class="{active : selectedASubNo == String(sub.A_SUB_NO)}"
											@click="fnSelectAnimalSub(sub.A_MAIN_NO, sub.A_SUB_NO, sub.A_SUB_TYPE)">
											{{sub.A_SUB_TYPE}}
										</div>
									</div>
								</div>
							</div>

							<div id="itemPanel" class="category-panel" :class="{active : categoryTab == 'item'}">
								<div class="category-title">상품 카테고리</div>

								<div class="category-all"
									:class="{active : selectedIMainNo == '' && selectedISubNo == ''}"
									@click="fnSelectItemAll()">
									상품 전체보기
								</div>

								<div v-for="main in itemMainList" :key="'itemMain' + main.I_MAIN_NO">
									<div class="main-category"
										:class="{active : selectedIMainNo == String(main.I_MAIN_NO)}"
										@click="fnToggleItemSub(main.I_MAIN_NO)">
										<span>{{main.I_MAIN_TYPE}}</span>
										<span>+</span>
									</div>

									<div class="main-btns">
										<span class="main-view-btn"
											:class="{active : selectedIMainNo == String(main.I_MAIN_NO) && selectedISubNo == ''}"
											@click.stop="fnSelectItemMain(main.I_MAIN_NO, main.I_MAIN_TYPE)">
											{{main.I_MAIN_TYPE}} 전체보기
										</span>
									</div>

									<div class="sub-list" :class="{show : openItemMainNo == main.I_MAIN_NO}">
										<div v-for="sub in itemSubList.filter(s => s.I_MAIN_NO == main.I_MAIN_NO)"
											:key="'itemSub' + sub.I_SUB_NO" class="sub-item"
											:class="{active : selectedISubNo == String(sub.I_SUB_NO)}"
											@click="fnSelectItemSub(sub.I_MAIN_NO, sub.I_SUB_NO, sub.I_SUB_TYPE)">
											{{sub.I_SUB_TYPE}}
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
								<input type="text" v-model="keyword" placeholder="상품명 검색">
								<select v-model="sort">
									<option value="">최신순</option>
									<option value="priceAsc">가격 낮은순</option>
									<option value="priceDesc">가격 높은순</option>
								</select>
								<button type="button" @click="fnGetProductList()">검색</button>
							</div>

							<div v-if="productList.length == 0" class="empty-box">
								조회된 상품이 없습니다.
							</div>

							<div v-else class="product-list">
								<div class="product-card" v-for="item in productList" :key="item.PRODUCT_NO"
									@click="fnMoveDetail(item.PRODUCT_NO)">
									<img v-if="item.MAIN_IMG != null && item.MAIN_IMG != ''" :src="item.MAIN_IMG">
									<img v-else src="http://localhost:8080/img/no-image.png">

									<div class="product-name">{{item.PRODUCT_NAME}}</div>
									<div class="product-info">브랜드 : {{item.BRAND == null ? '-' : item.BRAND}}</div>
									<div class="product-info">동물 : {{item.A_SUB_TYPE}}</div>
									<div class="product-info">상품 : {{item.I_SUB_TYPE}}</div>
									<div class="product-price">{{fnFormatPrice(item.PRODUCT_PRICE)}}원</div>
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
					categoryTab: "animal",
					animalMainList: [],
					animalSubList: [],
					itemMainList: [],
					itemSubList: [],
					productList: [],
					openAnimalMainNo: "",
					openItemMainNo: "",
					selectedAMainNo: "",
					selectedASubNo: "",
					selectedIMainNo: "",
					selectedISubNo: "",
					selectedAnimalText: "동물 전체",
					selectedItemText: "상품 전체",
					keyword: "",
					sort: "",
					cartCount: 0
				};
			},
			methods: {
				fnShowCategoryTab(type) {
					this.categoryTab = type;
				},

				fnGetCategoryList() {
					let self = this;
					$.ajax({
						url: "/productCategory.dox",
						dataType: "json",
						type: "POST",
						data: {},
						success: function (data) {
							if (data.result == "success") {
								self.animalMainList = data.animalMainList;
								self.animalSubList = data.animalSubList;
								self.itemMainList = data.itemMainList;
								self.itemSubList = data.itemSubList;
							} else {
								alert("카테고리 조회 실패");
							}
						}
					});
				},

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

				fnToggleAnimalSub(aMainNo) {
					this.openAnimalMainNo = this.openAnimalMainNo == aMainNo ? "" : aMainNo;
				},

				fnToggleItemSub(iMainNo) {
					this.openItemMainNo = this.openItemMainNo == iMainNo ? "" : iMainNo;
				},

				fnSelectAnimalAll() {
					this.selectedAMainNo = "";
					this.selectedASubNo = "";
					this.selectedAnimalText = "동물 전체";
					this.fnGetProductList();
				},

				fnSelectAnimalMain(aMainNo, aMainType) {
					this.selectedAMainNo = String(aMainNo);
					this.selectedASubNo = "";
					this.selectedAnimalText = aMainType + " 전체";
					this.fnGetProductList();
				},

				fnSelectAnimalSub(aMainNo, aSubNo, aSubType) {
					this.selectedAMainNo = String(aMainNo);
					this.selectedASubNo = String(aSubNo);
					this.selectedAnimalText = aSubType;
					this.fnGetProductList();
				},

				fnSelectItemAll() {
					this.selectedIMainNo = "";
					this.selectedISubNo = "";
					this.selectedItemText = "상품 전체";
					this.fnGetProductList();
				},

				fnSelectItemMain(iMainNo, iMainType) {
					this.selectedIMainNo = String(iMainNo);
					this.selectedISubNo = "";
					this.selectedItemText = iMainType + " 전체";
					this.fnGetProductList();
				},

				fnSelectItemSub(iMainNo, iSubNo, iSubType) {
					this.selectedIMainNo = String(iMainNo);
					this.selectedISubNo = String(iSubNo);
					this.selectedItemText = iSubType;
					this.fnGetProductList();
				},

				fnResetFilter() {
					this.selectedAMainNo = "";
					this.selectedASubNo = "";
					this.selectedIMainNo = "";
					this.selectedISubNo = "";
					this.selectedAnimalText = "동물 전체";
					this.selectedItemText = "상품 전체";
					this.keyword = "";
					this.sort = "";
					this.fnGetProductList();
				},

				fnGetProductList() {
					let self = this;
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
								self.productList = data.list;
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

				fnMoveDetail(productNo) {
					location.href = "/product/view.do?productNo=" + productNo;
				},

				fnMoveCart() {
					location.href = "/cart.do";
				},

				fnFormatPrice(price) {
					return Number(price).toLocaleString();
				}
			},
			mounted() {
				this.fnGetCategoryList();
				this.fnGetProductList();
				this.fnGetCartCount();
			}
		});

		app.mount('#app');
	</script>