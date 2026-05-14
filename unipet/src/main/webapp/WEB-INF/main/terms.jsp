<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>UNIPET</title>

<link rel="stylesheet" href="/css/main/terms.css">
</head>
<body>

<jsp:include page="/WEB-INF/header/header.jsp" />

<div class="terms-wrap">
    <div class="terms-container">

        <div class="terms-header">
            <h1>이용약관</h1>
            <p>유니펫 서비스 이용과 관련된 약관입니다.</p>
        </div>

        <div class="terms-box">

            <section class="terms-section">
                <h2>제1조 (목적)</h2>
                <p>
                    본 약관은 유니펫(이하 “회사”)이 제공하는 반려동물 관련 서비스
                    (예약, 쇼핑몰, 커뮤니티 등)의 이용과 관련하여 회사와 회원 간의
                    권리, 의무 및 책임사항을 규정함을 목적으로 합니다.
                </p>
            </section>

            <section class="terms-section">
                <h2>제2조 (정의)</h2>
                <p>① “서비스”란 회사가 제공하는 반려동물 관련 예약, 상품 구매, 커뮤니티 등의 모든 서비스를 의미합니다.</p>
                <p>② “회원”이란 본 약관에 동의하고 서비스를 이용하는 자를 말합니다.</p>
                <p>③ “일반회원”이란 개인 자격으로 서비스를 이용하는 회원을 말합니다.</p>
                <p>④ “사업자회원”이란 업체를 등록하고 서비스를 제공하는 회원을 말합니다.</p>
                <p>⑤ “예약”이란 회원이 사업자가 제공하는 서비스를 일정 시간에 이용하기 위해 신청하는 행위를 의미합니다.</p>
            </section>

            <section class="terms-section">
                <h2>제3조 (약관의 효력 및 변경)</h2>
                <p>① 본 약관은 서비스 화면에 게시하거나 기타 방법으로 공지함으로써 효력이 발생합니다.</p>
                <p>② 회사는 관련 법령을 위배하지 않는 범위에서 약관을 변경할 수 있으며, 변경 시 사전 공지합니다.</p>
            </section>

            <section class="terms-section">
                <h2>제4조 (회원가입 및 이용계약)</h2>
                <p>① 회원가입은 이용자가 약관에 동의하고 회사가 이를 승인함으로써 체결됩니다.</p>
                <p>② 회원은 가입 시 정확한 정보를 입력해야 하며, 허위 정보 입력으로 인한 책임은 회원에게 있습니다.</p>
                <p>③ 회원은 자신의 계정 정보를 안전하게 관리할 책임이 있습니다.</p>
            </section>

            <section class="terms-section">
                <h2>제5조 (서비스 이용)</h2>
                <p>① 회사는 다음과 같은 서비스를 제공합니다.</p>
                <ul>
                    <li>반려동물 관련 예약 서비스</li>
                    <li>상품 판매 및 구매 서비스</li>
                    <li>커뮤니티 및 정보 공유 서비스</li>
                </ul>
                <p>② 서비스 이용은 회사의 정책에 따라 제한될 수 있습니다.</p>
            </section>

            <section class="terms-section">
                <h2>제6조 (예약 서비스)</h2>
                <p>① 예약은 이용자가 예약금을 결제한 시점에 확정됩니다.</p>
                <p>② 예약 서비스는 회사가 제공하는 중개 서비스이며, 실제 서비스 제공 및 책임은 해당 사업자에게 있습니다.</p>
            </section>

            <section class="terms-section">
                <h2>제7조 (예약 취소 및 환불 정책)</h2>
                <p>① 회원은 마이페이지 또는 고객센터를 통해 예약 취소를 요청할 수 있습니다.</p>

                <div class="refund-table">
                    <div class="refund-row">
                        <span>예약일 3일 전까지 취소</span>
                        <strong>전액 환불</strong>
                    </div>
                    <div class="refund-row">
                        <span>예약일 1~2일 전 취소</span>
                        <strong>50% 환불</strong>
                    </div>
                    <div class="refund-row">
                        <span>예약 당일 취소 또는 미방문</span>
                        <strong>환불 불가</strong>
                    </div>
                </div>

                <p>② 환불 금액은 결제 수단에 따라 처리되며, 처리 기간은 영업일 기준 3~7일이 소요될 수 있습니다.</p>
                <p>③ 사업자의 사정으로 예약이 취소된 경우, 회원에게 전액 환불됩니다.</p>
                <p>④ 각 업체는 별도의 환불 정책을 설정할 수 있으며, 해당 정책이 우선 적용될 수 있습니다.</p>
                <p>⑤ 회원의 귀책 사유로 서비스 이용이 불가능한 경우 환불이 제한될 수 있습니다.</p>
                <p>⑥ 반려동물의 상태를 사전에 고지하지 않아 서비스 제공이 거부된 경우 환불이 제한될 수 있습니다.</p>
            </section>

            <section class="terms-section">
                <h2>제8조 (쇼핑몰 이용)</h2>
                <p>① 회원은 상품을 구매할 수 있으며 결제는 회사가 제공하는 결제수단을 이용합니다.</p>
                <p>② 상품의 배송, 교환 및 환불은 판매자의 정책 및 관련 법령에 따릅니다.</p>
            </section>

            <section class="terms-section">
                <h2>제9조 (커뮤니티 이용)</h2>
                <p>① 회원은 게시글 및 댓글을 작성할 수 있습니다.</p>
                <p>② 다음과 같은 행위는 금지됩니다.</p>
                <ul>
                    <li>타인을 비방하거나 명예를 훼손하는 행위</li>
                    <li>욕설, 음란물, 불법 콘텐츠 게시</li>
                    <li>광고 및 도배 행위</li>
                </ul>
                <p>③ 위반 시 게시물 삭제 및 서비스 이용 제한이 될 수 있습니다.</p>
            </section>

            <section class="terms-section">
                <h2>제10조 (리뷰 및 신고)</h2>
                <p>① 회원은 서비스 이용 후 리뷰를 작성할 수 있습니다.</p>
                <p>② 허위 리뷰 또는 악의적인 리뷰는 삭제될 수 있습니다.</p>
                <p>③ 신고된 게시물 및 리뷰는 회사의 정책에 따라 처리됩니다.</p>
            </section>

            <section class="terms-section">
                <h2>제11조 (회원의 의무)</h2>
                <p>회원은 다음 행위를 하여서는 안 됩니다.</p>
                <ul>
                    <li>타인의 계정을 도용하는 행위</li>
                    <li>서비스 운영을 방해하는 행위</li>
                    <li>관련 법령을 위반하는 행위</li>
                </ul>
            </section>

            <section class="terms-section">
                <h2>제12조 (회사의 의무)</h2>
                <p>
                    회사는 안정적인 서비스 제공을 위해 노력하며,
                    이용자의 개인정보를 보호합니다.
                </p>
            </section>

            <section class="terms-section">
                <h2>제13조 (서비스 이용 제한)</h2>
                <p>① 회사는 회원이 약관을 위반할 경우 서비스 이용을 제한하거나 회원 자격을 박탈할 수 있습니다.</p>
                <p>② 회원은 언제든지 탈퇴를 요청할 수 있으며, 회사는 관련 법령에 따라 처리합니다.</p>
            </section>

            <section class="terms-section">
                <h2>제14조 (면책조항)</h2>
                <p>① 회사는 회원과 사업자 간 거래에서 발생한 분쟁에 대해 책임을 지지 않습니다.</p>
                <p>② 회사는 천재지변, 시스템 장애 등 불가항력으로 인한 서비스 중단에 대해 책임을 지지 않습니다.</p>
            </section>

            <section class="terms-section">
                <h2>제15조 (개인정보 보호)</h2>
                <p>
                    회사는 관련 법령에 따라 회원의 개인정보를 보호하며,
                    자세한 내용은 개인정보처리방침에 따릅니다.
                </p>
            </section>

            <section class="terms-section">
                <h2>제16조 (준거법 및 관할)</h2>
                <p>
                    본 약관은 대한민국 법률에 따라 해석되며,
                    서비스 이용과 관련한 분쟁은 회사의 본사 소재지를 관할하는 법원을 따릅니다.
                </p>
            </section>

            <div class="terms-footer">
                <p>부칙</p>
                <p>본 약관은 2026년 4월 30일부터 시행됩니다.</p>
            </div>

        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/footer/footer.jsp" />

</body>
</html>