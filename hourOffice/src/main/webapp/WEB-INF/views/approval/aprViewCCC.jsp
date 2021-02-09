<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>H:our Office</title>
<!-- 폰트어썸 -->
<script src="https://use.fontawesome.com/releases/v5.2.0/js/all.js"></script>

<!--jQuery CDN-->
<script src="https://code.jquery.com/jquery-3.5.1.js" integrity="sha256-QWo7LDvxbWT2tbbQ97B53yJnYU3WhH/C8ycbRAkjPDc=" crossorigin="anonymous"></script>

<!-- CSS -->
<link rel="stylesheet" type="text/css" href="/resources/css/header&sideNavi.css" />
<link rel="stylesheet" type="text/css" href="/resources/css/approval/apr_form.css" />

</head>
<body>
<div id="wrap">
<c:if test="${sessionScope.member ==null }"><script>alert("로그인이 필요합니다."); location.href="/login.ho";</script></c:if>
	<c:choose>
	<c:when test="${docu.lockYN eq 'Y'.charAt(0) }"><!-- 비공개일때, 작성자도 아니고, 결재선도 아니고, 참조도 아니면 비공개 알람.  -->
		<c:choose>
			<c:when test="${sessionScope.member.memNo == docu.memNo }"><c:set var="canRead" value="yes"/></c:when>
			<c:otherwise>
				<c:set var="canRead" value="no"/>
				<c:forEach items="${aprNoList }" var="listMemNo">
				<c:if test="${sessionScope.member.memNo == listMemNo }"><c:set var="canRead" value="yes"/></c:if>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise><c:set var="canRead" value="yes"/></c:otherwise>
	</c:choose>
	
	<c:choose>
	<c:when test="${pageScope.canRead == 'yes' }">
		<%@ include file="/WEB-INF/views/common/header.jsp"%>
		<div id="contentsBox">
			<%@ include file="/WEB-INF/views/common/sideNavi.jsp"%>

			<div id="contents">
				<div id="contentsDetail" class="clearfix">
					<div id="TitleName">전자결재 조회</div>
                    <div id="TitleContents">
                        <form action="" method="post">
                            <div id="apr_btn_wrap2">
							<c:if test="${(sessionScope.member.memNo eq requestScope.docu.memNo) and docu.aprType eq 'W'.charAt(0)}">
                                <span id="apr_del_btn"><a href="/deleteApproval.ho?docuNo=${docu.docuNo }">삭제</a></span>
                                <span id="apr_mod_btn"><a href="/loadAprForm.ho?docuType=C&docuNo=${docu.docuNo }">수정</a></span>
							</c:if>
                                <span id="apr_list_btn" onclick="listPage();">목록</span>
                            </div>
                            <div id="title-wrap2">
                                <div>문서 제목</div><div>${requestScope.docu.title}</div>
                            </div>
                            <fieldset id="form-done-wrap">
                                <div id="form-title">법인카드사용신청서</div>
                                <table id="docu-info">
                                    <tr>
                                        <td>기안자</td>
                                        <td>${docu.memName }</td>
                                    </tr>
                                    <tr>
                                        <td>기안부서</td>
                                        <td>${docu.deptName }</td>
                                    </tr>
                                    <tr>
                                        <td>기안일</td>
                                        <td>${docu.docuDate }</td>
                                    </tr>
                                    <tr>
                                        <td>문서번호</td>
                                        <td>${docu.docuNo }</td>
                                    </tr>
                                </table>
                                <table id="apr-line-info">
                                    <tr><td colspan="3">결재선</td></tr>
                                    <tr>
                                        <td>${aprLine[0].memName } ${aprLine[0].memPosition }<c:choose>
                                        	<c:when test="${aprLine[0].aprType eq 'A'.charAt(0) }"><span class="apr-mark mark-apr">승인</span></c:when>
                                        	<c:when test="${aprLine[0].aprType eq 'R'.charAt(0) }"><span class="apr-mark mark-ref">반려</span></c:when>
                                        </c:choose></td>
                                        <td>${aprLine[1].memName } ${aprLine[1].memPosition }<c:choose>
                                        	<c:when test="${aprLine[1].aprType eq 'A'.charAt(0) }"><span class="apr-mark mark-apr">승인</span></c:when>
                                        	<c:when test="${aprLine[1].aprType eq 'R'.charAt(0) }"><span class="apr-mark mark-ref">반려</span></c:when>
                                        </c:choose></td>
                                        <td>${aprLine[2].memName } ${aprLine[2].memPosition }<c:choose>
                                        	<c:when test="${aprLine[2].aprType eq 'A'.charAt(0) }"><span class="apr-mark mark-apr">승인</span></c:when>
                                        	<c:when test="${aprLine[2].aprType eq 'R'.charAt(0) }"><span class="apr-mark mark-ref">반려</span></c:when>
                                        </c:choose></td>
                                    </tr>
                                    <tr>
                                        <td><fmt:formatDate value="${aprLine[0].aprDate }" pattern="yyyy-MM-dd"/></td>
                                        <td><fmt:formatDate value="${aprLine[1].aprDate }" pattern="yyyy-MM-dd"/></td>
                                        <td><fmt:formatDate value="${aprLine[2].aprDate }" pattern="yyyy-MM-dd"/></td>
                                    </tr>
                                </table>
                                <div id="tag-wrap">
                                <c:if test="${docu.lockYN eq 'Y'.charAt(0) }"><span id="lock-tag">비공개</span></c:if>
                                <c:if test="${docu.urgencyYN eq 'Y'.charAt(0) }"><span id="urg-tag">긴급</span></c:if>
                                </div>
                                <table id="con-info">
                                    <tr>
                                        <td>신청부서</td>
                                        <td>${docu.applyDept }</td>
                                        <td>*카드종류</td>
                                        <td><c:choose>
	                                        <c:when test="${sessionScope.member.memNo == aprLine[0].memNo or sessionScope.member.memNo == aprLine[1].memNo or sessionScope.member.memNo == aprLine[2].memNo}">
	                                        <select name="cardType" id="card_type">
	                                            	<option value="" selected disabled hidden>==카드선택==</option>
	                                                <option value="1">법인카드1</option>
	                                                <option value="2">법인카드2</option>
	                                            </select>
	                                        </c:when>
                                        	<c:otherwise>
		                                        <c:choose>
		                                        	<c:when test="${docu.cardType eq 1}">법인카드1</c:when>
		                                        	<c:when test="${docu.cardType eq 2}">법인카드2</c:when>
		                                        	<c:otherwise>미할당</c:otherwise>
		                                        </c:choose>
                                        	</c:otherwise>
                                        </c:choose>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>신청자</td>
                                        <td>${docu.applier }</td>
                                        <td>반납예정일</td>
                                        <td>${docu.returnDate }</td>
                                    </tr>
                                    <tr>
                                        <td>신청일</td>
                                        <td>${docu.applyDate }</td>
                                        <td>사용처</td>
                                        <td>${docu.usedPlace }</td>
                                    </tr>
                                    <tr>
                                        <td>사용금액</td>
                                        <td colspan="3">${docu.amounts } 원</td>
                                    </tr>
                                    <tr>
                                        <td>신청목적</td>
                                        <td colspan="3">${docu.applyPurpose }</td>
                                    </tr>
                                </table>
                            </fieldset>
                            <c:choose>
                            	<c:when test="${docu.aprType=='R'.charAt(0) or docu.aprType=='C'.charAt(0) }"><!-- 결재가 완료됐으면 무조건-->
                            		<fieldset id="apr-com-wrap">
		                                <div>관련의견</div>
		                                <div class="apr-comment"><c:forEach var="line" items="${aprLine }"><div><span>${line.memName } ${line.memPosition }</span><span>${line.aprComment }</span></div></c:forEach></div>
		                            </fieldset>
                            	</c:when>
                            	<c:otherwise><!-- 결재가 진행중이면 -->
		                            <c:forEach var="apr" items="${aprLine}"><!-- 결재선이고, 결재를 하지 않은 경우에만 -->
		                            	<c:if test="${apr.memNo==sessionScope.member.memNo and apr.aprType =='W'.charAt(0)}">
					                            <fieldset id="apr-com-wrap">
				                                <div>관련의견</div>
				                                <div class="line-name">${sessionScope.member.memName } ${sessionScope.member.memPosition }</div>
				                                <textarea name="aprComment" id="line-comment" required></textarea>
				                            </fieldset>
				                            <div id="apr-btn-wrap">
				                            	<input type="hidden" name="docuType" value="C"/>
				                                <button id="ref_btn" type="submit" formaction="/aprMark.ho?docuNo=${docu.docuNo }&aprType=R">결재 반려</button>
				                                <button id="apr_btn"  type="submit" formaction="/aprMark.ho?docuNo=${docu.docuNo }&aprType=A">결재 승인</button>
				                            </div>
			                            </c:if>
		                            </c:forEach>
                            	</c:otherwise>
                            </c:choose>
                        </form>
                    </div>
				</div>
			</div>
		</div>
	</div>

	<!-- 자바 스크립트    -->
	<script type="text/javascript" src="/resources/js/header&sideNavi.js"></script>
	<script>
		function listPage(){
			history.back(-1);
		}
	</script>
	</c:when>
	<c:otherwise><script>alert("비공개입니다."); history.back(-1);</script></c:otherwise>
	</c:choose>
</body>
</html>