<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNIPET - 반려동물 건강관리</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <script src="/js/page-change.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/footer.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/usermypage.css">

    <style>
        [v-cloak] { display:none; }
    </style>
</head>

<body>
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app" class="user-page-wrap" v-cloak>
        <div class="user-page-container">

            <jsp:include page="/WEB-INF/user/Mypage/sidebar.jsp" />

            <main class="user-content">
                <div class="content-header">
                    <h1>반려동물 건강관리</h1>
                </div>

                <div class="page-inner">

                    <!-- 반려동물 선택 -->
                    <div class="section-box">
                        <div class="section-title">반려동물 선택</div>

                        <div class="pet-list">
                            <div class="pet-card"
                                 v-for="pet in petList"
                                 :key="pet.petNo || pet.PET_NO"
                                 :class="{ active: String(selectedPetNo) === String(pet.petNo || pet.PET_NO) }"
                                 @click="fnSelectPet(pet)">

                                <div class="pet-thumb">
                                    <div class="pet-avatar">
                                        <img :src="fnGetPetImage(pet)" alt="펫이미지">
                                    </div>
                                </div>

                                <div class="pet-body">
                                    <div class="pet-name">
                                        {{ pet.petName || pet.PET_NAME || '-' }}
                                    </div>

                                    <div class="pet-info">
                                        {{ pet.species || pet.SPECIES || '' }}
                                        <template v-if="pet.birthdate || pet.BIRTHDATE">
                                            · {{ fnGetPetAge(pet.birthdate || pet.BIRTHDATE) }}살
                                        </template>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- 탭 -->
                    <div class="section-box">
                        <div class="health-tabs">
                            <button class="small-btn"
                                    :class="{active: healthTab === 'health'}"
                                    @click="healthTab='health'; fnLoadHealthList();">
                                건강기록 등록
                            </button>

                            <button class="small-btn"
                                    :class="{active: healthTab === 'weight'}"
                                    @click="healthTab='weight'; fnLoadWeightList();">
                                몸무게 등록
                            </button>

                            <button class="small-btn"
                                    :class="{active: healthTab === 'vaccine'}"
                                    @click="healthTab='vaccine'; fnLoadVaccineList();">
                                백신기록 등록
                            </button>
                        </div>
                    </div>

                    <!-- 건강기록 -->
                    <div v-if="healthTab === 'health'">
                        <div class="section-box">
                            <div class="section-title">건강 기록 등록</div>

                            <div class="row">
                                <label>제목</label>
                                <input type="text" v-model="healthForm.title">
                            </div>

                            <div class="row">
                                <label>기록일</label>
                                <input type="date" v-model="healthForm.date">
                            </div>

                            <div class="row">
                                <label>내용</label>
                                <textarea v-model="healthForm.memo"></textarea>
                            </div>

                            <div class="btn-box">
                                <button @click="fnSaveHealthRecord">등록</button>
                            </div>
                        </div>

                        <div class="section-box">
                            <div class="section-title">건강 기록 목록</div>

                            <div v-if="healthList.length === 0" class="empty-text">
                                건강 기록이 없습니다.
                            </div>

                            <div class="info-card" v-for="item in healthList" :key="item.id || item.healthNo">
                                <div class="list-title">{{ item.title || '-' }}</div>
                                <div class="list-sub">반려동물 : {{ item.petName || '-' }}</div>
                                <div class="list-sub">기록일 : {{ fnFormatDate(item.date) }}</div>
                                <div class="list-sub">내용 : {{ item.memo || '-' }}</div>
                            </div>
                        </div>
                    </div>

                    <!-- 몸무게 -->
                    <div v-if="healthTab === 'weight'">
                        <div class="section-box">
                            <div class="section-title">몸무게 등록</div>

                            <div class="row">
                                <label>몸무게(kg)</label>
                                <input type="text" v-model="weightForm.weight">
                            </div>

                            <div class="row">
                                <label>기록일</label>
                                <input type="date" v-model="weightForm.date">
                            </div>

                            <div class="row">
                                <label>비고</label>
                                <textarea v-model="weightForm.memo"></textarea>
                            </div>

                            <div class="btn-box">
                                <button @click="fnSaveWeightRecord">등록</button>
                            </div>
                        </div>

                        <div class="section-box">
                            <div class="section-title">몸무게 변화 차트</div>
                            <div class="chart-wrap">
                                <canvas id="weightChart"></canvas>
                            </div>
                        </div>

                        <div class="section-box">
                            <div class="section-title">몸무게 기록 목록</div>

                            <div v-if="weightList.length === 0" class="empty-text">
                                몸무게 기록이 없습니다.
                            </div>

                            <div class="info-card" v-for="item in weightList" :key="item.id || item.weightNo">
                                <div class="list-title">{{ item.weight }} kg</div>
                                <div class="list-sub">반려동물 : {{ item.petName || '-' }}</div>
                                <div class="list-sub">기록일 : {{ fnFormatDate(item.date) }}</div>
                                <div class="list-sub">비고 : {{ item.memo || '-' }}</div>
                            </div>
                        </div>
                    </div>

                    <!-- 백신 -->
                    <div v-if="healthTab === 'vaccine'">
                        <div class="section-box">
                            <div class="section-title">백신 기록 등록</div>

                            <div class="row">
                                <label>백신명</label>
                                <input type="text" v-model="vacForm.name">
                            </div>

                            <div class="row">
                                <label>접종일</label>
                                <input type="date" v-model="vacForm.date">
                            </div>

                            <div class="row">
                                <label>다음 접종일</label>
                                <input type="date" v-model="vacForm.nextDate">
                            </div>

                            <div class="row">
                                <label>병원명</label>
                                <input type="text" v-model="vacForm.hospitalName">
                            </div>

                            <div class="row">
                                <label>비고</label>
                                <textarea v-model="vacForm.memo"></textarea>
                            </div>

                            <div class="btn-box">
                                <button @click="fnSaveVacRecord">등록</button>
                            </div>
                        </div>

                        <div class="section-box">
                            <div class="section-title">백신 기록 목록</div>

                            <div v-if="vacList.length === 0" class="empty-text">
                                백신 기록이 없습니다.
                            </div>

                            <div class="info-card" v-for="item in vacList" :key="item.id || item.vacNo">
                                <div class="list-title">{{ item.name || item.vacName || '-' }}</div>
                                <div class="list-sub">반려동물 : {{ item.petName || '-' }}</div>
                                <div class="list-sub">접종일 : {{ fnFormatDate(item.date || item.vacDate) }}</div>
                                <div class="list-sub">
                                    다음 접종일 : {{ item.nextDate || item.nextVacDate ? fnFormatDate(item.nextDate || item.nextVacDate) : '-' }}
                                </div>
                                <div class="list-sub">병원명 : {{ item.hospitalName || '-' }}</div>
                                <div class="list-sub">비고 : {{ item.memo || '-' }}</div>

                                <div class="btn-box">
                                    <button class="btn-red" @click="fnDeleteVaccine(item.id || item.vacNo)">
                                        삭제
                                    </button>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </main>
        </div>
    </div>

    <jsp:include page="/WEB-INF/footer/footer.jsp" />
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                petList: [],
                selectedPetNo: "",
                healthTab: "health",

                healthList: [],
                weightList: [],
                vacList: [],

                weightChart: null,

                healthForm: {
                    title: "",
                    date: "",
                    memo: ""
                },

                weightForm: {
                    weight: "",
                    date: "",
                    memo: ""
                },

                vacForm: {
                    name: "",
                    date: "",
                    nextDate: "",
                    hospitalName: "",
                    memo: ""
                }
            };
        },

        methods: {
            fnLoadPetList: function () {
                let self = this;

                $.ajax({
                    url: "/user/pet-list.dox",
                    type: "POST",
                    dataType: "json",
                    data: {},
                    success: function (data) {
                        self.petList = data.result === "success" ? (data.petList || []) : [];

                        if (!self.selectedPetNo && self.petList.length > 0) {
                            self.selectedPetNo = self.petList[0].petNo || self.petList[0].PET_NO;
                        }

                        self.fnLoadHealthList();
                        self.fnLoadWeightList();
                        self.fnLoadVaccineList();
                    },
                    error: function () {
                        self.petList = [];
                    }
                });
            },

            fnSelectPet: function (pet) {
                this.selectedPetNo = pet.petNo || pet.PET_NO;

                this.fnLoadHealthList();
                this.fnLoadWeightList();
                this.fnLoadVaccineList();
            },

            fnLoadHealthList: function () {
                if (!this.selectedPetNo) return;

                let self = this;

                $.ajax({
                    url: "/user/health-list.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        petNo: self.selectedPetNo
                    },
                    success: function (data) {
                        self.healthList = data.result === "success" ? (data.healthList || []) : [];
                    },
                    error: function () {
                        self.healthList = [];
                    }
                });
            },

            fnLoadWeightList: function () {
                if (!this.selectedPetNo) return;

                let self = this;

                $.ajax({
                    url: "/user/weight-list.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        petNo: self.selectedPetNo
                    },
                    success: function (data) {
                        self.weightList = data.result === "success" ? (data.weightList || []) : [];

                        setTimeout(function () {
                            self.fnDrawWeightChart();
                        }, 100);
                    },
                    error: function () {
                        self.weightList = [];
                    }
                });
            },

            fnLoadVaccineList: function () {
                if (!this.selectedPetNo) return;

                let self = this;

                $.ajax({
                    url: "/user/vaccine-list.dox",
                    type: "POST",
                    dataType: "json",
                    data: {
                        petNo: self.selectedPetNo
                    },
                    success: function (data) {
                        self.vacList = data.result === "success" ? (data.vaccineList || data.vacList || []) : [];
                    },
                    error: function () {
                        self.vacList = [];
                    }
                });
            },

            fnSaveHealthRecord: function () {
                if (!this.selectedPetNo) {
                    alert("반려동물을 선택해주세요.");
                    return;
                }

                let self = this;

                $.ajax({
                    url: "/user/add-health.dox",
                    type: "POST",
                    data: {
                        petNo: self.selectedPetNo,
                        title: self.healthForm.title,
                        date: self.healthForm.date,
                        memo: self.healthForm.memo
                    },
                    success: function (data) {
                        alert(data.message || "건강 기록이 등록되었습니다.");

                        if (data.result === "success") {
                            self.healthForm = {
                                title: "",
                                date: "",
                                memo: ""
                            };

                            self.fnLoadHealthList();
                        }
                    },
                    error: function () {
                        alert("건강 기록 등록 실패");
                    }
                });
            },

            fnSaveWeightRecord: function () {
                if (!this.selectedPetNo) {
                    alert("반려동물을 선택해주세요.");
                    return;
                }

                let self = this;

                $.ajax({
                    url: "/user/add-weight.dox",
                    type: "POST",
                    data: {
                        petNo: self.selectedPetNo,
                        weight: self.weightForm.weight,
                        date: self.weightForm.date,
                        memo: self.weightForm.memo
                    },
                    success: function (data) {
                        alert(data.message || "몸무게 기록이 등록되었습니다.");

                        if (data.result === "success") {
                            self.weightForm = {
                                weight: "",
                                date: "",
                                memo: ""
                            };

                            self.fnLoadWeightList();
                        }
                    },
                    error: function () {
                        alert("몸무게 기록 등록 실패");
                    }
                });
            },

            fnSaveVacRecord: function () {
                if (!this.selectedPetNo) {
                    alert("반려동물을 선택해주세요.");
                    return;
                }

                let self = this;

                $.ajax({
                    url: "/user/add-vaccine.dox",
                    type: "POST",
                    data: {
                        petNo: self.selectedPetNo,
                        name: self.vacForm.name,
                        date: self.vacForm.date,
                        nextDate: self.vacForm.nextDate,
                        hospitalName: self.vacForm.hospitalName,
                        memo: self.vacForm.memo
                    },
                    success: function (data) {
                        alert(data.message || "백신 기록이 등록되었습니다.");

                        if (data.result === "success") {
                            self.vacForm = {
                                name: "",
                                date: "",
                                nextDate: "",
                                hospitalName: "",
                                memo: ""
                            };

                            self.fnLoadVaccineList();
                        }
                    },
                    error: function () {
                        alert("백신 기록 등록 실패");
                    }
                });
            },

            fnDeleteVaccine: function (id) {
                let self = this;

                if (!confirm("백신 기록을 삭제하시겠습니까?")) {
                    return;
                }

                $.ajax({
                    url: "/user/delete-vaccine.dox",
                    type: "POST",
                    data: {
                        vacNo: id
                    },
                    success: function () {
                        self.fnLoadVaccineList();
                    },
                    error: function () {
                        alert("백신 기록 삭제 실패");
                    }
                });
            },

            fnDrawWeightChart: function () {
                const canvas = document.getElementById("weightChart");

                if (!canvas || typeof Chart === "undefined") {
                    return;
                }

                if (this.weightChart) {
                    this.weightChart.destroy();
                    this.weightChart = null;
                }

                const list = [...this.weightList].sort(function (a, b) {
                    return String(a.date || "").localeCompare(String(b.date || ""));
                });

                const labels = list.map(item => this.fnFormatDate(item.date));
                const values = list.map(item => Number(item.weight || 0));

                this.weightChart = new Chart(canvas, {
                    type: "line",
                    data: {
                        labels: labels,
                        datasets: [{
                            label: "몸무게(kg)",
                            data: values,
                            tension: 0.3
                        }]
                    },
                    options: {
                        responsive: true,
                        maintainAspectRatio: false
                    }
                });
            },

            fnFormatDate: function (dateStr) {
                if (!dateStr || dateStr === "날짜 없음") {
                    return "-";
                }

                return String(dateStr).length >= 10
                    ? String(dateStr).substring(0, 10)
                    : String(dateStr);
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