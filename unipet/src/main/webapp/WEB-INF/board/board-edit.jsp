<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<title>게시글 수정</title>
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
				width: 1000px;
				margin: 0 auto;
				padding: 30px 0;
			}

			.box {
				background: #fff;
				border: 1px solid #ddd;
				border-radius: 12px;
				padding: 25px;
			}

			.title {
				font-size: 28px;
				font-weight: bold;
				margin-bottom: 20px;
			}

			.form-row {
				margin-bottom: 16px;
			}

			.label {
				font-weight: bold;
				margin-bottom: 8px;
			}

			input[type=text],
			textarea,
			select {
				width: 100%;
				border: 1px solid #ccc;
				border-radius: 8px;
				padding: 10px;
				font-size: 14px;
				font-family: 'Malgun Gothic';
			}

			textarea {
				height: 300px;
				resize: none;
			}

			.radio-row {
				display: flex;
				gap: 20px;
				align-items: center;
			}

			.btn-row {
				display: flex;
				gap: 10px;
				margin-top: 20px;
			}

			.btn-row button {
				height: 42px;
				border: none;
				border-radius: 8px;
				padding: 0 18px;
				cursor: pointer;
				font-weight: bold;
			}

			.save-btn {
				background: #ff7a00;
				color: #fff;
			}

			.remove-btn {
				background: #dc3545;
				color: #fff;
			}

			.list-btn {
				background: #333;
				color: #fff;
			}

			.file-box {
				background: #fafafa;
				border: 1px solid #eee;
				border-radius: 10px;
				padding: 12px;
				margin-bottom: 10px;
			}
		</style>
	</head>

	<body>
		<div id="app">
			<div class="wrap" v-if="loaded">
				<div class="box" v-if="board != null">
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
						<select v-model="bSubNo">
							<option value="">소분류 선택</option>
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
						<input type="text" v-model="title">
					</div>

					<div class="form-row">
						<div class="label">본문</div>
						<textarea v-model="bContent"></textarea>
					</div>

					<div class="form-row">
						<div class="label">기존 첨부파일</div>
						<div v-if="fileList.length == 0">첨부파일이 없습니다.</div>
						<div v-else>
							<div class="file-box" v-for="file in fileList" :key="file.FILE_NO">
								{{file.ORIGIN_NAME}}
							</div>
						</div>
					</div>

					<div class="btn-row">
						<button class="save-btn" @click="fnUpdateBoard()">수정</button>
						<button class="remove-btn" @click="fnRemoveBoard()">삭제</button>
						<button class="list-btn" @click="fnMoveView()">취소</button>
					</div>
				</div>
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
									location.href = "/user/login.do";
								} else if (data.result == "deny") {
									alert(data.message);
									location.href = "/board/view.do?boardNo=" + self.boardNo;
								} else {
									alert(data.message);
									location.href = "/board/list.do";
								}
							}
						});
					},
					fnChangeMain() {
						this.bSubNo = "";
						this.localNo = "";
					},
					fnUpdateBoard() {
						let self = this;
						$.ajax({
							url: "/board/update.dox",
							type: "POST",
							dataType: "json",
							data: {
								boardNo: self.boardNo,
								bSubNo: self.bSubNo,
								localNo: self.localNo,
								privateYn: self.privateYn,
								title: self.title,
								bContent: self.bContent
							},
							success: function (data) {
								if (data.result == "success") {
									alert(data.message);
									location.href = "/board/view.do?boardNo=" + self.boardNo;
								} else if (data.result == "login") {
									alert("로그인이 필요합니다.");
									location.href = "/user/login.do";
								} else {
									alert(data.message);
								}
							}
						});
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
									location.href = "/board/list.do";
								} else if (data.result == "login") {
									alert("로그인이 필요합니다.");
									location.href = "/user/login.do";
								} else {
									alert(data.message);
								}
							}
						});
					},
					fnMoveView() {
						location.href = "/board/view.do?boardNo=" + this.boardNo;
					}
				},
				mounted() {
					this.fnGetBoardEditInfo();
				}
			});
			app.mount("#app");
		</script>
	</body>

	</html>