<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>UNIPET Admin</title>
    <script src="https://code.jquery.com/jquery-3.7.1.js" integrity="sha256-eKhayi8LEQwp4NKxN+CfCh+3qOVUtJn3QNZ0TciWLP4=" crossorigin="anonymous"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
</head>
<body>

    <!-- 헤더 -->
    <jsp:include page="/WEB-INF/header/header.jsp" />

    <div id="app">
        <div class="container-main">
            <div class="admin-wrap">
                <!-- 왼쪽 메뉴 -->
                <aside class="admin-sidebar">
                    <div 
                        class="menu-item"
                        :class="{ active : currentMenu === 'dashboard' }"
                        @click="fnChangeMenu('dashboard')">
                        전체 현황판
                    </div>

                    <div 
                        class="menu-item"
                        :class="{ active : currentMenu === 'report' }"
                        @click="fnChangeMenu('report')">
                        커뮤니티 및 리뷰 신고리스트
                    </div>

                    <div 
                        class="menu-item"
                        :class="{ active : currentMenu === 'storeApprove' }"
                        @click="fnChangeMenu('storeApprove')">
                        사업자 입점 승인 관리
                    </div>

                    <div 
                        class="menu-item"
                        :class="{ active : currentMenu === 'banner' }"
                        @click="fnChangeMenu('banner')">
                        배너 관리
                    </div>
                </aside>

                <!-- 오른쪽 내용 -->
                <section class="admin-content">
                    <div class="content-card">
                        <template v-if="currentMenu === 'dashboard'">
                            <h2>전체 현황판</h2>
                            <div class="content-desc">여기에 전체 현황판 내용 들어감</div>
                        </template>

                        <template v-if="currentMenu === 'report'">
                            <h2>커뮤니티 및 리뷰 신고리스트</h2>
                            <div class="content-desc">여기에 신고리스트 내용 들어감</div>
                        </template>

                        <template v-if="currentMenu === 'storeApprove'">
                            <h2>사업자 입점 승인 관리</h2>
                            <div class="content-desc">승인 대기 중인 사업자 목록입니다.</div>

                            <div class="approve-list" v-if="approveList && approveList.length > 0">
                                <template v-for="item in approveList" :key="item.storeNo">
                                    <div class="approve-card" v-if="item.uStatus === 'PND'">
                                        <table class="approve-table">
                                            <tbody>
                                                <tr>
                                                    <th>업체 번호</th>
                                                    <td>{{ item.storeNo }}</td>
                                                </tr>
                                                <tr>
                                                    <th>아이디</th>
                                                    <td>{{ item.sUserId }}</td>
                                                </tr>
                                                <tr>
                                                    <th>업체명</th>
                                                    <td>{{ item.storeName }}</td>
                                                </tr>
                                                <tr>
                                                    <th>업종</th>
                                                    <td>{{ item.sCategory }}</td>
                                                </tr>
                                                <tr>
                                                    <th>주소</th>
                                                    <td>{{ item.sAddr }} {{ item.sFullAddr }}</td>
                                                </tr>
                                                <tr>
                                                    <th>상태</th>
                                                    <td>
                                                        {{
                                                            item.uStatus === 'PND' ? '승인 대기'
                                                            : item.uStatus === 'APR' ? '승인'
                                                            : item.uStatus === 'REJ' ? '거부'
                                                            : item.uStatus
                                                        }}
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>사업자 등록증 사본</th>
                                                    <td>
                                                        <a v-if="item.filePath && item.fileName"
                                                        href="javascript:;"
                                                        class="file-link"
                                                        @click="fnFilePreview(item)">
                                                            {{ item.originName }}
                                                        </a>
                                                        <span v-else>사업자 등록증 사본 파일이 없습니다.</span>
                                                    </td>
                                                </tr>
                                            </tbody>
                                        </table>

                                        <div class="approve-btn-box">
                                            <button type="button" class="btn-approve" @click="fnApprove(item)">승인</button>
                                            <button type="button" class="btn-reject" @click="fnReject(item)">거부</button>
                                        </div>
                                    </div>
                                </template>
                            </div>

                            <div class="empty-box" v-if="fnPendingCount() === 0">
                                승인 대기 중인 사업자가 없습니다.
                            </div>
                        </template>

                        <template v-if="currentMenu === 'banner'">
                            <h2>배너 관리</h2>

                            <!-- 업로드 영역 -->
                            <div class="banner-upload-box">
                                <input type="file" @change="fnFileChange">
                                <button @click="fnUploadBanner">배너 업로드</button>
                            </div>

                            <!-- 배너 리스트 -->
                            <div class="banner-list">
                                <div class="banner-item" v-for="item in bannerList" :key="item.fileName">
                                    <img :src="item.filePath + item.fileName" class="banner-img">

                                    <button class="btn-delete" @click="fnDeleteBanner(item)">
                                        삭제
                                    </button>
                                </div>
                            </div>
                        </template>
                    </div>
                </section>
            </div>
        </div>
    </div>

    <!-- 푸터 -->
    <jsp:include page="/WEB-INF/footer/footer.jsp" />

</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                // 변수 - (key : value)
                currentMenu: "dashboard",

                approveList: [],
                bannerList: [],
                selectedFile: null
                
            };
        },
        methods: {
            // 함수(메소드) - (key : function())
            fnChangeMenu: function (menuName) {
                let self = this;
                self.currentMenu = menuName;

                // 사업자 승인 관리 메뉴 눌렀을 때 목록 조회
                if (menuName === "storeApprove") {
                    self.fnBizList();
                }
            },

            // 배너 파일 업로드
            fnFileChange: function (event) {
                let self = this;
                self.selectedFile = event.target.files[0];
            },

            fnUploadBanner: function () {
                let self = this;

                if (!self.selectedFile) {
                    alert("파일을 선택하세요.");
                    return;
                }

                let formData = new FormData();
                formData.append("file", self.selectedFile);

                $.ajax({
                    url: "/banner/upload.dox",
                    type: "POST",
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function (data) {
                        if (data.result === "success") {
                            alert("업로드 완료");
                            self.fnBannerList();
                        } else {
                            alert(data.message);
                        }
                    }
                });
            },

            fnBannerList: function () {
                let self = this;

                $.ajax({
                    url: "/banner/list.dox",
                    type: "POST",
                    dataType: "json",
                    success: function (data) {
                        if (data.result === "success") {
                            self.bannerList = data.list;
                        }
                    }
                });
            },

            fnDeleteBanner: function (item) {
                let self = this;

                if (!confirm("삭제하시겠습니까?")) return;

                $.ajax({
                    url: "/banner/delete.dox",
                    type: "POST",
                    data: {
                        fileName: item.fileName
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            alert("삭제 완료");
                            self.fnBannerList();
                        }
                    }
                });
            },

            // 사업자 승인 대기 목록 조회
            fnBizList: function () {
                let self = this;
                let param = {};

                $.ajax({
                    url: "/adminBiz.dox",
                    dataType: "json",
                    type: "POST",
                    data: param,
                    success: function (data) {
                        console.log("사업자 승인 목록 응답 :", data);

                        if (data.result === "success") {
                            self.approveList = data.list;
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function () {
                        alert("서버 통신 중 오류가 발생했습니다.");
                    }
                });
            },

            fnApprove: function (item) {
                let self = this;

                if (!confirm(item.storeName + " 업체를 승인하시겠습니까?")) {
                    return;
                }

                $.ajax({
                    url: "/editBizStatusApr.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        storeNo: item.storeNo,
                        sUserId: item.sUserId
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            alert("승인 완료되었습니다.");
                            self.fnBizList();
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function () {
                        alert("서버 통신 중 오류가 발생했습니다.");
                    }
                });
            },

            fnReject: function (item) {
                let self = this;

                if (!confirm(item.storeName + " 업체를 거부하시겠습니까?")) {
                    return;
                }

                $.ajax({
                    url: "/editBizStatusRej.dox",
                    dataType: "json",
                    type: "POST",
                    data: {
                        storeNo: item.storeNo,
                        sUserId: item.sUserId
                    },
                    success: function (data) {
                        if (data.result === "success") {
                            alert("거부 완료되었습니다.");
                            self.fnBizList();
                        } else {
                            alert(data.message);
                        }
                    },
                    error: function () {
                        alert("서버 통신 중 오류가 발생했습니다.");
                    }
                });
            },

            fnFilePreview: function (item) {
                let url = item.filePath + item.fileName;
                window.open(url, "_blank");
            },

            fnPendingCount: function () {
                let self = this;
                return self.approveList.filter(function (item) {
                    return item.uStatus === "PND";
                }).length;
            },
            
        }, // methods
        mounted() {
            // 처음 시작할 때 실행되는 부분
            let self = this;
            if (self.currentMenu === "storeApprove") {
                self.fnBizList();
            }
            if (menuName === "banner") {
                self.fnBannerList();
            }
        }
    });

    app.mount('#app');
</script>