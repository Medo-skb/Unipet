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
							@click="fnShowCategoryTab('animal')">동물별</button>

						<button type="button" class="category-tab" :class="{active : categoryTab == 'item'}"
							@click="fnShowCategoryTab('item')">상품별</button>
					</div>

					<div id="animalPanel" class="category-panel" :class="{active : categoryTab == 'animal'}">
						<div class="category-title">동물 카테고리</div>

						<div class="category-all" :class="{active : selectedAMainNo == '' && selectedASubNo == ''}"
							@click="fnSelectAnimalAll()">
							동물 전체보기
						</div>

						<div v-for="main in animalMainList" :key="'animalMain' + main.A_MAIN_NO">
							<div class="main-category" :class="{active : selectedAMainNo == String(main.A_MAIN_NO)}"
								@click="fnToggleAnimalSub(main.A_MAIN_NO)">
								<span>{{main.A_MAIN_TYPE}}</span>
								<span>+</span>
							</div>

							<div class="sub-list" :class="{show : openAnimalMainNo == main.A_MAIN_NO}">
								<div class="sub-item"
									:class="{active : selectedAMainNo == String(main.A_MAIN_NO) && selectedASubNo == ''}"
									@click.stop="fnSelectAnimalMain(main.A_MAIN_NO, main.A_MAIN_TYPE)">
									{{main.A_MAIN_TYPE}} 전체보기
								</div>

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

						<div class="category-all" :class="{active : selectedIMainNo == '' && selectedISubNo == ''}"
							@click="fnSelectItemAll()">
							상품 전체보기
						</div>

						<div v-for="main in itemMainList" :key="'itemMain' + main.I_MAIN_NO">
							<div class="main-category" :class="{active : selectedIMainNo == String(main.I_MAIN_NO)}"
								@click="fnToggleItemSub(main.I_MAIN_NO)">
								<span>{{main.I_MAIN_TYPE}}</span>
								<span>+</span>
							</div>

							<div class="sub-list" :class="{show : openItemMainNo == main.I_MAIN_NO}">
								<div class="sub-item"
									:class="{active : selectedIMainNo == String(main.I_MAIN_NO) && selectedISubNo == ''}"
									@click.stop="fnSelectItemMain(main.I_MAIN_NO, main.I_MAIN_TYPE)">
									{{main.I_MAIN_TYPE}} 전체보기
								</div>

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
						<input type="text" v-model="keyword" placeholder="상품명 검색" @keyup.enter="fnGetProductList()">
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

							<div class="product-image-box">
								<img v-if="item.MAIN_IMG != null && item.MAIN_IMG != ''"
									:src="item.MAIN_IMG"
									class="product-image">

								<img v-else
									src="http://localhost:8080/img/no-image.png"
									class="product-image">
							</div>

							<div class="product-card-body">
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
	</div>

	<jsp:include page="/WEB-INF/footer/footer.jsp" />
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
					});
				},

				fnMoveDetail(productNo) {
					pageChange("/product/view.do", {
						productNo: productNo
					});
				},

				fnMoveCart() {
					pageChange("/cart.do", {});
				},

				fnFormatPrice(price) {
					return Number(price).toLocaleString();
				},
				
				fnMoveMain() {
					pageChange("/product.do", {});
				},
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
			},

			fnMoveMain() {
				location.href = "/product.do";
			},
		},
		mounted() {
			this.fnGetCategoryList();
			this.fnGetProductList();
			this.fnGetCartCount();
		}
	});

	app.mount('#app');
</script>