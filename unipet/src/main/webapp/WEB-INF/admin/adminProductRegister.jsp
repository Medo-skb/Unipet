<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>UNIPET</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
</head>
<body>

<jsp:include page="/WEB-INF/header/header.jsp" />

<div id="app" v-cloak>
    <div class="container-main">
        <div class="admin-wrap">

            <jsp:include page="/WEB-INF/admin/adminSidebar.jsp">
                <jsp:param name="activeMenu" value="productManage" />
            </jsp:include>

            <section class="admin-content">
                <div class="content-card">
                    <h2>상품 등록</h2>
                    <div class="content-desc">상품 기본 정보와 대표/상세 이미지를 등록합니다.</div>

                    <table class="approve-table">
                        <tbody>
                            <tr>
                                <th>상품명</th>
                                <td><input type="text" class="admin-product-edit-input" v-model="productInfo.productName"></td>
                            </tr>
                            <tr>
                                <th>브랜드</th>
                                <td><input type="text" class="admin-product-edit-input" v-model="productInfo.brand"></td>
                            </tr>
                            <tr>
                                <th>동물 카테고리</th>
                                <td>
                                    <div class="admin-product-category-row">
                                        <select class="admin-product-edit-select" v-model="productInfo.aMainNo" @change="fnChangeAnimalMain">
                                            <option value="">동물 메인 선택</option>
                                            <option v-for="item in animalMainList" :key="item.aMainNo" :value="item.aMainNo">
                                                {{ item.aMainType }}
                                            </option>
                                        </select>

                                        <select class="admin-product-edit-select" v-model="productInfo.aSubNo">
                                            <option value="">동물 서브 선택</option>
                                            <option v-for="item in animalSubList" :key="item.aSubNo" :value="item.aSubNo">
                                                {{ item.aSubType }}
                                            </option>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>상품 카테고리</th>
                                <td>
                                    <div class="admin-product-category-row">
                                        <select class="admin-product-edit-select" v-model="productInfo.iMainNo" @change="fnChangeItemMain">
                                            <option value="">상품 메인 선택</option>
                                            <option v-for="item in itemMainList" :key="item.iMainNo" :value="item.iMainNo">
                                                {{ item.iMainType }}
                                            </option>
                                        </select>

                                        <select class="admin-product-edit-select" v-model="productInfo.iSubNo">
                                            <option value="">상품 서브 선택</option>
                                            <option v-for="item in itemSubList" :key="item.iSubNo" :value="item.iSubNo">
                                                {{ item.iSubType }}
                                            </option>
                                        </select>
                                    </div>
                                </td>
                            </tr>
                            <tr>
                                <th>가격</th>
                                <td><input type="number" class="admin-product-edit-input" v-model="productInfo.productPrice"></td>
                            </tr>
                            <tr>
                                <th>재고</th>
                                <td><input type="number" class="admin-product-edit-input" v-model="productInfo.stockQty"></td>
                            </tr>
                            <tr>
                                <th>판매여부</th>
                                <td>
                                    <select class="admin-product-edit-select" v-model="productInfo.productStatus">
                                        <option value="Y">판매중</option>
                                        <option value="N">판매중지</option>
                                    </select>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <h4 class="admin-modal-subtitle">상품 이미지</h4>

                    <div class="admin-product-image-list">
                        <div class="admin-product-image-card">
                            <div class="admin-product-image-badge main">대표 이미지</div>
                            <div class="empty-box" v-if="!mainPreview">대표 이미지를 선택해주세요.</div>
                            <img v-else :src="mainPreview" class="admin-product-image" alt="대표 이미지 미리보기">
                            <input type="file" class="admin-product-file-input" accept="image/*" @change="fnChangeMainImage">
                        </div>

                        <div class="admin-product-image-card">
                            <div class="admin-product-image-badge detail">상세 이미지</div>
                            <div class="empty-box" v-if="!detailPreview">상세 이미지를 선택해주세요.</div>
                            <img v-else :src="detailPreview" class="admin-product-image" alt="상세 이미지 미리보기">
                            <input type="file" class="admin-product-file-input" accept="image/*" @change="fnChangeDetailImage">
                        </div>
                    </div>

                    <div class="approve-btn-box">
                        <button type="button" class="btn-reject" @click="fnGoList">목록</button>
                        <button type="button" class="btn-approve" @click="fnInsertProduct">등록</button>
                    </div>
                </div>
            </section>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/footer/footer.jsp" />

<script>
const app = Vue.createApp({
    data() {
        return {
            productInfo: {
                productName: "",
                brand: "",
                aMainNo: "",
                aSubNo: "",
                iMainNo: "",
                iSubNo: "",
                productPrice: "",
                stockQty: "",
                productStatus: "Y"
            },
            animalMainList: [],
            animalSubList: [],
            itemMainList: [],
            itemSubList: [],
            mainImageFile: null,
            detailImageFile: null,
            mainPreview: "",
            detailPreview: ""
        };
    },
    methods: {
        fnGetCategoryList: function () {
            let self = this;

            $.ajax({
                url: "/admin/product/category/list.dox",
                type: "POST",
                dataType: "json",
                data: {
                    aMainNo: self.productInfo.aMainNo,
                    iMainNo: self.productInfo.iMainNo
                },
                success: function (data) {
                    if (data.result === "success") {
                        self.animalMainList = data.animalMainList || [];
                        self.animalSubList = data.animalSubList || [];
                        self.itemMainList = data.itemMainList || [];
                        self.itemSubList = data.itemSubList || [];
                    } else {
                        alert(data.message || "카테고리 조회에 실패했습니다.");
                    }
                }
            });
        },
        fnChangeAnimalMain: function () {
            this.productInfo.aSubNo = "";
            this.fnGetCategoryList();
        },
        fnChangeItemMain: function () {
            this.productInfo.iSubNo = "";
            this.fnGetCategoryList();
        },
        fnChangeMainImage: function (event) {
            this.mainImageFile = event.target.files[0] || null;
            this.mainPreview = this.mainImageFile ? URL.createObjectURL(this.mainImageFile) : "";
        },
        fnChangeDetailImage: function (event) {
            this.detailImageFile = event.target.files[0] || null;
            this.detailPreview = this.detailImageFile ? URL.createObjectURL(this.detailImageFile) : "";
        },
        fnInsertProduct: function () {
            let self = this;

            if (!self.productInfo.productName) {
                alert("상품명을 입력해주세요.");
                return;
            }

            if (!self.productInfo.brand) {
                alert("브랜드를 입력해주세요.");
                return;
            }

            if (!self.productInfo.aSubNo) {
                alert("동물 카테고리를 선택해주세요.");
                return;
            }

            if (!self.productInfo.iSubNo) {
                alert("상품 카테고리를 선택해주세요.");
                return;
            }

            if (!self.productInfo.productPrice) {
                alert("가격을 입력해주세요.");
                return;
            }

            if (!self.productInfo.stockQty) {
                alert("재고를 입력해주세요.");
                return;
            }

            let formData = new FormData();

            formData.append("productName", self.productInfo.productName);
            formData.append("brand", self.productInfo.brand);
            formData.append("aSubNo", self.productInfo.aSubNo);
            formData.append("iSubNo", self.productInfo.iSubNo);
            formData.append("productPrice", self.productInfo.productPrice);
            formData.append("stockQty", self.productInfo.stockQty);
            formData.append("productStatus", self.productInfo.productStatus);

            if (self.mainImageFile) {
                formData.append("mainImageFile", self.mainImageFile);
            }

            if (self.detailImageFile) {
                formData.append("detailImageFile", self.detailImageFile);
            }

            $.ajax({
                url: "/admin/product/insert.dox",
                type: "POST",
                dataType: "json",
                data: formData,
                processData: false,
                contentType: false,
                success: function (data) {
                    if (data.result === "success") {
                        alert("상품이 등록되었습니다.");
                        location.href = "/admin/productManage.do";
                    } else {
                        alert(data.message || "상품 등록에 실패했습니다.");
                    }
                },
                error: function () {
                    alert("서버 통신 중 오류가 발생했습니다.");
                }
            });
        },
        fnGoList: function () {
            location.href = "/admin/productManage.do";
        }
    },
    mounted: function () {
        this.fnGetCategoryList();
    }
});

app.mount("#app");
</script>

</body>
</html>