<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
	<!DOCTYPE html>
	<html lang="ko">

	<head>
		<meta charset="UTF-8">
		<title>UNIPET</title>

		<script src="https://code.jquery.com/jquery-3.7.1.js"></script>
		<script src="https://unpkg.com/vue@3/dist/vue.global.js"></script>
		<script src="/js/page-change.js"></script>

		<link rel="stylesheet" href="/css/board/board-view.css">
	</head>

	<body>

		<jsp:include page="/WEB-INF/header/header.jsp" />

		<% String msg=request.getParameter("msg"); if ("update".equals(msg)) { %>
			<script>
				alert("수정되었습니다.");
			</script>
			<% } %>

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
									<a v-if="currentUserId == board.userId" class="profile-link" href="javascript:;"
										@click="fnMoveMypage()">
										{{board.writerNickname ? board.writerNickname : board.userId}}
									</a>

									<span v-else class="profile-text">
										{{board.writerNickname ? board.writerNickname : board.userId}}
									</span>
								</div>

								<div>카테고리 : {{board.bMainType}} / {{board.bSubType}}</div>
								<div>지역 : {{board.localName == null ? '-' : board.localName}}</div>
								<div>조회수 : {{board.viewCount}}</div>
								<div>추천수 : {{likeCnt}}</div>
								<div>작성일 : {{board.createTime}}</div>
							</div>

							<div class="content" v-html="board.bContent"></div>

							<div class="file-list" v-if="fileList.length > 0">
								<div v-for="file in fileList" :key="file.fileNo">
									<img v-if="fnIsImage(file.fileExt)" :src="fnGetFileUrl(file)"
										@error="fnFileImageError($event)">

									<video v-else-if="fnIsVideo(file.fileExt)" :src="fnGetFileUrl(file)" controls>
									</video>

									<div v-else>
										<a :href="fnGetFileUrl(file)" download>{{file.originName}}</a>
									</div>
								</div>
							</div>

							<div class="btn-row">
								<button class="like-btn" @click="fnBoardLike()">
									{{myLike == 'Y' ? '추천취소' : '추천'}} ({{likeCnt}})
								</button>

								<button type="button" class="report-btn" v-if="fnCanReportBoard()"
									@click="fnOpenReportModal()">
									신고
								</button>

								<button type="button" class="report-btn" v-if="fnCanEditBoard()" @click="fnMoveEdit()">
									수정
								</button>

								<button type="button" class="report-btn" v-if="fnCanDeleteBoard()"
									@click="fnRemoveBoard()">
									삭제
								</button>

								<button class="list-btn" @click="fnMoveList()">목록</button>
							</div>
						</div>

						<div v-if="board != null && resultType == 'success'" class="box comment-box">
							<div class="comment-title">댓글 {{commentList.length}}개</div>

							<div class="comment-write">
								<div class="comment-textarea-wrap">
									<textarea v-model="commentContents" placeholder="댓글을 입력하세요"
										:maxlength="maxCommentLength"></textarea>

									<div class="comment-text-count"
										:class="{danger : commentContents.length >= maxCommentLength}">
										{{commentContents.length}} / {{maxCommentLength}}
									</div>
								</div>

								<div class="btn-wrap">
									<button type="button" class="like-btn" @click="fnAddComment()">댓글 등록</button>
								</div>
							</div>

							<div v-if="commentList.length == 0">등록된 댓글이 없습니다.</div>

							<div v-for="comment in commentList" :key="comment.commentNo"
								:class="fnGetCommentClass(comment)">

								<div class="comment-head">
									<div class="comment-left">
										<span v-if="comment.replyDepth > 0" class="reply-depth-badge">
											{{fnGetReplyDepthText(comment)}}
										</span>

										<span class="comment-user">
											{{comment.writerNickname ? comment.writerNickname : comment.userId}}
										</span>
									</div>

									<div>{{comment.createTime}}</div>
								</div>

								<div v-if="comment.editMode">
									<div class="comment-textarea-wrap">
										<textarea v-model="comment.editContents" class="comment-edit-textarea"
											:maxlength="maxCommentLength"></textarea>

										<div class="comment-text-count"
											:class="{danger : comment.editContents.length >= maxCommentLength}">
											{{comment.editContents.length}} / {{maxCommentLength}}
										</div>
									</div>

									<div class="btn-row comment-edit-btn-row">
										<button type="button" class="like-btn"
											@click="fnUpdateComment(comment)">저장</button>
										<button type="button" class="report-btn"
											@click="fnCancelEditComment(comment)">취소</button>
									</div>
								</div>

								<div v-else>
									<div class="comment-content">{{comment.cContent}}</div>

									<div class="btn-row comment-btn-row">
										<button type="button" class="report-btn"
											@click="fnShowReply(comment.commentNo)">
											답글
										</button>

										<button type="button" class="report-btn" v-if="fnCanReportComment(comment)"
											@click="fnOpenCommentReportModal(comment.commentNo)">
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
										<div class="comment-textarea-wrap">
											<textarea v-model="replyContents" class="reply-textarea"
												:maxlength="maxCommentLength" placeholder="답글을 입력하세요"></textarea>

											<div class="comment-text-count"
												:class="{danger : replyContents.length >= maxCommentLength}">
												{{replyContents.length}} / {{maxCommentLength}}
											</div>
										</div>

										<div class="btn-row reply-btn-row">
											<button type="button" class="like-btn"
												@click="fnAddReply(comment.commentNo)">
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

						<div v-if="board != null && resultType == 'success'" class="board-move-box">
							<div class="board-move-row" :class="{empty : prevBoardNo == ''}" @click="fnMovePrevBoard()">

								<div class="board-move-label">이전글</div>

								<div class="board-move-title">
									{{prevBoardNo == '' ? '이전글이 없습니다.' : (prevBoardTitle == '' ? '이전글로 이동' :
									prevBoardTitle)}}
								</div>
							</div>

							<div class="board-move-row" :class="{empty : nextBoardNo == ''}" @click="fnMoveNextBoard()">

								<div class="board-move-label">다음글</div>

								<div class="board-move-title">
									{{nextBoardNo == '' ? '다음글이 없습니다.' : (nextBoardTitle == '' ? '다음글로 이동' :
									nextBoardTitle)}}
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
								adminId: '<%=session.getAttribute("adminId") == null ? "" : session.getAttribute("adminId")%>',
								adminName: '<%=session.getAttribute("adminName") == null ? "" : session.getAttribute("adminName")%>',
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
								reportCommentNo: "",
								maxCommentLength: 500,
								prevBoardNo: "",
								prevBoardTitle: "",
								nextBoardNo: "",
								nextBoardTitle: ""
							};
						},
						methods: {
							fnIsAdmin: function () {
								if (this.adminId != "") {
									return true;
								}

								if (this.currentUserRole == "A") {
									return true;
								}

								if (this.currentUserRole == "ADMIN") {
									return true;
								}

								if (this.currentUserId == "admin") {
									return true;
								}

								return false;
							},

							fnGetBoardDetail: function () {
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

											self.prevBoardNo = data.prevBoardNo || data.prevNo || "";
											self.prevBoardTitle = data.prevBoardTitle || data.prevTitle || "";

											if (data.prevBoard != null) {
												self.prevBoardNo = data.prevBoard.boardNo || self.prevBoardNo;
												self.prevBoardTitle = data.prevBoard.title || self.prevBoardTitle;
											}

											self.nextBoardNo = data.nextBoardNo || data.nextNo || "";
											self.nextBoardTitle = data.nextBoardTitle || data.nextTitle || "";

											if (data.nextBoard != null) {
												self.nextBoardNo = data.nextBoard.boardNo || self.nextBoardNo;
												self.nextBoardTitle = data.nextBoard.title || self.nextBoardTitle;
											}

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

							fnGetCommentList: function () {
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
											self.fnSetCommentDepth();
										}
									}
								});
							},

							fnSetCommentDepth: function () {
								let self = this;
								let commentMap = {};

								for (let i = 0; i < self.commentList.length; i++) {
									self.commentList[i].editMode = false;
									self.commentList[i].editContents = self.commentList[i].cContent;
									self.commentList[i].replyDepth = 0;

									commentMap[String(self.commentList[i].commentNo)] = self.commentList[i];
								}

								for (let i = 0; i < self.commentList.length; i++) {
									self.commentList[i].replyDepth = self.fnFindCommentDepth(self.commentList[i], commentMap);
								}
							},

							fnFindCommentDepth: function (comment, commentMap) {
								let depth = 0;
								let parentNo = comment.parentNo;
								let loopCount = 0;

								while (parentNo != null && parentNo != "" && loopCount < 5) {
									depth++;

									let parentComment = commentMap[String(parentNo)];

									if (parentComment == null) {
										break;
									}

									parentNo = parentComment.parentNo;
									loopCount++;
								}

								if (depth > 3) {
									depth = 3;
								}

								return depth;
							},

							fnGetCommentClass: function (comment) {
								let className = "comment-item";

								if (comment.replyDepth > 0) {
									className += " reply reply-depth-" + comment.replyDepth;
								}

								return className;
							},

							fnGetReplyDepthText: function (comment) {
								if (comment.replyDepth == 1) {
									return "답글";
								}

								return "대댓글";
							},

							fnAddComment: function () {
								let self = this;

								if (self.commentContents == "") {
									alert("댓글 내용을 입력해주세요.");
									return;
								}

								if (self.commentContents.length > self.maxCommentLength) {
									alert("댓글은 " + self.maxCommentLength + "자까지 입력할 수 있습니다.");
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
											alert("로그인이 필요한 서비스입니다.");
											location.href = "/user/login.do";

										} else {
											alert(data.message);
										}
									}
								});
							},

							fnMoveEdit: function () {
								pageChange("/board/edit.do", {
									boardNo: this.boardNo
								});
							},

							fnRemoveBoard: function () {
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
											pageChange("/user/login.do", {});

										} else {
											alert(data.message);
										}
									}
								});
							},

							fnBoardLike: function () {
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
											alert("로그인이 필요한 서비스입니다.");
											pageChange("/user/login.do", {});
										}
									}
								});
							},

							fnCanEditBoard: function () {
								if (this.board != null && this.currentUserId != "" && String(this.board.userId) == String(this.currentUserId)) {
									return true;
								}

								return false;
							},

							fnCanDeleteBoard: function () {
								if (this.fnIsAdmin()) {
									return true;
								}

								if (this.board != null && this.currentUserId != "" && String(this.board.userId) == String(this.currentUserId)) {
									return true;
								}

								return false;
							},

							fnCanReportBoard: function () {
								if (this.board == null) {
									return false;
								}

								if (this.fnIsAdmin()) {
									return false;
								}

								if (this.currentUserId != "" && String(this.board.userId) == String(this.currentUserId)) {
									return false;
								}

								return true;
							},

							fnCanReportComment: function (comment) {
								if (comment == null) {
									return false;
								}

								if (this.fnIsAdmin()) {
									return false;
								}

								if (this.currentUserId != "" && String(comment.userId) == String(this.currentUserId)) {
									return false;
								}

								return true;
							},

							fnReportBoard: function () {
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
											alert("로그인이 필요한 서비스입니다.");
											pageChange("/user/login.do", {});

										} else {
											alert(data.message);
										}
									}
								});
							},

							fnMoveMypage: function () {
								location.href = "/user/mypage.do";
							},

							fnMoveList: function () {
								if (this.board != null && this.board.bMainType == '통합') {
									pageChange("/board/list.do", {
										bMainNo: 1
									});

								} else if (this.board != null && this.board.bMainType == '지역') {
									pageChange("/board/list.do", {
										bMainNo: 2
									});

								} else if (this.board != null && this.board.bMainType == '전문가 Q&A') {
									pageChange("/board/list.do", {
										bMainNo: 3
									});

								} else {
									pageChange("/board/list.do", {});
								}
							},

							fnMovePrevBoard: function () {
								if (this.prevBoardNo == "") {
									return;
								}

								pageChange("/board/view.do", {
									boardNo: this.prevBoardNo
								});
							},

							fnMoveNextBoard: function () {
								if (this.nextBoardNo == "") {
									return;
								}

								pageChange("/board/view.do", {
									boardNo: this.nextBoardNo
								});
							},

							fnGetFileUrl: function (file) {
								if (file == null) {
									return "/img/board/unipet_logo.png";
								}

								let url = "";

								if (file.fileUrl != null && file.fileUrl != "") {
									url = file.fileUrl;
								} else if (file.img != null && file.img != "") {
									url = file.img;
								} else if (file.saveName != null && file.saveName != "") {
									url = file.saveName;
								} else if (file.fileName != null && file.fileName != "") {
									url = file.fileName;
								} else if (file.originName != null && file.originName != "") {
									url = file.originName;
								}

								if (url == "") {
									return "/img/board/unipet_logo.png";
								}

								if (url.startsWith("http://") || url.startsWith("https://") || url.startsWith("/")) {
									return url;
								}

								return "/upload/board/" + url;
							},

							fnFileImageError: function (event) {
								if (event == null || event.target == null) {
									return;
								}

								event.target.onerror = null;
								event.target.src = "/img/board/unipet_logo.png";
							},

							fnIsImage: function (ext) {
								if (!ext) {
									return false;
								}

								ext = ext.toLowerCase().replace(".", "");

								return ext == 'jpg' || ext == 'jpeg' || ext == 'png' || ext == 'gif' || ext == 'webp';
							},

							fnIsVideo: function (ext) {
								if (!ext) {
									return false;
								}

								ext = ext.toLowerCase().replace(".", "");

								return ext == 'mp4' || ext == 'webm' || ext == 'ogg';
							},

							fnCanManageComment: function (comment) {
								if (this.fnIsAdmin()) {
									return true;
								}

								if (this.currentUserId != "" && this.currentUserId == comment.userId) {
									return true;
								}

								return false;
							},

							fnEditComment: function (comment) {
								comment.editMode = true;
								comment.editContents = comment.cContent;
							},

							fnCancelEditComment: function (comment) {
								comment.editMode = false;
								comment.editContents = comment.cContent;
							},

							fnUpdateComment: function (comment) {
								let self = this;

								if (comment.editContents == "") {
									alert("댓글 내용을 입력해주세요.");
									return;
								}

								if (comment.editContents.length > self.maxCommentLength) {
									alert("댓글은 " + self.maxCommentLength + "자까지 입력할 수 있습니다.");
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
											alert("로그인이 필요한 서비스입니다.");
											pageChange("/user/login.do", {});

										} else {
											alert(data.message);
										}
									}
								});
							},

							fnRemoveComment: function (commentNo) {
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
											alert("로그인이 필요한 서비스입니다.");
											pageChange("/user/login.do", {});

										} else {
											alert(data.message);
										}
									}
								});
							},

							fnShowReply: function (commentNo) {
								if (this.replyTargetNo == commentNo) {
									this.replyTargetNo = null;
									this.replyContents = "";

								} else {
									this.replyTargetNo = commentNo;
									this.replyContents = "";
								}
							},

							fnAddReply: function (parentNo) {
								let self = this;

								if (self.replyContents == "") {
									alert("답글 내용을 입력해주세요.");
									return;
								}

								if (self.replyContents.length > self.maxCommentLength) {
									alert("답글은 " + self.maxCommentLength + "자까지 입력할 수 있습니다.");
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
											alert("로그인이 필요한 서비스입니다.");
											pageChange("/user/login.do", {});

										} else {
											alert(data.message);
										}
									}
								});
							},

							fnOpenReportModal: function () {
								this.reportCommentNo = "";
								this.showReportModal = true;
							},

							fnOpenCommentReportModal: function (commentNo) {
								this.reportCommentNo = commentNo;
								this.showReportModal = true;
							}
						},
						mounted() {
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