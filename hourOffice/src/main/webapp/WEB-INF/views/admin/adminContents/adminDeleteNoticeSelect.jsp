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
						<span>게시글 조회</span>
    				</div>
    				<div id="TitleContents">
    					<div class="searchStyle selectStyle">
    						<select class="optionStyle">
    							<option>제목+작성자</option>
    							<option>제목</option>
    							<option>작성자</option>
    						</select>
							<input type="text" name="#"/>
							<button><i class="fas fa-search"></i></button>
						</div>
    				
						<table id="noticeList" class="tblStyle">
                                <tr>
                                    <th><input type="checkbox"/></th>
                                    <th>제목</th>
                                    <th>작성자</th>
                                    <th>작성일</th>
                                    <th>조회</th>
                                    <th>삭제일</th>
                                </tr>
                                <tr>
                                    <td><input type="checkbox"/></td>
                                    <td>[영업실적] 1월 영업실적 보고</td>
                                    <td>장효진 사원</td>
                                    <td>2021-01-31</td>
                                    <td>1</td>
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
			$deleteList.children().eq(1).children(":first").removeClass('hoverColor');	
		
			// 게시글 조회 checkbox 전부 누르기		
			$('#noticeList').find('input').first().click(function(){
							
				if($(this).prop('checked')) {
					$('#noticeList input').each(function(){
						$(this).prop('checked',true);
					});
				} else {
					$('#noticeList input').each(function(){
						$(this).prop('checked',false);
					});
				}	
			});
		});		
	</script>
</body>
</html>