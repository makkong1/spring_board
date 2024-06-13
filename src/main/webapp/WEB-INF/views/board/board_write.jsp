<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		
		<script>
			function send(f){
				//유효성 체크 했다치고
				
				f.submit();
			}
		</script>
		
	</head>
	
	<body>
		<form name="f" method="post" action="insert.do">
		
		<table border="1" width="700" align="center">
			<caption>::: 새 글 작성 :::</caption>
		
			<tr>
				<th style="width:300px">제목</th>
				<td><input name="subject" size="50"></td>
			</tr>
			
			<tr>
				<th>작성자</th>
				<td><input name="name" size="50"></td>
			</tr>
			
			<tr>
				<th>내용</th>
				<td>
				<textarea rows="10" cols="80" 
				          style="resize:none"
				          name="content"></textarea>
				</td>
			</tr>
			
			<tr>
				<th>비밀번호</th>
				<td>
				<input type="password" name="pwd">
				</td>
			</tr>
			
			<tr>
				<td colspan="2" align="center">
					<input type="button" value="등록" onclick="send(this.form);">    
					<input type="button" value="취소" onclick="history.go(-1);">
				</td>
			</tr>
		</table>
		
		</form>
	</body>
</html>










