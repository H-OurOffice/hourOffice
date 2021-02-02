<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>H:our Office</title>
<%@ include file ="../adminForm/style.jsp" %>
<style>
</style>
</head>
<body>

	<div id="wrap">
		<%@ include file ="../adminForm/header.jsp" %>
		
		<div id="contentsBox">
			<%@ include file ="../adminForm/sideNaviBar.jsp" %>
			
			<div id="contents">
				<div id="contentsDetail" class="clearfix">
					<div id="TitleName">
						삭제 조회
						<span>사원 조회</span>
    				</div>
    				<div id="TitleContents">
    					<div class="searchStyle selectStyle">
    						<select class="optionStyle">
    							<option>사번</option>
    							<option>이름</option>
    							<option>직위</option>
    							<option>부서</option>
    						</select>
							<input type="text" name="#"/>
							<button><i class="fas fa-search"></i></button>
						</div>
    				
						<table id="memberList" class="tblStyle">
                                <tr>
                                    <th><input type="checkbox"/></th>
                                    <th>사번</th>
                                    <th>이름</th>
                                    <th>직위</th>
                                    <th>부서</th>
                                    <th>이메일</th>
                                    <th>전화번호</th>
                                    <th>퇴사일</th>
                                </tr>
                                <tr>
                                    <td><input type="checkbox"/></td>
                                    <td>M-10000</td>
                                    <td>다주빈</td>
                                    <td>부장</td>
                                    <td>전산팀</td>
                                    <td>zoodabin@hourOffice.com</td>
                                    <td>010-1234-5678</td>
                                    <td>2021-02-01</td>
                                </tr>
                    	</table>
                    	<center><span><< < 1 2 3 4 5 > >></span></center>
    					<div class="buttonSet buttonStyle">
                        	<button class="agreeButtonType">복원</button>
                            <button class="refuseButtonType">삭제</button>
                        </div>
    				</div>
				</div>
			</div> 
		</div>
	</div>
	<script>
		$(document).ready(function(){
			var $deleteList = $('#deleteList');			
			var $deleteSelect = $('#deleteSelect');
			
			 /* 삭제 관리일 때 */
            $deleteList.css('height','110px');
            $deleteSelect.children().eq(2).children().attr('class','iArrow fas fa-angle-left');
			
			$deleteSelect.removeClass('hoverColor').addClass('click');
			$deleteList.removeClass('accordion');
			$deleteList.addClass('click');
			$deleteList.children().eq(0).children(":first").removeClass('hoverColor');
			
			// 사원 조회 checkbox 전부 누르기		
			$('#memberList').find('input').first().click(function(){
							
				if($(this).prop('checked')) {
					$('#memberList input').each(function(){
						$(this).prop('checked',true);
					});
				} else {
					$('#memberList input').each(function(){
						$(this).prop('checked',false);
					});
				}	
			});
		});	
	</script>
</body>
</html>