<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<title>게시글 상세</title>
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

			.box {
				background: #fff;
				border: 1px solid #ddd;
				border-radius: 12px;
				padding: 25px;
				margin-bottom: 20px;
			}

			.title {
				font-size: 30px;
				font-weight: bold;
				margin-bottom: 16px;
			}

			.meta {
				display: flex;
				gap: 20px;
				flex-wrap: wrap;
				color: #666;
				font-size: 14px;
				margin-bottom: 20px;
			}

			.content {
				min-height: 200px;
				line-height: 1.8;
				white-space: pre-line;
				font-size: 15px;
			}

			.file-list img,
			.file-list video {
				max-width: 100%;
				border-radius: 10px;
				margin-top: 15px;
				border: 1px solid #ddd;
			}

			.btn-row {
				display: flex;
				gap: 10px;
				margin-top: 20px;
			}

			.btn-row button,
			.comment-write button,
			.report-modal button {
				height: 40px;
				border: none;
				border-radius: 8px;
				cursor: pointer;
				padding: 0 16px;
				font-weight: bold;
			}

			.like-btn {
				background: #ff7a00;
				color: #fff;
			}

			.report-btn {
				background: #e9ecef;
			}

			.list-btn {
				background: #333;
				color: #fff;
			}

			.comment-box {
				margin-top: 30px;
			}

			.comment-title {
				font-size: 20px;
				font-weight: bold;
				margin-bottom: 15px;
			}

			.comment-write textarea {
				width: 100%;
				height: 90px;
				border: 1px solid #ccc;
				border-radius: 8px;
				padding: 10px;
				resize: none;
				font-family: 'Malgun Gothic';
			}

			.comment-write {
				margin-bottom: 20px;
			}

			.comment-write .btn-wrap {
				margin-top: 10px;
			}

			.comment-item {
				border-top: 1px solid #eee;
				padding: 16px 0;
			}

			.comment-item.reply {
				padding-left: 40px;
				background: #fafafa;
			}

			.comment-head {
				display: flex;
				justify-content: space-between;
				margin-bottom: 8px;
				font-size: 14px;
			}

			.comment-user {
				font-weight: bold;
			}

			.comment-content {
				white-space: pre-line;
				line-height: 1.7;
			}

			.profile-link {
				color: #ff7a00;
				font-weight: bold;
				cursor: pointer;
			}

			.private-box {
				background: #fff8e1;
				border: 1px solid #f0d58c;
				padding: 30px;
				border-radius: 12px;
				text-align: center;
				font-weight: bold;
			}

			.report-modal-wrap {
				position: fixed;
				left: 0;
				top: 0;
				width: 100%;
				height: 100%;
				background: rgba(0, 0, 0, 0.5);
				display: flex;
				justify-content: center;
				align-items: center;
			}

			.report-modal {
				width: 420px;
				background: white;
				border-radius: 12px;
				padding: 20px;
			}

			.report-modal h3 {
				margin-top: 0;
			}

			.report-modal select {
				width: 100%;
				height: 40px;
				border: 1px solid #ccc;
				border-radius: 8px;
				padding: 0 10px;
				margin-bottom: 12px;
			}
		</style>
	</head>

	<body>
		<div id="app">
			<div style="padding:20px 0; text-align:center;">
				<img src="../../img/board/unipet_logo.png" style="height:60px; cursor:pointer;" onclick="fnGoHome()">
			</div>
			<div class="wrap">
				<div v-if="resultType == 'private'" class="private-box">
					비공개 게시글입니다.
					<div style="margin-top:15px;">
						<button class="list-btn" @click="fnMoveList()">목록으로</button>
					</div>
				</div>

				<div v-else-if="board != null" class="box">
					<div class="title">{{board.TITLE}}</div>

					<div class="meta">
						<div>작성자 : <span class="profile-link"
								@click="fnMoveMypage(board.USER_ID)">{{board.USER_ID}}</span></div>
						<div>카테고리 : {{board.B_MAIN_TYPE}} / {{board.B_SUB_TYPE}}</div>
						<div>지역 : {{board.LOCAL_NAME == null ? '-' : board.LOCAL_NAME}}</div>
						<div>조회수 : {{board.VIEW_COUNT}}</div>
						<div>추천수 : {{likeCnt}}</div>
						<div>작성일 : {{board.CREATE_TIME}}</div>
					</div>

					<div class="content">{{board.B_CONTENT}}</div>

					<div class="file-list" v-if="fileList.length > 0">
						<div v-for="file in fileList" :key="file.FILE_NO">
							<img v-if="fnIsImage(file.FILE_EXT)" :src="file.FILE_URL">
							<video v-else-if="fnIsVideo(file.FILE_EXT)" :src="file.FILE_URL" controls></video>
							<div v-else>
								<a :href="file.FILE_URL" download>{{file.ORIGIN_NAME}}</a>
							</div>
						</div>
					</div>

					<div class="btn-row">
						<button class="like-btn" @click="fnBoardLike()">
							{{myLike == 'Y' ? '추천취소' : '추천'}} ({{likeCnt}})
						</button>

						<button class="report-btn" @click="showReportModal = true">신고</button>

						<button class="report-btn" v-if="board.USER_ID == currentUserId || currentUserRole == 'A'"
							@click="fnMoveEdit()">수정</button>

						<button class="report-btn" v-if="board.USER_ID == currentUserId || currentUserRole == 'A'"
							@click="fnRemoveBoard()">삭제</button>

						<button class="list-btn" @click="fnMoveList()">목록</button>
					</div>
				</div>

				<div v-if="board != null && resultType == 'success'" class="box comment-box">
					<div class="comment-title">댓글 {{commentList.length}}개</div>

					<div class="comment-write">
						<textarea v-model="commentContents" placeholder="댓글을 입력하세요"></textarea>
						<div class="btn-wrap">
							<button class="like-btn" @click="fnAddComment()">댓글 등록</button>
						</div>
					</div>

					<div v-if="commentList.length == 0">등록된 댓글이 없습니다.</div>

					<div v-for="comment in commentList" :key="comment.COMMENT_NO"
						:class="comment.PARENT_NO == null ? 'comment-item' : 'comment-item reply'">

						<div class="comment-head">
							<div class="comment-user">{{comment.USER_ID}}</div>
							<div>{{comment.CREATE_TIME}}</div>
						</div>

						<div v-if="comment.editMode">
							<textarea v-model="comment.editContents"
								style="width:100%; height:80px; border:1px solid #ccc; border-radius:8px; padding:10px; resize:none; font-family:'Malgun Gothic';"></textarea>

							<div class="btn-row" style="margin-top:10px;">
								<button class="like-btn" @click="fnUpdateComment(comment)">저장</button>
								<button class="report-btn" @click="fnCancelEditComment(comment)">취소</button>
							</div>
						</div>

						<div v-else>
							<div class="comment-content">{{comment.C_CONTENT}}</div>

							<div class="btn-row" style="margin-top:10px;">
								<button class="report-btn" @click="fnShowReply(comment.COMMENT_NO)">답글</button>

								<button class="report-btn" v-if="fnCanManageComment(comment)"
									@click="fnEditComment(comment)">수정</button>

								<button class="report-btn" v-if="fnCanManageComment(comment)"
									@click="fnRemoveComment(comment.COMMENT_NO)">삭제</button>
							</div>

							<div v-if="replyTargetNo == comment.COMMENT_NO" style="margin-top:10px;">
								<textarea v-model="replyContents"
									style="width:100%; height:70px; border:1px solid #ccc; border-radius:8px; padding:10px; resize:none;"></textarea>

								<div class="btn-row" style="margin-top:5px;">
									<button class="like-btn" @click="fnAddReply(comment.COMMENT_NO)">등록</button>
									<button class="report-btn" @click="replyTargetNo = null">취소</button>
								</div>
							</div>
						</div>
					</div>
				</div>

				<div v-if="showReportModal" class="report-modal-wrap">
					<div class="report-modal">
						<h3>게시글 신고</h3>
						<select v-model="reportReason">
							<option value="">신고 사유 선택</option>
							<option value="욕설/비방">욕설/비방</option>
							<option value="광고/도배">광고/도배</option>
							<option value="음란성">음란성</option>
							<option value="허위정보">허위정보</option>
							<option value="기타">기타</option>
						</select>

						<div class="btn-row">
							<button class="like-btn" @click="fnReportBoard()">접수</button>
							<button class="report-btn" @click="showReportModal = false">취소</button>
						</div>
					</div>
				</div>
			</div>
		</div>

		<script>
			const app = Vue.createApp({
				data() {
					return {
						boardNo: '<%=request.getAttribute("boardNo")%>',
						currentUserId: '<%=(String)session.getAttribute("sessionId") == null ? "" : (String)session.getAttribute("sessionId")%>',
						currentUserRole: '<%=(String)session.getAttribute("sessionRole") == null ? "" : (String)session.getAttribute("sessionRole")%>',
						board: null,
						fileList: [],
						commentList: [],
						commentContents: "",
						likeCnt: 0,
						myLike: "N",
						resultType: "",
						showReportModal: false,
						reportReason: "",
						replyTargetNo: null,
						replyContents: ""
					};
				},
				methods: {
					fnGetBoardDetail() {
						let self = this;
						$.ajax({
							url: "/board/detail.dox",
							type: "POST",
							dataType: "json",
							data: {
								boardNo: self.boardNo
							},
							success: function (data) {
								self.resultType = data.result;

								if (data.result == "success") {
									self.board = data.board;
									self.fileList = data.fileList || [];
									self.likeCnt = data.likeCnt || 0;
									self.myLike = data.myLike || "N";
									self.fnGetCommentList();
								} else if (data.result == "private") {
									self.board = null;
								} else {
									alert(data.message);
									location.href = "/board/list.do";
								}
							}
						});
					},
					fnGetCommentList() {
						let self = this;
						$.ajax({
							url: "/board/comment/list.dox",
							type: "POST",
							dataType: "json",
							data: {
								boardNo: self.boardNo
							},
							success: function (data) {
								if (data.result == "success") {
									self.commentList = data.list || [];

									for (let i = 0; i < self.commentList.length; i++) {
										self.commentList[i].editMode = false;
										self.commentList[i].editContents = self.commentList[i].C_CONTENT;
									}
								}
							}
						});
					},
					fnAddComment() {
						let self = this;

						if (self.commentContents == "") {
							alert("댓글 내용을 입력해주세요.");
							return;
						}

						$.ajax({
							url: "/board/comment/add.dox",
							type: "POST",
							dataType: "json",
							data: {
								boardNo: self.boardNo,
								contents: self.commentContents,
								parentNo: null
							},
							success: function (data) {
								if (data.result == "success") {
									alert("댓글이 등록되었습니다.");
									self.commentContents = "";
									self.fnGetCommentList();
								} else if (data.result == "login") {
									alert("로그인이 필요합니다.");
									location.href = "/user/login.do";
								} else {
									alert(data.message);
								}
							}
						});
					},
					fnMoveEdit() {
						location.href = "/board/edit.do?boardNo=" + this.boardNo;
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
					fnBoardLike() {
						let self = this;
						$.ajax({
							url: "/board/like.dox",
							type: "POST",
							dataType: "json",
							data: {
								boardNo: self.boardNo
							},
							success: function (data) {
								if (data.result == "success") {
									alert(data.message);
									self.likeCnt = data.likeCnt;
									self.myLike = data.myLike;
								} else if (data.result == "login") {
									alert("로그인이 필요합니다.");
									location.href = "/user/login.do";
								}
							}
						});
					},
					fnReportBoard() {
						let self = this;

						if (self.reportReason == "") {
							alert("신고 사유를 선택해주세요.");
							return;
						}

						$.ajax({
							url: "/board/report.dox",
							type: "POST",
							dataType: "json",
							data: {
								boardNo: self.boardNo,
								commentNo: "",
								reportReason: self.reportReason
							},
							success: function (data) {
								if (data.result == "success") {
									alert(data.message);
									self.showReportModal = false;
									self.reportReason = "";
								} else if (data.result == "login") {
									alert("로그인이 필요합니다.");
									location.href = "/user/login.do";
								} else {
									alert(data.message);
								}
							}
						});
					},
					fnMoveMypage(userId) {
						location.href = "/mypage.do?userId=" + userId;
					},
					fnMoveList() {
						if (this.board != null && this.board.B_MAIN_TYPE == '통합') {
							location.href = "/board/list.do?bMainNo=1";
						} else if (this.board != null && this.board.B_MAIN_TYPE == '지역') {
							location.href = "/board/list.do?bMainNo=2";
						} else if (this.board != null && this.board.B_MAIN_TYPE == '전문가 Q&A') {
							location.href = "/board/list.do?bMainNo=3";
						} else {
							location.href = "/board/list.do";
						}
					},
					fnIsImage(ext) {
						if (!ext) return false;
						ext = ext.toLowerCase();
						return ext == 'jpg' || ext == 'jpeg' || ext == 'png' || ext == 'gif' || ext == 'webp';
					},
					fnIsVideo(ext) {
						if (!ext) return false;
						ext = ext.toLowerCase();
						return ext == 'mp4' || ext == 'webm' || ext == 'ogg';
					},

					fnCanManageComment(comment) {
						if (this.currentUserRole == "A") {
							return true;
						}
						if (this.currentUserId != "" && this.currentUserId == comment.USER_ID) {
							return true;
						}
						return false;
					},

					fnEditComment(comment) {
						comment.editMode = true;
						comment.editContents = comment.C_CONTENT;
					},

					fnCancelEditComment(comment) {
						comment.editMode = false;
						comment.editContents = comment.C_CONTENT;
					},

					fnUpdateComment(comment) {
						let self = this;

						if (comment.editContents == "") {
							alert("댓글 내용을 입력해주세요.");
							return;
						}

						$.ajax({
							url: "/board/comment/update.dox",
							type: "POST",
							dataType: "json",
							data: {
								commentNo: comment.COMMENT_NO,
								contents: comment.editContents
							},
							success: function (data) {
								if (data.result == "success") {
									alert(data.message);
									self.fnGetCommentList();
								} else if (data.result == "login") {
									alert("로그인이 필요합니다.");
									location.href = "/user/login.do";
								} else {
									alert(data.message);
								}
							}
						});
					},

					fnRemoveComment(commentNo) {
						let self = this;

						if (!confirm("댓글을 삭제하시겠습니까?")) {
							return;
						}

						$.ajax({
							url: "/board/comment/remove.dox",
							type: "POST",
							dataType: "json",
							data: {
								commentNo: commentNo
							},
							success: function (data) {
								if (data.result == "success") {
									alert(data.message);
									self.fnGetCommentList();
								} else if (data.result == "login") {
									alert("로그인이 필요합니다.");
									location.href = "/user/login.do";
								} else {
									alert(data.message);
								}
							}
						});
					},
					fnShowReply(commentNo) {
						if (this.replyTargetNo == commentNo) {
							this.replyTargetNo = null;
							this.replyContents = "";
						} else {
							this.replyTargetNo = commentNo;
							this.replyContents = "";
						}
					},

					fnAddReply(parentNo) {
						let self = this;

						if (self.replyContents == "") {
							alert("답글 내용을 입력해주세요.");
							return;
						}

						$.ajax({
							url: "/board/comment/add.dox",
							type: "POST",
							dataType: "json",
							data: {
								boardNo: self.boardNo,
								contents: self.replyContents,
								parentNo: parentNo
							},
							success: function (data) {
								if (data.result == "success") {
									alert("답글이 등록되었습니다.");
									self.replyTargetNo = null;
									self.replyContents = "";
									self.fnGetCommentList();
								} else if (data.result == "login") {
									alert("로그인이 필요합니다.");
									location.href = "/user/login.do";
								} else {
									alert(data.message);
								}
							}
						});
					},

				},
				mounted() {
					this.fnGetBoardDetail();
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