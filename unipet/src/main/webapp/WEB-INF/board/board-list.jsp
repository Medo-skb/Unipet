<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<title>커뮤니티 목록</title>
		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-change.js"></script>
		<style>
			* {
				box-sizing: border-box;
			}

			body {
				margin: 0;
				font-family: 'Malgun Gothic';
				background: #f7f8fa;
			}

			.wrap {
				width: 1200px;
				margin: 0 auto;
				padding: 30px 0;
			}

			.page-title {
				font-size: 28px;
				font-weight: bold;
				margin-bottom: 20px;
			}

			.box {
				background: #fff;
				border: 1px solid #ddd;
				border-radius: 12px;
				padding: 20px;
				margin-bottom: 20px;
			}

			.tab-row,
			.search-row,
			.sort-row {
				display: flex;
				gap: 10px;
				flex-wrap: wrap;
				margin-bottom: 15px;
			}

			.tab-btn,
			.sort-btn {
				border: none;
				background: #e9ecef;
				padding: 10px 16px;
				border-radius: 999px;
				cursor: pointer;
				font-weight: bold;
			}

			.tab-btn.active,
			.sort-btn.active {
				background: #ff7a00;
				color: #fff;
			}

			.search-row select,
			.search-row input {
				height: 40px;
				border: 1px solid #ccc;
				border-radius: 8px;
				padding: 0 10px;
			}

			.search-row input {
				width: 300px;
			}

			.search-row button,
			.write-btn {
				height: 40px;
				border: none;
				border-radius: 8px;
				background: #ff7a00;
				color: #fff;
				padding: 0 16px;
				cursor: pointer;
				font-weight: bold;
			}

			table {
				width: 100%;
				border-collapse: collapse;
			}

			th,
			td {
				padding: 14px 10px;
				border-bottom: 1px solid #eee;
				text-align: center;
			}

			th {
				background: #fafafa;
			}

			.title-cell {
				text-align: left;
				cursor: pointer;
				font-weight: bold;
			}

			.title-wrap {
				display: flex;
				align-items: center;
				gap: 8px;
			}

			.thumb {
				width: 60px;
				height: 60px;
				object-fit: cover;
				border-radius: 8px;
				border: 1px solid #ddd;
				background: #f3f3f3;
			}

			.private-badge,
			.popular-badge {
				display: inline-block;
				padding: 3px 8px;
				border-radius: 999px;
				font-size: 12px;
			}

			.private-badge {
				background: #fff1c9;
				color: #7b5a00;
			}

			.popular-badge {
				background: #ffe3e3;
				color: #d6336c;
			}

			.pagination {
				display: flex;
				justify-content: center;
				gap: 8px;
				margin-top: 20px;
			}

			.pagination button {
				width: 36px;
				height: 36px;
				border: 1px solid #ccc;
				background: white;
				border-radius: 8px;
				cursor: pointer;
			}

			.pagination button.active {
				background: #ff7a00;
				color: white;
				border-color: #ff7a00;
			}

			.top-row {
				display: flex;
				justify-content: space-between;
				align-items: center;
				margin-bottom: 15px;
			}
		</style>
	</head>

	<body>
		<div id="app">
			<div class="wrap">
				<div class="page-title">커뮤니티</div>

				<div class="box">
					<!-- 대분류 탭 -->
					<div class="tab-row">
						<button class="tab-btn" :class="{active : selectedMainNo == ''}"
							@click="fnSelectMain('')">전체</button>
						<button class="tab-btn" :class="{active : selectedMainNo == '1'}"
							@click="fnSelectMain('1')">통합</button>
						<button class="tab-btn" :class="{active : selectedMainNo == '2'}"
							@click="fnSelectMain('2')">지역</button>
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
						<button class="tab-btn" :class="{active : localCategory == 'walk'}" @click="fnSelectLocalCategory('walk')">산책</button>
						<button class="tab-btn" :class="{active : localCategory == 'meet'}" @click="fnSelectLocalCategory('meet')">소모임</button>
						<button class="tab-btn" :class="{active : localCategory == 'travel'}" @click="fnSelectLocalCategory('travel')">여행</button>
						<button class="tab-btn" :class="{active : localCategory == 'info'}" @click="fnSelectLocalCategory('info')">지역정보</button>
						<button class="tab-btn" :class="{active : localCategory == 'hospital'}" @click="fnSelectLocalCategory('hospital')">병원추천</button>
						<button class="tab-btn" :class="{active : localCategory == 'care'}" @click="fnSelectLocalCategory('care')">돌봄</button>
						<button class="tab-btn" :class="{active : localCategory == 'market'}" @click="fnSelectLocalCategory('market')">중고거래</button>
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

						<div style="display:flex; gap:10px;">
							<button class="write-btn" @click="fnMoveTempList()">임시저장 글 보기</button>
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
										<span v-if="item.PRIVATE == 'Y'" class="private-badge">비공개</span>
										<span v-if="Number(item.LIKE_CNT) >= 5" class="popular-badge">인기글</span>
										<span>[{{item.B_MAIN_TYPE}}]</span>
										<span>{{item.TITLE}}</span>
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
						localCategory: ''
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
								tempYn: self.tempYn
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
							location.href = "/board/edit.do?boardNo=" + boardNo;
						} else {
							location.href = "/board/view.do?boardNo=" + boardNo;
						}
					},
					
					fnMoveAdd() {
						if (this.selectedMainNo == "") {
							alert("글을 작성할 게시판 탭을 먼저 선택해주세요.");
							return;
						}

						location.href = "/board/add.do?bMainNo=" + this.selectedMainNo;
					},
					
					fnMoveTempList() {
						location.href = "/board/list.do?tempYn=Y";
					},

					fnMoveNormalList() {
						location.href = "/board/list.do";
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
					}
				},
				mounted() {
					this.fnGetBoardList();
				}
			});

			app.mount("#app");
		</script>
	</body>

	</html>