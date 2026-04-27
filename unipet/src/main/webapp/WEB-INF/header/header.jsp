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
                    <a href="${pageContext.request.contextPath}/board/list.do" class="nav-link">커뮤니티</a>
                </nav>

                <div class="user-menu-wrap">
                    <c:choose>
                        <c:when test="${empty sessionScope.sessionId}">
                            <a href="${pageContext.request.contextPath}/user/login.do" class="header-icon-link" aria-label="로그인">
                                <svg class="header-icon" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M10 17l5-5-5-5"></path>
                                    <path d="M15 12H3"></path>
                                    <path d="M21 3v18"></path>
                                </svg>
                            </a>
                        </c:when>

                        <c:when test="${sessionScope.sessionRole eq 'USER'}">
                            <a href="${pageContext.request.contextPath}/user/mypage.do" class="header-icon-link" aria-label="마이페이지">
                                <svg class="header-icon" viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="12" cy="7" r="4"></circle>
                                    <path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8"></path>
                                </svg>
                            </a>

                            <a href="${pageContext.request.contextPath}/cart.do" class="header-icon-link cart-icon-wrap" aria-label="장바구니">
                                
                                <svg class="header-icon" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M3 4h2l2.4 11.5h10.2L20 8H7"></path>
                                    <circle cx="9" cy="20" r="1.5"></circle>
                                    <circle cx="17" cy="20" r="1.5"></circle>
                                </svg>

                                <c:if test="${sessionScope.cartCount > 0}">
                                    <span class="cart-count">
                                        <c:choose>
                                            <c:when test="${sessionScope.cartCount > 99}">99+</c:when>
                                            <c:otherwise>${sessionScope.cartCount}</c:otherwise>
                                        </c:choose>
                                    </span>
                                </c:if>

                            </a>

                            <a href="${pageContext.request.contextPath}/logout.do" class="logout-btn">로그아웃</a>
                        </c:when>

                        <c:when test="${sessionScope.sessionRole eq 'BIZ'}">
                            <a href="${pageContext.request.contextPath}/biz/MyPage.do" class="header-icon-link" aria-label="사업자 마이페이지">
                                <svg class="header-icon" viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="12" cy="7" r="4"></circle>
                                    <path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8"></path>
                                </svg>
                            </a>

                            <a href="${pageContext.request.contextPath}/logout.do" class="logout-btn">로그아웃</a>
                        </c:when>

                        <c:when test="${sessionScope.sessionRole eq 'ADMIN'}">

                            <a href="${pageContext.request.contextPath}/admin.do" class="header-icon-link" aria-label="관리자 페이지">
                                <svg class="header-icon" viewBox="0 0 24 24" aria-hidden="true">
                                    <circle cx="12" cy="7" r="4"></circle>
                                    <path d="M4 21c0-4.4 3.6-8 8-8s8 3.6 8 8"></path>
                                </svg>
                            </a>

                            <a href="${pageContext.request.contextPath}/admin/logout.do" class="logout-btn">
                                로그아웃
                            </a>

                        </c:when>

                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/user/login.do" class="header-icon-link" aria-label="로그인">
                                <svg class="header-icon" viewBox="0 0 24 24" aria-hidden="true">
                                    <path d="M10 17l5-5-5-5"></path>
                                    <path d="M15 12H3"></path>
                                    <path d="M21 3v18"></path>
                                </svg>
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