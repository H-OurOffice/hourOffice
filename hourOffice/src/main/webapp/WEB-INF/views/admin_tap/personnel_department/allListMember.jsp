<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
	<!-- 폰트어썸 -->
    <script src="https://use.fontawesome.com/releases/v5.2.0/js/all.js"></script>
    
    <!--jQuery CDN-->
    <script src="https://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>
	
	<!-- 헤더 & 네비 CSS -->
	<link rel="stylesheet" type="text/css" href="/resources/css/header&sideNavi.css" />
	<!-- 관리자 탭 공통 CSS -->
	<link rel="stylesheet" type="text/css" href="/resources/css/admin_tap/adminTapCommon.css" />
	<!-- CSS -->
	<link rel="stylesheet" type="text/css" href="/resources/css/admin_tap/allListMember.css" />
	
	<style>
        
        
    </style>
<script>
    $(function(){
        // 추출된 사번을 담은 변수배열
        var checkMem = [];
        // checkbox 누르면 해당 직원의 사번을 추출
        $('input[name=checkMem]').click(function(){
            if($(this).is(':checked')){
                if($(this).val()=='all'){ // 전체 선택을 하면
                    $('input[name=checkMem]').prop('checked',true); // 모든 checkbox:checked
                    checkMem = []; // 변수 비워주기
                    $('input:checkbox[name=checkMem]:checked').each(function(){
                        // 반복문 checked 된 checkbox가 있는만큼 반복하여라
                        checkMem.push($(this).val());
                    })
                }else{
                    checkMem.push($(this).val());
                }
            }else{
                if($(this).val()=='all'){
                    $('input[name=checkMem]').prop('checked',false);
                    checkMem = []; // 변수 비워주기
                }else{
                    checkMem.splice(checkMem.indexOf($(this).val()),1);
                }
            }
        });
        
        // 직위변경 버튼 누르면 직위 변경 영역 열림
        $('#positionChangeBtn').click(function(){
            alert(checkMem.length);
            if(checkMem.length==1){
                $('.positionChangePlace').hide();
                $('#change'+checkMem).show();
                //$('#change'+checkMem).children().slideDown();
                //$('#change'+checkMem).slideDown();
            }else{
                alert('하나의 사원을 선택해주세요');
            }
        });
        
        // 직위 변경 저장 버튼 -> update
        $('.positionChangeSaveBtn').click(function(){
            var memNo = $(this).parents('tr').attr('id').substr(6); // 사번
            var position = $(this).prev().val(); // 변경할 직위
            if(position!=''){
                var result = confirm('['+memNo+'] 해당 사번의 직위를 '+position+'(으)로 변경하시겠습니까?');
                if(result){
                    // $.ajax 처리
                }
            }else{
                alert('변경할 직위를 선택해주세요.');
            }
            
        });
        
        // 직위 변경 취소 버튼 누르면 td가 안 보이게 변경 
        $('.positionChangeResetBtn').click(function(){
            $(this).parents('.positionChangePlace').hide();
            //$(this).parents('.positionChangePlace').slideUp();
            //$(this).parents('.positionChangePlace').children().hide();
        });
        
        // 사원삭제 -> update
        $('#dropMemBtn').click(function(){
            if(checkMem.length>0){
                if(checkMem[0]=='all'){
                    checkMem.splice(checkMem.indexOf(checkMem[0]),1);
                }
                if(confirm('정말 삭제하시겠습니까?')){
                    // $.ajax();
                    // 삭제로직~   
                }
            }else{
                alert('삭제할 사원을 선택해주세요');
            }
        });
    })
</script>
</head>
<body>
	<div id="wrap">
		<%@ include file="/WEB-INF/views/common/header.jsp" %>
		<div id="contentsBox">
			<%@ include file="/WEB-INF/views/common/sideNavi.jsp" %>

			<div id="contents">
				<div id="contentsDetail" class="clearfix">
					<div id="TitleName">
						<!--여기서 각자 id 만드시면 됩니다-->
						인사관리 통합사원
						<!----------------------------------->
					</div>
					<div id="TitleContents">
						<!--여기서 각자 id 만드시면 됩니다-->
						
						<div id="totalMemNum"><span id="totalMem">현재사원수</span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;001명</div>
                        <hr width="200px" align="left">
                        <div id="btnPlace"><a href="/admin_tap_memberJoin.ho"><button type="button">+ 사원생성</button></a><button type="button" id="positionChangeBtn">직위변경</button><button type="button" id="dropMemBtn" class="delBtn">- 사원삭제</button></div>
                        <div>
                            <table id="memAllListTbl">
                                <tr height="1px"><td colspan="8"><hr style="margin:0;"></td></tr>
                                <tr>
                                    <td><input type="checkbox" name="checkMem" value="all"/></td>
                                    <td>사번</td>
                                    <td>이름</td>
                                    <td>직위</td>
                                    <td>부서</td>
                                    <td>이메일</td>
                                    <td>전화번호</td>
                                    <td>입사일</td>
                                </tr>
                                <tr style="padding:0;"><td colspan="8" style="padding:0;"><hr style="margin:0;"></td></tr>
                                <tr>
                                    <td><input type="checkbox" name="checkMem" value="2101001"/></td>
                                    <td>2101001</td>
                                    <td><a href="/admin_tap_memberInfo.ho">주다빈</a></td>
                                    <td>사원</td>
                                    <td>인사팀</td>
                                    <td>메일@메일.com</td>
                                    <td>010-0000-0000</td>
                                    <td>2021/01/22</td>
                                </tr>
                                <tr id="change2101001" class="positionChangePlace">
                                    <td colspan="2" align="center">직위 변경</td>
                                    <td colspan="6">
                                        <select name="memPosition">
                                           <option value="">직위선택</option>
                                           <option value="사원">사 원</option>
                                           <option value="대리">대 리</option>
                                           <option value="과장">과 장</option>
                                           <option value="차장">차 장</option>
                                           <option value="부장">부 장</option>
                                           <option value="임원">임 원</option>
                                           <option value="이사">이 사</option>
                                           <option value="대표">대 표</option>
                                        </select>
                                        <button type="button" class="positionChangeSaveBtn">저장</button><button type="button" class="delBtn positionChangeResetBtn">취소</button>
                                    </td>
                                </tr>
                            </table>
                            <div id="pageNavi">1 2 3 4 5 ></div>
                        </div>
						
						
						
						<!----------------------------------->
					</div>
				</div>
			</div>
		</div>

	<!-- 자바 스크립트    -->
	<script type="text/javascript" src="/resources/js/header&sideNavi.js"></script>

	</div>
</body>
</html>