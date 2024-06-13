<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>    
    
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	
	<style>
		div{width:700px;
		    margin:0 auto;}
	</style>
	
	</head>
	
	<body>
		<c:forEach var="vo" items="${ list }">
			<form>
				<input type="hidden" name="c_idx" value="${ vo.c_idx }">
				<input type="hidden" name="pwd" value="${vo.pwd}">
		
				<hr width="700">
				<div>
				${ vo.content }<br>
				작성자( ${ vo.name } )/${ vo.regdate } <br>
				<input type="password" name="c_pwd" placeholder="input password">
				<input type="button" value="삭제" onclick="del_comment(this.form);">
				</div>
			
			</form>
		</c:forEach>
		
		<div align="center">${ pageMenu }</div>

	</body>
</html>









