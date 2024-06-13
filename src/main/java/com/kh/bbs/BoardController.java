package com.kh.bbs;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import dao.BoardDAO;
import dao.CommentDAO;
import util.Common;
import util.Paging;
import vo.BoardVO;
import vo.CommentVO;

@Controller
public class BoardController {

	@Autowired
	HttpServletRequest request;

	@Autowired
	HttpSession session;

	BoardDAO board_dao;
	CommentDAO comment_dao;

	public BoardController(BoardDAO board_dao, CommentDAO comment_dao) {
		this.board_dao = board_dao;
		this.comment_dao = comment_dao;
	}

	@RequestMapping(value={"/", "/list.do"})
	public String list( Model model, String page, String search, String search_text ) {
		int nowPage = 1;
		if( page != null && !page.isEmpty() ) {
			nowPage = Integer.parseInt(page);
		}		

		//한 페이지에 표시되는 게시물의 시작과 끝 번호를 계산
		//?page=2
		int start = (nowPage - 1) * Common.Board.BLOCKLIST + 1;
		int end = start + Common.Board.BLOCKLIST - 1;

		//start, end변수를 Map에 저장
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("start", start);
		map.put("end", end);	

		//검색어 관련 파라미터
		//list.do?search=name&search_text=abc&page=2

		//검색할 내용이 있는 경우
		if(search != null && !search.equals("all")) {

			if( search.equals("name_subject_content") ) {
				map.put("name", search_text);
				map.put("subject", search_text);
				map.put("content", search_text);
			}else if( search.equals("name") ) {
				map.put("name", search_text);
			}else if( search.equals("subject") ){
				map.put("subject", search_text);
			}else if( search.equals("content")) {
				map.put("content", search_text);
			}

		}		

		//전체목록 가져오기
		List<BoardVO> list = board_dao.selectList(map);

		//전체 게시글 수 가져오기
		int row_total = board_dao.getRowTotal(map);

		//페이지 메뉴 생성
		String search_param = 
				String.format("search=%s&search_text=%s", search, search_text);

		String pageMenu = Paging.getPaging(
				"list.do", nowPage, row_total, 
				search_param,
				Common.Board.BLOCKLIST, 
				Common.Board.BLOCKPAGE);

		//list객체 바인딩 및 포워딩
		model.addAttribute("list", list);
		model.addAttribute("pageMenu", pageMenu);

		//조회수 증가를 위해 기록돼있던 show정보를 삭제
		session.removeAttribute("show");

		return Common.Board.VIEW_PATH + "board_list.jsp";

	}

	//게시글 상세보기
	@RequestMapping("/view.do")
	public String view(Model model, int idx) {

		//view.do?idx=21
		//상세보기를 위한 게시글 조회
		BoardVO vo = board_dao.selectOne(idx);

		//조회수 무한증가 방지를 위한 세션
		String show = (String)session.getAttribute("show");

		if(show == null) {
			//조회수 증가
			board_dao.update_readhit(idx);
			session.setAttribute("show", "");
		}


		//바인딩
		model.addAttribute("vo", vo);

		return Common.Board.VIEW_PATH + "board_view.jsp";

	}

	//새글작성 폼
	@RequestMapping("/board_write.do")
	public String insert_form() {
		return Common.Board.VIEW_PATH + "board_write.jsp";
	}

	//새 글 등록
	@RequestMapping("/insert.do")
	public String insert(BoardVO vo) {

		String ip = request.getRemoteAddr();
		vo.setIp(ip);

		//새글 등록
		board_dao.insert(vo);
		//response.sendRedirect("list.do");
		return "redirect:list.do";		
	}

	//글 삭제
	@RequestMapping("/del.do")
	@ResponseBody
	public String delete(int idx) {

		//삭제(된 것 처럼 업데이트)를 위한 idx수신
		int res = board_dao.del_update(idx);

		String resultStr = "";
		String result = "no";

		if( res == 1 ) {
			result = "yes";
		}

		resultStr = String.format("[{'result':'%s'}]", result);
		//response.getWriter().print(resultStr);

		return resultStr;
	}

	//댓글 작성화면으로 이동
	@RequestMapping("/reply_form.do")
	public String replyForm(int idx, String page) {
		return Common.Board.VIEW_PATH + "board_reply.jsp?idx="+idx+"&page="+page;
	}

	//댓글작성
	@RequestMapping("/reply.do")
	public String reply(String page, BoardVO vo) {

		String ip = request.getRemoteAddr();

		//댓글을 작성하고 싶은 게시글의 idx에 해당되는 상세정보를 얻기
		BoardVO baseVO = board_dao.selectOne(vo.getIdx());

		//가져온 baseVO의 step보다 큰 값을 가진 데이터들의
		//step을 +1처리
		board_dao.update_step(baseVO);

		//댓글vo
		vo.setIp(ip);
		//댓글이 들어갈 위치 설정
		vo.setRef( baseVO.getRef() );
		vo.setStep( baseVO.getStep()+1 );
		vo.setDepth( baseVO.getDepth()+1 );

		board_dao.reply(vo);
		//response.sendRedirect("list.do?page="+page);
		return "redirect:list.do?page="+page;

	}

	//코멘트 추가
	@RequestMapping("/comment_insert.do")
	@ResponseBody
	public String comment_insert( CommentVO vo ) {
		int res = comment_dao.insert(vo);

		String result = "no";
		if( res > 0 ) {
			result = "yes";
		}

		String resultStr = String.format("[{'result':'%s'}]", result);

		return resultStr;
	}

	//코멘트 갱신
	@RequestMapping("/comment_list.do")
	//@ResponseBody
	public String comment_list( Model model, String page, int idx) {

		int nowPage = 1;

		if( page != null && !page.isEmpty() ) {
			nowPage = Integer.parseInt(page);
		}

		int start = (nowPage - 1) * Common.Comment.BLOCKLIST + 1;
		int end = start + Common.Comment.BLOCKLIST - 1;


		//메인 게시글 번호
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("idx", idx);
		map.put("start", start);
		map.put("end", end);

		List<CommentVO> list = comment_dao.selectList(map);
		int row_total = comment_dao.getRowTotal(map);

		//페이지 메뉴
		String pageMenu = 
				Paging.getPaging("comment_list.do", 
						nowPage, 
						row_total, 
						Common.Comment.BLOCKLIST, 
						Common.Comment.BLOCKPAGE);


		model.addAttribute("list", list);
		model.addAttribute("pageMenu", pageMenu);

		return Common.Comment.VIEW_PATH + "comment_list.jsp";

	}

	//코멘트 삭제
	@RequestMapping("/comment_del.do")
	@ResponseBody
	public String comment_del( int c_idx ) {
		int res = comment_dao.comm_del(c_idx);

		String result = "no";
		if( res > 0 ) {
			result = "yes";
		}

		String resultStr = String.format("[{'result':'%s'}]", result);
		
		return resultStr;
	}

}












