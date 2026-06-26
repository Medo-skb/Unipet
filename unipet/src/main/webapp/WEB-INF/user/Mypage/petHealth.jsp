<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
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

                <div class="section-box">
                    <div class="section-title">반려동물 선택</div>

                    <div class="pet-list health-pet-list">
                        <div class="pet-card health-pet-card"
                             v-for="pet in petList"
                             :key="pet.petNo || pet.PET_NO"
                             :class="{
                                active: String(selectedPetNo) === String(pet.petNo || pet.PET_NO),
                                'main-pet-card': (pet.isMain || pet.IS_MAIN) === 'Y'
                             }"
                             @click="fnSelectPet(pet)">

                            <div class="pet-thumb">
                                <div class="pet-avatar">
                                    <img :src="fnGetPetImage(pet)" alt="펫이미지">
                                </div>
                            </div>

                            <div class="pet-name">
                                {{ pet.petName || pet.PET_NAME || '-' }}
                                <span v-if="(pet.isMain || pet.IS_MAIN) === 'Y'" class="main-badge">
                                    대표동물
                                </span>
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

                <div class="section-box">
                    <div class="health-tabs">
                        <button class="small-btn"
                                :class="{active: healthTab === 'health'}"
                                @click="healthTab='health'; fnLoadHealthList();">
                            건강기록
                        </button>

                        <button class="small-btn"
                                :class="{active: healthTab === 'weight'}"
                                @click="healthTab='weight'; fnLoadWeightList();">
                            몸무게
                        </button>

                        <button class="small-btn"
                                :class="{active: healthTab === 'vaccine'}"
                                @click="healthTab='vaccine'; fnLoadVaccineList();">
                            백신기록
                        </button>
                    </div>
                </div>

                <div v-if="!selectedPetNo" class="section-box">
                    <div class="empty-text">반려동물을 선택해주세요.</div>
                </div>

                <div v-if="selectedPetNo && healthTab === 'health'">
                    <div class="section-box">
                        <div class="section-title">
                            {{ healthForm.id ? '건강 기록 수정' : '건강 기록 등록' }}
                        </div>

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
                            <button @click="fnSaveHealthRecord">
                                {{ healthForm.id ? '수정' : '등록' }}
                            </button>
                            <button v-if="healthForm.id" class="btn-gray" @click="fnCancelHealthEdit">
                                취소
                            </button>
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

                            <div class="btn-box">
                                <button class="small-btn" @click="fnEditHealth(item)">수정</button>
                                <button class="btn-red" @click="fnDeleteHealth(item.id || item.healthNo)">삭제</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div v-if="selectedPetNo && healthTab === 'weight'">
                    <div class="section-box">
                        <div class="section-title">
                            {{ weightForm.id ? '몸무게 수정' : '몸무게 등록' }}
                        </div>

                        <div class="row">
                            <label>몸무게(kg)</label>
                            <input type="text" v-model="weightForm.weight">
                        </div>

                        <div class="row">
                            <label>기록일</label>
                            <input type="date" v-model="weightForm.date">
                        </div>

                        <div class="btn-box">
                            <button @click="fnSaveWeightRecord">
                                {{ weightForm.id ? '수정' : '등록' }}
                            </button>
                            <button v-if="weightForm.id" class="btn-gray" @click="fnCancelWeightEdit">
                                취소
                            </button>
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

                            <div class="btn-box">
                                <button class="small-btn" @click="fnEditWeight(item)">수정</button>
                                <button class="btn-red" @click="fnDeleteWeight(item.id || item.weightNo)">삭제</button>
                            </div>
                        </div>
                    </div>
                </div>

                <div v-if="selectedPetNo && healthTab === 'vaccine'">
                    <div class="section-box">
                        <div class="section-title">
                            {{ vacForm.id ? '백신 기록 수정' : '백신 기록 등록' }}
                        </div>

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
                            <button @click="fnSaveVacRecord">
                                {{ vacForm.id ? '수정' : '등록' }}
                            </button>
                            <button v-if="vacForm.id" class="btn-gray" @click="fnCancelVacEdit">
                                취소
                            </button>
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
                                다음 접종일 :
                                {{ item.nextDate || item.nextVacDate ? fnFormatDate(item.nextDate || item.nextVacDate) : '-' }}
                            </div>
                            <div class="list-sub">병원명 : {{ item.hospitalName || '-' }}</div>
                            <div class="list-sub">비고 : {{ item.memo || '-' }}</div>

                            <div class="btn-box">
                                <button class="small-btn" @click="fnEditVaccine(item)">수정</button>
                                <button class="btn-red" @click="fnDeleteVaccine(item.id || item.vacNo)">삭제</button>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </main>
    </div>
</div>

<jsp:include page="/WEB-INF/footer/footer.jsp" />

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
                id: "",
                title: "",
                date: "",
                memo: ""
            },

            originHealthForm: {
                title: "",
                date: "",
                memo: ""
            },

            weightForm: {
                id: "",
                weight: "",
                date: ""
            },

            originWeightForm: {
                weight: "",
                date: ""
            },

            vacForm: {
                id: "",
                name: "",
                date: "",
                nextDate: "",
                hospitalName: "",
                memo: ""
            },

            originVacForm: {
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

                    self.selectedPetNo = "";
                    self.healthList = [];
                    self.weightList = [];
                    self.vacList = [];
                },
                error: function () {
                    self.petList = [];
                    self.selectedPetNo = "";
                    self.healthList = [];
                    self.weightList = [];
                    self.vacList = [];
                }
            });
        },

        fnSelectPet: function (pet) {
            this.selectedPetNo = pet.petNo || pet.PET_NO;

            this.fnCancelHealthEdit();
            this.fnCancelWeightEdit();
            this.fnCancelVacEdit();

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
                data: { petNo: self.selectedPetNo },
                success: function (data) {
                    self.healthList = data.result === "success" ? (data.healthList || []) : [];

                    self.healthList.sort(function (a, b) {
                        return String(b.date || "").localeCompare(String(a.date || ""));
                    });
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
                data: { petNo: self.selectedPetNo },
                success: function (data) {
                    self.weightList = data.result === "success" ? (data.weightList || []) : [];

                    self.weightList.sort(function (a, b) {
                        return String(b.date || "").localeCompare(String(a.date || ""));
                    });

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
                data: { petNo: self.selectedPetNo },
                success: function (data) {
                    self.vacList = data.result === "success" ? (data.vaccineList || data.vacList || []) : [];

                    self.vacList.sort(function (a, b) {
                        return String(b.date || b.vacDate || "").localeCompare(String(a.date || a.vacDate || ""));
                    });
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

            if (!this.healthForm.title) {
                alert("제목을 입력해주세요.");
                return;
            }

            if (!this.healthForm.date) {
                alert("기록일을 입력해주세요.");
                return;
            }

            if (this.healthForm.id
                && this.healthForm.title === this.originHealthForm.title
                && this.healthForm.date === this.originHealthForm.date
                && this.healthForm.memo === this.originHealthForm.memo) {
                alert("변경된 내용이 없습니다.");
                return;
            }

            let self = this;
            const url = self.healthForm.id ? "/user/update-health.dox" : "/user/add-health.dox";

            $.ajax({
                url: url,
                type: "POST",
                dataType: "json",
                data: {
                    id: self.healthForm.id,
                    petNo: self.selectedPetNo,
                    title: self.healthForm.title,
                    memo: self.healthForm.memo,
                    date: self.healthForm.date
                },
                success: function (data) {
                    alert(data.message || "저장되었습니다.");

                    if (data.result === "success") {
                        self.fnCancelHealthEdit();
                        self.fnLoadHealthList();
                    }
                },
                error: function () {
                    alert("건강 기록 저장 실패");
                }
            });
        },

        fnEditHealth: function (item) {
            const title = item.title || "";
            const date = this.fnFormatDate(item.date);
            const memo = item.memo || "";

            this.healthForm = {
                id: item.id || item.healthNo,
                title: title,
                date: date,
                memo: memo
            };

            this.originHealthForm = {
                title: title,
                date: date,
                memo: memo
            };

            window.scrollTo(0, 0);
        },

        fnCancelHealthEdit: function () {
            this.healthForm = {
                id: "",
                title: "",
                date: "",
                memo: ""
            };

            this.originHealthForm = {
                title: "",
                date: "",
                memo: ""
            };
        },

        fnDeleteHealth: function (id) {
            let self = this;

            if (!confirm("건강 기록을 삭제하시겠습니까?")) return;

            $.ajax({
                url: "/user/delete-health.dox",
                type: "POST",
                dataType: "json",
                data: { id: id },
                success: function (data) {
                    alert(data.message || "삭제되었습니다.");
                    self.fnLoadHealthList();
                },
                error: function () {
                    alert("건강 기록 삭제 실패");
                }
            });
        },

        fnSaveWeightRecord: function () {
            if (!this.selectedPetNo) {
                alert("반려동물을 선택해주세요.");
                return;
            }

            if (!this.weightForm.weight) {
                alert("몸무게를 입력해주세요.");
                return;
            }

            if (!this.weightForm.date) {
                alert("기록일을 입력해주세요.");
                return;
            }

            if (this.weightForm.id
                && String(this.weightForm.weight) === String(this.originWeightForm.weight)
                && this.weightForm.date === this.originWeightForm.date) {
                alert("변경된 내용이 없습니다.");
                return;
            }

            let self = this;
            const url = self.weightForm.id ? "/user/update-weight.dox" : "/user/add-weight.dox";

            $.ajax({
                url: url,
                type: "POST",
                dataType: "json",
                data: {
                    id: self.weightForm.id,
                    petNo: self.selectedPetNo,
                    weight: self.weightForm.weight,
                    date: self.weightForm.date
                },
                success: function (data) {
                    alert(data.message || "저장되었습니다.");

                    if (data.result === "success") {
                        self.fnCancelWeightEdit();
                        self.fnLoadWeightList();
                    }
                },
                error: function () {
                    alert("몸무게 기록 저장 실패");
                }
            });
        },

        fnEditWeight: function (item) {
            const weight = item.weight || "";
            const date = this.fnFormatDate(item.date);

            this.weightForm = {
                id: item.id || item.weightNo,
                weight: weight,
                date: date
            };

            this.originWeightForm = {
                weight: weight,
                date: date
            };

            window.scrollTo(0, 0);
        },

        fnCancelWeightEdit: function () {
            this.weightForm = {
                id: "",
                weight: "",
                date: ""
            };

            this.originWeightForm = {
                weight: "",
                date: ""
            };
        },

        fnDeleteWeight: function (id) {
            let self = this;

            if (!confirm("몸무게 기록을 삭제하시겠습니까?")) return;

            $.ajax({
                url: "/user/delete-weight.dox",
                type: "POST",
                dataType: "json",
                data: { id: id },
                success: function (data) {
                    alert(data.message || "삭제되었습니다.");
                    self.fnLoadWeightList();
                },
                error: function () {
                    alert("몸무게 기록 삭제 실패");
                }
            });
        },

        fnSaveVacRecord: function () {
            if (!this.selectedPetNo) {
                alert("반려동물을 선택해주세요.");
                return;
            }

            if (!this.vacForm.name) {
                alert("백신명을 입력해주세요.");
                return;
            }

            if (!this.vacForm.date) {
                alert("접종일을 입력해주세요.");
                return;
            }

            if (this.vacForm.id
                && this.vacForm.name === this.originVacForm.name
                && this.vacForm.date === this.originVacForm.date
                && this.vacForm.nextDate === this.originVacForm.nextDate
                && this.vacForm.hospitalName === this.originVacForm.hospitalName
                && this.vacForm.memo === this.originVacForm.memo) {
                alert("변경된 내용이 없습니다.");
                return;
            }

            let self = this;
            const url = self.vacForm.id ? "/user/update-vaccine.dox" : "/user/add-vaccine.dox";

            $.ajax({
                url: url,
                type: "POST",
                dataType: "json",
                data: {
                    id: self.vacForm.id,
                    petNo: self.selectedPetNo,
                    name: self.vacForm.name,
                    date: self.vacForm.date,
                    nextDate: self.vacForm.nextDate ? self.vacForm.nextDate : null,
                    hospitalName: self.vacForm.hospitalName || "",
                    memo: self.vacForm.memo || ""
                },
                success: function (data) {
                    alert(data.message || "저장되었습니다.");

                    if (data.result === "success") {
                        self.fnCancelVacEdit();
                        self.fnLoadVaccineList();
                    }
                },
                error: function () {
                    alert("백신 기록 저장 실패");
                }
            });
        },

        fnEditVaccine: function (item) {
            const name = item.name || item.vacName || "";
            const date = this.fnFormatDate(item.date || item.vacDate);
            const nextDate = this.fnFormatDate(item.nextDate || item.nextVacDate);
            const hospitalName = item.hospitalName || "";
            const memo = item.memo || "";

            this.vacForm = {
                id: item.id || item.vacNo,
                name: name,
                date: date,
                nextDate: nextDate,
                hospitalName: hospitalName,
                memo: memo
            };

            this.originVacForm = {
                name: name,
                date: date,
                nextDate: nextDate,
                hospitalName: hospitalName,
                memo: memo
            };

            window.scrollTo(0, 0);
        },

        fnCancelVacEdit: function () {
            this.vacForm = {
                id: "",
                name: "",
                date: "",
                nextDate: "",
                hospitalName: "",
                memo: ""
            };

            this.originVacForm = {
                name: "",
                date: "",
                nextDate: "",
                hospitalName: "",
                memo: ""
            };
        },

        fnDeleteVaccine: function (id) {
            let self = this;

            if (!confirm("백신 기록을 삭제하시겠습니까?")) return;

            $.ajax({
                url: "/user/delete-vaccine.dox",
                type: "POST",
                dataType: "json",
                data: { id: id },
                success: function (data) {
                    alert(data.message || "삭제되었습니다.");
                    self.fnLoadVaccineList();
                },
                error: function () {
                    alert("백신 기록 삭제 실패");
                }
            });
        },

        fnDrawWeightChart: function () {
            const canvas = document.getElementById("weightChart");

            if (!canvas || typeof Chart === "undefined") return;

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
            if (!dateStr || dateStr === "날짜 없음") return "";
            return String(dateStr).length >= 10 ? String(dateStr).substring(0, 10) : String(dateStr);
        },

        fnGetPetImage: function (pet) {
            if (pet.petImg || pet.PET_IMG) return pet.petImg || pet.PET_IMG;

            const species = pet.species || pet.SPECIES || "";

            if (species === "고양이") return "/img/user/pet/cat.png";
            if (species === "강아지") return "/img/user/pet/dog.png";
            if (species === "조류") return "/img/user/pet/bird.png";
            if (species === "어류") return "/img/user/pet/fish.png";

            return "/img/user/pet/etc.png";
        },

        fnGetPetAge: function (birthdate) {
            if (!birthdate) return "-";

            const str = String(birthdate).substring(0, 10);
            const parts = str.split("-");

            if (parts.length < 3) return "-";

            const birthYear = Number(parts[0]);
            const birthMonth = Number(parts[1]);
            const birthDay = Number(parts[2]);

            if (!birthYear || !birthMonth || !birthDay) return "-";

            const today = new Date();
            let age = today.getFullYear() - birthYear;

            const todayMonth = today.getMonth() + 1;
            const todayDay = today.getDate();

            if (
                todayMonth < birthMonth ||
                (todayMonth === birthMonth && todayDay < birthDay)
            ) {
                age--;
            }

            return Math.max(age, 0);
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