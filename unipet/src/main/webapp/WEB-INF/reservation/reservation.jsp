<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/css/reservation/reservation.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <title>Reservation</title>
    
</head>
<body>
    <div id="app">
        <div id="container">
            <div id="datetime-area">
                <div class="title">날짜/시간</div>
                <div class="cal-slot">
                    <div id="calendar-area">
                        <div class="calendar-header">
                            <button @click="changeMonth(-1)">◀</button>
                            <span v-text="currentYear + '년 ' + (currentMonth + 1) + '월'"></span> 
                            <button @click="changeMonth(1)">▶</button>
                        </div>

                        <div class="calendar-main">
                            <div class="day-header" v-for="name in ['일','월','화','수','목','금','토']" v-text="name"></div>
                            
                            <div v-for="(d, index) in calendarDays" :key="index" 
                                class="day-cell"
                                :class="{ 
                                    'empty': !d.day, 
                                    'today': d.fullDate === today,
                                    'selected': d.day && d.fullDate === selectedDate,
                                    /* d.isFullDisabled가 true일 때 disabled 클래스 적용 */
                                    'disabled': d.day && d.isFullDisabled 
                                }"
                                @click="selectDate(d)">
                                <span v-text="d.day"></span>
                            </div>
                        </div>
                    </div>
                    <div id="time-slot-area">
                        <button v-for="slot in timeSlots" 
                                :key="slot.slotNo" 
                                class="time-btn"
                                :class="{ 
                                    /* 계산된 isClosed 값이 true면 booked 클래스 적용 */
                                    'booked': slot.isClosed, 
                                    'selected': selectedTime === slot 
                                }"
                                /* 클릭 비활성화 */
                                :disabled="slot.isClosed"
                                @click="selectTime(slot)">
                            <span v-text="slot.slotTime.substring(0, 5)" class="timetxt"></span>
                        </button>
                    </div>
                </div>
            </div>
            
            <div id="pet-area">
                <div class="title">반려동물 선택</div>
                <div class="pet-list-container">
                    <div v-for="(pet, index) in petList" 
                        :key="index" 
                        class="pet-card"
                        :class="{ 'selected': selectedPet === pet }"
                        @click="selectedPet = pet">
                        
                        <div class="pet-header">
                            <span class="pet-name" v-text="pet.petName"></span>
                            <span class="pet-main" v-if="pet.isMain === 'Y'">대표</span>
                        </div>
                        
                        <div class="pet-info">
                            <p><span v-text="pet.species"></span> / <span v-text="pet.breed"></span> / <span v-text="pet.gender === 'M' ? '남아' : '여아'"></span></p>
                            <p><span v-text="pet.birthdate"></span> ({{ fnGetAge(pet.birthdate) }}살)</p>
                        </div>
                    </div>
                </div>
            </div>
            <div id="menu-area">
                <div class="title">진료/서비스 선택</div>
                <div class="menus">
                    <div v-for="menu in menuList" :key="menu.menuNo" class="menu-item">
                        <label>
                            <input type="radio" 
                                name="menu-selection"
                                :value="menu"
                                v-model="selectedMenu">
                            <span class="menu-name">{{ menu.menuName }}</span>
                            <span class="menu-price">{{ menu.menuPrice.toLocaleString() }}원</span>
                        </label>
                    </div>
                </div>
            </div>

            <div id="price-area">
                <div class="price" v-if="selectedMenu"></div>
                <div class="price">
                    총 예약 결제 금액: 
                    <strong style="color: #ff4757;">{{ reservationPrice.toLocaleString() }}</strong> 원
                    <div><span class="sub-text">** 진료/서비스 금액의 (10%)</span></div>
                </div>
                
            </div>
            <div id="request">
                <div class="title">요청사항 입력</div>
                <textarea placeholder="요청사항 입력 바랍니다."></textarea>
            </div>
            <div class="button" @click="fnGoConfirm">예약 & 결제</div>
        </div>
    </div>
</body>

<script>
    const app = Vue.createApp({
        data() {
            return {
                storeNo: '${map.storeNo}',
                currentYear: new Date().getFullYear(),
                currentMonth: new Date().getMonth(),
                selectedDate: new Date().toISOString().split('T')[0],
                today: new Date().toISOString().split('T')[0],
                calendarDays: [],
                timeSlots: [],
                userId: 'test_user01', // 테스트용 아이디
                petList: [],
                selectedPet: null,
                menuList: [],
                selectedMenu: null, // 이제 단일 객체
                selectedTime: null,
                cutoff: 0 // store_policy에서 가져올 예약 마감 시간 (단위: 시간)
            };
        },
        computed: {
            totalPrice() {
                // 단일 객체이므로 바로 가격 리턴
                return this.selectedMenu ? Number(this.selectedMenu.menuPrice) : 0;
            },
            reservationPrice() {
                return Math.floor(this.totalPrice * 0.1);
            }
        },
        methods: {
            fnGetStorePolicy() {
                const self = this;
                $.ajax({
                    url: "/reservation/store-policy.dox",
                    type: "POST",
                    data: { storeNo: self.storeNo },
                    success: function(data) {
                        self.cutoff = data.info.cutoff;
                        
                        // 정책을 가져온 후 달력을 그립니다.
                        self.buildCalendar();

                        // [추가] 만약 오늘이 예약 불가능(isFullDisabled)하다면 다음날을 기본값으로 설정
                        const todayObj = self.calendarDays.find(d => d.fullDate === self.today);
                        if (todayObj && todayObj.isFullDisabled) {
                            const tomorrow = new Date();
                            tomorrow.setDate(tomorrow.getDate() + 1);
                            self.selectedDate = tomorrow.toISOString().split('T')[0];
                        }

                        self.fnGetTimeList();
                    }
                });
            },
            
            buildCalendar() {
                this.calendarDays = [];
                const firstDay = new Date(this.currentYear, this.currentMonth, 1).getDay();
                const lastDate = new Date(this.currentYear, this.currentMonth + 1, 0).getDate();
                
                // 마감 기준 시점 (현재 + cutoff 시간)
                const now = new Date();
                const limitTime = new Date(now.getTime() + (Number(this.cutoff) * 60 * 60 * 1000));

                for (let i = 0; i < firstDay; i++) {
                    this.calendarDays.push({ day: '', fullDate: '' });
                }

                for (let i = 1; i <= lastDate; i++) {
                    const dateStr = this.currentYear + '-' + String(this.currentMonth + 1).padStart(2, '0') + '-' + String(i).padStart(2, '0');
                    
                    // 해당 날짜의 영업 종료 시간 (예: 20:00). 필요시 store_policy에서 가져온 값을 넣으세요.
                    const endOfBusiness = new Date(dateStr + 'T20:00:00'); 
                    
                    let isFullDisabled = false;

                    if (dateStr < this.today) {
                        isFullDisabled = true; // 과거 날짜
                    } else if (dateStr === this.today) {
                        // 오늘인데, 영업 종료 시간이 이미 마감 기준 시점(limitTime)보다 전이라면 예약 불가
                        if (endOfBusiness <= limitTime) {
                            isFullDisabled = true;
                        }
                    }

                    this.calendarDays.push({ 
                        day: i, 
                        fullDate: dateStr,
                        isFullDisabled: isFullDisabled
                    });
                }
            },
            changeMonth(diff) {
                this.currentMonth += diff;
                if (this.currentMonth < 0) { this.currentMonth = 11; this.currentYear--; }
                else if (this.currentMonth > 11) { this.currentMonth = 0; this.currentYear++; }
                this.buildCalendar();
            },
            selectDate(date) {
                // 1. 빈 칸이거나 2. 비활성화된 날짜(과거/마감)라면 아무 동작 안함
                if (!date.day || date.isFullDisabled) {
                    return; 
                }
                this.selectedDate = date.fullDate;
                this.fnGetTimeList();
            },
            fnGetTimeList() {
                const self = this;
                $.ajax({
                    url: "/reservation/store-reservation.dox",
                    type: "POST",
                    data: { storeNo: self.storeNo, targetDate: self.selectedDate },
                    success: function(data) {
                        const now = new Date();
                        // 현재 시간에 cutoff(시간)를 더한 시점
                        const limitTime = new Date(now.getTime() + (Number(self.cutoff) * 60 * 60 * 1000));

                        self.timeSlots = data.timelist.map(slot => {
                            // [수정] slotDate와 slotTime을 합칠 때 포맷 확인
                            // 만약 slotTime이 '10:00'이라면 '10:00:00'으로 맞춰주는 게 안전합니다.
                            const timeStr = slot.slotTime.length === 5 ? slot.slotTime + ":00" : slot.slotTime;
                            const slotDateTime = new Date(slot.slotDate + 'T' + timeStr); // T를 넣는 것이 표준 포맷
                            
                            return {
                                ...slot,
                                // 마감 조건 판별
                                isClosed: slot.isAvailable === 'N' || 
                                        slot.curCount >= slot.capacity || 
                                        slotDateTime < limitTime
                            };
                        });
                    }
                });
            },
            selectTime(slot) {
                if (slot.isAvailable === 'N' || slot.curCount >= slot.capacity) {
                    alert("이미 예약이 완료된 시간대입니다.");
                    return;
                }
                this.selectedTime = slot;
            },
            fnGetPetList() {
                const self = this;
                $.ajax({
                    url: "/reservation/pet-list.dox",
                    type: "POST",
                    data: { userId: self.userId },
                    success: function(data) { self.petList = data.petlist; }
                });
            },
            fnGetMenuList() {
                const self = this;
                $.ajax({
                    url: "/reservation/store-menu.dox",
                    type: "POST",
                    data: { storeNo: self.storeNo },
                    success: function(data) {
                        console.log("메뉴 데이터 원본:", data.list);
                        self.menuList = data.list; 
                    }
                });
            },
            fnGetAge(birthdate) {
                if (!birthdate) return "";
                const birth = new Date(birthdate);
                const today = new Date();
                let age = today.getFullYear() - birth.getFullYear();
                return age < 0 ? 0 : age;
            },
            fnGoConfirm() {
                if (!this.selectedDate || !this.selectedTime || !this.selectedPet || !this.selectedMenu) {
                    alert("모든 항목(날짜, 시간, 반려동물, 메뉴)을 선택해주세요.");
                    return;
                }

                // XML 쿼리에 필요한 9가지 파라미터 묶기
                const reserveData = {
                    // 서버에서 새로 추가한 petNo와 menuNo가 여기 잘 담기는지 확인
                    petNo: this.selectedPet.petNo,
                    menuNo: this.selectedMenu.menuNo,
                    slotNo: this.selectedTime.slotNo,
                    storeNo: this.storeNo,
                    
                    date: this.selectedDate,
                    time: this.selectedTime.slotTime,
                    userId: this.userId,
                    pet: this.selectedPet,           // 객체 전체 (화면 표시용)
                    menus: [this.selectedMenu],      // 배열 형태 (화면 표시용)
                    reservationPrice: this.reservationPrice,
                    request: document.querySelector('#request textarea').value
                };

                console.log("넘기기 전 최종 확인:", reserveData); // 여기서 No값들이 숫자로 나오면 성공!
                localStorage.setItem("reserveTemp", JSON.stringify(reserveData));
                location.href = "/reservation/rsv-confirm.do";
            }
        },
        mounted() {
            this.fnGetStorePolicy();
            this.buildCalendar();
            this.fnGetPetList();
            this.fnGetMenuList();
        }   
    }).mount('#app');
</script>
</html>