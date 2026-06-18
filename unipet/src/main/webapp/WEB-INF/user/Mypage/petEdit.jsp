<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

<!DOCTYPE html>
<html lang="ko">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNIPET - 반려동물 관리</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/usermypage.css">
</head>

<body>

<jsp:include page="/WEB-INF/header/header.jsp" />

<div id="app" class="user-page-wrap" v-cloak>

    <div class="user-page-container">

        <jsp:include page="/WEB-INF/user/Mypage/sidebar.jsp" />

        <main class="user-content">

            <div class="content-header">
                <h1>반려동물 관리</h1>
            </div>

            <div class="page-inner">

                <div class="section-box">

                    <div class="section-header">
                        <div class="section-title" style="margin-bottom:0;">
                            반려동물 프로필 관리
                        </div>

                        <button class="small-btn" @click="fnOpenAddPetModal">
                            프로필 추가
                        </button>
                    </div>

                    <div class="pet-profile-list">

                        <div class="pet-profile-card"
                             v-for="pet in petList"
                             :key="pet.petNo || pet.PET_NO"
                             :class="{'main-pet-card': (pet.isMain || pet.IS_MAIN) === 'Y'}">

                            <div class="pet-profile-img-area">
                                <div class="pet-profile-img">
                                    <img :src="fnGetPetImage(pet)" alt="펫이미지">
                                </div>
                            </div>

                            <div class="pet-profile-content">

                                <div class="pet-profile-top">
                                    <div class="pet-profile-name">
                                        {{ pet.petName || pet.PET_NAME || '-' }}

                                        <span v-if="(pet.isMain || pet.IS_MAIN) === 'Y'" class="main-badge">
                                            대표동물
                                        </span>
                                    </div>
                                </div>

                                <div class="pet-info-grid">

                                    <div class="pet-info-item">
                                        <span class="pet-info-label">이름</span>
                                        {{ pet.petName || pet.PET_NAME || '-' }}
                                    </div>

                                    <div class="pet-info-item">
                                        <span class="pet-info-label">종류</span>
                                        {{ pet.species || pet.SPECIES || '-' }}
                                    </div>

                                    <div class="pet-info-item">
                                        <span class="pet-info-label">품종</span>
                                        {{ pet.breed || pet.BREED || '-' }}
                                    </div>

                                    <div class="pet-info-item">
                                        <span class="pet-info-label">성별</span>
                                        {{ fnGenderText(pet.gender || pet.GENDER) }}
                                    </div>

                                    <div class="pet-info-item">
                                        <span class="pet-info-label">생년월일</span>
                                        {{ fnFormatDate(pet.birthdate || pet.BIRTHDATE) }}
                                    </div>

                                    <div class="pet-info-item">
                                        <span class="pet-info-label">나이</span>
                                        {{ fnGetPetAge(pet.birthdate || pet.BIRTHDATE) }}살
                                    </div>

                                    <div class="pet-info-item">
                                        <span class="pet-info-label">대표여부</span>
                                        {{ (pet.isMain || pet.IS_MAIN) === 'Y' ? '대표동물' : '일반' }}
                                    </div>

                                </div>

                                <div class="pet-profile-btns">

                                    <button class="btn-main"
                                            v-if="(pet.isMain || pet.IS_MAIN) !== 'Y'"
                                            @click="fnChangeMainPet(pet.petNo || pet.PET_NO)">
                                        대표설정
                                    </button>

                                    <button class="btn-main-gray"
                                            v-else
                                            disabled>
                                        대표동물
                                    </button>

                                    <button class="btn-edit" @click="fnOpenEditPetModal(pet)">
                                        수정
                                    </button>

                                    <button class="btn-delete"
                                            @click="fnDeletePet(pet.petNo || pet.PET_NO)">
                                        삭제
                                    </button>

                                </div>

                            </div>

                        </div>

                    </div>

                    <div v-if="petList.length === 0" class="empty-text">
                        등록된 반려동물이 없습니다.
                    </div>

                </div>

            </div>

        </main>

    </div>

    <!-- 반려동물 등록/수정 모달 -->
    <div class="modal-wrap" v-if="showPetModal">

        <div class="modal-box">

            <div class="modal-title">
                {{ petForm.petNo ? '반려동물 수정' : '반려동물 등록' }}
            </div>

            <div class="form-row">
                <label>이름</label>
                <input type="text" v-model="petForm.petName" placeholder="반려동물 이름">
            </div>

            <div class="form-row">
                <label>종류</label>
                <select v-model="petForm.species">
                    <option value="">선택</option>
                    <option value="강아지">강아지</option>
                    <option value="고양이">고양이</option>
                    <option value="조류">조류</option>
                    <option value="어류">어류</option>
                    <option value="기타">기타</option>
                </select>
            </div>

            <div class="form-row">
                <label>품종</label>
                <input type="text" v-model="petForm.breed" placeholder="품종">
            </div>

            <div class="form-row">
                <label>생년월일</label>
                <input type="date" v-model="petForm.birthdate">
            </div>

            <div class="form-row">
                <label>성별</label>
                <select v-model="petForm.gender">
                    <option value="">선택</option>
                    <option value="M">수컷</option>
                    <option value="F">암컷</option>
                </select>
            </div>

            <div class="form-row check-row">
                <label>
                    <input type="checkbox"
                           v-model="petForm.isMain"
                           true-value="Y"
                           false-value="N">
                    대표 동물로 설정
                </label>
            </div>

            <div class="modal-btns">
                <button type="button" class="btn-cancel" @click="fnClosePetModal">
                    취소
                </button>

                <button type="button" class="btn-save" @click="fnSavePet">
                    저장
                </button>
            </div>

        </div>

    </div>

</div>

<jsp:include page="/WEB-INF/footer/footer.jsp" />

<script>
    const app = Vue.createApp({

        data() {
            return {
                petList: [],
                showPetModal: false,

                petForm: {
                    petNo: "",
                    petName: "",
                    species: "",
                    breed: "",
                    birthdate: "",
                    gender: "",
                    isMain: "N"
                }
            };
        },

        methods: {

            fnLoadPetList: function () {
                let self = this;

                $.ajax({
                    url: "/user/pet-list.dox",
                    dataType: "json",
                    type: "POST",
                    data: {},
                    success: function (data) {
                        self.petList = data.result === "success" ? (data.petList || []) : [];
                    },
                    error: function () {
                        self.petList = [];
                        alert("반려동물 목록 조회 실패");
                    }
                });
            },

            fnOpenAddPetModal: function () {
                this.petForm = {
                    petNo: "",
                    petName: "",
                    species: "",
                    breed: "",
                    birthdate: "",
                    gender: "",
                    isMain: "N"
                };

                this.showPetModal = true;
            },

            fnOpenEditPetModal: function (pet) {
                this.petForm = {
                    petNo: pet.petNo || pet.PET_NO || "",
                    petName: pet.petName || pet.PET_NAME || "",
                    species: pet.species || pet.SPECIES || "",
                    breed: pet.breed || pet.BREED || "",
                    birthdate: this.fnFormatDate(pet.birthdate || pet.BIRTHDATE),
                    gender: pet.gender || pet.GENDER || "",
                    isMain: pet.isMain || pet.IS_MAIN || "N"
                };

                this.showPetModal = true;
            },

            fnClosePetModal: function () {
                this.showPetModal = false;
            },

            fnSavePet: function () {
                let self = this;

                if (!self.petForm.petName) {
                    alert("반려동물 이름을 입력해주세요.");
                    return;
                }

                if (!self.petForm.species) {
                    alert("반려동물 종류를 선택해주세요.");
                    return;
                }

                const url = self.petForm.petNo
                    ? "/user/update-pet.dox"
                    : "/user/add-pet.dox";

                $.ajax({
                    url: url,
                    type: "POST",
                    dataType: "json",
                    data: self.petForm,
                    success: function (res) {
                        alert(res.message || "저장되었습니다.");

                        if (res.result === "success") {
                            self.showPetModal = false;
                            self.fnLoadPetList();
                        }
                    },
                    error: function () {
                        alert("반려동물 저장 실패");
                    }
                });
            },

            fnChangeMainPet: function (petNo) {
                let self = this;

                if (!confirm("대표 동물로 설정하시겠습니까?")) {
                    return;
                }

                $.ajax({
                    url: "/user/change-main-pet.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        petNo: petNo
                    },
                    success: function (res) {
                        alert(res.message || "대표동물이 변경되었습니다.");
                        self.fnLoadPetList();
                    },
                    error: function () {
                        alert("대표동물 변경 실패");
                    }
                });
            },

            fnDeletePet: function (petNo) {
                let self = this;

                if (!confirm("삭제하시겠습니까?")) {
                    return;
                }

                $.ajax({
                    url: "/user/delete-pet.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        petNo: petNo
                    },
                    success: function (res) {
                        alert(res.message || "삭제되었습니다.");
                        self.fnLoadPetList();
                    },
                    error: function () {
                        alert("반려동물 삭제 실패");
                    }
                });
            },

            fnGetPetImage: function (pet) {
                if (pet.petImg || pet.PET_IMG) {
                    return pet.petImg || pet.PET_IMG;
                }

                const species = pet.species || pet.SPECIES || "";

                if (species === "고양이") {
                    return "/img/user/pet/cat.png";
                }

                if (species === "강아지") {
                    return "/img/user/pet/dog.png";
                }

                if (species === "조류") {
                    return "/img/user/pet/bird.png";
                }

                if (species === "어류") {
                    return "/img/user/pet/fish.png";
                }

                return "/img/user/pet/etc.png";
            },

            fnFormatDate: function (dateStr) {
                if (!dateStr) {
                    return "";
                }

                return String(dateStr).substring(0, 10);
            },

            fnGenderText: function (gender) {
                if (gender === "M") {
                    return "수컷";
                }

                if (gender === "F") {
                    return "암컷";
                }

                return "-";
            },

            fnGetPetAge: function (birthdate) {
                if (!birthdate) {
                    return "-";
                }

                const birth = new Date(birthdate);
                const today = new Date();

                if (isNaN(birth.getTime())) {
                    return "-";
                }

                let age = today.getFullYear() - birth.getFullYear();

                const monthDiff = today.getMonth() - birth.getMonth();
                const dayDiff = today.getDate() - birth.getDate();

                if (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)) {
                    age--;
                }

                return age;
            }
        },

        mounted() {
            this.fnLoadPetList();
        }
    });

    app.mount("#app");
</script>

</body>
</html>