<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- <link href="/css/user/rsv-review.css" rel="stylesheet"> -->
    <link href="/css/user/rsv-review2.css" rel="stylesheet">
    <script src="https://code.jquery.com/jquery-3.7.1.js"></script>
    <script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
    <script src="/js/page-change.js"></script>
    <title>예약 리뷰</title>
    
</head>
<body>
    <jsp:include page="/WEB-INF/header/header.jsp" />


    <div id="app">
        <div id="container">
            <div id="top">
                <div class="title">리뷰 쓰기</div>
                <div class="info" v-if="info.rsvNo">
                    <div class="name">[{{ info.storeName }}]</div>
                    <div>
                        예약 번호: {{ info.rsvNo }} | 
                        예약 일시: {{ info.slotDate }} {{ info.slotTime }}
                    </div>
                    <div>
                        반려동물: {{ info.petName }} ({{ info.species }}/{{ info.breed }}) | 
                        진료/서비스명: {{ info.menuName }}
                    </div>
                </div>
                <div class="info" v-else>
                    정보를 불러오는 중입니다...
                </div>
            </div>
            <div id="bottom">
                <div class="attach">
                    <div>리뷰 관련 이미지를 첨부해주세요. ({{ images.length }}/5)</div>
                    <div class="attach-function">
                        
                        <div class="attach-item" v-if="images.length < 5">
                            <div class="btn-attach" @click="triggerFileInput">
                                <div class="attach-label">첨부하기</div>
                                <input type="file" ref="fileInput" accept="image/*" multiple @change="handleFileChange" style="display: none;">
                            </div>
                        </div>

                        <div v-for="(img, index) in images" :key="'img-' + index" class="attach-item">
                            <div class="thumbnail">
                                <img :src="img.preview">
                                <button class="btn-delete" @click="removeImage(index)">×</button>
                            </div>
                        </div>

                        <div v-for="n in (5 - images.length - (images.length < 5 ? 1 : 0))" :key="'empty-' + n" class="attach-item">
                            <div class="empty-slot"></div>
                        </div>

                    </div>
                </div>
                <div class="rate">
                    <div>서비스 만족 점수를 주세요.</div>
                    <div class="rate-function">
                        <div class="star-rating">
                            <span v-for="star in 5" 
                                :key="star" 
                                class="star" 
                                :class="{ active: star <= rating }"
                                @click="setRating(star)">
                                ★
                            </span>
                        </div>
                        <div class="rate-text">{{ rating }}점</div>
                    </div>
                </div>
                <div class="text">
                    <div>고객님의 소중한 의견 부탁 드려요.</div>
                    <div class="textarea-wrapper">
                        <textarea v-model="reviewContent" placeholder="리뷰를 작성해주세요." maxlength="1000"></textarea>
                        <div class="char-count">
                            <span>{{ reviewContent.length }}</span> / 1000
                        </div>
                    </div>
                </div>
                <div class="button-area">
                    <div class="button" @click="fnSaveReview" style="cursor: pointer;">등록하기</div>
                </div>
                
            </div>
            
        </div>
    </div>
</body>

<jsp:include page="/WEB-INF/footer/footer.jsp" />

<script>
    const app = Vue.createApp({
        data() {
            return {
                userId: '${sessionScope.sessionId}',
                rsvNo: '${map.rsvNo}',
                
                // 2. 서버에서 받아올 예약 상세 정보
                info: {}, 
                
                // 3. 사용자 입력 리뷰 데이터
                reviewContent: '',
                rating: 5, // 기본 별점 (추후 별점 UI와 연결)
                
                // 4. 이미지 첨부 데이터 (최대 5장)
                // 구조: { file: 실제파일객체, preview: '미리보기URL' }
                images: []
            };
        },
        methods: {
            // 페이지 로드 시 예약 정보를 가져오는 함수
            fnGetDetail() {
                const self = this;
                const params = {
                    userId: self.userId,
                    rsvNo: self.rsvNo
                };

                $.ajax({
                    url: "/reservation/info.dox",
                    type: "POST",
                    data: params,
                    success: function(data) {
                        // 콘솔 확인 결과: data.info 안에 상세 데이터가 있음
                        if (data.result === "success") {
                            self.info = data.info;
                        } else {
                            alert(data.message || "예약 정보를 불러오는데 실패했습니다.");
                        }
                    }
                });
            },

            // 이미지 첨부 관련 메서드
           triggerFileInput() {
                // 이제 fileInput은 v-for 밖에 있으므로 배열이 아닌 단일 객체입니다.
                if (this.$refs.fileInput) {
                    this.$refs.fileInput.click();
                }
            },

            handleFileChange(event) {
                const files = event.target.files;
                if (!files) return;

                // 배열로 변환하여 순회
                Array.from(files).forEach(file => {
                    // 이미 5장이면 더 이상 추가 안함
                    if (this.images.length >= 5) return;

                    if (file.type.match('image.*')) {
                        const reader = new FileReader();
                        reader.onload = (e) => {
                            this.images.push({
                                file: file,
                                preview: e.target.result
                            });
                        };
                        reader.readAsDataURL(file);
                    }
                });
                
                // 동일 파일 다시 올릴 수 있게 초기화
                event.target.value = '';
            },

            removeImage(index) {
                this.images.splice(index, 1);
            },

            setRating(value) {
                this.rating = value;
            },

            checkLength() {
                if (this.reviewContent.length > 1000) {
                    this.reviewContent = this.reviewContent.substring(0, 1000);
                }
            },

            // 최종 리뷰 저장 함수 (INSERT)
            fnSaveReview() {
                const self = this;

                // 1. 유효성 검사
                if (self.reviewContent.trim().length < 10) {
                    alert("리뷰 내용을 최소 10자 이상 입력해 주세요.");
                    return;
                }

                const formData = new FormData();

                formData.append("userId", self.info.userId);
                formData.append("rsvNo", self.info.rsvNo);
                formData.append("storeNo", self.info.storeNo);
                formData.append("rating", self.rating);
                formData.append("rContents", self.reviewContent);

                self.images.forEach((img, index) => {
                    formData.append("files", img.file); 
                });

                if (!confirm("리뷰를 등록하시겠습니까?")) return;

                // 3. AJAX 통신
                $.ajax({
                    url: "/user/mypage/add-review-rsv.dox",
                    type: "POST",
                    processData: false,
                    contentType: false,
                    data: formData,
                    success: function(data) {
                        if (typeof data === "string") data = JSON.parse(data);
            
                        if (data.result === "success") {
                            alert("리뷰가 등록되었습니다.");
                            sessionStorage.setItem("triggerFunction", "openRsvList"); // 메모 남기기
                            location.href = "/user/mypage.do";  
                        }
                    }
                });
            }
        },
        mounted() {
            if (!this.userId) {
                alert("로그인이 필요한 서비스입니다.");
                location.href = "/user/login.do";
                return;
            }
            this.fnGetDetail();
        }
    }).mount('#app');
</script>
</html>