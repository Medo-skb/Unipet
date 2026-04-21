<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<title>마이페이지</title>
<script src="https://code.jquery.com/jquery-3.7.1.min.js"></script>
<style>
    * {
        box-sizing: border-box;
    }

    body {
        margin: 0;
        padding: 0;
        font-family: Arial, sans-serif;
        background-color: #f7f8fa;
    }

    .mypage-wrap {
        width: 1200px;
        margin: 30px auto;
        display: flex;
        gap: 20px;
    }

    .sidebar {
        width: 220px;
        background: #fff;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }

    .sidebar h3 {
        margin-top: 0;
        margin-bottom: 20px;
        font-size: 22px;
    }

    .sidebar ul {
        list-style: none;
        padding: 0;
        margin: 0;
    }

    .sidebar ul li {
        padding: 12px 0;
        border-bottom: 1px solid #eee;
        cursor: pointer;
    }

    .content {
        flex: 1;
    }

    .section {
        background: #fff;
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 20px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.05);
    }

    .section h2 {
        margin: 0 0 16px 0;
        font-size: 22px;
    }

    .pet-list {
        display: flex;
        gap: 15px;
        flex-wrap: wrap;
    }

    .pet-card {
        width: 220px;
        border: 1px solid #e5e5e5;
        border-radius: 12px;
        padding: 15px;
        background: #fafafa;
    }

    .pet-name {
        font-size: 18px;
        font-weight: bold;
        margin-bottom: 8px;
    }

    .pet-info {
        font-size: 14px;
        color: #555;
        margin-bottom: 5px;
    }

    .main-badge {
        display: inline-block;
        margin-top: 8px;
        padding: 4px 8px;
        background: #ffefb3;
        border-radius: 8px;
        font-size: 12px;
    }

    .btn {
        margin-top: 10px;
        padding: 8px 12px;
        border: none;
        border-radius: 8px;
        background: #333;
        color: #fff;
        cursor: pointer;
    }

    .grid-box {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
    }

    .item-box {
        border: 1px solid #eee;
        border-radius: 10px;
        padding: 15px;
        background: #fafafa;
        min-height: 120px;
    }

    .item-title {
        font-size: 18px;
        font-weight: bold;
        margin-bottom: 12px;
    }

    .empty-text {
        color: #999;
        font-size: 14px;
    }

    .line-item {
        padding: 8px 0;
        border-bottom: 1px solid #ececec;
        font-size: 14px;
    }

    .line-item:last-child {
        border-bottom: none;
    }
</style>
</head>
<body>

<div class="mypage-wrap">
    <div class="sidebar">
        <h3>마이페이지</h3>
        <ul>
            <li>내 정보</li>
            <li>반려동물 관리</li>
            <li>예약 내역</li>
            <li>주문 내역</li>
            <li>구독 관리</li>
            <li>즐겨찾기</li>
        </ul>
    </div>

    <div class="content">
        <div class="section">
            <h2>내 반려동물</h2>
            <div class="pet-list" id="petList"></div>
        </div>

        <div class="grid-box">
            <div class="section">
                <h2>최근 예약</h2>
                <div id="reservationList"></div>
            </div>

            <div class="section">
                <h2>최근 주문</h2>
                <div id="orderList"></div>
            </div>

            <div class="section">
                <h2>구독 정보</h2>
                <div id="subscriptionBox"></div>
            </div>

            <div class="section">
                <h2>즐겨찾기</h2>
                <div id="favoriteList"></div>
            </div>
        </div>
    </div>
</div>

<script>
$(function(){
    loadMypage();
});

function loadMypage() {
    $.ajax({
        url : "/user/mypage.dox",
        type : "POST",
        success : function(res) {
            var data = typeof res === "string" ? JSON.parse(res) : res;

            renderPetList(data.petList);
            renderReservationList(data.reservationList);
            renderOrderList(data.orderList);
            renderSubscription(data.subscription);
            renderFavoriteList(data.favoriteList);
        },
        error : function() {
            alert("마이페이지 정보를 불러오지 못했습니다.");
        }
    });
}

function renderPetList(list) {
    var html = "";

    if (list && list.length > 0) {
        for (var i = 0; i < list.length; i++) {
            var p = list[i];

            html += "<div class='pet-card'>";
            html += "<div class='pet-name'>" + nvl(p.petName) + "</div>";
            html += "<div class='pet-info'>종류 : " + nvl(p.petType) + "</div>";
            html += "<div class='pet-info'>품종 : " + nvl(p.petBreed) + "</div>";
            html += "<div class='pet-info'>나이 : " + nvl(p.petAge) + "</div>";

            if (p.isMain === "Y") {
                html += "<div class='main-badge'>대표 반려동물</div>";
            } else {
                html += "<button type='button' class='btn' onclick='changeMain(" + p.petId + ")'>대표 설정</button>";
            }

            html += "</div>";
        }
    } else {
        html = "<div class='empty-text'>등록된 반려동물이 없습니다.</div>";
    }

    $("#petList").html(html);
}

function renderReservationList(list) {
    var html = "";

    if (list && list.length > 0) {
        for (var i = 0; i < list.length; i++) {
            var r = list[i];
            html += "<div class='line-item'>";
            html += "<div>예약명 : " + nvl(r.resTitle) + "</div>";
            html += "<div>예약일 : " + nvl(r.resDate) + "</div>";
            html += "<div>상태 : " + nvl(r.resStatus) + "</div>";
            html += "</div>";
        }
    } else {
        html = "<div class='empty-text'>예약 내역이 없습니다.</div>";
    }

    $("#reservationList").html(html);
}

function renderOrderList(list) {
    var html = "";

    if (list && list.length > 0) {
        for (var i = 0; i < list.length; i++) {
            var o = list[i];
            html += "<div class='line-item'>";
            html += "<div>상품명 : " + nvl(o.productName) + "</div>";
            html += "<div>주문일 : " + nvl(o.orderDate) + "</div>";
            html += "<div>배송상태 : " + nvl(o.deliveryStatus) + "</div>";
            html += "</div>";
        }
    } else {
        html = "<div class='empty-text'>주문 내역이 없습니다.</div>";
    }

    $("#orderList").html(html);
}

function renderSubscription(sub) {
    var html = "";

    if (sub) {
        html += "<div class='line-item'>플랜명 : " + nvl(sub.planName) + "</div>";
        html += "<div class='line-item'>만료일 : " + nvl(sub.endDate) + "</div>";
        html += "<div class='line-item'>상태 : " + nvl(sub.subStatus) + "</div>";
    } else {
        html = "<div class='empty-text'>구독 정보가 없습니다.</div>";
    }

    $("#subscriptionBox").html(html);
}

function renderFavoriteList(list) {
    var html = "";

    if (list && list.length > 0) {
        for (var i = 0; i < list.length; i++) {
            var f = list[i];
            html += "<div class='line-item'>";
            html += "<div>이름 : " + nvl(f.favName) + "</div>";
            html += "<div>유형 : " + nvl(f.favType) + "</div>";
            html += "</div>";
        }
    } else {
        html = "<div class='empty-text'>즐겨찾기 내역이 없습니다.</div>";
    }

    $("#favoriteList").html(html);
}

function changeMain(petId) {
    $.ajax({
        url : "/user/change-main-pet.dox",
        type : "POST",
        data : { petId : petId },
        success : function(res) {
            var data = typeof res === "string" ? JSON.parse(res) : res;

            if (data.result === "success") {
                alert("대표 반려동물로 변경되었습니다.");
                loadMypage();
            } else {
                alert("대표 반려동물 변경에 실패했습니다.");
            }
        },
        error : function() {
            alert("대표 반려동물 변경 중 오류가 발생했습니다.");
        }
    });
}

function nvl(value) {
    if (value === null || value === undefined || value === "") {
        return "-";
    }
    return value;
}
</script>

</body>
</html>

