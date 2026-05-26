<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>

    <!DOCTYPE html>
    <html lang="ko">

    <head>

        <!-- 문자 인코딩 -->
        <meta charset="UTF-8">

        <!-- 모바일 반응형 -->
        <meta name="viewport" content="width=device-width, initial-scale=1.0">

        <title>UNIPET - 반려동물 관리</title>

        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.7.1.js"></script>

        <!-- Vue -->
        <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

        <!-- 공통 페이지 이동 -->
        <script src="/js/page-change.js"></script>

        <!-- CSS -->
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css">

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/usermypage.css">

        <style>
            /* Vue 렌더링 전 숨김 */
            [v-cloak] {
                display: none;
            }
        </style>

    </head>

    <body>

        <!-- 헤더 -->
        <jsp:include page="/WEB-INF/header/header.jsp" />

        <!-- Vue 영역 -->
        <div id="app" class="user-page-wrap" v-cloak>

            <div class="user-page-container">

                <!-- 사이드바 -->
                <jsp:include page="/WEB-INF/user/Mypage/sidebar.jsp" />

                <!-- 본문 -->
                <main class="user-content">

                    <!-- 제목 -->
                    <div class="content-header">

                        <h1>반려동물 관리</h1>

                    </div>

                    <div class="page-inner">

                        <div class="section-box">

                            <!-- 상단 -->
                            <div class="section-header">

                                <div class="section-title" style="margin-bottom:0;">

                                    반려동물 프로필 관리

                                </div>

                                <!-- 추가 버튼 -->
                                <button class="small-btn" @click="fnOpenAddPetModal">

                                    프로필 추가

                                </button>

                            </div>

                            <!-- 반려동물 목록 -->
                            <div class="pet-list">

                                <div class="pet-card" v-for="pet in petList" :key="pet.petNo || pet.PET_NO">

                                    <!-- 프로필 이미지 -->
                                    <div class="pet-thumb">

                                        <div class="pet-avatar">

                                            <img :src="fnGetPetImage(pet)" alt="펫이미지">

                                        </div>

                                    </div>

                                    <!-- 프로필 내용 -->
                                    <div class="pet-body">

                                        <!-- 이름 -->
                                        <div class="pet-name">

                                            {{ pet.petName || pet.PET_NAME }}

                                        </div>

                                        <!-- 종 / 나이 -->
                                        <div class="pet-info">

                                            {{ pet.species || pet.SPECIES || '' }}

                                            <template v-if="pet.birthdate || pet.BIRTHDATE">

                                                ·
                                                {{ fnGetPetAge(pet.birthdate || pet.BIRTHDATE) }}살

                                            </template>

                                        </div>

                                        <!-- 버튼 -->
                                        <div class="pet-btns">

                                            <div class="pet-sub-btn-row">

                                                <!-- 수정 -->
                                                <button class="pet-btn edit" @click="fnOpenEditPetModal(pet)">

                                                    수정

                                                </button>

                                                <!-- 삭제 -->
                                                <button class="pet-btn delete"
                                                    @click="fnDeletePet(pet.petNo || pet.PET_NO)">

                                                    삭제

                                                </button>

                                            </div>

                                        </div>

                                    </div>

                                </div>

                            </div>

                        </div>

                    </div>

                </main>

            </div>

        </div>

        <!-- 푸터 -->
        <jsp:include page="/WEB-INF/footer/footer.jsp" />

        <script>

            // Vue 앱 생성
            const app = Vue.createApp({

                data() {

                    return {

                        // 반려동물 목록
                        petList: [],

                        // 모달 여부
                        showPetModal: false,

                        // 반려동물 폼
                        petForm: {

                            petNo: "",
                            petName: "",
                            species: "",
                            breed: "",
                            birthdate: "",
                            gender: ""

                        }

                    };

                },

                methods: {

                    // 반려동물 목록 조회
                    fnLoadPetList: function () {

                        let self = this;

                        let param = {};

                        $.ajax({

                            url: "/user/pet-list.dox",

                            dataType: "json",

                            type: "POST",

                            data: param,

                            success: function (data) {

                                self.petList =
                                    data.result === "success"
                                        ? (data.petList || [])
                                        : [];

                            },

                            error: function () {

                                self.petList = [];

                                alert("반려동물 목록 조회 실패");

                            }

                        });

                    },

                    // 반려동물 추가 모달 열기
                    fnOpenAddPetModal: function () {

                        this.petForm = {

                            petNo: "",
                            petName: "",
                            species: "",
                            breed: "",
                            birthdate: "",
                            gender: ""

                        };

                        this.showPetModal = true;

                    },

                    // 반려동물 수정 모달 열기
                    fnOpenEditPetModal: function (pet) {

                        this.petForm = {

                            petNo: pet.petNo || pet.PET_NO || "",
                            petName: pet.petName || pet.PET_NAME || "",
                            species: pet.species || pet.SPECIES || "",
                            breed: pet.breed || pet.BREED || "",
                            birthdate: pet.birthdate || pet.BIRTHDATE || "",
                            gender: pet.gender || pet.GENDER || ""

                        };

                        this.showPetModal = true;

                    },

                    // 반려동물 모달 닫기
                    fnClosePetModal: function () {

                        this.showPetModal = false;

                    },

                    // 반려동물 저장
                    fnSavePet: function () {

                        let self = this;

                        const url =
                            self.petForm.petNo
                                ? "/user/update-pet.dox"
                                : "/user/add-pet.dox";

                        $.ajax({

                            url: url,

                            type: "POST",

                            data: self.petForm,

                            success: function () {

                                self.showPetModal = false;

                                self.fnLoadPetList();

                            },

                            error: function () {

                                alert("반려동물 저장 실패");

                            }

                        });

                    },

                    // 반려동물 삭제
                    fnDeletePet: function (petNo) {

                        let self = this;

                        if (!confirm("삭제하시겠습니까?")) {

                            return;

                        }

                        $.ajax({

                            url: "/user/delete-pet.dox",

                            type: "POST",

                            data: {
                                petNo: petNo
                            },

                            success: function () {

                                self.fnLoadPetList();

                            },

                            error: function () {

                                alert("반려동물 삭제 실패");

                            }

                        });

                    },

                    // 반려동물 이미지
                    // 반려동물 이미지
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
                    // 반려동물 나이 계산
                    fnGetPetAge: function (birthdate) {

                        if (!birthdate) {

                            return "-";

                        }

                        const age =
                            new Date().getFullYear()
                            - new Date(birthdate).getFullYear();

                        return isNaN(age)
                            ? "-"
                            : age;

                    }

                },

                // 시작 시 실행
                mounted() {

                    this.fnLoadPetList();

                }

            });

            app.mount("#app");

        </script>

    </body>

    </html>