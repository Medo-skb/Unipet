<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<title>커뮤니티 목록</title>
		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-change.js"></script>
		
		<link rel="stylesheet" href="/css/board/board-list.css">

	</head>

	<body>
		<div id="app">
			<div class="wrap">
				<div class="page-title">커뮤니티</div>

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

							<div v-for="item in alarmList"
							     @click="fnReadAlarm(item)"
							     class="alarm-item">
								{{item.ALARM_CONTENT}}
								<br>
								<small>{{item.CDATE}}</small>
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
					<div class="tab-row" v-if="selectedMainNo == '1'">
						<button class="tab-btn" :class="{active : integratedCategory == ''}" @click="fnSelectIntegratedCategory('')">전체</button>
						<button class="tab-btn" :class="{active : integratedCategory == 'NTC'}" @click="fnSelectIntegratedCategory('NTC')">공지사항</button>
						<button class="tab-btn" :class="{active : integratedCategory == 'GEN'}" @click="fnSelectIntegratedCategory('GEN')">일반</button>
						<button class="tab-btn" :class="{active : integratedCategory == 'INF'}" @click="fnSelectIntegratedCategory('INF')">정보/팁</button>
						<button class="tab-btn" :class="{active : integratedCategory == 'GIF'}" @click="fnSelectIntegratedCategory('GIF')">움짤</button>
						<button class="tab-btn" :class="{active : integratedCategory == 'VID'}" @click="fnSelectIntegratedCategory('VID')">동영상</button>
						<button class="tab-btn" :class="{active : integratedCategory == 'QNA'}" @click="fnSelectIntegratedCategory('QNA')">질문</button>
						<button class="tab-btn" :class="{active : integratedCategory == 'MAR'}" @click="fnSelectIntegratedCategory('MAR')">나눔/장터</button>
					</div>
					
					
					<!-- 지역 카테고리 필터 -->
					<div class="tab-row" v-if="selectedMainNo == '2'">
						<button class="tab-btn" :class="{active : localCategory == ''}" @click="fnSelectLocalCategory('')">전체</button>
						<button class="tab-btn" :class="{active : localCategory == 'WALK'}" @click="fnSelectLocalCategory('WALK')">산책</button>
						<button class="tab-btn" :class="{active : localCategory == 'MEET'}" @click="fnSelectLocalCategory('MEET')">소모임</button>
						<button class="tab-btn" :class="{active : localCategory == 'TRAVEL'}" @click="fnSelectLocalCategory('TRAVEL')">여행</button>
						<button class="tab-btn" :class="{active : localCategory == 'LINFO'}" @click="fnSelectLocalCategory('LINFO')">지역정보</button>
						<button class="tab-btn" :class="{active : localCategory == 'HOSP'}" @click="fnSelectLocalCategory('HOSP')">병원추천</button>
						<button class="tab-btn" :class="{active : localCategory == 'CARE'}" @click="fnSelectLocalCategory('CARE')">돌봄</button>
						<button class="tab-btn" :class="{active : localCategory == 'MARKET'}" @click="fnSelectLocalCategory('MARKET')">중고거래</button>
					</div>
					
					<div class="search-row" v-if="selectedMainNo == '2'">
						<select v-model="localNo" @change="fnSelectLocalNo()">
							<option value="">전체 지역</option>
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
								@click="fnChangeSort('like')">인기순</button>
							<button class="sort-btn" :class="{active : sortType == 'view'}"
								@click="fnChangeSort('view')">조회순</button>
						</div>

						<div class="board-btn-wrap">

							<button class="write-btn" @click="fnMoveTempList()">임시저장</button>
							<button class="write-btn" @click="fnMoveNormalList()">전체 글</button>
							<button class="write-btn" @click="fnMoveAdd()">글쓰기</button>

						</div>
					</div>

					<!-- 목록 -->
					<table>
						<thead>
							<tr>
								<th width="90">번호</th>
								<th width="100">썸네일</th>
								<th>제목</th>
								<th width="120">작성자</th>
								<th width="90">조회수</th>
								<th width="90">추천수</th>
								<th width="90">댓글수</th>
								<th width="150">작성일</th>
							</tr>
						</thead>
						<tbody>
							<tr v-if="boardList.length == 0">
								<td colspan="8">게시글이 없습니다.</td>
							</tr>

							<tr v-for="item in boardList" :key="item.BOARD_NO">
								<td>{{item.BOARD_NO}}</td>
								<td>
									<img v-if="item.THUMBNAIL" :src="item.THUMBNAIL" class="thumb">
									<img v-else src="../../img/board/unipet_logo.png" class="thumb">
								</td>
								<td class="title-cell" @click="fnMoveView(item.BOARD_NO)">
									<div class="title-wrap">
										<span v-if="item.PRIVATE == 'Y'" class="private-badge">🔒</span>
										<span v-if="Number(item.LIKE_CNT) >= 5" class="popular-badge">🔥</span>

										<span v-if="selectedMainNo == ''" class="main-badge">{{item.B_MAIN_TYPE}}</span>

										<span class="category">[{{item.B_SUB_TYPE}}]</span>
										<span class="title-text">{{item.TITLE}}</span>
									</div>
								</td>
								<td>{{item.USER_ID}}</td>
								<td>{{item.VIEW_COUNT}}</td>
								<td>{{item.LIKE_CNT}}</td>
								<td>{{item.COMMENT_CNT}}</td>
								<td>{{item.CREATE_TIME}}</td>
							</tr>
						</tbody>
					</table>

					<!-- 페이징 -->
					<div class="pagination" v-if="pageCount > 0">
						<button @click="fnGoPage(currentPage - 1)" v-if="currentPage > 1">&lt;</button>

						<button v-for="n in pageCount" :key="n" :class="{active : currentPage == n}"
							@click="fnGoPage(n)">
							{{n}}
						</button>

						<button @click="fnGoPage(currentPage + 1)" v-if="currentPage < pageCount">&gt;</button>
					</div>
				</div>
			</div>
		</div>

		<script>
			const app = Vue.createApp({
				data() {
					return {
						boardList: [],
						selectedMainNo: '<%=request.getAttribute("bMainNo") == null ? "" : request.getAttribute("bMainNo")%>',
						searchType: '<%=request.getAttribute("searchType") == null ? "" : request.getAttribute("searchType")%>',
						keyword: '<%=request.getAttribute("keyword") == null ? "" : request.getAttribute("keyword")%>',
						sortType: '<%=request.getAttribute("sortType") == null || request.getAttribute("sortType").equals("") ? "new" : request.getAttribute("sortType")%>',
						currentPage: Number('<%=request.getAttribute("page") == null || request.getAttribute("page").equals("") ? "1" : request.getAttribute("page")%>'),
						tempYn: '<%=request.getAttribute("tempYn") == null ? "" : request.getAttribute("tempYn")%>',
						pageSize: 10,
						totalCount: 0,
						integratedCategory: '',
						localCategory: '',
						localNo: "",
						showAlarm: false,
						alarmList: [],
						alarmCount: 0
						
						
					};
				},
				computed: {
					pageCount() {
						return Math.ceil(this.totalCount / this.pageSize);
					}
				},
				methods: {
					fnGetBoardList() {
						let self = this;
						$.ajax({
							url: "/board/list.dox",
							type: "POST",
							dataType: "json",
							data: {
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
							},
							success: function (data) {
								if (data.result == "success") {
									self.boardList = data.list || [];
									self.totalCount = data.count || 0;
								}
							}
						});
					},
					fnSelectMain(bMainNo) {
						this.selectedMainNo = bMainNo;
						this.currentPage = 1;
						this.integratedCategory = "";
						this.localCategory = "";
						this.localNo = "";
						this.fnGetBoardList();
					},
					fnChangeSort(sortType) {
						this.sortType = sortType;
						this.currentPage = 1;
						this.fnGetBoardList();
					},
					fnSearch() {
						this.currentPage = 1;
						this.fnGetBoardList();
					},
					fnGoPage(page) {
						if (page < 1 || page > this.pageCount) {
							return;
						}
						this.currentPage = page;
						this.fnGetBoardList();
					},
					
					fnMoveView(boardNo) {
						if (this.tempYn == "Y") {
							pageChange("/board/edit.do", {
								boardNo: boardNo
							});
						} else {
							pageChange("/board/view.do", {
								boardNo: boardNo
							});
						}
					},
					
					fnMoveAdd() {
						if (this.selectedMainNo == "") {
							alert("글을 작성할 게시판 탭을 먼저 선택해주세요.");
							return;
						}

						pageChange("/board/add.do", {
							bMainNo: this.selectedMainNo
						});
					},
					
					fnMoveTempList() {
						pageChange("/board/list.do", {
							tempYn: "Y"
						});
					},

					fnMoveNormalList() {
						pageChange("/board/list.do", {});
					},
					
					fnTempList() {
						this.tempYn = "Y";
						this.currentPage = 1;
						this.fnGetBoardList();
					},

					fnNormalList() {
						this.tempYn = "";
						this.currentPage = 1;
						this.fnGetBoardList();
					},
					
					fnSelectLocalCategory(category) {
						this.localCategory = category;
						this.currentPage = 1;
						this.fnGetBoardList();
					},
					
					fnSelectIntegratedCategory(category) {
						this.integratedCategory = category;
						this.currentPage = 1;
						this.fnGetBoardList();
					},
					
					fnSelectLocalNo() {
						this.currentPage = 1;
						this.fnGetBoardList();
					},
					
					fnGetAlarmList() {
						let self = this;

						self.showAlarm = !self.showAlarm;

						if (self.showAlarm) {
							$.ajax({
								url: "/board/alarm/list.dox",
								type: "POST",
								dataType: "json",
								success: function(data) {
									if (data.result == "success") {
										self.alarmList = data.list;
										self.alarmCount = 0;
									}
								}
							});
						}
					},
					fnReadAlarm(item) {
						let self = this;

						$.ajax({
							url: "/board/alarm/read.dox",
							type: "POST",
							dataType: "json",
							data: {
								alarmNo: item.ALARM_NO
							},
							success: function(data) {
								if (self.alarmCount > 0) {
									self.alarmCount--;
								}

								pageChange("/board/view.do", {
									boardNo: item.BOARD_NO
								});
							}
						});
					},
					
					fnCloseAlarmOutside(e) {
						let alarmArea = document.querySelector(".alarm-area");

						if (alarmArea != null && !alarmArea.contains(e.target)) {
							this.showAlarm = false;
						}
					},
					
					fnGetAlarmCount() {
						let self = this;

						$.ajax({
							url: "/board/alarm/list.dox",
							type: "POST",
							dataType: "json",
							success: function(data) {
								if (data.result == "success") {
									let count = 0;

									for (let i = 0; i < data.list.length; i++) {
										if (data.list[i].READ_YN == "N") {
											count++;
										}
									}

									self.alarmCount = count;
								}
							}
						});
					}
				},
				mounted() {
					this.fnGetBoardList();
					this.fnGetAlarmCount();
					this.showAlarm = false;

					document.addEventListener("click", this.fnCloseAlarmOutside);
				},
				
				beforeUnmount() {
					document.removeEventListener("click", this.fnCloseAlarmOutside);
				}
			});

			app.mount("#app");
		</script>
	</body>

	</html>