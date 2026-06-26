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
                    <h2>상품 수정</h2>
                    <div class="content-desc">상품 기본 정보와 등록된 이미지를 조회합니다.</div>

                    <div v-if="productInfo">
                        <table class="approve-table">
                            <tbody>
                                <tr><th>상품번호</th><td>{{ productInfo.productNo }}</td></tr>
                                <tr><th>상품명</th><td>{{ fnEmpty(productInfo.productName) }}</td></tr>
                                <tr><th>브랜드</th><td>{{ fnEmpty(productInfo.brand) }}</td></tr>
                                <tr><th>동물 카테고리</th><td>{{ fnCategory(productInfo.aMainType, productInfo.aSubType) }}</td></tr>
                                <tr><th>상품 카테고리</th><td>{{ fnCategory(productInfo.iMainType, productInfo.iSubType) }}</td></tr>
                                <tr><th>가격</th><td><input type="number" class="admin-product-edit-input" v-model="productInfo.productPrice"></td></tr>
                                <tr><th>재고</th><td><input type="number" class="admin-product-edit-input" v-model="productInfo.stockQty"></td></tr>
                                <tr>
                                    <th>상태</th>
                                    <td>
                                        <select class="admin-product-edit-select" v-model="productInfo.productStatus">
                                            <option value="Y">판매중</option>
                                            <option value="N">판매중지</option>
                                        </select>
                                    </td>
                                </tr>
                                <tr><th>등록일</th><td>{{ fnEmpty(productInfo.cdate) }}</td></tr>
                            </tbody>
                        </table>

                        <h4 class="admin-modal-subtitle">상품 이미지</h4>

                        <div class="admin-product-image-list">
                            <div class="admin-product-image-card">
                                <div class="admin-product-image-badge main">대표 이미지</div>

                                <img v-if="mainImage" :src="mainImage.filePath" class="admin-product-image" alt="대표 이미지" @click="fnOpenImage(mainImage.filePath)">
                                <div class="empty-box" v-else>대표 이미지가 없습니다.</div>

                                <input type="file" class="admin-product-file-input" accept="image/*" @change="fnChangeMainImage">
                            </div>

                            <div class="admin-product-image-card">
                                <div class="admin-product-image-badge detail">상세 이미지</div>

                                <img v-if="detailImage" :src="detailImage.filePath" class="admin-product-image" alt="상세 이미지" @click="fnOpenImage(detailImage.filePath)">
                                <div class="empty-box" v-else>상세 이미지가 없습니다.</div>

                                <input type="file" class="admin-product-file-input" accept="image/*" @change="fnChangeDetailImage">
                            </div>
                        </div>
                        <div class="approve-btn-box">
                            <button type="button" class="btn-reject" @click="fnGoList">목록</button>
                            <button type="button" class="btn-approve" @click="fnSaveProduct">저장</button>
                        </div>
                    </div>

                    <div class="empty-box" v-else>
                        상품 정보를 불러오는 중입니다.
                    </div>
                </div>
            </section>
            </div>

            <div class="admin-image-modal" v-if="selectedImagePath" @click="fnCloseImage">
                <div class="admin-image-modal-box" @click.stop>
                    <button type="button" class="admin-image-modal-close" @click="fnCloseImage">×</button>
                    <img :src="selectedImagePath" class="admin-image-modal-img" alt="상품 이미지 크게 보기">
                </div>
            </div>
        </div>
</div>

<jsp:include page="/WEB-INF/footer/footer.jsp" />

<script>
const app = Vue.createApp({
    data() {
        return {
            productNo: "${productNo}",
            productInfo: null,
            fileList: [],
            mainImageFile: null,
            detailImageFile: null,
            selectedImagePath: null
        };
    },
    computed: {
        mainImage: function () {
            return this.fileList.find(function (item) {
                return item.isMain === "Y";
            }) || null;
        },
        detailImage: function () {
            return this.fileList.find(function (item) {
                return item.isDetail === "Y";
            }) || null;
        }
    },
    methods: {
        fnGetProductDetail: function () {
            let self = this;

            $.ajax({
                url: "/admin/product/detail.dox",
                type: "POST",
                dataType: "json",
                data: {
                    productNo: self.productNo
                },
                success: function (data) {
                    if (data.result === "success") {
                        self.productInfo = data.info;
                        self.fileList = data.fileList || [];
                    } else {
                        alert(data.message || "상품 상세 조회 중 오류가 발생했습니다.");
                    }
                }
            });
        },
        fnChangeMainImage: function (event) {
            this.mainImageFile = event.target.files[0] || null;
        },
        fnChangeDetailImage: function (event) {
            this.detailImageFile = event.target.files[0] || null;
        },
        fnProductStatus: function (status) {
            if (status === "Y") {
                return "판매중";
            }

            if (status === "N") {
                return "판매중지";
            }

            return "-";
        },
        fnPrice: function (value) {
            if (value == null || value === "") {
                return "-";
            }

            return Number(value).toLocaleString() + "원";
        },
        fnEmpty: function (value) {
            if (value == null || value === "") {
                return "-";
            }

            return value;
        },
        fnCategory: function (mainType, subType) {
            if ((mainType == null || mainType === "") && (subType == null || subType === "")) {
                return "-";
            }

            if (mainType == null || mainType === "") {
                return subType;
            }

            if (subType == null || subType === "") {
                return mainType;
            }

            return mainType + " - " + subType;
        },
        fnOpenImage: function (imagePath) {
            this.selectedImagePath = imagePath;
        },
        fnCloseImage: function () {
            this.selectedImagePath = null;
        },
        fnSaveProduct: function () {
            let self = this;
            let formData = new FormData();

            formData.append("productNo", self.productInfo.productNo);
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
                url: "/admin/product/update.dox",
                type: "POST",
                dataType: "json",
                data: formData,
                processData: false,
                contentType: false,
                success: function (data) {
                    if (data.result === "success") {
                        alert("상품 정보가 수정되었습니다.");
                        location.href = "/admin/productManage.do";
                    } else {
                        alert(data.message || "상품 수정에 실패했습니다.");
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
        this.fnGetProductDetail();
    }
});

app.mount("#app");
</script>

</body>
</html>