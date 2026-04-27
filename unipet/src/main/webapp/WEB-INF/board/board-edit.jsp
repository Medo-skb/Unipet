<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<title>게시글 수정</title>
		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-change.js"></script>

		<link rel="stylesheet" href="/css/board/board-edit.css">

	</head>

	<body>
		<jsp:include page="/WEB-INF/header/header.jsp" />
		<% String msg=request.getParameter("msg"); if ("temp".equals(msg)) { %>
			<script>
				alert("임시저장되었습니다.");
			</script>
			<% } %>
				<div id="app">
				
					<div class="wrap" v-if="loaded">
						<form class="box" v-if="board != null" action="/board/update.do" method="post"
							enctype="multipart/form-data">
							<input type="hidden" name="boardNo" :value="boardNo">
							<input type="hidden" name="bStatus" id="bStatus" :value="board.B_STATUS == 'T' ? 'T' : 'Y'">

							<div class="title">게시글 수정</div>

							<div class="form-row">
								<div class="label">게시판 대분류</div>
								<select v-model="selectedMainNo" @change="fnChangeMain()">
									<option value="">대분류 선택</option>
									<option v-for="item in mainTypeList" :key="item.B_MAIN_NO" :value="item.B_MAIN_NO">
										{{item.B_MAIN_TYPE}}
									</option>
								</select>
							</div>

							<div class="form-row">
								<div class="label">게시판 소분류</div>
								<select v-model="bSubNo" name="bSubNo">
									<option value="">소분류 선택</option>
									<option v-for="item in filteredSubTypeList" :key="item.B_SUB_NO"
										:value="item.B_SUB_NO">
										{{item.B_SUB_TYPE}}
									</option>
								</select>
							</div>

							<div class="form-row" v-if="isLocalBoard">
								<div class="label">지역</div>
								<select v-model="localNo" name="localNo">
									<option value="">지역 선택</option>
									<option v-for="item in localList" :key="item.LOCAL_NO" :value="item.LOCAL_NO">
										{{item.LOCAL_NAME}}
									</option>
								</select>
							</div>

							<div class="form-row">
								<div class="label">공개 설정</div>
								<div class="radio-row">
									<label><input type="radio" value="N" v-model="privateYn" name="privateYn">
										공개</label>
									<label><input type="radio" value="Y" v-model="privateYn" name="privateYn">
										비공개</label>
								</div>
							</div>

							<div class="form-row">
								<div class="label">제목</div>
								<input type="text" v-model="title" name="title">
							</div>

							<div class="form-row">
								<div class="label">본문</div>
								<textarea v-model="bContent" name="bContent"></textarea>
							</div>

							<div class="form-row">
								<div class="label">기존 첨부파일</div>
								<div v-if="fileList.length == 0">첨부파일이 없습니다.</div>
								<div v-else>
									<div class="file-box" v-for="file in fileList" :key="file.FILE_NO">
										{{file.ORIGIN_NAME}}
										<button type="button" @click="fnRemoveFile(file.FILE_NO)">삭제</button>
									</div>
								</div>
							</div>

							<div class="form-row">
								<div class="label">새 첨부파일</div>
								<input type="file" name="files" multiple>
							</div>

							<div class="btn-row">
								<button type="submit" class="save-btn"
									onclick="document.getElementById('bStatus').value='Y'">등록</button>
								<button type="submit" class="list-btn"
									onclick="document.getElementById('bStatus').value='T'">임시저장</button>
								<button type="button" class="remove-btn" @click="fnRemoveBoard()">삭제</button>
								<button type="button" class="list-btn" @click="fnMoveView()">취소</button>
							</div>
						</form>
					</div>
				</div>

				<script>
					const app = Vue.createApp({
						data() {
							return {
								boardNo: '<%=request.getAttribute("boardNo")%>',
								board: null,
								mainTypeList: [],
								subTypeList: [],
								localList: [],
								fileList: [],
								selectedMainNo: "",
								bSubNo: "",
								localNo: "",
								privateYn: "N",
								title: "",
								bContent: "",
								loaded: false
							};
						},
						computed: {
							filteredSubTypeList() {
								if (this.selectedMainNo == "") {
									return [];
								}
								return this.subTypeList.filter(item => String(item.B_MAIN_NO) == String(this.selectedMainNo));
							},
							isLocalBoard() {
								return String(this.selectedMainNo) == "2";
							}
						},
						methods: {
							fnGetBoardEditInfo() {
								let self = this;
								$.ajax({
									url: "/board/edit-info.dox",
									type: "POST",
									dataType: "json",
									data: {
										boardNo: self.boardNo
									},
									success: function (data) {
										self.loaded = true;

										if (data.result == "success") {
											self.board = data.board;
											self.mainTypeList = data.mainTypeList || [];
											self.subTypeList = data.subTypeList || [];
											self.localList = data.localList || [];
											self.fileList = data.fileList || [];

											self.bSubNo = data.board.B_SUB_NO;
											self.localNo = data.board.LOCAL_NO == null ? "" : data.board.LOCAL_NO;
											self.privateYn = data.board.PRIVATE;
											self.title = data.board.TITLE;
											self.bContent = data.board.B_CONTENT;

											for (let i = 0; i < self.subTypeList.length; i++) {
												if (String(self.subTypeList[i].B_SUB_NO) == String(self.bSubNo)) {
													self.selectedMainNo = self.subTypeList[i].B_MAIN_NO;
													break;
												}
											}
										} else if (data.result == "login") {
											alert("로그인이 필요합니다.");
											pageChange("/user/login.do", {});
										} else if (data.result == "deny") {
											alert(data.message);
											pageChange("/board/view.do", {
												boardNo: self.boardNo
											});
										} else {
											alert(data.message);
											pageChange("/board/list.do", {});
										}
									}
								});
							},
							fnChangeMain() {
								this.bSubNo = "";
								this.localNo = "";
							},
							fnRemoveBoard() {
								let self = this;

								if (!confirm("게시글을 삭제하시겠습니까?")) {
									return;
								}

								$.ajax({
									url: "/board/remove.dox",
									type: "POST",
									dataType: "json",
									data: {
										boardNo: self.boardNo
									},
									success: function (data) {
										if (data.result == "success") {
											alert(data.message);
											pageChange("/board/list.do", {});
										} else if (data.result == "login") {
											alert("로그인이 필요합니다.");
											pageChange("/user/login.do", {});
										} else {
											alert(data.message);
										}
									}
								});
							},
							fnMoveView() {
								pageChange("/board/view.do", {
									boardNo: this.boardNo
								});
							},
							fnRemoveFile(fileNo) {
								let self = this;

								if (!confirm("첨부파일을 삭제하시겠습니까?")) {
									return;
								}

								$.ajax({
									url: "/board/file/remove.dox",
									type: "POST",
									dataType: "json",
									data: {
										fileNo: fileNo,
										boardNo: self.boardNo
									},
									success: function (data) {
										if (data.result == "success") {
											alert(data.message);
											self.fnGetBoardEditInfo();
										} else if (data.result == "login") {
											alert("로그인이 필요합니다.");
											pageChange("/user/login.do", {});
										} else {
											alert(data.message);
										}
									}
								});
							},
							fnMoveList() {
								pageChange("/board/list.do", {});
							}
						},
						mounted() {
							this.fnGetBoardEditInfo();
						}
					});
					app.mount("#app");
				</script>
				<jsp:include page="/WEB-INF/footer/footer.jsp" />
	</body>

	</html>