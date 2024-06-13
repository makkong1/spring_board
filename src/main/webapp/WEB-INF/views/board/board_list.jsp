<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>  
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>        
    
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Insert title here</title>
		
		<style>
			a{text-decoration:none;}
		</style>
		
		<script>
			window.onload=function(){
				let search = document.getElementById("search");
				let search_array = ['all', 'subject', 'name', 'content', 'name_subject_content'];
				
				for( let i = 0; i < search_array.length; i++ ){
					if( '${param.search}' == search_array[i] ){
						search[i].selected = true;
						
						let search_text = document.getElementById("search_text");
						search_text.value = '${param.search_text}';
						
					}
				}
				
			}
		
			function search(){
				//조회 카테고리
				let search = document.getElementById("search").value;
				
				//검색어
				let search_text = 
					document.getElementById("search_text").value;
				
				if( search != 'all' && search_text == '' ){
					alert("검색할 내용을 입력하세요");
					return;
				}
				
				location.href="list.do?search="+search+
						      "&search_text="+encodeURIComponent(search_text)+
						      "&page=1";
				
			}
		</script>
		
	</head>
	
	<body>
		<table border="1" width="700" align="center">
			<caption>::: 게시판 연습중 :::</caption>
			
			<tr>
				<td align="center" width="7%">번호</td>
				<td align="center">제목</td>
				<td align="center" width="20%">작성자</td>
				<td align="center" width="20%">작성일</td>
				<td align="center" width="10%">조회수</td>
			</tr>
			
			<c:forEach var="vo" items="${list}">
			
			<tr>
				<c:if test="${ vo.del_info ne -1 }">
					<td align="center">${vo.idx}</td>
				</c:if>
				
				<c:if test="${ vo.del_info eq -1 }">
					<td align="center">x</td>
				</c:if>
				
				<td>
					<c:forEach begin="1" end="${vo.depth}">&nbsp;</c:forEach>
					
					<!-- 댓글기호(ㄴ) 표시 -->
					<c:if test="${ vo.depth ne 0 }">ㄴ</c:if>
					
					<c:if test="${vo.del_info ne -1}">
						<a href="view.do?idx=${vo.idx}&page=${param.page}&search=${param.search}&search_text=${param.search_text}">
						${ vo.subject }
						</a>
					</c:if>
					
					<c:if test="${vo.del_info eq -1}">
						<font color="gray">삭제된 게시글 입니다</font>
					</c:if>
					
				</td>
				
				<c:if test="${ vo.del_info ne -1 }">
					<td align="center">${vo.name}</td>
				</c:if>
				
				<c:if test="${ vo.del_info eq -1 }">
					<td align="center">unknown</td>
				</c:if>
				
				<td align="center">
				${ fn:split( vo.regdate, ' ' )[0]}
				</td>
				
				<td align="center">${vo.readhit}</td>
				
			</tr>
			
			</c:forEach>
			
			<tr>
				<td colspan="5" align="center">
					
					<select id="search">
						<option value="all">전체보기</option>
						<option value="subject">제목</option>
						<option value="name">이름</option>
						<option value="content">내용</option>
						<option value="name_subject_content">이름+제목+내용</option>						
					</select>
									
					<input id="search_text">
					<input type="button" value="검색" onclick="search();">
				</td>
			</tr>
			
			<tr>
				<td colspan="5" align="center">
					${ pageMenu }
				</td>
			</tr>
			
			<tr>
				<td colspan="5" align="right">
					<img src="/bbs/resources/img/btn_reg.gif" style="cursor:pointer"
					     onclick="location.href='board_write.do'">
				</td>
			</tr>
			
		</table>
	</body>
</html>












