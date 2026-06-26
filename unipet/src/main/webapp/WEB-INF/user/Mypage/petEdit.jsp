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

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/usermypage.css">
</head>

<body>

<jsp:include page="/WEB-INF/header/header.jsp" />

<div id="app" class="user-page-wrap" v-cloak>

    <div class="user-page-container">

        <jsp:include page="/WEB-INF/user/Mypage/sidebar.jsp">
            <jsp:param name="activeMenu" value="pet" />
        </jsp:include>

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

                                    <button class="btn-main-gray" v-else disabled>
                                        대표동물
                                    </button>

                                    <button class="btn-edit" @click="fnOpenEditPetModal(pet)">
                                        수정
                                    </button>

                                    <button class="btn-delete" @click="fnDeletePet(pet.petNo || pet.PET_NO)">
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
                <select v-model="petForm.species" @change="fnChangeSpecies">
                    <option value="">선택</option>
                    <option value="강아지">강아지</option>
                    <option value="고양이">고양이</option>
                    <option value="조류">조류</option>
                    <option value="어류">어류</option>
                </select>
            </div>

            <div class="form-row">
                <label>품종</label>

                <input type="text"
                       v-model="breedKeyword"
                       @input="fnSearchBreed"
                       @keydown.down.prevent="fnMoveDown"
                       @keydown.up.prevent="fnMoveUp"
                       @keydown.enter.prevent="fnSelectByEnter"
                       placeholder="예: 말티즈"
                       autocomplete="off">

                <div v-if="breedList.length > 0" class="breed-list">
                    <div v-for="(item, index) in breedList"
                         :key="item.BREED_NO"
                         class="breed-item"
                         :class="{ active: index === selectedBreedIndex }"
                         @click="fnSelectBreed(item)">
                        {{ item.BREED_NAME }}
                    </div>
                </div>

                <div v-if="selectedBreedCaution === 'Y'" class="breed-caution-box">
                    <span class="guide-icon">⚠️</span>
                    <span>
                        선택하신 품종은 사육 시 주의가 필요한 품종입니다.
                        관련 법령 및 지자체 규정을 확인한 후 등록해주세요.
                    </span>
                </div>
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
                    <option value="N">중성화</option>
                </select>
            </div>

            <div class="form-row check-row">
                <label>
                    <input type="checkbox" v-model="petForm.isMain" true-value="Y" false-value="N">
                    대표 동물로 설정
                </label>
            </div>

            <div class="form-row check-row">
                <label>
                    <input type="checkbox" v-model="petForm.agreePolicy">
                    등록하는 반려동물 정보는 사실이며, 허위 정보 또는 사육이 제한된 동물을 등록하여 발생하는 모든 책임은 사용자 본인에게 있음을 확인합니다.
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
                breedList: [],
                breedKeyword: "",
                selectedBreedIndex: -1,
                selectedBreedCaution: "N",
                showPetModal: false,

                petForm: {
                    petNo: "",
                    petName: "",
                    species: "",
                    breed: "",
                    breedNo: "",
                    birthdate: "",
                    gender: "",
                    isMain: "N",
                    agreePolicy: false
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
                        if (data.result === "success") {
                            self.petList = (data.petList || []).sort(function (a, b) {
                                const aMain = (a.isMain || a.IS_MAIN) === "Y";
                                const bMain = (b.isMain || b.IS_MAIN) === "Y";

                                if (aMain && !bMain) return -1;
                                if (!aMain && bMain) return 1;
                                return 0;
                            });
                        } else {
                            self.petList = [];
                        }
                    },
                    error: function () {
                        self.petList = [];
                        alert("반려동물 목록 조회 실패");
                    }
                });
            },

            fnChangeSpecies: function () {
                this.petForm.breed = "";
                this.petForm.breedNo = "";
                this.breedKeyword = "";
                this.breedList = [];
                this.selectedBreedIndex = -1;
                this.selectedBreedCaution = "N";
            },

            fnSearchBreed: function () {
                let self = this;

                self.petForm.breed = "";
                self.petForm.breedNo = "";
                self.breedList = [];
                self.selectedBreedIndex = -1;
                self.selectedBreedCaution = "N";

                if (!self.petForm.species) {
                    alert("동물 종류를 먼저 선택해주세요.");
                    self.breedKeyword = "";
                    return;
                }

                const keyword = self.breedKeyword.trim();

                if (keyword.length < 1) {
                    return;
                }

                $.ajax({
                    url: "/user/breed-list.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        speciesNo: self.fnGetSpeciesNo(self.petForm.species),
                        keyword: keyword
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            self.breedList = data.list || [];

                            if (self.breedList.length > 0) {
                                self.selectedBreedIndex = 0;
                            }
                        } else {
                            self.breedList = [];
                        }
                    },
                    error: function () {
                        self.breedList = [];
                        alert("품종 검색 실패");
                    }
                });
            },

            fnSelectBreed: function (item) {
                this.petForm.breedNo = item.BREED_NO;
                this.petForm.breed = item.BREED_NAME;
                this.breedKeyword = item.BREED_NAME;
                this.selectedBreedCaution = item.CAUTION || "N";
                this.breedList = [];
                this.selectedBreedIndex = -1;
            },

            fnMoveDown: function () {
                if (this.breedList.length === 0) return;

                if (this.selectedBreedIndex < this.breedList.length - 1) {
                    this.selectedBreedIndex++;
                } else {
                    this.selectedBreedIndex = 0;
                }
            },

            fnMoveUp: function () {
                if (this.breedList.length === 0) return;

                if (this.selectedBreedIndex > 0) {
                    this.selectedBreedIndex--;
                } else {
                    this.selectedBreedIndex = this.breedList.length - 1;
                }
            },

            fnSelectByEnter: function () {
                if (this.breedList.length === 0) return;

                if (this.selectedBreedIndex < 0) {
                    this.selectedBreedIndex = 0;
                }

                this.fnSelectBreed(this.breedList[this.selectedBreedIndex]);
            },

            fnGetSpeciesNo: function (species) {
                if (species === "강아지") return 1;
                if (species === "고양이") return 2;
                if (species === "조류") return 3;
                if (species === "어류") return 4;
                return 0;
            },

            fnOpenAddPetModal: function () {
                this.petForm = {
                    petNo: "",
                    petName: "",
                    species: "",
                    breed: "",
                    breedNo: "",
                    birthdate: "",
                    gender: "",
                    isMain: "N",
                    agreePolicy: false
                };

                this.breedKeyword = "";
                this.breedList = [];
                this.selectedBreedIndex = -1;
                this.selectedBreedCaution = "N";
                this.showPetModal = true;
            },

            fnOpenEditPetModal: function (pet) {
                const originBreed = pet.breed || pet.BREED || "";

                this.petForm = {
                    petNo: pet.petNo || pet.PET_NO || "",
                    petName: pet.petName || pet.PET_NAME || "",
                    species: pet.species || pet.SPECIES || "",
                    breed: originBreed,
                    breedNo: pet.breedNo || pet.BREED_NO || "",
                    birthdate: this.fnFormatDate(pet.birthdate || pet.BIRTHDATE),
                    gender: pet.gender || pet.GENDER || "",
                    isMain: pet.isMain || pet.IS_MAIN || "N",
                    agreePolicy: true
                };

                this.breedKeyword = originBreed;
                this.breedList = [];
                this.selectedBreedIndex = -1;
                this.selectedBreedCaution = "N";
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

                if (!self.petForm.breedNo) {
                    alert("품종은 자동완성 목록에서 선택해주세요.");
                    return;
                }

                if (!self.petForm.gender) {
                    alert("성별을 선택해주세요.");
                    return;
                }

                if (!self.petForm.agreePolicy) {
                    alert("반려동물 등록 책임 확인에 동의해주세요.");
                    return;
                }

                if (!self.petForm.petNo) {
                    const agree = confirm(
                        "[반려동물 등록 안내]\n\n" +
                        "회원은 등록하는 반려동물의 적법성 및 사육 가능 여부를 직접 확인해야 합니다.\n\n" +
                        "사육이 제한되거나 허가가 필요한 동물을 등록하는 경우 발생하는 모든 책임은 등록한 회원에게 있습니다.\n\n" +
                        "UniPet은 등록 정보의 적법성을 보증하지 않으며,\n" +
                        "관련 법적 책임을 부담하지 않습니다.\n\n" +
                        "확인을 누르면 등록을 계속 진행합니다."
                    );

                    if (!agree) {
                        return;
                    }
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
                    data: { petNo: petNo },
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
                    data: { petNo: petNo },
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

                if (species === "고양이") return "/img/user/pet/cat.png";
                if (species === "강아지") return "/img/user/pet/dog.png";
                if (species === "조류") return "/img/user/pet/bird.png";
                if (species === "어류") return "/img/user/pet/fish.png";

                return "/img/user/pet/etc.png";
            },

            fnFormatDate: function (dateStr) {
                if (!dateStr) return "";
                return String(dateStr).substring(0, 10);
            },

            fnGenderText: function (gender) {
                gender = String(gender || "").trim();

                if (gender === "M") return "수컷";
                if (gender === "F") return "암컷";
                if (gender === "N") return "중성화";

                return "-";
            },

            fnGetPetAge: function (birthdate) {
                if (!birthdate) return "-";

                const birth = new Date(String(birthdate).substring(0, 10));
                const today = new Date();

                let age = today.getFullYear() - birth.getFullYear();

                if (
                    today.getMonth() < birth.getMonth() ||
                    (today.getMonth() === birth.getMonth() &&
                        today.getDate() < birth.getDate())
                ) {
                    age--;
                }

                if (age < 0) age = 0;

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