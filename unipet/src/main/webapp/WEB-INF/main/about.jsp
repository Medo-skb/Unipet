<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>UNIPET</title>

<link rel="stylesheet" href="/css/main/about.css">
</head>
<body>

<jsp:include page="/WEB-INF/header/header.jsp" />

<div class="about-wrap">
    <div class="about-container">

        <!-- 타이틀 -->
        <div class="about-header">
            <h1>유니펫</h1>
            <p>반려동물과 보호자를 연결하는 통합 플랫폼</p>
        </div>

        <!-- 소개 -->
        <section class="about-section">
            <h2>서비스 소개</h2>
            <p>
                유니펫은 반려동물과 보호자를 위한 통합 플랫폼으로,
                예약, 쇼핑, 커뮤니티 서비스를 하나의 공간에서 제공합니다.
            </p>
            <p>
                사용자는 쉽고 빠르게 원하는 업체를 예약하고,
                다양한 반려동물 상품을 구매하며,
                커뮤니티를 통해 정보를 공유할 수 있습니다.
            </p>
        </section>

        <!-- 핵심 기능 -->
        <section class="about-section">
            <h2>핵심 기능</h2>

            <div class="about-grid">
                <div class="about-card">
                    <h3>예약 서비스</h3>
                    <p>동물병원, 미용 등 다양한 업체를 쉽고 빠르게 예약할 수 있습니다.</p>
                </div>

                <div class="about-card">
                    <h3>쇼핑몰</h3>
                    <p>반려동물 관련 상품을 편리하게 구매할 수 있습니다.</p>
                </div>

                <div class="about-card">
                    <h3>커뮤니티</h3>
                    <p>정보 공유와 소통을 위한 커뮤니티 공간을 제공합니다.</p>
                </div>
            </div>
        </section>

        <!-- 가치 -->
        <section class="about-section">
            <h2>서비스 가치</h2>
            <ul class="about-list">
                <li>신뢰할 수 있는 업체 연결</li>
                <li>편리한 예약 시스템</li>
                <li>안전한 거래 환경</li>
                <li>활발한 커뮤니티</li>
            </ul>
        </section>

        <!-- 문의 -->
        <section class="about-section">
            <h2>고객 지원</h2>
            <p>서비스 이용 중 문의사항이 있으시면 고객센터를 이용해주세요.</p>
            <p>이메일: unipet@example.com</p>
        </section>

    </div>
</div>

<jsp:include page="/WEB-INF/footer/footer.jsp" />

</body>
</html>