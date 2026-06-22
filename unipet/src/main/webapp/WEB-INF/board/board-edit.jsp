<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<title>UNIPET</title>

		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>

		<!-- Jodit 에디터 -->
		<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/jodit/4.6.13/es2015/jodit.fat.min.css">
		<script src="https://cdnjs.cloudflare.com/ajax/libs/jodit/4.6.13/es2018/jodit.fat.min.js"></script>

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
							enctype="multipart/form-data" @submit="fnCheckForm">
							<input type="hidden" name="boardNo" :value="boardNo">
							<input type="hidden" name="bStatus" id="bStatus" :value="board.bStatus == 'T' ? 'T' : 'Y'">

							<div class="title">게시글 수정</div>

							<div class="form-row">
								<div class="label">게시판 대분류</div>

								<select v-model="selectedMainNo" @change="fnChangeMain()">
									<option value="">대분류 선택</option>

									<option v-for="item in mainTypeList" :key="item.bMainNo" :value="item.bMainNo">
										{{item.bMainType}}
									</option>
								</select>
							</div>

							<div class="form-row">
								<div class="label">게시판 소분류</div>

								<select v-model="bSubNo" name="bSubNo">
									<option value="">소분류 선택</option>

									<option v-for="item in filteredSubTypeList" :key="item.bSubNo" :value="item.bSubNo">
										{{item.bSubType}}
									</option>
								</select>
							</div>

							<div class="form-row" v-if="isLocalBoard">
								<div class="label">지역</div>

								<select v-model="localNo" name="localNo">
									<option value="">지역 선택</option>

									<option v-for="item in localList" :key="item.localNo" :value="item.localNo">
										{{item.localName}}
									</option>
								</select>
							</div>

							<div class="form-row">
								<div class="label">공개 설정</div>

								<div class="radio-row">
									<label>
										<input type="radio" value="N" v-model="privateYn" name="privateYn">
										공개
									</label>

									<label>
										<input type="radio" value="Y" v-model="privateYn" name="privateYn">
										비공개
									</label>
								</div>
							</div>

							<div class="form-row">
								<div class="label">제목</div>

								<div class="input-wrap">
									<input type="text" v-model="title" name="title" :maxlength="maxTitleLength">

									<div class="input-count" :class="{danger : title.length >= maxTitleLength}">
										{{title.length}} / {{maxTitleLength}}
									</div>
								</div>
							</div>

							<div class="form-row">
								<div class="label">본문</div>

								<div class="textarea-wrap">
									<textarea id="bContent" name="bContent"></textarea>

									<div class="text-count" :class="{danger : contentTextLength >= maxContentLength}">
										{{contentTextLength}} / {{maxContentLength}}
									</div>
								</div>
							</div>

							<div class="form-row">
								<div class="label">기존 첨부파일</div>

								<div v-if="fileList.length == 0">첨부파일이 없습니다.</div>

								<div v-else>
									<div class="file-box" v-for="file in fileList" :key="file.fileNo">
										<span>
											📎 {{file.originName ? file.originName : file.fileName}}
										</span>

										<button type="button" @click="fnRemoveFile(file.fileNo)">삭제</button>
									</div>
								</div>
							</div>

							<div class="form-row">
								<div class="label">새 첨부파일</div>
								<input type="file" name="files" multiple>
							</div>

							<div class="btn-row">
								<button type="submit" class="save-btn"
									onclick="document.getElementById('bStatus').value='Y'">
									등록
								</button>

								<button type="submit" class="list-btn"
									onclick="document.getElementById('bStatus').value='T'">
									임시저장
								</button>

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
								contentTextLength: 0,
								maxTitleLength: 100,
								maxContentLength: 2000,
								loaded: false,
								editor: null,
								editorTimer: null,

								sessionId: '<%=session.getAttribute("sessionId") == null ? "" : session.getAttribute("sessionId")%>',
								sessionRole: '<%=session.getAttribute("sessionRole") == null ? "" : session.getAttribute("sessionRole")%>',
								adminId: '<%=session.getAttribute("adminId") == null ? "" : session.getAttribute("adminId")%>',
								adminName: '<%=session.getAttribute("adminName") == null ? "" : session.getAttribute("adminName")%>'
							};
						},
						computed: {
							filteredSubTypeList() {
								if (this.selectedMainNo == "") {
									return [];
								}

								let list = [];

								for (let i = 0; i < this.subTypeList.length; i++) {
									if (String(this.subTypeList[i].bMainNo) == String(this.selectedMainNo)) {

										if (String(this.subTypeList[i].bSubNo) == "1" && !this.fnIsAdmin()) {
											continue;
										}

										list.push(this.subTypeList[i]);
									}
								}

								return list;
							},
							isLocalBoard() {
								return String(this.selectedMainNo) == "2";
							}
						},
						methods: {
							fnIsAdmin() {
								if (this.adminId != "") {
									return true;
								}

								if (this.sessionRole == "A") {
									return true;
								}

								if (this.sessionRole == "ADMIN") {
									return true;
								}

								if (this.sessionId == "admin") {
									return true;
								}

								return false;
							},

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
										if (data.result == "success") {
											self.board = data.board;
											self.mainTypeList = data.mainTypeList || [];
											self.subTypeList = data.subTypeList || [];
											self.localList = data.localList || [];
											self.fileList = data.fileList || [];

											self.bSubNo = data.board.bSubNo;
											self.localNo = data.board.localNo == null || data.board.localNo == 0 ? "" : data.board.localNo;
											self.privateYn = data.board.privateYn == null ? "N" : data.board.privateYn;
											self.title = data.board.title == null ? "" : data.board.title;
											self.bContent = data.board.bContent == null ? "" : data.board.bContent;
											self.contentTextLength = self.fnGetOnlyText(self.bContent).length;

											for (let i = 0; i < self.subTypeList.length; i++) {
												if (String(self.subTypeList[i].bSubNo) == String(self.bSubNo)) {
													self.selectedMainNo = self.subTypeList[i].bMainNo;
													break;
												}
											}

											if (String(self.bSubNo) == "1" && !self.fnIsAdmin()) {
												alert("공지사항은 관리자만 수정할 수 있습니다.");
												pageChange("/board/view.do", {
													boardNo: self.boardNo
												});
												return;
											}

											self.loaded = true;

											self.$nextTick(function () {
												self.fnInitEditor();
											});

										} else if (data.result == "login") {
											alert("로그인이 필요한 서비스입니다.");
											location.href = "/user/login.do";

										} else if (data.result == "deny") {
											alert(data.message);
											pageChange("/board/view.do", {
												boardNo: self.boardNo
											});

										} else {
											alert(data.message);
											pageChange("/board/list.do", {});
										}
									},
									error: function () {
										alert("게시글 정보를 불러오지 못했습니다.");
									}
								});
							},

							fnInitEditor() {
								let self = this;

								if (typeof Jodit == "undefined") {
									alert("Jodit 에디터 파일을 불러오지 못했습니다.");
									return;
								}

								if (document.getElementById("bContent") == null) {
									alert("본문 입력창을 찾지 못했습니다.");
									return;
								}

								if (self.editor != null) {
									self.editor.destruct();
									self.editor = null;
								}

								if (self.editorTimer != null) {
									clearInterval(self.editorTimer);
									self.editorTimer = null;
								}

								$("#bContent").val(self.bContent);

								self.editor = Jodit.make("#bContent", {
									height: 430,
									minHeight: 320,
									toolbarAdaptive: false,
									showCharsCounter: false,
									showWordsCounter: false,
									showXPathInStatusbar: false,
									askBeforePasteHTML: false,
									askBeforePasteFromWord: false,
									defaultActionOnPaste: "insert_clear_html",
									buttons: [
										"source", "|",
										"bold", "italic", "underline", "strikethrough", "|",
										"font", "fontsize", "brush", "paragraph", "|",
										"ul", "ol", "outdent", "indent", "|",
										"left", "center", "right", "justify", "|",
										"link", "image", "table", "hr", "|",
										"eraser", "copyformat", "|",
										"undo", "redo", "fullsize"
									],
									events: {
										change: function () {
											self.fnUpdateEditorValue();
										},
										keyup: function () {
											self.fnUpdateEditorValue();
										}
									}
								});

								self.editor.value = self.bContent;
								self.fnUpdateEditorValue();

								self.editorTimer = setInterval(function () {
									self.fnUpdateEditorValue();
								}, 300);
							},

							fnUpdateEditorValue() {
								if (this.editor == null) {
									return;
								}

								let html = this.editor.value;
								let text = this.fnGetOnlyText(html);

								this.contentTextLength = text.length;

								if (text == "") {
									this.bContent = "";
								} else {
									this.bContent = html;
								}

								let bContentTextarea = document.getElementById("bContent");

								if (bContentTextarea != null) {
									bContentTextarea.value = this.bContent;
								}
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
											alert("로그인이 필요한 서비스입니다.");
											location.href = "/user/login.do";

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
											alert("로그인이 필요한 서비스입니다.");
											location.href = "/user/login.do";

										} else {
											alert(data.message);
										}
									}
								});
							},

							fnMoveList() {
								pageChange("/board/list.do", {});
							},

							fnGetOnlyText(content) {
								if (content == null) {
									return "";
								}

								let div = document.createElement("div");
								div.innerHTML = content;

								return div.textContent
									.replace(/\u00a0/g, "")
									.replace(/\n/g, "")
									.trim();
							},

							fnIsEmptyContent(content) {
								return this.fnGetOnlyText(content) == "";
							},

							fnCheckForm(e) {
								this.fnUpdateEditorValue();

								if (this.bSubNo == "") {
									alert("소분류를 선택해주세요.");
									e.preventDefault();
									return;
								}

								if (String(this.bSubNo) == "1" && !this.fnIsAdmin()) {
									alert("공지사항은 관리자만 작성하거나 수정할 수 있습니다.");
									e.preventDefault();
									return;
								}

								if (this.isLocalBoard && this.localNo == "") {
									alert("지역을 선택해주세요.");
									e.preventDefault();
									return;
								}

								if (this.title == "") {
									alert("제목을 입력해주세요.");
									e.preventDefault();
									return;
								}

								if (this.title.length > this.maxTitleLength) {
									alert("제목은 " + this.maxTitleLength + "자까지 입력할 수 있습니다.");
									e.preventDefault();
									return;
								}

								if (this.fnIsEmptyContent(this.bContent)) {
									alert("본문을 입력해주세요.");
									e.preventDefault();
									return;
								}

								if (this.contentTextLength > this.maxContentLength) {
									alert("본문은 " + this.maxContentLength + "자까지 입력할 수 있습니다.");
									e.preventDefault();
									return;
								}
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