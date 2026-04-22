<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<title>게시글 작성</title>
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

			.list-btn {
				background: #333;
				color: #fff;
			}

			.info-box {
				background: #fafafa;
				border: 1px solid #eee;
				padding: 12px;
				border-radius: 10px;
				font-size: 13px;
				color: #666;
				line-height: 1.6;
			}
		</style>
	</head>

	<body>
		<div id="app">
			<div style="padding:20px 0; text-align:center;">
			    <img src="/img/board/unipet_logo.png"
			         style="height:60px; cursor:pointer;"
			         onclick="fnGoHome()">
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
						<div class="info-box">
							파일 업로드 기능은 다음 단계에서 연결 예정<br>
							현재는 게시글 기본 등록 구조부터 먼저 맞춘 상태
						</div>
					</div>

					<div class="btn-row">
						<button class="save-btn" @click="fnAddBoard()">등록</button>
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
					fnAddBoard: function () {
						let self = this;

						$.ajax({
							url: "/board/add.dox",
							type: "POST",
							dataType: "json",
							data: {
								bSubNo: self.bSubNo,
								localNo: self.localNo,
								privateYn: self.privateYn,
								title: self.title,
								bContent: self.bContent
							},
							success: function (data) {
								if (data.result == "success") {
									alert(data.message);
									location.href = "/board/view.do?boardNo=" + data.boardNo;
								} else if (data.result == "login") {
									alert("로그인이 필요합니다.");
									location.href = "/user/login.do";
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
						location.href = "/board/list.do?bMainNo=" + this.selectedMainNo;
					}
				},
				mounted() {
					if (this.selectedMainNo == "") {
						alert("게시판 탭을 먼저 선택해주세요.");
						location.href = "/board/list.do";
						return;
					}
					this.fnGetInitData();
				}
			});

			app.mount("#app");
		</script>
		<script>
		function fnGoHome() {
			location.href = "/board/list.do";
		}
		</script>
	</body>

	</html>