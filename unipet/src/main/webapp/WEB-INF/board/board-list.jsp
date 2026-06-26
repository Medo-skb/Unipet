<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
	<meta charset="UTF-8">
	<title>UNIPET</title>
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<script src="/js/page-change.js"></script>
	<link rel="stylesheet" href="/css/board/board-list.css">
</head>

<body>
	<jsp:include page="/WEB-INF/header/header.jsp" />

	<div id="app">
		<div class="wrap">

			<div class="box">
				<div class="alarm-area" @click.stop>
					<div class="alarm-fixed" @click="fnGetAlarmList()">
						🔔
						<span class="alarm-badge" v-if="alarmCount > 0">{{alarmCount}}</span>
					</div>

					<div v-if="showAlarm" class="alarm-box" @click.stop>
						<div v-if="alarmList.length == 0" class="alarm-empty">
							알림이 없습니다
						</div>

						<div v-for="item in alarmList" :key="item.alarmNo" @click="fnReadAlarm(item)" class="alarm-item">
							{{item.alarmContent}}
							<br>
							<small>{{item.cdate}}</small>
						</div>
					</div>
				</div>

				<!-- 대분류 탭 -->
				<div class="tab-row main-tab-row">
					<div class="main-tab-left">
						<button class="tab-btn" :class="{active : selectedMainNo == ''}"
							@click="fnSelectMain('')">전체</button>

						<button class="tab-btn" :class="{active : selectedMainNo == '1'}"
							@click="fnSelectMain('1')">통합</button>

						<button class="tab-btn" :class="{active : selectedMainNo == '2'}"
							@click="fnSelectMain('2')">지역</button>
					</div>
				</div>

				<!-- 통합 카테고리 필터 -->
				<div class="tab-row" v-if="selectedMainNo == '1'">
					<button class="tab-btn" :class="{active : integratedCategory == ''}"
						@click="fnSelectIntegratedCategory('')">전체</button>

					<button class="tab-btn" :class="{active : integratedCategory == 'NTC'}"
						@click="fnSelectIntegratedCategory('NTC')">공지사항</button>

					<button class="tab-btn" :class="{active : integratedCategory == 'GEN'}"
						@click="fnSelectIntegratedCategory('GEN')">일반</button>

					<button class="tab-btn" :class="{active : integratedCategory == 'INF'}"
						@click="fnSelectIntegratedCategory('INF')">정보/팁</button>

					<button class="tab-btn" :class="{active : integratedCategory == 'GIF'}"
						@click="fnSelectIntegratedCategory('GIF')">움짤</button>

					<button class="tab-btn" :class="{active : integratedCategory == 'VID'}"
						@click="fnSelectIntegratedCategory('VID')">동영상</button>

					<button class="tab-btn" :class="{active : integratedCategory == 'QNA'}"
						@click="fnSelectIntegratedCategory('QNA')">질문</button>

					<button class="tab-btn" :class="{active : integratedCategory == 'MAR'}"
						@click="fnSelectIntegratedCategory('MAR')">나눔/장터</button>
				</div>

				<!-- 지역 카테고리 필터 -->
				<div class="tab-row local-tab-row" v-if="selectedMainNo == '2'">
					<select class="local-select" v-model="localNo" @change="fnSelectLocalNo()">
						<option value="">지역 전체</option>
						<option value="1">서울</option>
						<option value="2">인천</option>
						<option value="3">부산</option>
						<option value="4">대구</option>
						<option value="5">광주</option>
						<option value="6">대전</option>
						<option value="7">울산</option>
						<option value="8">세종</option>
						<option value="9">경기</option>
						<option value="10">강원</option>
						<option value="11">충청</option>
						<option value="12">전라</option>
						<option value="13">경상</option>
						<option value="14">제주</option>
					</select>

					<button class="tab-btn" :class="{active : localCategory == ''}"
						@click="fnSelectLocalCategory('')">전체</button>

					<button class="tab-btn" :class="{active : localCategory == 'WALK'}"
						@click="fnSelectLocalCategory('WALK')">산책</button>

					<button class="tab-btn" :class="{active : localCategory == 'MEET'}"
						@click="fnSelectLocalCategory('MEET')">소모임</button>

					<button class="tab-btn" :class="{active : localCategory == 'TRAVEL'}"
						@click="fnSelectLocalCategory('TRAVEL')">여행</button>

					<button class="tab-btn" :class="{active : localCategory == 'LINFO'}"
						@click="fnSelectLocalCategory('LINFO')">지역정보</button>

					<button class="tab-btn" :class="{active : localCategory == 'HOSP'}"
						@click="fnSelectLocalCategory('HOSP')">병원추천</button>

					<button class="tab-btn" :class="{active : localCategory == 'CARE'}"
						@click="fnSelectLocalCategory('CARE')">돌봄</button>

					<button class="tab-btn" :class="{active : localCategory == 'MARKET'}"
						@click="fnSelectLocalCategory('MARKET')">중고거래</button>
				</div>

				<!-- 검색 -->
				<div class="search-row">
					<select v-model="searchType">
						<option value="">전체</option>
						<option value="title">제목</option>
						<option value="contents">내용</option>
						<option value="user">작성자</option>
					</select>

					<input type="text" v-model="keyword" @keyup.enter="fnSearch()" placeholder="검색어를 입력하세요">

					<button @click="fnSearch()">검색</button>
				</div>

				<!-- 정렬 + 글쓰기 -->
				<div class="top-row">
					<div class="sort-row">
						<button class="sort-btn" :class="{active : sortType == 'new'}"
							@click="fnChangeSort('new')">최신순</button>

						<button class="sort-btn" :class="{active : sortType == 'like'}"
							@click="fnChangeSort('like')">추천순</button>

						<button class="sort-btn" :class="{active : sortType == 'view'}"
							@click="fnChangeSort('view')">조회순</button>

						<button class="sort-btn" :class="{active : sortType == 'comment'}"
							@click="fnChangeSort('comment')">댓글순</button>
					</div>

					<div class="board-btn-wrap">
						<button class="write-btn" @click="fnMoveTempList()">임시저장목록</button>

						<button class="write-btn" v-if="sessionRole == 'A' || integratedCategory != 'NTC'"
							@click="fnMoveAdd()">
							글쓰기
						</button>
					</div>
				</div>

				<!-- 목록 -->
				<table>
					<thead>
						<tr>
							<th class="col-no">번호</th>
							<th>제목</th>
							<th class="col-writer">작성자</th>
							<th class="col-count">조회수</th>
							<th class="col-count">추천수</th>
							<th class="col-count">댓글수</th>
							<th class="col-date">작성일</th>
						</tr>
					</thead>

					<tbody>
						<tr v-if="boardList.length == 0">
							<td colspan="7">게시글이 없습니다.</td>
						</tr>

						<tr v-for="(item, index) in boardList"
							:key="item.boardNo"
							:class="{noticeRow : item.bSubType == '공지사항'}">
							<td>
								<span v-if="item.bSubType == '공지사항'">공지</span>
								<span v-else>{{item.displayNo}}</span>
							</td>

							<td class="title-cell" @click="fnMoveView(item)">
								<div class="title-wrap">
									<span v-if="item.privateYn == 'Y'" class="private-badge">🔒</span>
									<span v-if="Number(item.likeCnt) >= 5" class="popular-badge">🔥</span>

									<span 
										v-if="selectedMainNo == '' && item.bSubType != '공지사항'" 
										class="main-badge">
										{{item.bMainType}}
									</span>

									<span 
										v-if="fnShowLocalBadge(item)" 
										class="local-badge">
										{{fnGetLocalName(item)}}
									</span>

									<span v-if="item.bSubType == '공지사항'" class="notice-badge">📌 공지사항</span>
									<span v-else class="category">{{item.bSubType}}</span>

									<span class="title-text" v-if="fnCanReadBoard(item)">
										{{item.title}}
									</span>

									<span class="title-text" v-else>
										비공개 게시글입니다.
									</span>
								</div>
							</td>

							<td>{{item.writerNickname ? item.writerNickname : item.userId}}</td>
							<td>{{item.viewCount}}</td>
							<td>{{item.likeCnt}}</td>
							<td>{{item.commentCnt}}</td>

							<td class="date-cell">
								<span v-if="item.createTime != null && item.createTime != ''">
									{{fnFormatCreateTime(item.createTime)}}
								</span>
							</td>
						</tr>
					</tbody>
				</table>

				<!-- 페이징 -->
				<div class="pagination" v-if="pageCount > 0">
					<button @click="fnGoPage(1)" v-if="currentPage > 1">&lt;&lt;</button>

					<button @click="fnGoPage(currentPage - 1)" v-if="currentPage > 1">&lt;</button>

					<button 
						v-for="page in pageList" 
						:key="page" 
						:class="{active : currentPage == page}"
						@click="fnGoPage(page)">
						{{page}}
					</button>

					<button @click="fnGoPage(currentPage + 1)" v-if="currentPage < pageCount">&gt;</button>

					<button @click="fnGoPage(pageCount)" v-if="currentPage < pageCount">&gt;&gt;</button>
				</div>
			</div>
		</div>
	</div>

	<script>
		const app = Vue.createApp({
			data() {
				return {
					// 게시글 목록
					boardList: [],

					// 검색 / 필터 / 정렬
					selectedMainNo: '<%=request.getAttribute("bMainNo") == null ? "" : request.getAttribute("bMainNo")%>',
					searchType: '<%=request.getAttribute("searchType") == null ? "" : request.getAttribute("searchType")%>',
					keyword: '<%=request.getAttribute("keyword") == null ? "" : request.getAttribute("keyword")%>',
					sortType: '<%=request.getAttribute("sortType") == null || request.getAttribute("sortType").equals("") ? "new" : request.getAttribute("sortType")%>',
					integratedCategory: '',
					localCategory: '',
					localNo: "",
					tempYn: '<%=request.getAttribute("tempYn") == null ? "" : request.getAttribute("tempYn")%>',

					// 로그인 정보
					sessionId: '<%=session.getAttribute("sessionId") == null ? "" : session.getAttribute("sessionId")%>',
					sessionRole: '<%=session.getAttribute("sessionRole") == null ? "" : session.getAttribute("sessionRole")%>',

					// 페이징
					currentPage: Number('<%=request.getAttribute("page") == null || request.getAttribute("page").equals("") ? "1" : request.getAttribute("page")%>'),
					pageSize: 10,
					pageBlockSize: 10,
					totalCount: 0,
					pageCount: 0,
					pageList: [],

					// 알림
					showAlarm: false,
					alarmList: [],
					alarmCount: 0
				};
			},

			methods: {
				fnIsAdmin: function () {
					if (this.sessionRole == "A") {
						return true;
					}

					if (this.sessionId == "admin") {
						return true;
					}

					return false;
				},

				fnCanReadBoard: function (item) {
					if (item.privateYn != "Y") {
						return true;
					}

					if (this.fnIsAdmin()) {
						return true;
					}

					if (this.sessionId != "" && this.sessionId == item.userId) {
						return true;
					}

					return false;
				},

				fnGetBoardList: function () {
					let self = this;

					let param = {
						bMainNo: self.selectedMainNo,
						searchType: self.searchType,
						keyword: self.keyword,
						sortType: self.sortType,
						page: self.currentPage,
						pageSize: self.pageSize,
						tempYn: self.tempYn,
						integratedCategory: self.integratedCategory,
						localCategory: self.localCategory,
						localNo: self.localNo
					};

					$.ajax({
						url: "/board/list.dox",
						type: "POST",
						dataType: "json",
						data: param,
						success: function (data) {
							if (data.result == "success") {
								self.boardList = data.list || [];
								self.totalCount = data.count || 0;

								self.fnSetPageInfo();

							} else {
								alert(data.message);
							}
						},
						error: function (xhr) {
							alert("게시글 목록 조회 중 오류가 발생했습니다.");
						}
					});
				},

				fnSetPageInfo: function () {
					let self = this;

					self.pageList = [];

					self.pageCount = Math.ceil(self.totalCount / self.pageSize);

					if (self.pageCount == 0) {
						self.currentPage = 1;
						return;
					}

					if (self.currentPage > self.pageCount) {
						self.currentPage = self.pageCount;
					}

					let startPage = Math.floor((self.currentPage - 1) / self.pageBlockSize) * self.pageBlockSize + 1;
					let endPage = startPage + self.pageBlockSize - 1;

					if (endPage > self.pageCount) {
						endPage = self.pageCount;
					}

					for (let i = startPage; i <= endPage; i++) {
						self.pageList.push(i);
					}
				},

				fnSelectMain: function (bMainNo) {
					let self = this;

					self.selectedMainNo = bMainNo;
					self.currentPage = 1;
					self.integratedCategory = "";
					self.localCategory = "";
					self.localNo = "";
					self.tempYn = "";

					self.fnGetBoardList();
				},

				fnChangeSort: function (sortType) {
					let self = this;

					self.sortType = sortType;
					self.currentPage = 1;

					self.fnGetBoardList();
				},

				fnSearch: function () {
					let self = this;

					self.currentPage = 1;
					self.fnGetBoardList();
				},

				fnGoPage: function (page) {
					let self = this;

					if (page < 1) {
						return;
					}

					if (page > self.pageCount) {
						return;
					}

					self.currentPage = page;
					self.fnGetBoardList();
				},

				fnMoveView: function (item) {
					if (!this.fnCanReadBoard(item)) {
						alert("비공개 게시글입니다. 작성자와 관리자만 확인할 수 있습니다.");
						return;
					}

					if (this.tempYn == "Y") {
						pageChange("/board/edit.do", {
							boardNo: item.boardNo
						});
					} else {
						pageChange("/board/view.do", {
							boardNo: item.boardNo
						});
					}
				},

				fnMoveAdd: function () {
					if (this.sessionId == "") {
						alert("로그인이 필요한 서비스입니다.");
						location.href = "/user/login.do";
						return;
					}

					if (this.selectedMainNo == "") {
						alert("통합 또는 지역 게시판을 먼저 선택해주세요.");
						return;
					}

					pageChange("/board/add.do", {
						bMainNo: this.selectedMainNo
					});
				},

				fnMoveTempList: function () {
					let self = this;

					self.tempYn = "Y";
					self.selectedMainNo = "";
					self.integratedCategory = "";
					self.localCategory = "";
					self.localNo = "";
					self.searchType = "";
					self.keyword = "";
					self.sortType = "new";
					self.currentPage = 1;

					self.fnGetBoardList();
				},

				fnMoveNormalList: function () {
					let self = this;

					self.tempYn = "";
					self.selectedMainNo = "";
					self.integratedCategory = "";
					self.localCategory = "";
					self.localNo = "";
					self.currentPage = 1;

					self.fnGetBoardList();
				},

				fnTempList: function () {
					let self = this;

					self.tempYn = "Y";
					self.currentPage = 1;

					self.fnGetBoardList();
				},

				fnNormalList: function () {
					let self = this;

					self.tempYn = "";
					self.currentPage = 1;

					self.fnGetBoardList();
				},

				fnSelectLocalCategory: function (category) {
					let self = this;

					self.selectedMainNo = "2";
					self.localCategory = category;
					self.tempYn = "";
					self.currentPage = 1;

					self.fnGetBoardList();
				},

				fnSelectIntegratedCategory: function (category) {
					let self = this;

					self.selectedMainNo = "1";
					self.integratedCategory = category;
					self.tempYn = "";
					self.currentPage = 1;

					self.fnGetBoardList();
				},

				fnSelectLocalNo: function () {
					let self = this;

					self.tempYn = "";
					self.currentPage = 1;

					self.fnGetBoardList();
				},

				fnIsLocalBoard: function (item) {
					if (String(item.bMainNo) == "2") {
						return true;
					}

					if (item.bMainType == "지역") {
						return true;
					}

					if (item.localNo != null && item.localNo != "") {
						return true;
					}

					return false;
				},

				fnGetLocalName: function (item) {
					if (item.localName != null && item.localName != "") {
						return item.localName;
					}

					let localNo = String(item.localNo);

					if (localNo == "1") {
						return "서울";
					} else if (localNo == "2") {
						return "인천";
					} else if (localNo == "3") {
						return "부산";
					} else if (localNo == "4") {
						return "대구";
					} else if (localNo == "5") {
						return "광주";
					} else if (localNo == "6") {
						return "대전";
					} else if (localNo == "7") {
						return "울산";
					} else if (localNo == "8") {
						return "세종";
					} else if (localNo == "9") {
						return "경기";
					} else if (localNo == "10") {
						return "강원";
					} else if (localNo == "11") {
						return "충청";
					} else if (localNo == "12") {
						return "전라";
					} else if (localNo == "13") {
						return "경상";
					} else if (localNo == "14") {
						return "제주";
					}

					return "지역";
				},
				
				fnFormatCreateTime: function (createTime) {
					if (createTime == null || createTime == "") {
						return "";
					}

					let value = String(createTime).trim();
					value = value.replace("T", " ");

					// yyyy-MM-dd HH:mm 형태가 제대로 있으면 날짜+시간 표시
					if (value.length >= 16 && value.substring(13, 16).indexOf(":") == 0) {
						return value.substring(0, 16);
					}

					// 시간이 01: 처럼 깨져 있으면 날짜만 표시
					if (value.length >= 10) {
						return value.substring(0, 10);
					}

					return value;
				},

				fnShowLocalBadge: function (item) {
					if (item.bSubType == "공지사항") {
						return false;
					}

					if (!this.fnIsLocalBoard(item)) {
						return false;
					}

					if (this.selectedMainNo == "2" && this.localNo != "") {
						return false;
					}

					return true;
				},

				fnGetAlarmList: function () {
					let self = this;

					self.showAlarm = !self.showAlarm;

					if (self.showAlarm) {
						$.ajax({
							url: "/board/alarm/list.dox",
							type: "POST",
							dataType: "json",
							success: function (data) {
								if (data.result == "success") {
									self.alarmList = data.list.filter(function (item) {
										return item.readYn == "N";
									});
								}
							}
						});
					}
				},

				fnReadAlarm: function (item) {
					let self = this;

					let param = {
						alarmNo: item.alarmNo
					};

					$.ajax({
						url: "/board/alarm/read.dox",
						type: "POST",
						dataType: "json",
						data: param,
						success: function (data) {
							if (self.alarmCount > 0) {
								self.alarmCount--;
							}

							pageChange("/board/view.do", {
								boardNo: item.boardNo
							});
						}
					});
				},

				fnCloseAlarmOutside: function (e) {
					let alarmArea = document.querySelector(".alarm-area");

					if (alarmArea != null && !alarmArea.contains(e.target)) {
						this.showAlarm = false;
						this.fnGetAlarmCount();
					}
				},

				fnGetAlarmCount: function () {
					let self = this;

					$.ajax({
						url: "/board/alarm/list.dox",
						type: "POST",
						dataType: "json",
						success: function (data) {
							if (data.result == "success") {
								let count = 0;

								for (let i = 0; i < data.list.length; i++) {
									if (data.list[i].readYn == "N") {
										count++;
									}
								}

								self.alarmCount = count;
							}
						}
					});
				}
			}, // methods

			mounted() {
				// 처음 시작할 때 실행되는 부분
				let self = this;

				self.fnGetBoardList();
				self.fnGetAlarmCount();
				self.showAlarm = false;

				document.addEventListener("click", self.fnCloseAlarmOutside);
			}
		});

		app.mount("#app");
	</script>

	<jsp:include page="/WEB-INF/footer/footer.jsp" />
</body>

</html>