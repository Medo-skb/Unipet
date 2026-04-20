<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link href="/css/reservation/reservation.css" rel="stylesheet">
    <title>Reservation</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
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
                                    /* d.day가 있을 때만 selected 클래스가 적용되도록 조건 추가 */
                                    'selected': d.day && d.fullDate === selectedDate,
                                    'disabled': d.fullDate && d.fullDate < today
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
                                :class="{ 'booked': slot.isAvailable === 'N' || slot.curCount >= slot.capacity }"
                                :disabled="slot.isAvailable === 'N' || slot.curCount >= slot.capacity"
                                @click="selectTime(slot)">
                            <span v-text="slot.slotTime" class="timetxt"></span>
                        </button>
                    </div>
                </div>
            </div>
            
            <div id="pet-area"><div class="title">반려동물 선택</div><div class="pet-card"></div></div>
            <div id="service-area"><div class="services"></div></div>
            <div id="price-area"><div class="price">총 금액...</div></div>
            <div id="request">
                <div class="title">요청사항 입력</div>
                <textarea rows="5" cols="30" placeholder="요청사항 입력"></textarea>
            </div>
            <div class="button">예약 & 결제</div>
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
                timeSlots:[]
            };
        },
        methods: {
            buildCalendar() {
                this.calendarDays = [];
                const firstDay = new Date(this.currentYear, this.currentMonth, 1).getDay();
                const lastDate = new Date(this.currentYear, this.currentMonth + 1, 0).getDate();
                
                for (let i = 0; i < firstDay; i++) {
                    this.calendarDays.push({ day: '', fullDate: '' });
                }
                for (let i = 1; i <= lastDate; i++) {
                    const dateStr = this.currentYear + '-' + String(this.currentMonth + 1).padStart(2, '0') + '-' + String(i).padStart(2, '0');
                    this.calendarDays.push({ day: i, fullDate: dateStr });
                }
            },
            changeMonth(diff) {
                this.currentMonth += diff;
                if (this.currentMonth < 0) { this.currentMonth = 11; this.currentYear--; }
                else if (this.currentMonth > 11) { this.currentMonth = 0; this.currentYear++; }
                this.buildCalendar();
            },
            selectDate(date) {
                if (!date.day || date.fullDate < this.today) return;
                this.selectedDate = date.fullDate;
                this.fnGetList();
            },
            fnGetList() {
                const self = this;
                $.ajax({
                    url: "/reservation/store-reservation.dox", // .dox 함수 호출
                    type: "POST",
                    data: { 
                        storeNo: self.storeNo, 
                        targetDate: self.selectedDate // 서버가 어떤 날짜를 조회할지 알아야 함 
                    },
                    success: function(data) {
                        // 서버에서 보낸 JSON 데이터가 res에 담김
                        console.log(data);
                        self.timeSlots = data.list; 
                    }
                });
            }
        },
        mounted() {
            this.buildCalendar();
            this.fnGetList();
        }   
    }).mount('#app');
</script>
</html>