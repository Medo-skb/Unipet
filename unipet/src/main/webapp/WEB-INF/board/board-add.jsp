<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<title>게시글 작성</title>
		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-change.js"></script>
		
		<link rel="stylesheet" href="/css/board/board-add.css">

	</head>

	<body>
		<div id="app">
			<div class="logo-area">
				<img src="/img/board/unipet_logo.png" class="logo-img" onclick="fnGoHome()">
			</div>
			<div class="wrap">
				<div class="box">
					<div class="title">{{boardTitle}}</div>

					<div class="form-row">
						<div class="label">카테고리</div>
						<select v-model="bSubNo">
							<option value="">카테고리 선택</option>
							<option v-for="item in filteredSubTypeList" :key="item.B_SUB_NO" :value="item.B_SUB_NO">
								{{item.B_SUB_TYPE}}
							</option>
						</select>
					</div>

					<div class="form-row" v-if="isLocalBoard">
						<div class="label">지역</div>
						<select v-model="localNo">
							<option value="">지역 선택</option>
							<option v-for="item in localList" :key="item.LOCAL_NO" :value="item.LOCAL_NO">
								{{item.LOCAL_NAME}}
							</option>
						</select>
					</div>

					<div class="form-row">
						<div class="label">공개 설정</div>
						<div class="radio-row">
							<label><input type="radio" value="N" v-model="privateYn"> 공개</label>
							<label><input type="radio" value="Y" v-model="privateYn"> 비공개</label>
						</div>
					</div>

					<div class="form-row">
						<div class="label">제목</div>
						<input type="text" v-model="title" placeholder="제목을 입력하세요">
					</div>

					<div class="form-row">
						<div class="label">본문</div>
						<textarea v-model="bContent" placeholder="내용을 입력하세요"></textarea>
					</div>

					<div class="form-row">
						<div class="label">첨부파일</div>
						<input type="file" id="fileInput" multiple>
					</div>

					<div class="btn-row">
						<button class="save-btn" @click="fnAddBoard('Y')">등록</button>
						<button class="list-btn" @click="fnAddBoard('T')">임시저장</button>
						<button class="list-btn" @click="fnLoadTempBoard()">최근 임시저장 불러오기</button>
						<button class="list-btn" @click="fnMoveList()">목록</button>
					</div>
				</div>
			</div>
		</div>

		<script>
			const app = Vue.createApp({
				data() {
					return {
						subTypeList: [],
						localList: [],
						filteredSubTypeList: [],
						selectedMainNo: '<%=request.getAttribute("bMainNo") == null ? "" : request.getAttribute("bMainNo")%>',
						bSubNo: "",
						localNo: "",
						privateYn: "N",
						title: "",
						bContent: "",
						boardTitle: "게시글 작성",
						isLocalBoard: false
					};
				},
				methods: {
					fnSetBoardInfo: function () {
						let self = this;

						if (self.selectedMainNo == "1") {
							self.boardTitle = "통합 게시판 글쓰기";
							self.isLocalBoard = false;
						} else if (self.selectedMainNo == "2") {
							self.boardTitle = "지역 게시판 글쓰기";
							self.isLocalBoard = true;
							self.localNo = "2";
						} else if (self.selectedMainNo == "3") {
							self.boardTitle = "전문가 Q&A 글쓰기";
							self.isLocalBoard = false;
						} else {
							self.boardTitle = "게시글 작성";
							self.isLocalBoard = false;
						}
					},
					fnFilterSubTypeList: function () {
						let self = this;
						self.filteredSubTypeList = [];

						for (let i = 0; i < self.subTypeList.length; i++) {
							if (String(self.subTypeList[i].B_MAIN_NO) == String(self.selectedMainNo)) {
								self.filteredSubTypeList.push(self.subTypeList[i]);
							}
						}
					},
					fnGetInitData: function () {
						let self = this;
						$.ajax({
							url: "/board/category/list.dox",
							type: "POST",
							dataType: "json",
							data: {},
							success: function (data) {
								if (data.result == "success") {
									self.subTypeList = data.subTypeList || [];
									self.localList = data.localList || [];
									self.fnSetBoardInfo();
									self.fnFilterSubTypeList();
								} else {
									alert("카테고리 조회 실패");
								}
							},
							error: function (xhr, status, error) {
								console.log("카테고리 조회 오류:", xhr.responseText);
								alert("카테고리 조회 중 오류가 발생했습니다.");
							}
						});
					},
					fnAddBoard: function (status) {
						let self = this;
						if (self.bSubNo == "") {
							alert("카테고리를 선택해주세요.");
							return;
						}
						
						if (self.selectedMainNo == "2" && self.localNo == "") {
							alert("지역을 선택해주세요.");
							return;
						}

						let formData = new FormData();

						formData.append("bSubNo", self.bSubNo);
						formData.append("localNo", self.localNo);
						formData.append("privateYn", self.privateYn);
						formData.append("title", self.title);
						formData.append("bContent", self.bContent);
						formData.append("bStatus", status);

						let files = $("#fileInput")[0].files;
						for (let i = 0; i < files.length; i++) {
							formData.append("files", files[i]);
						}

						$.ajax({
							url: "/board/add.dox",
							type: "POST",
							dataType: "json",
							data: formData,
							processData: false,
							contentType: false,
							success: function (data) {
								if (data.result == "success") {
									alert(data.message);

									if (status == "T") {
										pageChange("/board/edit.do", {
											boardNo: data.boardNo
										});
									} else {
										pageChange("/board/view.do", {
											boardNo: data.boardNo
										});
									}
								} else if (data.result == "login") {
									alert("로그인이 필요합니다.");
									pageChange("/user/login.do", {});
								} else {
									alert(data.message);
								}
							},
							error: function (xhr, status, error) {
								console.log("게시글 등록 오류:", xhr.responseText);
								alert("게시글 등록 중 오류가 발생했습니다.");
							}
						});
					},
					fnMoveList: function () {
						pageChange("/board/list.do", {
							bMainNo: this.selectedMainNo
						});
					},

					fnLoadTempBoard: function () {
						let self = this;

						$.ajax({
							url: "/board/temp-recent.dox",
							type: "POST",
							dataType: "json",
							data: {},
							success: function (data) {
								if (data.result == "success") {
									self.bSubNo = data.info.B_SUB_NO == null ? "" : data.info.B_SUB_NO;
									self.localNo = data.info.LOCAL_NO == null ? "" : data.info.LOCAL_NO;
									self.privateYn = data.info.PRIVATE == null ? "N" : data.info.PRIVATE;
									self.title = data.info.TITLE == null ? "" : data.info.TITLE;
									self.bContent = data.info.B_CONTENT == null ? "" : data.info.B_CONTENT;

									alert("최근 임시저장 글을 불러왔습니다.");
								} else if (data.result == "login") {
									alert("로그인이 필요합니다.");
									pageChange("/user/login.do", {});
								} else {
									alert(data.message);
								}
							},
							error: function (xhr, status, error) {
								console.log("임시저장 불러오기 오류:", xhr.responseText);
								alert("임시저장 글 불러오기 중 오류가 발생했습니다.");
							}
						});
					}
				},
				mounted() {
					if (this.selectedMainNo == "") {
						alert("게시판 탭을 먼저 선택해주세요.");
						pageChange("/board/list.do", {});
						return;
					}
					this.fnGetInitData();
				}
			});

			app.mount("#app");
		</script>
		<script>
			function fnGoHome() {
				pageChange("/board/list.do", {});
			}
		</script>
	</body>

	</html>