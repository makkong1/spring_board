package dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import vo.CommentVO;

public class CommentDAO {
	
	SqlSession sqlSession;
	
	public CommentDAO(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	
	//코멘트 등록
	public int insert(CommentVO vo) {
		int res = sqlSession.insert("c.comment_insert", vo);
		return res;
	}
	
	//코멘트 조회
	public List<CommentVO> selectList(Map<String, Object> map){
		List<CommentVO> list = sqlSession.selectList("c.comment_list", map);
		return list;
	}
	
	//페이징을 위한 전체 게시글 갯수
	public int getRowTotal(Map<String, Object> map) {
		int cnt = sqlSession.selectOne("c.comment_idx_count", map);
		return cnt;
	}
	
	//코멘트 삭제
	public int comm_del(int c_idx) {
		int res = sqlSession.delete("c.comment_delete", c_idx);
		return res;
	}
}















