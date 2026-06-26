<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>UNIPET</title>

    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main/customer.css">
</head>
<body>

<jsp:include page="/WEB-INF/header/header.jsp" />

<div id="app" v-cloak>
    <div class="customer-wrap">

        <jsp:include page="/WEB-INF/main/customer/customerSidebar.jsp">
            <jsp:param name="activeMenu" value="inquiry" />
        </jsp:include>

        <section class="customer-content">
            <div class="customer-card">
                <h2>홈페이지 문의</h2>
                <p class="customer-desc">
                    UNIPET 이용 중 궁금한 점이나 불편한 점을 남겨주세요.
                </p>

                <table class="customer-form-table">
                    <tbody>
                        <tr>
                            <th>문의 유형</th>
                            <td>
                                <select class="customer-select" v-model="qna.unaType">
                                    <option value="">문의 유형 선택</option>
                                    <option value="계정/로그인">계정/로그인</option>
                                    <option value="결제">결제</option>
                                    <option value="배송">배송</option>
                                    <option value="교환/반품/환불">교환/반품/환불</option>
                                    <option value="쿠폰/이벤트">쿠폰/이벤트</option>
                                    <option value="사이트 오류">사이트 오류</option>
                                    <option value="입점/사업자 문의">입점/사업자 문의</option>
                                    <option value="기타">기타</option>
                                </select>
                            </td>
                        </tr>

                        <tr>
                            <th>문의 제목</th>
                            <td>
                                <input type="text"
                                       class="customer-input"
                                       v-model="qna.unaTitle"
                                       placeholder="문의 제목을 입력해주세요.">
                            </td>
                        </tr>

                        <tr>
                            <th>본문</th>
                            <td>
                                <textarea class="customer-textarea"
                                          v-model="qna.unaContent"
                                          placeholder="문의 내용을 자세히 입력해주세요."></textarea>
                            </td>
                        </tr>
                    </tbody>
                </table>

                <div class="customer-btn-box">
                    <button type="button" class="btn-cancel" @click="fnReset">초기화</button>
                    <button type="button" class="btn-submit" @click="fnSubmitQna">문의 하기</button>
                </div>
            </div>
        </section>
    </div>
</div>

<jsp:include page="/WEB-INF/footer/footer.jsp" />

<script>
const app = Vue.createApp({
    data() {
        return {
            qna: {
                unaType: "",
                unaTitle: "",
                unaContent: ""
            }
        };
    },
    methods: {
        fnReset() {
            this.qna = {
                unaType: "",
                unaTitle: "",
                unaContent: ""
            };
        },

        fnSubmitQna() {
            let self = this;

            if (!self.qna.unaType) {
                alert("문의 유형을 선택해주세요.");
                return;
            }

            if (!self.qna.unaTitle.trim()) {
                alert("문의 제목을 입력해주세요.");
                return;
            }

            if (!self.qna.unaContent.trim()) {
                alert("본문을 입력해주세요.");
                return;
            }

            $.ajax({
                url: "/unipet/customer/inquiry/insert.dox",
                type: "POST",
                dataType: "json",
                data: self.qna,
                success: function(data) {
                    if (data.result === "success") {
                        alert("문의가 등록되었습니다.");
                        location.href = "/unipet/customer/inquiry.do";
                    } else if (data.result === "notLogin") {
                        alert("로그인 후 문의할 수 있습니다.");
                        location.href = "/user/login.do";
                    } else {
                        alert(data.message || "문의 등록에 실패했습니다.");
                    }
                },
                error: function() {
                    alert("문의 등록 중 오류가 발생했습니다.");
                }
            });
        }
    }
});

app.mount("#app");
</script>

</body>
</html>