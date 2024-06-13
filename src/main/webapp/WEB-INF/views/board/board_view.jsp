<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    

<%
			String ip = request.getRemoteAddr();
			
			for( int i = 0; i < 120; i++){
			if(ip.equals("192.168.0."+i)){%>
				
				<script>
					alert("오지마");
					location.href="list.do";
				</script>
				
			<%return; } }%> 
    
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		
		<!-- Ajax사용을 위한 js파일 -->
		<script src="/bbs/resources/js/httpRequest.js"></script>
		
		<script>
			//현재 보고있는 댓글의 페이지 번호를 저장할 변수
			let comm_page = 1;
		
			//페이지가 실행되면 존재하는 comment를 보여준다
			window.onload = function(){
				comment_list(1);
			}
			
			//댓글삭제를 위한 메서드
			function del_comment(f){
				let c_pwd = f.c_pwd.value;//입력받은 비번
				let pwd = f.pwd.value;//원본 비번
				let c_idx = f.c_idx.value;//삭제할 코멘트 번호
				
				if( c_pwd == '' ){
					alert("비밀번호는 필수입니다");
					return;
				}
				
				if( c_pwd != pwd ){
					alert("비밀번호 불일치");
					return;
				}
				
				if( !confirm("정말 삭제하시겠습니까?")){
					return;
				}
				
				//삭제를 위해 Ajax요청
				let url = "comment_del.do";
				let param = "c_idx=" + c_idx;
				sendRequest(url, param, comm_delFn, "post");
			}
			
			function comm_delFn(){
				if( xhr.readyState == 4 && xhr.status == 200 ){
					let data = xhr.responseText;
					
					let json = (new Function('return '+data))();
					
					if( json[0].result == 'yes' ){
						comment_list(comm_page);
					}else{
						alert("삭제실패");
					}
					
				}
			}
		
			function del(){
				let c_pwd = document.getElementById("c_pwd").value;
				
				if( !confirm("삭제 하시겠습니까?") ){
					return;
				}

				if( c_pwd != '${vo.pwd}' ){
					alert("비밀번호 불일치");
					return;
				}
				
				let url = "del.do";
				let param = "idx=${vo.idx}";
				sendRequest(url, param, resultFn, "POST");
				
			}//del()
			
			function resultFn(){
				if( xhr.readyState == 4 && xhr.status == 200 ){
					
					//"[{'result':'yes'}]"
					let data = xhr.responseText;
					let json = (new Function('return '+data))();
					
					if( json[0].result == 'yes' ){
						alert("삭제성공");
						location.href="list.do?page=${param.page}";
					}else{
						alert("삭제실패");
					}
				}
			}
			
		
			function reply(){
				location.href="reply_form.do?idx=${vo.idx}&page=${param.page}";
			}
			
			/* comment등록 메서드 */
			function send(f){
				//유효성 체크 했습니다
				
				let url = "comment_insert.do";
				let param = "idx=${vo.idx}&name="+f.name.value+
				            "&content="+f.content.value +
				            "&pwd="+f.pwd.value;
				
				sendRequest(url, param, commFn, "post");
				
				//form태그에 포함되어 있는 모든 입력상자의 값을 초기화
				f.reset();
			}
			
			function commFn(){
				if( xhr.readyState == 4 && xhr.status == 200 ){
					
					let data = xhr.responseText;
					let json = (new Function('return ' + data))();
					
					if(json[0].result == 'yes'){
						comment_list(comm_page);
					}else{
						alert("등록실패");
					}
					
				}
			}
			
			/* 코멘트 작성 완료 후, 해당 게시글에 대한 코멘트만 추려내서 가져온 결과 */
			function comm_list_fn(){
				if( xhr.readyState == 4 && xhr.status == 200 ){
					
					let data = xhr.responseText;
					document.getElementById("comment_disp").innerHTML = data;
				}
			}
			
			function comment_list(comm_page){
				
				let url = "comment_list.do";
				let param = "idx=${vo.idx}&page="+comm_page;
				sendRequest(url, param, comm_list_fn, "post");
			}
			
		</script>
		
	</head>
	
	<body>
	
		<form name="f" method="post">
			<table border="1" width="700" align="center">
				<caption>상세보기</caption>
				
				<tr>
					<td>제목</td>
					<td>${ vo.subject }</td>
				</tr>
				
				<tr>
					<td>작성자</td>
					<td>${ vo.name }</td>
				</tr>
				
				<tr>
					<td>작성일</td>
					<td>${ vo.regdate }</td>
				</tr>
				
				<tr>
					<td>ip</td>
					<td>${ vo.ip }</td>
				</tr>
				
				<tr>
					<td>내용</td>
					<td><pre>${ vo.content }</pre></td>
				</tr>
				
				<tr>
					<td>비밀번호</td>
					<td>
						<input type="password" id="c_pwd">
					</td>
				</tr>
				
				<tr>
					<td colspan="2">
						<!-- 목록으로 -->
						<input type="button" value="목록으로" 
						       onclick="location.href='list.do?page=${param.page}&search=${param.search}&search_text=${param.search_text}'">
						
						<c:if test="${ vo.depth lt 1 }">       
							<!-- 댓글 -->
							<img src="/bbs/resources/img/btn_reply.gif" onclick="reply();"
							     style="cursor:pointer;"> 
						</c:if>      
						       
						<!-- 수정 -->
						<img src="/bbs/resources/img/btn_modify.gif" onclick="modify();"
						     style="cursor:pointer;">   
						     
						<!-- 삭제 -->
						<img src="/bbs/resources/img/btn_delete.gif" onclick="del();"
						     style="cursor:pointer;">             
						       
					</td>
				</tr>
				
			</table>
		
		</form>
		
		<!-- comment영역 -->
		
		<hr width="700" align="center">
		
		<div>
		<form>
			<table border="1" align="center" width="700">
				<tr>
					<th>작성자</th>
					<td><input name="name"></td>
				</tr>
				
				<tr>
					<th>내용</th>
					<td>
					<textarea rows="5" cols="80" 
					          style="resize:none"
					          name="content"></textarea>
					</td>
				</tr>
				
				<tr>
					<th>비밀번호</th>
					<td>
						<input type="password" name="pwd">
						<input type="button" value="등록"
						       onclick="send(this.form);">
					</td>
				</tr>
				
			</table>
		</form>
		</div>
		
		<div id="comment_disp">
		
		</div>
		
	</body>
</html>











