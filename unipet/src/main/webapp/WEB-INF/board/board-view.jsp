<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">

<head>
	<meta charset="UTF-8">
	<title>게시글 상세</title>
	<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
	<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
	<script src="/js/page-change.js"></script>

	<!-- <link rel="stylesheet" href="/css/board/board-view.css"> -->
	<link rel="stylesheet" href="/css/board/board-view2.css">
</head>

<body>

	<jsp:include page="/WEB-INF/header/header.jsp" />

	<%
		String msg = request.getParameter("msg");
		if ("update".equals(msg)) {
	%>
		<script>
			alert("수정되었습니다.");
		</script>
	<%
		}
	%>

	<div id="app">
		<div class="wrap">

			<div v-if="resultType == 'private'" class="private-box">
				비공개 게시글입니다.
				<div class="private-btn-wrap">
					<button class="list-btn" @click="fnMoveList()">목록으로</button>
				</div>
			</div>

			<div v-else-if="board != null" class="box">
				<div class="title">{{board.title}}</div>

				<div class="meta">
					<div>
						작성자 :
						<span class="profile-link" @click="fnMoveMypage(board.userId)">
							{{board.userId}}
						</span>
					</div>
					<div>카테고리 : {{board.bMainType}} / {{board.bSubType}}</div>
					<div>지역 : {{board.localName == null ? '-' : board.localName}}</div>
					<div>조회수 : {{board.viewCount}}</div>
					<div>추천수 : {{likeCnt}}</div>
					<div>작성일 : {{board.createTime}}</div>
				</div>

				<div class="content">{{board.bContent}}</div>

				<div class="file-list" v-if="fileList.length > 0">
					<div v-for="file in fileList" :key="file.fileNo">
						<img v-if="fnIsImage(file.fileExt)" :src="file.fileUrl">
						<video v-else-if="fnIsVideo(file.fileExt)" :src="file.fileUrl" controls></video>
						<div v-else>
							<a :href="file.fileUrl" download>{{file.originName}}</a>
						</div>
					</div>
				</div>

				<div class="btn-row">
					<button class="like-btn" @click="fnBoardLike()">
						{{myLike == 'Y' ? '추천취소' : '추천'}} ({{likeCnt}})
					</button>

					<button type="button" class="report-btn" @click="fnOpenReportModal()">신고</button>

					<button type="button" class="report-btn" v-if="fnCanManageBoard()" @click="fnMoveEdit()">
						수정
					</button>

					<button type="button" class="report-btn" v-if="fnCanManageBoard()" @click="fnRemoveBoard()">
						삭제
					</button>

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

				<div v-for="comment in commentList" :key="comment.commentNo"
					:class="comment.parentNo == null ? 'comment-item' : 'comment-item reply'">

					<div class="comment-head">
						<div class="comment-user">{{comment.userId}}</div>
						<div>{{comment.createTime}}</div>
					</div>

					<div v-if="comment.editMode">
						<textarea v-model="comment.editContents" class="comment-edit-textarea"></textarea>
						<div class="btn-row" style="margin-top:10px;">
							<button type="button" class="like-btn" @click="fnUpdateComment(comment)">저장</button>
							<button type="button" class="report-btn" @click="fnCancelEditComment(comment)">취소</button>
						</div>
					</div>

					<div v-else>
						<div class="comment-content">{{comment.cContent}}</div>

						<div class="btn-row comment-btn-row">
							<button type="button" class="report-btn" @click="fnShowReply(comment.commentNo)">
								답글
							</button>

							<button type="button" class="report-btn" @click="fnOpenCommentReportModal(comment.commentNo)">
								신고
							</button>

							<button type="button" class="report-btn" v-if="fnCanManageComment(comment)"
								@click="fnEditComment(comment)">
								수정
							</button>

							<button type="button" class="report-btn" v-if="fnCanManageComment(comment)"
								@click="fnRemoveComment(comment.commentNo)">
								삭제
							</button>
						</div>

						<div v-if="replyTargetNo == comment.commentNo" class="reply-write-box">
							<textarea v-model="replyContents" class="reply-textarea"></textarea>

							<div class="btn-row reply-btn-row">
								<button type="button" class="like-btn" @click="fnAddReply(comment.commentNo)">
									등록
								</button>
								<button type="button" class="report-btn" @click="replyTargetNo = null">
									취소
								</button>
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
						<button type="button" class="report-btn" @click="showReportModal = false">취소</button>
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
								console.log("board.userId =", data.board.userId);

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
									self.commentList[i].editContents = self.commentList[i].cContent;
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

					if (this.board != null && this.currentUserId != "" && String(this.board.userId) == String(this.currentUserId)) {
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
					if (this.board != null && this.board.bMainType == '통합') {
						pageChange("/board/list.do", { bMainNo: 1 });

					} else if (this.board != null && this.board.bMainType == '지역') {
						pageChange("/board/list.do", { bMainNo: 2 });

					} else if (this.board != null && this.board.bMainType == '전문가 Q&A') {
						pageChange("/board/list.do", { bMainNo: 3 });

					} else {
						pageChange("/board/list.do", {});
					}
				},

				fnIsImage(ext) {
					if (!ext) {
						return false;
					}

					ext = ext.toLowerCase();

					return ext == 'jpg' || ext == 'jpeg' || ext == 'png' || ext == 'gif' || ext == 'webp';
				},

				fnIsVideo(ext) {
					if (!ext) {
						return false;
					}

					ext = ext.toLowerCase();

					return ext == 'mp4' || ext == 'webm' || ext == 'ogg';
				},

				fnCanManageComment(comment) {
					if (this.currentUserRole == "A") {
						return true;
					}

					if (this.currentUserId != "" && this.currentUserId == comment.userId) {
						return true;
					}

					return false;
				},

				fnEditComment(comment) {
					comment.editMode = true;
					comment.editContents = comment.cContent;
				},

				fnCancelEditComment(comment) {
					comment.editMode = false;
					comment.editContents = comment.cContent;
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
							commentNo: comment.commentNo,
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

	<jsp:include page="/WEB-INF/footer/footer.jsp" />
</body>

</html>