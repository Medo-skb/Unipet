<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지</title>

    <script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
            font-family: Arial, sans-serif;
        }

        body {
            background: #f4f6fb;
            color: #333;
        }

        #app {
            width: 1320px;
            margin: 30px auto;
            display: flex;
            gap: 20px;
        }

        .sidebar {
            width: 120px;
            min-height: 1100px;
            background: linear-gradient(180deg, #363636, #2c2c2c);
            border-radius: 16px;
            padding: 20px 10px;
            display: flex;
            flex-direction: column;
            gap: 14px;
            align-items: center;
        }

        .menu {
            width: 90px;
            min-height: 70px;
            border-radius: 12px;
            background: rgba(255,255,255,0.06);
            color: #fff;
            cursor: pointer;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            line-height: 1.25;
            text-align: center;
            transition: 0.2s;
            padding: 8px 4px;
            font-size: 13px;
        }

        .menu:hover {
            background: rgba(255,255,255,0.18);
            transform: translateY(-2px);
        }

        .menu.active {
            background: #0d5bd7;
        }

        .content {
            flex: 1;
            min-height: 1100px;
            background: #f0f4f5;
            border: 1px solid #7ea3db;
            border-radius: 16px;
            padding: 28px 24px 24px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
        }

        .page-title {
            font-size: 28px;
            font-weight: 700;
            margin-bottom: 24px;
        }

        .section-box {
            background: #fff;
            border: 1px solid #d9e3ef;
            border-radius: 14px;
            padding: 18px;
            margin-bottom: 18px;
        }

        .section-title {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 14px;
        }

        .section-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 14px;
        }

        .grid-2 {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 16px;
        }

        .dashboard-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 18px;
        }

        .row {
            margin-bottom: 12px;
        }

        .row label {
            display: block;
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .row input,
        .row select,
        .row textarea {
            width: 100%;
            border: 1px solid #cfd8e3;
            border-radius: 10px;
            padding: 10px 12px;
            font-size: 14px;
            background: #fff;
        }

        .row input,
        .row select {
            height: 42px;
        }

        .row textarea {
            min-height: 90px;
            resize: vertical;
        }

        .btn-box {
            display: flex;
            gap: 8px;
            margin-top: 12px;
            flex-wrap: wrap;
        }

        .btn-box button,
        .small-btn {
            height: 40px;
            border: 2px solid #8ea8d8;
            border-radius: 10px;
            background: #eef4ff;
            font-size: 14px;
            font-weight: 700;
            cursor: pointer;
            padding: 0 16px;
        }

        .btn-gray {
            background: #eef1f4 !important;
            border-color: #b8c3cf !important;
        }

        .btn-red {
            background: #fff0f0 !important;
            border-color: #d9a1a1 !important;
        }

        .empty-text {
            color: #777;
            font-size: 13px;
            padding: 10px 4px;
        }

        .pet-list {
            display: flex;
            gap: 14px;
            flex-wrap: wrap;
        }

        .pet-card {
            width: 180px;
            border: 1px solid #d9e3ef;
            border-radius: 12px;
            overflow: hidden;
            background: #fff;
            text-align: center;
        }

        .pet-thumb {
            height: 110px;
            background: linear-gradient(135deg, #eef3f8, #dde8f1);
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .pet-avatar {
            width: 62px;
            height: 62px;
            border-radius: 50%;
            background: #8ba3ba;
            color: #fff;
            font-size: 24px;
            font-weight: 700;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .pet-body {
            padding: 12px 10px 14px;
        }

        .pet-name {
            font-size: 18px;
            font-weight: 700;
            margin-bottom: 6px;
        }

        .pet-info {
            font-size: 13px;
            color: #666;
            min-height: 36px;
            margin-bottom: 10px;
            line-height: 1.4;
        }

        .pet-btns {
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            gap: 6px;
        }

        .pet-btn {
            border: none;
            color: white;
            padding: 7px 10px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 700;
            cursor: pointer;
        }

        .pet-btn.main { background: #f29b38; }
        .pet-btn.main.gray { background: #c7cdd6; cursor: default; }
        .pet-btn.edit { background: #5d92d6; }
        .pet-btn.delete { background: #d56b6b; }

        .pet-add-card {
            width: 180px;
            min-height: 210px;
            border: 2px dashed #cfd6df;
            border-radius: 12px;
            background: #fafbfd;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
            color: #7d8b99;
            font-weight: 700;
            gap: 10px;
        }

        .pet-add-plus {
            font-size: 40px;
            line-height: 1;
        }

        .list-item {
            padding: 12px 4px;
            border-bottom: 1px solid #edf0f3;
        }

        .list-item:last-child {
            border-bottom: none;
        }

        .list-title {
            font-size: 14px;
            font-weight: 700;
            margin-bottom: 4px;
        }

        .list-sub {
            font-size: 12px;
            color: #666;
            margin-bottom: 3px;
        }

        .list-status {
            font-size: 12px;
            font-weight: 700;
            color: #4e90dc;
        }

        .info-card {
            border: 1px solid #d9e3ef;
            border-radius: 12px;
            background: #fff;
            padding: 16px;
            margin-bottom: 12px;
        }

        .order-item {
            display: flex;
            gap: 14px;
            align-items: center;
            padding: 10px 0;
            border-top: 1px solid #eee;
        }

        .order-item:first-child {
            border-top: none;
            padding-top: 0;
        }

        .order-img {
            width: 72px;
            height: 72px;
            object-fit: cover;
            border-radius: 12px;
            border: 1px solid #ddd;
            background: #f5f5f5;
        }

        .chart-wrap {
            width: 100%;
            height: 360px;
            position: relative;
        }

        .modal-wrap {
            display: flex;
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.4);
            z-index: 999;
            align-items: center;
            justify-content: center;
        }

        .modal-box {
            width: 430px;
            background: white;
            border-radius: 14px;
            padding: 24px;
        }

        .modal-title {
            font-size: 22px;
            font-weight: 700;
            margin-bottom: 20px;
            color: #324455;
        }

        .modal-btns {
            display: flex;
            gap: 10px;
            margin-top: 18px;
        }

        .modal-btns button {
            flex: 1;
            height: 42px;
            border-radius: 12px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 700;
            border: 2px solid #8ea8d8;
            background: #eef4ff;
            color: #2b2b2b;
        }

        .btn-cancel {
            background: #eef1f4 !important;
            border-color: #b8c3cf !important;
        }

        .btn-save {
            background: #fff2df !important;
            border-color: #f0bf74 !important;
        }
    </style>
</head>
<body>
<div id="app">

    <div class="sidebar">
        <div class="menu" :class="{active: currentMenu==='userMyPage'}" @click="changeMenu('userMyPage')">🏠<br>마이페이지</div>
        <div class="menu" :class="{active: currentMenu==='orderList'}" @click="changeMenu('orderList')">🛒<br>주문내역</div>
        <div class="menu" :class="{active: currentMenu==='reserveList'}" @click="changeMenu('reserveList')">📅<br>예약내역</div>
        <div class="menu" :class="{active: currentMenu==='petEdit'}" @click="changeMenu('petEdit')">🐶<br>반려동물</div>
        <div class="menu" :class="{active: currentMenu==='petMyPage'}" @click="changeMenu('petMyPage')">💗<br>건강조회</div>
        <div class="menu" :class="{active: currentMenu==='petHealthPage'}" @click="changeMenu('petHealthPage')">📝<br>건강기록</div>
        <div class="menu" :class="{active: currentMenu==='petVacPage'}" @click="changeMenu('petVacPage')">💉<br>접종기록</div>
        <div class="menu" :class="{active: currentMenu==='petWeightPage'}" @click="changeMenu('petWeightPage')">⚖️<br>몸무게</div>
    </div>

    <div class="content">
        <div class="page-title">{{ pageTitle }}</div>

        <!-- 마이페이지 -->
        <div v-if="currentMenu === 'userMyPage'">
            <div class="section-box">
                <div class="section-title">회원정보 관리</div>
                <div class="grid-2">
                    <div class="row">
                        <label>이름</label>
                        <input type="text" v-model="user.userName">
                    </div>
                    <div class="row">
                        <label>닉네임</label>
                        <input type="text" v-model="user.nickname">
                    </div>
                    <div class="row">
                        <label>이메일</label>
                        <input type="text" v-model="user.email">
                    </div>
                    <div class="row">
                        <label>전화번호</label>
                        <input type="text" v-model="user.phone">
                    </div>
                    <div class="row">
                        <label>우편번호</label>
                        <input type="text" v-model="user.zipcode">
                    </div>
                    <div class="row">
                        <label>주소</label>
                        <input type="text" v-model="user.userAddr">
                    </div>
                </div>

                <div class="row">
                    <label>상세주소</label>
                    <input type="text" v-model="user.fullAddr">
                </div>

                <div class="btn-box">
                    <button @click="updateUser">회원정보 저장</button>
                    <button class="btn-gray" @click="openPwdModal">비밀번호 변경</button>
                    <button class="btn-red" @click="deleteUser">회원 탈퇴</button>
                </div>
            </div>

            <div class="section-box">
                <div class="section-title">멀티 프로필 관리</div>
                <div class="pet-list">
                    <div class="pet-card" v-for="pet in petList" :key="pet.petNo">
                        <div class="pet-thumb">
                            <div class="pet-avatar">{{ getPetInitial(pet.petName) }}</div>
                        </div>
                        <div class="pet-body">
                            <div class="pet-name">{{ pet.petName }}</div>
                            <div class="pet-info">{{ pet.species || '' }}{{ pet.birthdate ? ' · ' + getPetAge(pet.birthdate) + '살' : '' }}</div>
                            <div class="pet-btns">
                                <button v-if="pet.isMain === 'Y'" class="pet-btn main gray" disabled>대표 프로필</button>
                                <button v-else class="pet-btn main" @click="changeMainPet(pet.petNo)">대표 프로필</button>
                                <button class="pet-btn edit" @click="openEditPetModal(pet)">수정</button>
                                <button class="pet-btn delete" @click="deletePet(pet.petNo)">삭제</button>
                            </div>
                        </div>
                    </div>

                    <div class="pet-add-card" @click="openAddPetModal">
                        <div class="pet-add-plus">+</div>
                        <div>프로필 추가</div>
                    </div>
                </div>
            </div>

            <div class="dashboard-grid">
                <div class="section-box">
                    <div class="section-header">
                        <div class="section-title" style="margin-bottom:0;">최근 예약 현황</div>
                        <button type="button" class="small-btn" @click="changeMenu('reserveList')">전체 예약목록</button>
                    </div>

                    <div v-if="reservationList.length === 0" class="empty-text">예약 내역이 없습니다.</div>

                    <div class="list-item" v-for="item in reservationList" :key="item.rsvNo">
                        <div class="list-title">예약번호 : {{ item.rsvNo || '-' }}</div>
                        <div class="list-sub">예약일 : {{ item.rsvDate || '-' }}</div>
                        <div class="list-sub">시간 : {{ item.rsvStartTime || '-' }} ~ {{ item.rsvEndTime || '-' }}</div>
                        <div class="list-sub">반려동물번호 : {{ item.petNo || '-' }}</div>
                        <div class="list-status">상태 : {{ item.rsvStatus || '-' }}</div>
                    </div>
                </div>

                <div class="section-box">
                    <div class="section-title">안내</div>
                    <div class="info-card">
                        <div class="list-title">현재 로그인</div>
                        <div class="list-sub">{{ user.userName || '-' }} / {{ user.nickname || '-' }}</div>
                    </div>
                    <div class="info-card">
                        <div class="list-title">바로가기</div>
                        <div class="btn-box">
                            <button @click="changeMenu('orderList')">주문내역</button>
                            <button @click="changeMenu('petEdit')">반려동물</button>
                            <button @click="changeMenu('petWeightPage')">몸무게</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 주문목록 -->
        <div v-if="currentMenu === 'orderList'">
            <div class="section-box">
                <div class="section-title">쇼핑몰 주문 내역</div>

                <div v-if="groupedOrderList.length === 0" class="empty-text">주문 내역이 없습니다.</div>

                <div class="info-card" v-for="group in groupedOrderList" :key="group.orderDate" style="margin-bottom:16px;">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:14px;">
                        <div class="list-title" style="font-size:16px;">주문일자 : {{ group.orderDate }}</div>
                        <button class="small-btn" @click="openOrderDetail(group)">주문상세보기</button>
                    </div>

                    <div v-for="order in group.items" :key="order.orderNo" class="order-item">
                        <img :src="order.productImage" alt="상품이미지" class="order-img">
                        <div style="flex:1;">
                            <div class="list-title">{{ order.productName }}</div>
                            <div class="list-sub">주문번호 : {{ order.orderNo }}</div>
                            <div class="list-sub">수량 : {{ order.qty }}개</div>
                            <div class="list-sub">금액 : {{ order.price }}원</div>
                            <div class="list-status">상태 : {{ order.orderStatus }}</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 주문상세 -->
        <div v-if="currentMenu === 'orderDetail'">
            <div class="section-box">
                <div class="section-header">
                    <div class="section-title" style="margin-bottom:0;">주문 상세</div>
                    <button class="small-btn" @click="goOrderList()">주문목록으로</button>
                </div>

                <div class="info-card" style="margin-bottom:18px;">
                    <div class="list-title">주문일자 : {{ selectedOrderGroup.orderDate }}</div>
                    <div class="list-sub">총 상품 수 : {{ selectedOrderGroup.items.length }}건</div>
                </div>

                <div v-if="selectedOrderGroup.items.length === 0" class="empty-text">주문 상세 내역이 없습니다.</div>

                <div class="info-card" v-for="order in selectedOrderGroup.items" :key="'detail-' + order.orderNo">
                    <div class="order-item">
                        <img :src="order.productImage" alt="상품이미지" class="order-img">
                        <div style="flex:1;">
                            <div class="list-title">{{ order.productName }}</div>
                            <div class="list-sub">주문번호 : {{ order.orderNo }}</div>
                            <div class="list-sub">주문일자 : {{ order.orderDate }}</div>
                            <div class="list-sub">수량 : {{ order.qty }}개</div>
                            <div class="list-sub">금액 : {{ order.price }}원</div>
                            <div class="list-sub">배송추적 : {{ order.trackingNo }}</div>
                            <div class="list-status">상태 : {{ order.orderStatus }}</div>
                        </div>
                    </div>

                    <div class="row" style="margin-top:12px;">
                        <label>상세내용</label>
                        <textarea readonly>{{ order.detail }}</textarea>
                    </div>
                </div>
            </div>
        </div>

        <!-- 예약목록 -->
        <div v-if="currentMenu === 'reserveList'">
            <div class="section-box">
                <div class="section-header">
                    <div class="section-title" style="margin-bottom:0;">예약 내역</div>
                    <button class="small-btn" @click="loadReservationAllList">새로고침</button>
                </div>

                <div v-if="reservationAllList.length === 0" class="empty-text">예약 내역이 없습니다.</div>

                <div class="list-item" v-for="item in reservationAllList" :key="'all-' + item.rsvNo">
                    <div class="list-title">예약번호 : {{ item.rsvNo || '-' }}</div>
                    <div class="list-sub">예약일 : {{ item.rsvDate || '-' }}</div>
                    <div class="list-sub">시간 : {{ item.rsvStartTime || '-' }} ~ {{ item.rsvEndTime || '-' }}</div>
                    <div class="list-sub">매장번호 : {{ item.storeNo || '-' }}</div>
                    <div class="list-sub">반려동물번호 : {{ item.petNo || '-' }}</div>
                    <div class="list-sub">요청사항 : {{ item.request || '-' }}</div>
                    <div class="list-status">상태 : {{ item.rsvStatus || '-' }}</div>
                </div>
            </div>
        </div>

        <!-- 반려동물 -->
        <div v-if="currentMenu === 'petEdit'">
            <div class="section-box">
                <div class="section-header">
                    <div class="section-title" style="margin-bottom:0;">반려동물 프로필 관리</div>
                    <button class="small-btn" @click="openAddPetModal">프로필 추가</button>
                </div>

                <div class="pet-list">
                    <div class="pet-card" v-for="pet in petList" :key="'edit-' + pet.petNo">
                        <div class="pet-thumb">
                            <div class="pet-avatar">{{ getPetInitial(pet.petName) }}</div>
                        </div>
                        <div class="pet-body">
                            <div class="pet-name">{{ pet.petName }}</div>
                            <div class="pet-info">{{ pet.species || '' }}{{ pet.birthdate ? ' · ' + getPetAge(pet.birthdate) + '살' : '' }}</div>
                            <div class="pet-btns">
                                <button class="pet-btn edit" @click="openEditPetModal(pet)">수정</button>
                                <button class="pet-btn delete" @click="deletePet(pet.petNo)">삭제</button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- 건강조회 -->
        <div v-if="currentMenu === 'petMyPage'">
            <div class="section-box">
                <div class="section-title">건강 기록 조회</div>
                <div v-if="healthList.length === 0" class="empty-text">건강 기록이 없습니다.</div>
                <div class="info-card" v-for="item in healthList" :key="'h-' + item.id">
                    <div class="list-title">{{ item.title }}</div>
                    <div class="list-sub">기록일 : {{ item.date }}</div>
                    <div class="list-sub">내용 : {{ item.memo }}</div>
                </div>
            </div>

            <div class="section-box">
                <div class="section-title">접종 기록 조회</div>
                <div v-if="vacList.length === 0" class="empty-text">접종 기록이 없습니다.</div>
                <div class="info-card" v-for="item in vacList" :key="'v-' + item.id">
                    <div class="list-title">{{ item.name }}</div>
                    <div class="list-sub">접종일 : {{ item.date }}</div>
                    <div class="list-sub">비고 : {{ item.memo }}</div>
                </div>
            </div>

            <div class="section-box">
                <div class="section-title">몸무게 기록 조회</div>
                <div v-if="weightList.length === 0" class="empty-text">몸무게 기록이 없습니다.</div>
                <div class="info-card" v-for="item in weightList" :key="'w-main-' + item.id">
                    <div class="list-title">{{ item.weight }} kg</div>
                    <div class="list-sub">기록일 : {{ item.date }}</div>
                </div>
            </div>
        </div>

        <!-- 건강기록 -->
        <div v-if="currentMenu === 'petHealthPage'">
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
                    <button @click="saveHealthRecord">등록</button>
                </div>
            </div>

            <div class="section-box">
                <div class="section-title">건강 기록 목록</div>
                <div v-if="healthList.length === 0" class="empty-text">건강 기록이 없습니다.</div>
                <div class="info-card" v-for="item in healthList" :key="'health-' + item.id">
                    <div class="list-title">{{ item.title }}</div>
                    <div class="list-sub">기록일 : {{ item.date }}</div>
                    <div class="list-sub">내용 : {{ item.memo }}</div>
                </div>
            </div>
        </div>

        <!-- 접종기록 -->
        <div v-if="currentMenu === 'petVacPage'">
            <div class="section-box">
                <div class="section-title">접종 기록 등록</div>
                <div class="row">
                    <label>접종명</label>
                    <input type="text" v-model="vacForm.name">
                </div>
                <div class="row">
                    <label>접종일</label>
                    <input type="date" v-model="vacForm.date">
                </div>
                <div class="row">
                    <label>비고</label>
                    <textarea v-model="vacForm.memo"></textarea>
                </div>
                <div class="btn-box">
                    <button @click="saveVacRecord">등록</button>
                </div>
            </div>

            <div class="section-box">
                <div class="section-title">접종 기록 목록</div>
                <div v-if="vacList.length === 0" class="empty-text">접종 기록이 없습니다.</div>
                <div class="info-card" v-for="item in vacList" :key="'vac-' + item.id">
                    <div class="list-title">{{ item.name }}</div>
                    <div class="list-sub">접종일 : {{ item.date }}</div>
                    <div class="list-sub">비고 : {{ item.memo }}</div>
                </div>
            </div>
        </div>

        <!-- 몸무게 -->
        <div v-if="currentMenu === 'petWeightPage'">
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
                    <button @click="saveWeightRecord">등록</button>
                </div>
            </div>

            <div class="section-box">
                <div class="section-title">일자별 몸무게 차트 그래프</div>
                <div class="chart-wrap">
                    <canvas id="weightChart"></canvas>
                </div>
            </div>

            <div class="section-box">
                <div class="section-title">몸무게 기록 목록</div>
                <div v-if="weightList.length === 0" class="empty-text">몸무게 기록이 없습니다.</div>
                <div class="info-card" v-for="item in weightList" :key="'w-' + item.id">
                    <div class="list-title">{{ item.weight }} kg</div>
                    <div class="list-sub">기록일 : {{ item.date }}</div>
                    <div class="list-sub">비고 : {{ item.memo || '-' }}</div>
                </div>
            </div>
        </div>
    </div>

    <!-- 펫 모달 -->
    <div class="modal-wrap" v-if="showPetModal">
        <div class="modal-box">
            <div class="modal-title">{{ petForm.petNo ? '반려동물 프로필 수정' : '반려동물 프로필 추가' }}</div>

            <div class="row">
                <label>이름</label>
                <input type="text" v-model="petForm.petName">
            </div>

            <div class="row">
                <label>종</label>
                <input type="text" v-model="petForm.species">
            </div>

            <div class="row">
                <label>품종</label>
                <input type="text" v-model="petForm.breed">
            </div>

            <div class="row">
                <label>생년월일</label>
                <input type="date" v-model="petForm.birthdate">
            </div>

            <div class="row">
                <label>성별</label>
                <select v-model="petForm.gender">
                    <option value="">선택해주세요</option>
                    <option value="M">수컷</option>
                    <option value="F">암컷</option>
                </select>
            </div>

            <div class="modal-btns">
                <button type="button" class="btn-cancel" @click="closePetModal">취소</button>
                <button type="button" class="btn-save" @click="savePet">저장</button>
            </div>
        </div>
    </div>

    <!-- 비밀번호 모달 -->
    <div class="modal-wrap" v-if="showPwdModal">
        <div class="modal-box">
            <div class="modal-title">비밀번호 변경</div>

            <div class="row">
                <label>현재 비밀번호</label>
                <input type="password" v-model="pwdForm.pwd">
            </div>

            <div class="row">
                <label>새 비밀번호</label>
                <input type="password" v-model="pwdForm.newPwd">
            </div>

            <div class="modal-btns">
                <button type="button" class="btn-cancel" @click="closePwdModal">취소</button>
                <button type="button" class="btn-save" @click="changePassword">변경</button>
            </div>
        </div>
    </div>
</div>

<script>
const app = Vue.createApp({
    data() {
        return {
            currentMenu: "userMyPage",

            user: {
                userName: "",
                nickname: "",
                email: "",
                phone: "",
                zipcode: "",
                userAddr: "",
                fullAddr: ""
            },

            petList: [],
            reservationList: [],
            reservationAllList: [],
            orderList: [],
            healthList: [],
            vacList: [],
            weightList: [
                { id: 1, weight: 4.2, date: "2026-03-01", memo: "" },
                { id: 2, weight: 4.4, date: "2026-04-01", memo: "" },
                { id: 3, weight: 4.5, date: "2026-04-20", memo: "" }
            ],

            showPetModal: false,
            showPwdModal: false,
            weightChart: null,

            selectedOrderGroup: {
                orderDate: "",
                items: []
            },

            petForm: {
                petNo: "",
                petName: "",
                species: "",
                breed: "",
                birthdate: "",
                gender: ""
            },

            pwdForm: {
                pwd: "",
                newPwd: ""
            },

            healthForm: {
                title: "",
                date: "",
                memo: ""
            },

            vacForm: {
                name: "",
                date: "",
                memo: ""
            },

            weightForm: {
                weight: "",
                date: "",
                memo: ""
            }
        };
    },

    computed: {
        pageTitle() {
            const map = {
                userMyPage: "마이페이지",
                orderList: "주문 내역",
                orderDetail: "주문 상세",
                reserveList: "예약 내역",
                petEdit: "반려동물 관리",
                petMyPage: "건강 조회",
                petHealthPage: "건강 기록",
                petVacPage: "접종 기록",
                petWeightPage: "몸무게 관리"
            };
            return map[this.currentMenu] || "마이페이지";
        },

        groupedOrderList() {
            const grouped = {};

            this.orderList.forEach(order => {
                const date = order.orderDate || "날짜없음";
                if (!grouped[date]) {
                    grouped[date] = [];
                }
                grouped[date].push(order);
            });

            return Object.keys(grouped)
                .sort((a, b) => b.localeCompare(a))
                .map(date => ({
                    orderDate: date,
                    items: grouped[date]
                }));
        }
    },

    methods: {
        changeMenu(menu) {
            this.currentMenu = menu;

            if (menu === "reserveList") {
                this.loadReservationAllList();
            }

            if (menu === "orderList") {
                this.loadOrderList();
            }

            if (menu === "petWeightPage") {
                this.$nextTick(() => {
                    this.drawWeightChart();
                });
            }
        },

        goOrderList() {
            this.currentMenu = "orderList";
        },

        openOrderDetail(group) {
            this.selectedOrderGroup = {
                orderDate: group.orderDate,
                items: group.items
            };
            this.currentMenu = "orderDetail";
        },

        loadMypage() {
            const self = this;
            $.ajax({
                url: "/user/mypage.dox",
                type: "POST",
                success: function(data) {
                    if (data.result === "success" && data.userInfo) {
                        self.user = {
                            userName: data.userInfo.userName || "",
                            nickname: data.userInfo.nickname || "",
                            email: data.userInfo.email || "",
                            phone: data.userInfo.phone || "",
                            zipcode: data.userInfo.zipcode || "",
                            userAddr: data.userInfo.userAddr || "",
                            fullAddr: data.userInfo.fullAddr || ""
                        };
                    }
                },
                error: function() {
                    alert("마이페이지 정보를 불러오지 못했습니다.");
                }
            });
        },

        updateUser() {
            const self = this;
            $.ajax({
                url: "/user/update-user.dox",
                type: "POST",
                data: self.user,
                success: function(data) {
                    alert(data.message);
                },
                error: function() {
                    alert("회원정보 수정 중 오류가 발생했습니다.");
                }
            });
        },

        openPwdModal() {
            this.showPwdModal = true;
        },

        closePwdModal() {
            this.showPwdModal = false;
            this.pwdForm = {
                pwd: "",
                newPwd: ""
            };
        },

        changePassword() {
            const self = this;

            $.ajax({
                url: "/user/check-password.dox",
                type: "POST",
                data: { pwd: self.pwdForm.pwd },
                success: function(data) {
                    if (data.result !== "success") {
                        alert(data.message);
                        return;
                    }

                    $.ajax({
                        url: "/user/change-pwd.dox",
                        type: "POST",
                        data: {
                            pwd: self.pwdForm.pwd,
                            newPwd: self.pwdForm.newPwd
                        },
                        success: function(data2) {
                            alert(data2.message);
                            if (data2.result === "success") {
                                self.closePwdModal();
                            }
                        },
                        error: function() {
                            alert("비밀번호 변경 중 오류가 발생했습니다.");
                        }
                    });
                },
                error: function() {
                    alert("비밀번호 확인 중 오류가 발생했습니다.");
                }
            });
        },

        deleteUser() {
            if (!confirm("정말 탈퇴하시겠습니까?")) {
                return;
            }

            $.ajax({
                url: "/user/delete-user.dox",
                type: "POST",
                success: function(data) {
                    alert(data.message);
                    if (data.result === "success") {
                        location.href = "/user/login.do";
                    }
                },
                error: function() {
                    alert("회원 탈퇴 중 오류가 발생했습니다.");
                }
            });
        },

        loadPetList() {
            const self = this;
            $.ajax({
                url: "/user/pet-list.dox",
                type: "POST",
                success: function(data) {
                    if (data.result === "success") {
                        self.petList = data.petList || [];
                    } else {
                        self.petList = [];
                    }
                },
                error: function() {
                    alert("반려동물 목록을 불러오지 못했습니다.");
                }
            });
        },

        getPetInitial(name) {
            if (!name) return "P";
            return name.substring(0, 1);
        },

        getPetAge(birthdate) {
            if (!birthdate) return "";
            const birth = new Date(birthdate);
            const today = new Date();
            let age = today.getFullYear() - birth.getFullYear();

            const monthDiff = today.getMonth() - birth.getMonth();
            const dayDiff = today.getDate() - birth.getDate();

            if (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)) {
                age--;
            }

            return age >= 0 ? age : 0;
        },

        openAddPetModal() {
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

        openEditPetModal(pet) {
            this.petForm = {
                petNo: pet.petNo || "",
                petName: pet.petName || "",
                species: pet.species || "",
                breed: pet.breed || "",
                birthdate: pet.birthdate || "",
                gender: pet.gender || ""
            };
            this.showPetModal = true;
        },

        closePetModal() {
            this.showPetModal = false;
        },

        savePet() {
            const self = this;

            if (!self.petForm.petName) {
                alert("이름을 입력해주세요.");
                return;
            }

            if (!self.petForm.species) {
                alert("종을 입력해주세요.");
                return;
            }

            const url = self.petForm.petNo ? "/user/update-pet.dox" : "/user/add-pet.dox";

            $.ajax({
                url: url,
                type: "POST",
                data: self.petForm,
                success: function(data) {
                    alert(data.message);
                    if (data.result === "success") {
                        self.closePetModal();
                        self.loadPetList();
                    }
                },
                error: function() {
                    alert("반려동물 저장 중 오류가 발생했습니다.");
                }
            });
        },

        deletePet(petNo) {
            const self = this;

            if (!confirm("반려동물 정보를 삭제하시겠습니까?")) {
                return;
            }

            $.ajax({
                url: "/user/delete-pet.dox",
                type: "POST",
                data: { petNo: petNo },
                success: function(data) {
                    alert(data.message);
                    if (data.result === "success") {
                        self.loadPetList();
                    }
                },
                error: function() {
                    alert("반려동물 삭제 중 오류가 발생했습니다.");
                }
            });
        },

        changeMainPet(petNo) {
            const self = this;

            $.ajax({
                url: "/user/change-main-pet.dox",
                type: "POST",
                data: { petNo: petNo },
                success: function(data) {
                    alert(data.message);
                    if (data.result === "success") {
                        self.loadPetList();
                    }
                },
                error: function() {
                    alert("대표 프로필 변경 중 오류가 발생했습니다.");
                }
            });
        },

        loadReservationList() {
            const self = this;

            $.ajax({
                url: "/user/reservation-list.dox",
                type: "POST",
                success: function(data) {
                    if (data.result === "success") {
                        self.reservationList = data.reservationList || [];
                    } else {
                        self.reservationList = [];
                    }
                },
                error: function() {
                    self.reservationList = [];
                    alert("예약 내역을 불러오지 못했습니다.");
                }
            });
        },

        loadReservationAllList() {
            const self = this;

            $.ajax({
                url: "/user/reservation-all-list.dox",
                type: "POST",
                success: function(data) {
                    if (data.result === "success") {
                        self.reservationAllList = data.reservationList || [];
                    } else {
                        self.reservationAllList = [];
                    }
                },
                error: function() {
                    self.reservationAllList = [];
                    alert("전체 예약 내역을 불러오지 못했습니다.");
                }
            });
        },

        loadOrderList() {
            const self = this;

            $.ajax({
                url: "/user/order-list.dox",
                type: "POST",
                success: function(data) {
                    if (data.result === "success") {
                        self.orderList = data.orderList || [];
                    } else {
                        self.orderList = [];
                    }
                },
                error: function() {
                    self.orderList = [];
                    alert("주문 내역을 불러오지 못했습니다.");
                }
            });
        },

        saveHealthRecord() {
            if (!this.healthForm.title || !this.healthForm.date) {
                alert("제목과 날짜를 입력해주세요.");
                return;
            }

            this.healthList.unshift({
                id: Date.now(),
                title: this.healthForm.title,
                date: this.healthForm.date,
                memo: this.healthForm.memo
            });

            alert("건강 기록이 등록되었습니다.");
            this.healthForm = {
                title: "",
                date: "",
                memo: ""
            };
        },

        saveVacRecord() {
            if (!this.vacForm.name || !this.vacForm.date) {
                alert("접종명과 날짜를 입력해주세요.");
                return;
            }

            this.vacList.unshift({
                id: Date.now(),
                name: this.vacForm.name,
                date: this.vacForm.date,
                memo: this.vacForm.memo
            });

            alert("접종 기록이 등록되었습니다.");
            this.vacForm = {
                name: "",
                date: "",
                memo: ""
            };
        },

        saveWeightRecord() {
            if (!this.weightForm.weight || !this.weightForm.date) {
                alert("몸무게와 날짜를 입력해주세요.");
                return;
            }

            this.weightList.push({
                id: Date.now(),
                weight: Number(this.weightForm.weight),
                date: this.weightForm.date,
                memo: this.weightForm.memo
            });

            this.weightList.sort((a, b) => a.date.localeCompare(b.date));

            alert("몸무게 기록이 등록되었습니다.");

            this.weightForm = {
                weight: "",
                date: "",
                memo: ""
            };

            this.$nextTick(() => {
                this.drawWeightChart();
            });
        },

        drawWeightChart() {
            const canvas = document.getElementById("weightChart");
            if (!canvas) return;

            const labels = this.weightList.map(item => item.date);
            const values = this.weightList.map(item => item.weight);

            if (this.weightChart) {
                this.weightChart.destroy();
            }

            this.weightChart = new Chart(canvas, {
                type: "line",
                data: {
                    labels: labels,
                    datasets: [{
                        label: "몸무게 (kg)",
                        data: values,
                        fill: false,
                        tension: 0.3,
                        borderWidth: 2,
                        pointRadius: 4,
                        pointHoverRadius: 6
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: {
                        legend: {
                            display: true
                        }
                    },
                    scales: {
                        y: {
                            beginAtZero: false
                        }
                    }
                }
            });
        }
    },

    mounted() {
        this.loadMypage();
        this.loadPetList();
        this.loadReservationList();
        this.loadReservationAllList();
        this.loadOrderList();
    }
});

app.mount("#app");
</script>
</body>
</html>