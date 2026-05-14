<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>회사소개 | Unipet</title>
<link rel="stylesheet" href="/css/main/about.css">
</head>
<body>

<jsp:include page="/WEB-INF/header/header.jsp" />

<main class="company-page">

    <section class="company-hero fade-up">
        <div class="hero-inner">
            <p class="hero-label">ABOUT UNIPET</p>
            <h1>
                반려동물과 보호자의 일상을<br>
                더 쉽고 연결합니다.
            </h1>
            <p class="hero-desc">
                Unipet은 예약, 쇼핑, 커뮤니티를 하나로 연결하여
                반려생활을 더 편리하게 만드는 통합 플랫폼입니다.
            </p>
        </div>
    </section>

    <section class="company-section intro-section">
        <div class="section-title fade-up">
            <p>UNIPET SERVICE</p>
            <h2>반려생활에 필요한 모든 서비스</h2>
        </div>

        <div class="intro-grid">
            <div class="intro-card fade-up">
                <span>01</span>
                <h3>예약 서비스</h3>
                <p>병원, 미용, 호텔을 간편하게 예약할 수 있습니다.</p>
            </div>

            <div class="intro-card fade-up">
                <span>02</span>
                <h3>쇼핑</h3>
                <p>사료, 간식, 용품을 한곳에서 구매할 수 있습니다.</p>
            </div>

            <div class="intro-card fade-up">
                <span>03</span>
                <h3>커뮤니티</h3>
                <p>보호자들이 자유롭게 소통하고 정보를 공유합니다.</p>
            </div>
        </div>
    </section>

    <section class="value-section fade-up">
        <div class="value-box">
            <div class="value-text">
                <p class="section-label">OUR VALUE</p>
                <h2>편리함과 신뢰를 동시에</h2>
                <p>
                    Unipet은 단순한 플랫폼을 넘어,
                    보호자가 신뢰할 수 있는 선택을 돕는 서비스를 제공합니다.
                </p>
            </div>

            <div class="value-list">
                <div>
                    <strong>신뢰</strong>
                    <p>후기와 정보를 기반으로 선택을 돕습니다.</p>
                </div>
                <div>
                    <strong>편리</strong>
                    <p>모든 서비스를 하나로 이용할 수 있습니다.</p>
                </div>
                <div>
                    <strong>연결</strong>
                    <p>보호자와 업체를 자연스럽게 연결합니다.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="company-section business-section">
        <div class="section-title fade-up">
            <p>KEY BUSINESS</p>
            <h2>핵심 서비스</h2>
        </div>

        <div class="business-list">
            <div class="business-item fade-up">
                <div class="business-num">01</div>
                <div>
                    <h3>예약 플랫폼</h3>
                    <p>카테고리별 업체를 검색하고 예약할 수 있습니다.</p>
                </div>
            </div>

            <div class="business-item fade-up">
                <div class="business-num">02</div>
                <div>
                    <h3>쇼핑몰</h3>
                    <p>반려동물 상품을 쉽게 구매할 수 있습니다.</p>
                </div>
            </div>

            <div class="business-item fade-up">
                <div class="business-num">03</div>
                <div>
                    <h3>커뮤니티</h3>
                    <p>정보 공유와 소통 공간을 제공합니다.</p>
                </div>
            </div>
        </div>
    </section>

    <section class="vision-section fade-up">
        <p class="section-label">VISION</p>
        <h2>
            더 나은 반려생활을 위한 플랫폼
        </h2>
        <p>
            보호자와 반려동물이 더 편리하고 행복한 일상을 누릴 수 있도록
            Unipet은 계속 발전합니다.
        </p>
    </section>

</main>

<jsp:include page="/WEB-INF/footer/footer.jsp" />

<script>
document.addEventListener("DOMContentLoaded", function () {
    const items = document.querySelectorAll(".fade-up");

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(function(entry) {
            if (entry.isIntersecting) {
                entry.target.classList.add("show");
            }
        });
    }, {
        threshold: 0.15
    });

    items.forEach(function(el) {
        observer.observe(el);
    });
});
</script>

</body>
</html>