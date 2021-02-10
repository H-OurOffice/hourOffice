package kr.or.houroffice.board.controller;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

import kr.or.houroffice.board.model.service.PartBoardService;
import kr.or.houroffice.board.model.vo.BoardFile;
import kr.or.houroffice.board.model.vo.PartBoard;
import kr.or.houroffice.board.model.vo.PartComments;
import kr.or.houroffice.common.Page;
import kr.or.houroffice.member.model.service.AdminMemberService;
import kr.or.houroffice.member.model.vo.Department;
import kr.or.houroffice.member.model.vo.Member;

@Controller
public class PartBoardController {
	
	@Autowired
	ServletContext context;
	
	@Resource(name="adminMemberService")
	private AdminMemberService mService;
	
	@Resource(name="partBService")
	private PartBoardService bService;
	
	private Page page;
	
	// 부서별 게시판 all select
	@RequestMapping(value="/allPartBoardPage.ho")
	public String allPartBoardPage(Model model, HttpServletRequest request, @SessionAttribute("member") Member m){
		if(m!=null){
			if(m.getDeptCode()!=null){
				
				Page page = createPage(request,10,10); // (request , 한 페이지당 게시물수 , 한 페이지당 보여줄 네비 수)
				
				HashMap<String, Object> map = new HashMap<String, Object>();
				map.put("deptCode", m.getDeptCode());
				map.put("page", page);
				// 리스트
				List<Object> list = bService.selectBoardList(map);
				// 페이지네비
				Page pageNavi = bService.getPageNavi(map);
				
				model.addAttribute("list",list);
				model.addAttribute("pageNavi",pageNavi);
			}else{ // 부서가 없는 사람
				model.addAttribute("msg","부서별 게시판입니다.\n부서가 없는 사람은 접근할 수 없습니다.");
				model.addAttribute("location","login.jsp");
			}
			
		}else{ // 로그인 안 한 사람
			return "redirect:login.jsp";
		}
		return "part_board/allPartBoardPage";
	}
	// 부서별 게시판 all select - 검색 select
	@RequestMapping(value="/searchPartBoard.ho")
	public String searchBoard(@RequestParam("searchType") String searchType, @RequestParam("keyword") String keyword, 
							@RequestParam("deptCode") String pageDeptCode, Model model, HttpServletRequest request, HttpServletResponse response, @SessionAttribute("member") Member m)
	{
		response.setHeader("Content-Type", "text/html;charset=utf-8");
		if(m!=null && pageDeptCode.equals(m.getDeptCode())){
			Page page = createPage(request,10,10); // (request , 한 페이지당 게시물수 , 한 페이지당 보여줄 네비 수)
			
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("deptCode", m.getDeptCode());
			map.put("page", page);
			if(!searchType.equals("both")){
				map.put("searchType", "part_"+searchType); // 쿼리문 데이터
			}else{
				map.put("searchType", searchType); // 쿼리문 데이터
			}
			map.put("keyword", "%"+keyword+"%"); // 쿼리문 데이터
			map.put("searchTypeOrg", searchType); // 네비 데이터
			map.put("keywordOrg", keyword); // 네비 데이터
			
			// 리스트
			List<Object> list = bService.selectSearchBoardList(map);
			// 페이지네비
			Page pageNavi = bService.getPageNavi(map);
			
			model.addAttribute("list",list);
			model.addAttribute("pageNavi",pageNavi);
		}
		return "part_board/allPartBoardPage";
	}
	
	// 부서별 게시판 - 게시글 one select
	@RequestMapping(value="/postInPartBoard.ho")
	public String partBoard(@RequestParam("deptCode") String pageDeptCode, @RequestParam("partNo") int partNo, Model model, 
						HttpServletRequest request, @SessionAttribute("member") Member m)
	{
		if(m != null && pageDeptCode.equals(m.getDeptCode())){
			// 조회수 +1
			bService.updateHits(partNo);
			return onePost(pageDeptCode,partNo,model,request,m);
		}
		model.addAttribute("msg","잘못된 접근입니다.");
		return "part_board/allPartBoardPage";
	}
	private String onePost(String pageDeptCode, int partNo, Model model, HttpServletRequest request, Member m) {
		// 댓글 등록하면 해당 페이지를 제 로딩하려고 했는데 
		// 이렇게 분리하지 않으면 조회수가 댓글 등록할 때마다 오름 ;;
		HashMap<String, Object> map = new HashMap<String, Object>();
		map.put("deptCode", pageDeptCode);
		map.put("postNo", partNo);
		PartBoard pb = (PartBoard)bService.selectOnePost(map); // 게시글 정보
		
		// 다음글
		int nextPostNo = bService.selectNextPost(map);
		// 이전글
		int prevPostNo = bService.selectPrevPost(map);
		// 게시글 파일
		System.out.println(nextPostNo + " / "+prevPostNo+" / "+pageDeptCode);
		// 게시글 댓글
		int comntCount = bService.selectComntCount(partNo);
		
		Page comntPage = createPage(request, 5, 5);
		map.put("page", comntPage);
		map.put("comntPostNo", partNo);
		List<Object> comntList = bService.selectPostComments(map);
		//Page pageNavi = bService.getComntPageNavi(map);
		
		model.addAttribute("pb",pb);
		model.addAttribute("comntList",comntList);
		model.addAttribute("comntCount",comntCount);
		model.addAttribute("nextPost",nextPostNo);
		model.addAttribute("prevPost",prevPostNo);
		return "part_board/partBoard";
	}
	// 부서별 게시판 - 게시글 삭제
	@RequestMapping(value="/deltetPostPartBoard.ho")
	public void deletePost(@RequestParam("memNo") int memNo, @RequestParam("postNo") int postNo, HttpServletResponse response, 
							@SessionAttribute("member") Member m) throws IOException{
		if(m != null){
			HashMap<String,Object> map = new HashMap<String, Object>();
			map.put("memNo",memNo);
			map.put("postNo", postNo);
			int result = bService.deletePost(map);
			if(result>0){
				response.getWriter().print(true);
			}
		}
		response.getWriter().print(false);
	}
	//  부서별 게시판 - 댓글 등록
	@RequestMapping(value="/writeComntPartBoard.ho")
	public String writeComnt(PartComments comnt, Model model, HttpServletRequest request, @SessionAttribute("member") Member m){
		if(m != null){
			comnt.setMemNo(m.getMemNo());
			comnt.setPartComntWriter(m.getMemName());
			comnt.setPartComntEmail(m.getMemEmail());
			int result = bService.insertPostComnt(comnt);
			if(result>0){
				return onePost(m.getDeptCode(),comnt.getPartNo(),model,request,m);
			}else{
				model.addAttribute("msg","댓글 작성이 실패하였습니다. \n지속적인 문제 발생시 관리자에 문의하세요.");
				model.addAttribute("location","/postInPartBoard.ho?deptCode="+m.getDeptCode()+"&partNo="+comnt.getPartNo());
				return "result";
			}
		}else{ // 비로그인 시 
			return "redirect:login.jsp";
		}
		
	}
	
	
	
	
	// 부서별 게시판 - 새글쓰기 page
	@RequestMapping(value="/writePostPartBoard.ho")
	public String writePost(@RequestParam("deptCode") String pageDeptCode, Model model, @SessionAttribute("member") Member m){
		String deptCode = m.getDeptCode().replaceAll(" ", ""); // 공백제거
		if(m!=null && pageDeptCode.equals(deptCode)){
			ArrayList<Department> deptList = mService.selectDeptAll();
			for(Department dept : deptList){
				if(dept.getDeptCode().equals(pageDeptCode+" ")) model.addAttribute("deptName", dept.getDeptName());
				// 부서 이름 거르기
			}
			return "part_board/writePostPartBoard";
		}
		return "redirect:login.jsp";
	}
	// 부서별 게시판 - 게시글 등록 insert
	@RequestMapping(value="/savePostPartBoard.ho")
	public String addPost(Model model, HttpServletRequest request, @SessionAttribute("member") Member m) throws IOException{
		
		if(m!=null){
			// 파일이 업로드 되는 경로
			String uploadPath = "/resources/file/part_board/";
	
			// 최대 파일 사이즈를 정하기 위한 값
			int uploadFileSizeLimit = 10*1024*1024; // 최대 10MB 까지 업로드 가능
	
			// 파일 이름 인코딩 값
			String encType = "UTF-8"; 
			
			// 정보를 가지고 있는 객체
			// @Autowired	ServletContext context;
			
			// context.getRealPath(); -> WebContent까지의 절대 경로 (실제경로)
			String realUploadPath = context.getRealPath(uploadPath);
			
			// MultipartRequest 객체 생성 (생성하면서 마지막 5번째 정책 설정 객체 만들기)
			MultipartRequest multi = new MultipartRequest(request, // 1. request
																realUploadPath, // 2. 실제 업로드 되는 경로 
																uploadFileSizeLimit, // 3. 최대 파일 사이즈 크기
																encType, // 4. 인코딩 타입
																new DefaultFileRenamePolicy()); // 5. 중복 이름 정책
			
			// 위의 코드까지 하면 파일 업로드는 완료
			
			// 게시판 insert 비즈니스 로직
			PartBoard pb = new PartBoard(); 
			
			pb.setPartTitle(multi.getParameter("partTitle"));	// 제목
			pb.setDeptCode(m.getDeptCode());					// 부서코드
			pb.setMemNo(m.getMemNo());							// 사번
			pb.setPartWriter(m.getMemName());					// 작성자
			pb.setPartContent(multi.getParameter("partContent"));//글내용
			//System.out.println(pb.getPartTitle()+" / "+pb.getDeptCode()+" / "+pb.getMemNo()+" / "+pb.getPartWriter()+" / "+pb.getPartContent());
			
			// 비즈니스 로직
			int partNo = bService.insertPost(pb);
			// 게시글 고유번호
			if(partNo>0){
				
				if(multi.getFilesystemName("attachedFile")!=null){
				
					// 서버에 실제로 업로드 된 파일이름 가져오기
					String originalFileName = multi.getFilesystemName("attachedFile");
					
					long currentTime = Calendar.getInstance().getTimeInMillis(); // 현재 시간값 가져오기
					
					// File 객체는 경로를 통해서 해당 파일을 연결하는 객체
					File file = new File(realUploadPath+"\\"+originalFileName);
					// File 객체가 가지고 있는 renameTo 메소드를 통해서 파일의이름을 바꿀 수 잇음
					file.renameTo(new File(realUploadPath+"\\"+m.getDeptCode()+partNo+"_"+currentTime+"_ho")); // 실제 경로에 있는 파일 이름을 바꿈
					String changedFileName = m.getDeptCode()+partNo+"_"+currentTime+"_ho"; // DB에 저장할 파일 이름
					// File 객체를 통해 파일이름이 변경되면 새롭게 연결하는 파일 객체가 필요함
					File reNameFile = new File(realUploadPath+"\\"+changedFileName); // 이름이 바뀌여 다시 연결해줌
					String filePath = reNameFile.getPath(); // 경로
					// 해당 업로드된 file의 사이즈
					long fileSize = reNameFile.length();
					
					BoardFile pf  = new BoardFile();
					pf.setPostNo(partNo);
					pf.setOrigName(originalFileName);
					pf.setChgName(changedFileName);
					pf.setPath(filePath);
					pf.setSize(fileSize);
					
					bService.insertPostFile(pf); // 파일 DB에 저장
				} // 파일 null이 아니면 디비 저장 if 문
				
				model.addAttribute("msg","성공");
				
			}else{
				model.addAttribute("msg","실패");
			}// 게시글 디비 저장 실패 if 문
			
			model.addAttribute("location","/allPartBoardPage.ho");
			
		}else{
			return "redirect:login.jsp";
		} // 로그인을 하지 않았다면
		return "result";
	}
	
	// 부서별 게시판 update
	@RequestMapping(value="/partBoardModify.ho")
	public String partBoardModify(){
		return "part_board/partBoardModify";
	}
	
	
	
	// 페이징처리 할 때 필요한 페이지 객체 만들기
	private Page createPage(HttpServletRequest request,int RCPP, int NCPP){
		page = new Page();
		
		int currentPage; // 현재 페이지값을 가지고 있는 변수 - 페이징 처리를 위한 변수
		if(request.getParameter("currentPage")==null) {
			page.setCurrentPage(1);
		}else {
			page.setCurrentPage(Integer.parseInt(request.getParameter("currentPage")));
		}
		page.setRecordCountPerPage(RCPP); // 한 페이지당 몇개의 게시물이 보이게 될 것인지 - 페이징 처리를 위한 변수
		page.setNaviCountPerPage(NCPP); // page Navi값이 몇개씩 보여줄 것인지 - 페이징 처리(네비)를 위한 변수
		
		return page;
	}
}
