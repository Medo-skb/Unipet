<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<title>게시글 상세</title>
		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-change.js"></script>

		<link rel="stylesheet" href="/css/board/board-view.css">

	</head>

	<body>
		<% String msg=request.getParameter("msg"); if ("update".equals(msg)) { %>
			<script>
				alert("수정되었습니다.");
			</script>
			<% } %>
				<div id="app">
					<div class="logo-area">
						<img src="../../img/board/unipet_logo.png" class="logo-img" onclick="fnGoHome()">
					</div>
					<div class="wrap">
						<div v-if="resultType == 'private'" class="private-box">
							비공개 게시글입니다.
							<div class="private-btn-wrap">
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

								<button type="button" class="report-btn" @click="fnOpenReportModal()">신고</button>

								<button type="button" class="report-btn" v-if="fnCanManageBoard()"
									@click="fnMoveEdit()">수정</button>

								<button type="button" class="report-btn" v-if="fnCanManageBoard()"
									@click="fnRemoveBoard()">삭제</button>

								<button class="list-btn" @click="fnMoveList()">목록</button>
							</div>
						</div>

						<div v-if="board != null && resultType == 'success'" class="box comment-box">
							<div class="comment-title">댓글 {{commentList.length}}개</div>

							<div class="comment-write">
								<textarea v-model="commentContents" placeholder="댓글을 입력하세요"></textarea>
								<div class="btn-wrap">
									<button type="button" class="like-btn" @click="fnAddComment()">댓글 등록</button>
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
									<textarea v-model="comment.editContents" class="comment-edit-textarea"></textarea>
									<div class="btn-row" style="margin-top:10px;">
										<button type="button" class="like-btn"
											@click="fnUpdateComment(comment)">저장</button>
										<button type="button" class="report-btn"
											@click="fnCancelEditComment(comment)">취소</button>
									</div>
								</div>

								<div v-else>
									<div class="comment-content">{{comment.C_CONTENT}}</div>

									<div class="btn-row comment-btn-row">
										<button type="button" class="report-btn"
											@click="fnShowReply(comment.COMMENT_NO)">답글</button>
										<button type="button" class="report-btn"
											@click="fnOpenCommentReportModal(comment.COMMENT_NO)">신고</button>

										<button type="button" class="report-btn" v-if="fnCanManageComment(comment)"
											@click="fnEditComment(comment)">수정</button>

										<button type="button" class="report-btn" v-if="fnCanManageComment(comment)"
											@click="fnRemoveComment(comment.COMMENT_NO)">삭제</button>
									</div>

									<div v-if="replyTargetNo == comment.COMMENT_NO" class="reply-write-box">
										<textarea v-model="replyContents" class="reply-textarea"></textarea>

										<div class="btn-row reply-btn-row">
											<button type="button" class="like-btn"
												@click="fnAddReply(comment.COMMENT_NO)">등록</button>
											<button type="button" class="report-btn"
												@click="replyTargetNo = null">취소</button>
										</div>
									</div>
								</div>
							</div>
						</div>

						<div v-if="showReportModal" class="report-modal-wrap">
							<div class="report-modal">
								<h3>{{reportCommentNo == '' ? '게시글 신고' : '댓글 신고'}}</h3>
								<select v-model="reportReason">
									<option value="">신고 사유 선택</option>
									<option value="욕설/비방">욕설/비방</option>
									<option value="광고/도배">광고/도배</option>
									<option value="음란성">음란성</option>
									<option value="허위정보">허위정보</option>
									<option value="기타">기타</option>
								</select>

								<div class="btn-row">
									<button type="button" class="like-btn" @click="fnReportBoard()">접수</button>
									<button type="button" class="report-btn"
										@click="showReportModal = false">취소</button>
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
								currentUserId: '<%=session.getAttribute("sessionId") == null ? "" : session.getAttribute("sessionId")%>',
								currentUserRole: '<%=session.getAttribute("sessionRole") == null ? "" : session.getAttribute("sessionRole")%>',
								fileList: [],
								commentList: [],
								commentContents: "",
								likeCnt: 0,
								myLike: "N",
								resultType: "",
								showReportModal: false,
								reportReason: "",
								replyTargetNo: null,
								replyContents: "",
								reportCommentNo: ""
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
											console.log("board.USER_ID =", data.board.USER_ID);
											self.fileList = data.fileList || [];
											self.likeCnt = data.likeCnt || 0;
											self.myLike = data.myLike || "N";
											self.fnGetCommentList();
										} else if (data.result == "private") {
											self.board = null;
										} else {
											alert(data.message);
											pageChange("/board/list.do", {});
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
								console.log("댓글등록 클릭");

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
											pageChange("/user/login.do", {});
										} else {
											alert(data.message);
										}
									}
								});
							},
							fnMoveEdit() {
								pageChange("/board/edit.do", {
									boardNo: this.boardNo
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
											pageChange("/user/login.do", {});
										}
									}
								});
							},

							fnCanManageBoard() {
								if (this.currentUserRole == "A") {
									return true;
								}
								if (this.board != null && this.currentUserId != "" && String(this.board.USER_ID) == String(this.currentUserId)) {
									return true;
								}
								return false;
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
										commentNo: self.reportCommentNo == "" ? null : self.reportCommentNo,
										reportReason: self.reportReason
									},
									success: function (data) {
										if (data.result == "success") {
											alert(data.message);
											self.showReportModal = false;
											self.reportReason = "";
											self.reportCommentNo = "";
										} else if (data.result == "login") {
											alert("로그인이 필요합니다.");
											pageChange("/user/login.do", {});
										} else {
											alert(data.message);
										}
									}
								});
							},

							fnMoveMypage(userId) {
								pageChange("/user/mypage.do", {});
							},

							fnMoveList() {
								if (this.board != null && this.board.B_MAIN_TYPE == '통합') {
									pageChange("/board/list.do", { bMainNo: 1 });
								} else if (this.board != null && this.board.B_MAIN_TYPE == '지역') {
									pageChange("/board/list.do", { bMainNo: 2 });
								} else if (this.board != null && this.board.B_MAIN_TYPE == '전문가 Q&A') {
									pageChange("/board/list.do", { bMainNo: 3 });
								} else {
									pageChange("/board/list.do", {});
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
											pageChange("/user/login.do", {});
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
											pageChange("/user/login.do", {});
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
											pageChange("/user/login.do", {});
										} else {
											alert(data.message);
										}
									}
								});
							},

							fnOpenReportModal() {
								console.log("신고버튼 클릭");
								this.reportCommentNo = "";
								this.showReportModal = true;
							},

							fnOpenCommentReportModal(commentNo) {
								this.reportCommentNo = commentNo;
								this.showReportModal = true;
							}

						},
						mounted() {
							console.log("currentUserId =", this.currentUserId);
							console.log("currentUserRole =", this.currentUserRole);
							this.fnGetBoardDetail();
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