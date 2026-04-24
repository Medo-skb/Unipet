<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Document</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/header.css">
</head>
<body>
    <header class="site-header">
        <div class="header-container">
            <div class="header-left">
                <a href="${pageContext.request.contextPath}/main.do" class="logo-link">
                    <img src="${pageContext.request.contextPath}/img/main/logo.png" alt="로고" class="logo-image">
                </a>
            </div>

            <div class="header-center">
                <form class="search-form" action="${pageContext.request.contextPath}/main/search.do" method="get">
                    <input spellcheck="false" autocorrect="off" autocomplete="off"
                    type="text" name="keyword" class="search-input" placeholder="검색어를 입력하세요">
                    <button type="submit" class="search-btn" aria-label="검색">
                        <svg viewBox="0 0 24 24" aria-hidden="true">
                            <circle cx="11" cy="11" r="7"></circle>
                            <line x1="20" y1="20" x2="16.65" y2="16.65"></line>
                        </svg>
                    </button>
                </form>
            </div>

            <div class="header-right">
                <nav class="main-nav">
                    <a href="${pageContext.request.contextPath}/reservation/search.do" class="nav-link">예약</a>
                    <a href="${pageContext.request.contextPath}/product.do" class="nav-link">쇼핑</a>
                    <a href="#" class="nav-link">커뮤니티</a>
                    <a href="#" class="nav-link">관광지</a>
                </nav>

                <div class="user-menu-wrap">
                    <c:choose>
                        <c:when test="${empty sessionScope.sessionId}">
                            <a href="${pageContext.request.contextPath}/user/login.do" class="user-link">
                                <img src="${pageContext.request.contextPath}/img/main/login.png"
                                    alt="로그인"
                                    class="user-icon">
                            </a>
                        </c:when>

                        <c:when test="${sessionScope.sessionRole eq 'USER'}">
                            <a href="${pageContext.request.contextPath}/user/mypage.do" class="user-link">
                                <img src="${pageContext.request.contextPath}/img/main/mypage.png"
                                    alt="마이페이지"
                                    class="user-icon">
                            </a>
                            <a href="${pageContext.request.contextPath}/logout.do" class="logout-btn"
                            onclick="return confirm('로그아웃 하시겠습니까?');">로그아웃</a>
                        </c:when>

                        <c:when test="${sessionScope.sessionRole eq 'BIZ'}">
                            <a href="${pageContext.request.contextPath}/biz/MyPage.do" class="user-link">
                                <img src="${pageContext.request.contextPath}/img/main/mypage.png"
                                    alt="사업자 마이페이지"
                                    class="user-icon">
                            </a>
                            <a href="${pageContext.request.contextPath}/logout.do" class="logout-btn"
                            onclick="return confirm('로그아웃 하시겠습니까?');">로그아웃</a>
                        </c:when>

                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/user/login.do" class="user-link">
                                <img src="${pageContext.request.contextPath}/img/main/login.png"
                                    alt="로그인"
                                    class="user-icon">
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
    </header>
</body>
</html>

<script>

</script>