<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<title>UNIPET</title>
		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-change.js"></script>

		<link rel="stylesheet" href="/css/board/board-add.css">
	</head>

	<body>
		<jsp:include page="/WEB-INF/header/header.jsp" />

		<div id="app">
			<div class="wrap">
				<div class="back-area">
					<button class="back-btn" @click="fnMoveList()">← 커뮤니티로 돌아가기</button>
				</div>

				<div class="box">
					<div class="title">{{boardTitle}}</div>

					<div class="form-row" v-if="isLocalBoard">
						<div class="label">지역</div>
						<select v-model="localNo">
							<option value="">지역 선택</option>
							<option v-for="item in localList" :key="item.localNo" :value="item.localNo">
								{{item.localName}}
							</option>
						</select>
					</div>

					<div class="form-row">
						<div class="label">카테고리</div>
						<select v-model="bSubNo">
							<option value="">카테고리 선택</option>
							<option v-for="item in filteredSubTypeList" :key="item.bSubNo" :value="item.bSubNo">
								{{item.bSubType}}
							</option>
						</select>
					</div>

					<div class="form-row">
						<div class="label">공개 설정</div>
						<div class="radio-row">
							<label>
								<input type="radio" value="N" v-model="privateYn">
								공개
							</label>
							<label>
								<input type="radio" value="Y" v-model="privateYn">
								비공개
							</label>
						</div>
					</div>

					<div class="form-row">
						<div class="label">제목</div>
						<input type="text" v-model="title" placeholder="제목을 입력하세요">
					</div>

					<div class="form-row">
						<div class="label">본문</div>

						<div class="textarea-wrap">
							<textarea v-model="bContent" :maxlength="maxContentLength"
								placeholder="내용을 입력하세요"></textarea>

							<div class="text-count" :class="{danger : bContent.length >= maxContentLength}">
								{{bContent.length}} / {{maxContentLength}}
							</div>
						</div>
					</div>

					<div class="form-row">
						<div class="label">첨부파일</div>

						<div>
							<input type="file" id="fileInput" multiple>

							<div class="existing-file-box" v-if="existingFileList.length > 0">
								<div class="existing-file-title">기존 첨부파일</div>

								<div class="existing-file-item" v-for="file in existingFileList" :key="file.fileNo">
									📎 {{file.fileName}}
								</div>
							</div>
						</div>
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
						maxContentLength: 2000,
						boardTitle: "게시글 작성",
						isLocalBoard: false,
						existingFileList: [],
						sessionId: '<%=session.getAttribute("sessionId") == null ? "" : session.getAttribute("sessionId")%>',
						sessionRole: '<%=session.getAttribute("sessionRole") == null ? "" : session.getAttribute("sessionRole")%>',
						adminId: '<%=session.getAttribute("adminId") == null ? "" : session.getAttribute("adminId")%>',
						adminName: '<%=session.getAttribute("adminName") == null ? "" : session.getAttribute("adminName")%>'
					};
				},
				methods: {
					fnIsAdmin: function () {
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

					fnSetBoardInfo: function () {
						let self = this;

						if (self.selectedMainNo == "1") {
							self.boardTitle = "통합 게시판 글쓰기";
							self.isLocalBoard = false;

						} else if (self.selectedMainNo == "2") {
							self.boardTitle = "지역 게시판 글쓰기";
							self.isLocalBoard = true;

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
							if (String(self.subTypeList[i].bMainNo) == String(self.selectedMainNo)) {

								if (self.subTypeList[i].bSubNo == 1 && !self.fnIsAdmin()) {
									continue;
								}

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
								alert("카테고리 조회 중 오류가 발생했습니다.");
							}
						});
					},

					fnAddBoard: function (status) {
						let self = this;

						if (self.selectedMainNo == "2" && self.localNo == "") {
							alert("지역을 선택해주세요.");
							return;
						}

						if (self.bSubNo == "") {
							alert("카테고리를 선택해주세요.");
							return;
						}

						if (self.bSubNo == "1" && !self.fnIsAdmin()) {
							alert("공지사항은 관리자만 작성할 수 있습니다.");
							return;
						}

						if (self.title == "") {
							alert("제목을 입력해주세요.");
							return;
						}

						if (self.bContent == "") {
							alert("본문을 입력해주세요.");
							return;
						}

						if (self.bContent.length > self.maxContentLength) {
							alert("본문은 " + self.maxContentLength + "자까지 입력할 수 있습니다.");
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
									alert("로그인이 필요한 서비스입니다.");
									location.href = "/user/login.do";

								} else {
									alert(data.message);
								}
							},
							error: function (xhr, status, error) {
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

									if (data.info == null || data.info.boardNo == null) {
										alert("불러올 임시저장 글이 없습니다.");
										return;
									}

									alert("최근 임시저장 글을 불러왔습니다.");

									pageChange("/board/edit.do", {
										boardNo: data.info.boardNo
									});

								} else if (data.result == "login") {
									alert("로그인이 필요한 서비스입니다.");
									location.href = "/user/login.do";

								} else {
									alert(data.message);
								}
							},
							error: function (xhr, status, error) {
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

		<jsp:include page="/WEB-INF/footer/footer.jsp" />
	</body>

	</html>