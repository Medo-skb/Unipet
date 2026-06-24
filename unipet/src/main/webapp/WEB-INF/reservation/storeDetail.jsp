<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=${kakaoApiKey}&libraries=services"></script>
    
    <title>UNIPET</title>
    <link href="/css/reservation/storeDetail.css" rel="stylesheet">
</head>
<body>
    <jsp:include page="/WEB-INF/header/header.jsp" />
    
    <div id="app">
        <div id="container">
            <div id="top">
                <div class="top-wrapper">
                    <div>{{ storeInfo.storeName }}</div>
                    <div class="s-type">{{ storeInfo.storeType }}</div>
                </div>
                
                <div id="top-sub">
                    <div>{{ storeInfo.subTitle }}</div>
                    <div class="button" @click="fnRsv(storeInfo.storeNo)">예약하기</div>
                </div>
            </div>
            
            <div id="contents">
                <div class="img-area">
                    <div v-for="file in storeImgList" :key="file.fileNo" class="image-item" :data-fno="file.fileNo">
                        <img :src="file.filePath + file.fileName" 
                            :alt="file.originName" 
                            :class="{ 'main-img': file.isMain === 'Y' }">
                    </div>
                </div>

                <div id="middle-section">
                    <div class="info-area">
                        <div class="intro">
                            <div>소개</div>
                            <hr>
                            <div class="sContents">{{ storeInfo.sContents }}</div>
                        </div>
                        <div class="time">
                            <div class="time-header">
                                <span class="label">영업시간:</span>
                                <span class="value">{{ formatStoreTime(storeInfo.openTime) }} ~ {{ formatStoreTime(storeInfo.closeTime) }}</span>
                            </div>
                            <hr>
                        </div>
                    </div>
                    
                    <div id="map"></div>
                </div>

                <div class="menu">
                    <div>가격표</div>
                    <hr>
                    <ul id="MenuList">
                        <li v-for="item in storeMenuList" :key="item.menuNo">
                            {{ item.menuName }} : {{ item.menuPrice.toLocaleString() }}원
                        </li>
                    </ul>
                </div>

                <div class="review-section" id="review-anchor">
                    <div class="review">
                        <div class="review-title">
                            방문자 리뷰 
                            <span v-if="reviewCount > 0" class="title-stats">
                                <span class="total-count">[총 {{ reviewCount }}개</span>
                                <span class="avg-score"> / 평균 ⭐ {{ reviewAvg }}]</span>
                            </span>
                        </div>
                        <hr>
                        
                        <div class="review-list-container">
                            <div v-if="reviewList.length === 0" class="no-review">
                                작성된 리뷰가 없습니다.
                            </div>
                            
                            <div v-for="rev in reviewList.slice((currentPage - 1) * itemsPerPage, currentPage * itemsPerPage)" 
                                :key="rev.rsvNo" 
                                class="rev-cont">
                                
                                <div class="rev-top-layout">
                                    <div class="info-group">
                                        <div class="rev-header">
                                            <div class="header-left">
                                                <span class="nickname">{{ rev.nickname }}</span>
                                                <span class="date">{{ formatReviewTime(rev.cdate) }}</span>
                                            </div>
                                            </div>
                                        
                                        <div class="rev-star" v-if="!rev.isEditing">
                                            {{ fnConvertStar(rev.rating) }}
                                            <span class="review-score">{{rev.rating}}점</span>
                                        </div>
                                    </div>

                                    <div class="thumb-group" v-if="rev.filePaths && !rev.isEditing">
                                        <img v-for="(path, index) in rev.filePaths.split(',')" 
                                            :key="index" 
                                            :src="path" 
                                            class="thumb-img-large" 
                                            @click="fnOpenImageModal(path, rev.filePaths)"
                                            alt="리뷰 첨부사진">
                                    </div>

                                    <div class="rev-actions" v-if="fnCanManageReview(rev) && !rev.isEditing">
                                        <button type="button" v-if="currentUserId != '' && currentUserId == rev.userId" @click="fnEditMode(rev)">수정</button>
                                        <button type="button" @click="fnDeleteReview(rev.rsvNo)" class="btn-delete">삭제</button>
                                    </div>

                                </div> 
                                <div class="rev-text" v-if="!rev.isEditing">
                                    {{ rev.rContents }}
                                </div>

                                <div class="rev-edit-area" v-if="rev.isEditing">
                                    <textarea v-model="rev.editContents" class="edit-textarea"></textarea>
                                    <div class="edit-btns">
                                        <button type="button" class="btn-cancel" @click="fnCancelEdit(rev)">취소</button>
                                        <button type="button" class="btn-save" @click="fnSaveReview(rev)">저장</button>
                                    </div>
                                </div>
                                
                            <div class="img-modal-overlay" v-if="showImageModal" @click="fnCloseImageModal">
                                <button type="button" 
                                        class="modal-nav-btn btn-left" 
                                        v-if="currentImgIndex > 0" 
                                        @click.stop="fnPrevImage">
                                    &#10094;
                                </button>
                                
                                <div class="modal-content-wrap" @click.stop>
                                    <img :src="modalImages[currentImgIndex]" class="modal-large-img">
                                    <button type="button" class="modal-close-btn" @click="fnCloseImageModal">
                                        ×
                                    </button>
                                </div>
                                
                                <button type="button" 
                                        class="modal-nav-btn btn-right" 
                                        v-if="currentImgIndex < modalImages.length - 1" 
                                        @click.stop="fnNextImage">
                                    &#10095;
                                </button>
                            </div>
                            
                        </div> <div class="pagination-wrap" v-if="totalPages > 1">
                            <button class="btn-prev" 
                                    @click="fnChangePage(currentPage - 1)" 
                                    :disabled="currentPage === 1">
                                &lt;
                            </button>
                            
                            <span v-for="page in totalPages" :key="page" 
                                :class="['page-num', { 'active': currentPage === page }]"
                                @click="fnChangePage(page)">
                                {{ page }}
                            </span>
                            
                            <button class="btn-next" 
                                    @click="fnChangePage(currentPage + 1)" 
                                    :disabled="currentPage === totalPages">
                                &gt;
                            </button>
                        </div>

                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="/WEB-INF/footer/footer.jsp" />
</body>
</html>

<script>
    const app = Vue.createApp({
        data() {
            return {
                storeNo: '${map.storeNo}', 
                storeInfo: {}, 
                storeMenuList: [],
                storeImgList:[],
                reviewList: [],
                reviewCount: 0,
                reviewAvg: 0,
                currentPage: 1,      
                itemsPerPage: 5,
                showImageModal: false,  
                selectedImageUrl: '',
                modalImages: [],     
                currentImgIndex: 0,        
                currentUserId: '<%=session.getAttribute("sessionId") == null ? "" : session.getAttribute("sessionId")%>',
                currentUserRole: '<%=session.getAttribute("sessionRole") == null ? "" : session.getAttribute("sessionRole")%>',
                adminId: '<%=session.getAttribute("adminId") == null ? "" : session.getAttribute("adminId")%>',
                adminName: '<%=session.getAttribute("adminName") == null ? "" : session.getAttribute("adminName")%>'     
            };
        },
        computed: {
            // 🎯 [추가] 총 리뷰 페이지 수 계산
            totalPages() {
                return Math.ceil(this.reviewList.length / this.itemsPerPage);
            }
        },
        methods: {
            formatStoreTime(time) {
                if (!time) return '';
                return time.substring(0, 5);
            },

            formatReviewTime(time) {
                if (!time) return '';
                return time.substring(0, 10);
            },
            
            fnGetStoreDetail() {
                const self = this;
                $.ajax({
                    url: "/reservation/store-detail.dox",
                    type: "POST",
                    data: { storeNo: self.storeNo }, 
                    success: function(data) {
                        self.storeInfo = data.info;
                        self.storeMenuList = data.menuList;
                        self.storeImgList = data.imgList;
                        self.reviewList = data.reviewList;
                        self.reviewCount = data.reviewCount; 
                        self.reviewAvg = data.reviewAvg;
                        
                        setTimeout(() => {
                            self.drawMap();
                        }, 100);
                    }
                });
            },

            fnConvertStar(rating) {
                const num = Math.floor(Number(rating));
                return "⭐️".repeat(num);
            },

            // 🎯 [추가] 리뷰 페이지 변경 함수
            fnChangePage(page) {
                if (page < 1 || page > this.totalPages) return;
                this.currentPage = page;
                
                // 페이지 이동 시 리뷰 섹션 최상단(id="review-anchor")으로 화면을 부드럽게 스크롤
                const element = document.getElementById("review-anchor");
                if (element) {
                    element.scrollIntoView({ behavior: 'smooth', block: 'start' });
                }
            },

            drawMap: function() {
                const self = this;
                const info = self.storeInfo;
                const container = document.getElementById('map');
                const geocoder = new kakao.maps.services.Geocoder();

                const lat = parseFloat(info.lat);
                const lng = parseFloat(info.lng);

                if (lat && lng && lat !== 0) {
                    const moveLatLon = new kakao.maps.LatLng(lat, lng);
                    self.renderMap(container, moveLatLon);
                } else {
                    let addr = (info.sAddr || "").split('(')[0].trim();
                    if (!addr) {
                        container.style.display = 'none';
                        return;
                    }
                    
                    geocoder.addressSearch(addr, (result, status) => {
                        if (status === kakao.maps.services.Status.OK) {
                            const moveLatLon = new kakao.maps.LatLng(result[0].y, result[0].x);
                            self.renderMap(container, moveLatLon);
                        } else {
                            container.style.display = 'none'; 
                        }
                    });
                }
            },

            renderMap(container, latlng) {
                const options = { center: latlng, level: 3 };
                const map = new kakao.maps.Map(container, options);
                const marker = new kakao.maps.Marker({ position: latlng, map: map });

                const item = this.storeInfo;
                const status = String(item.sStatus || "").toUpperCase();

                var content = '<div style="padding:10px 12px; min-width:160px; background:#fff; font-family:sans-serif; letter-spacing:-0.5px;">';
                content += '    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:6px; gap:8px;">';
                
                if (item.storeType) {
                    content += '    <span style="font-size:10px; color:#777; background:#f0f0f0; padding:2px 5px; border-radius:3px; font-weight:600;">' + item.storeType + '</span>';
                }
                if (status === 'GEN') {
                    content += '    <span style="font-size:10px; color:#ff4b82; background:#fff0f5; border:1px solid #ffdae9; padding:1px 5px; border-radius:3px; font-weight:700; white-space:nowrap;">유니펫 회원사</span>';
                }
                
                content += '    </div>';
                content += '    <div style="margin-bottom:4px;">';
                content += '        <strong style="font-size:15px; color:#111; font-weight:700;">' + (item.storeName || '') + '</strong>';
                content += '    </div>';
                content += '    <div style="font-size:12px; color:#666; line-height:1.4;">' + (item.sAddr || '') + '</div>';
                content += '</div>';

                const infowindow = new kakao.maps.InfoWindow({ content: content });
                infowindow.open(map, marker);
            },

            fnRsv(storeNo) {
                if (!storeNo) {
                    alert("업체 정보가 로드되지 않았습니다.");
                    return;
                }
                pageChange("/reservation/book.do", { storeNo: storeNo });
            },

            fnIsAdmin: function () {
                if (this.adminId != "") {
                    return true;
                }
                if (this.currentUserRole == "A") {
                    return true;
                }
                if (this.currentUserRole == "ADMIN") {
                    return true;
                }
                if (this.currentUserId == "admin") {
                    return true;
                }
                return false;
            },

            // 🎯 [추가] 리뷰 관리(수정/삭제 권한) 가능 여부를 체크하는 함수
            fnCanManageReview(rev) {
                // 1. 관리자라면 무조건 통과 (삭제 가능)
                if (this.fnIsAdmin()) {
                    return true;
                }
                // 2. 관리자가 아니라면 본인이 쓴 글인지 체크
                if (this.currentUserId != "" && this.currentUserId == rev.userId) {
                    return true;
                }
                return false;
            },

            // 🎯 [기존 함수 보완] 내 글 판단 변수명을 currentUserId로 매핑 수정
            fnEditMode(rev) {
                rev.isEditing = true;
                rev.editContents = rev.rContents; 
            },
            fnCancelEdit(rev) {
                rev.isEditing = false;
            },
            fnSaveReview(rev) {
                if (!rev.editContents.trim()) {
                    alert("수정할 내용을 입력해 주세요.");
                    return;
                }
                if (!confirm("리뷰를 수정하시겠습니까?")) return;

                $.ajax({
                    url: "/reservation/review-update.dox", 
                    type: "POST",
                    data: {
                        rsvNo: rev.rsvNo,
                        rContents: rev.editContents
                    },
                    success: function(res) {
                        alert("리뷰가 수정되었습니다.");
                        rev.rContents = rev.editContents;
                        rev.isEditing = false;
                    },
                    error: function() {
                        alert("리뷰 수정 중 오류가 발생했습니다.");
                    }
                });
            },
            fnDeleteReview(rsvNo) {
                if (!confirm("정말 이 리뷰를 삭제하시겠습니까?")) return;

                const self = this;
                $.ajax({
                    url: "/reservation/review-remove.dox", 
                    type: "POST",
                    data: { rsvNo: rsvNo },
                    success: function(res) {
                        alert("리뷰가 삭제되었습니다.");
                        self.fnGetStoreDetail(); 
                    },
                    error: function() {
                        alert("리뷰 삭제 중 오류가 발생했습니다.");
                    }
                });
            },
            fnOpenImageModal(currentPath, allPaths) {
                this.modalImages = allPaths.split(',');
                this.currentImgIndex = this.modalImages.indexOf(currentPath);
                this.showImageModal = true;
                
                document.body.style.overflow = 'hidden'; 
            },
            fnCloseImageModal() {
                this.showImageModal = false;
                this.modalImages = [];
                this.currentImgIndex = 0;
                document.body.style.overflow = ''; 
            },
            fnPrevImage() {
                if (this.currentImgIndex > 0) {
                    this.currentImgIndex--;
                }
            },
            
            fnNextImage() {
                if (this.currentImgIndex < this.modalImages.length - 1) {
                    this.currentImgIndex++;
                }
            }
        }, 
        
        mounted() {
            if (!this.storeNo) {
                alert("업체 선택이 필요합니다.");
                location.href = "/reservation/search.do";
                return;
            } else {
                this.fnGetStoreDetail();
            }
        }
    });
    app.mount('#app');
</script>