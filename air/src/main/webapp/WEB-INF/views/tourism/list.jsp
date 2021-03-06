<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="s" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="tags" tagdir="/WEB-INF/tags" %>
<%@taglib prefix="shiro" uri="http://shiro.apache.org/tags" %>  

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title></title>
<jsp:include page="/WEB-INF/views/commons/head.jsp"></jsp:include>

<script type="text/javascript">
	$(document).ready(function () {
	    
	    $("#queryButton").click(function(){
	    	$("#queryForm").submit();
	    })
	    
	    var timer = null; 
	    $("#listTable tbody tr").dblclick(function(){
	    	timer && clearTimeout(timer); 
	    	window.location.href = "./create.do?id=" + $(this).data("id");
	    })
	});

	function offLineTourism(enableId){
		
		idgConfirmObj.confirm("确认下线？", function(){ 
					
			$.ajax({
		      url: "enable.do",
		      type: "GET",
		      data: {
		    	  enableId : enableId
		      },
		      success:function (data) {
		      	
		      	if(data == 1){
		      		idgMessageObj.iMSuccessAlert("操作成功", 2000, function(){$("#queryForm").submit();});
		      	}else if(data.indexOf("gotoLogin") > -1){
		      		idgMessageObj.iMWarnAlert("用户连接超时，请重新登陆！", 2000);
		        }else{
		        	idgMessageObj.iMWarnAlert("操作失败", 2000);
		      	}
		      },
		      error:function(data){
		    	  idgMessageObj.iMWarnAlert("网络异常！", 2000);
		      }
		  })
		})
	}
	
	function deleteTourism(enableId){
		
		idgConfirmObj.confirm("确认删除？", function(){ 
					
			$.ajax({
				url: "delete.do",
				type: "GET",
				data: {
				 deleteId : enableId
				},
				success:function (data) {
					
					if(data == 1){
						idgMessageObj.iMSuccessAlert("操作成功", 2000, function(){$("#queryForm").submit();});
					}else if(data.indexOf("gotoLogin") > -1){
						idgMessageObj.iMWarnAlert("用户连接超时，请重新登陆！", 2000);
				  }else{
				  	idgMessageObj.iMWarnAlert("操作失败", 2000);
					}
				},
				error:function(data){
					idgMessageObj.iMWarnAlert("网络异常！", 2000);
				}
			})
		})
	}
	
</script>
</head>
<body style="background-color: #f3f3f3; overflow-x: hidden; padding-right: 15px;">
<tags:idgMessage warnMessage="${warnMessage}" successMessage="${successMessage}" 
	infoMessage="${infoMessage}" dangerMessage="${dangerMessage}" />
	<form action="./list.do" method="post" name="queryForm" id="queryForm">
	<div class="row">
		<div class="col-md-12">
			<h1 class="page-header">
				行程路线 <small>列表</small>
			</h1>
		</div>
	</div>
	<div class="row">
		<div class="col-md-12">
			<!-- Advanced Tables -->
			<div class="panel panel-default">
				<div class="panel-heading">
					<a href="./create.do" class="btn btn-primary">新增</a>
					<tags:fileUpload/>
				</div>
				<div class="panel-body">
					<div class="table-responsive" style="overflow-x: hidden;">
						<div class="row">
							<div class="col-sm-7">
							</div>
							<div class="col-sm-4">
								<input type="input" class="form-control" name="serach_content" placeholder="路线名称/产品编号/路线简介" value="${param.serach_content}">
							</div>
							<div class="col-sm-1">
								<button class="btn btn-primary" id="queryButton" name="queryButton">查询</button>
							</div>
						</div>
						<br>						
						<table class="table table-striped table-bordered table-hover" id="listTable">
							<thead>
								<tr>
									<th style="width: 20%;" data-sort="routeName">路线名称</th>
									<th style="width: 10%;" data-sort="productNumber">产品编号</th>
									<th style="width: 10%;" data-sort="pointOfDeparture">出发地点</th>
									<th style="width: 7%;" data-sort="destination">目的地</th>
									<th style="width: 10%;" data-sort="routeDays">行程天数</th>
									<th style="width: 5%;" data-sort="nowPrice">现价</th>
									<th style="width: 10%;" data-sort="rangType.fullName">产品类别</th>
									<th style="width: 10%;" data-sort="examineResult.fullName">审核状态</th>
									<th>操作</th>
								</tr>
							</thead>
							<tbody>
								<c:if test="${fn:length(pagedList.content) le 0}">
									<tr>
										<td colspan="11" style="text-align: center;">暂无资料</td>
									</tr>
								</c:if>
								<c:forEach items="${pagedList.content}" var="tourism" varStatus="status" >
									<tr data-id="${tourism.itineraryId}" class="
										<c:if test="${status.index % 2 eq 1}">odd gradeX</c:if>
										<c:if test="${status.index % 2 eq 0}">even gradeX</c:if>
									">
										<td>${tourism.routeName}</td>
										<td>${tourism.productNumber}</td>
										<td>${tourism.pointOfDeparture}</td>
										<td>${tourism.destination}</td>
										<td>${tourism.routeDays}</td>
										<td>${tourism.nowPrice}</td>
										<td>${tourism.rangType.fullName}</td>
										<td>
											<c:if test="${tourism.examineResult.itemKey == 'rejected'}">
												<a href="./viewResult.do?id=${tourism.itineraryId}">${tourism.examineResult.fullName}</a>
											</c:if>
											<c:if test="${tourism.examineResult.itemKey != 'rejected'}">
												${tourism.examineResult.fullName}
											</c:if>
										</td>
										<td>
											<a href="./view.do?id=${tourism.itineraryId}">查看</a>
											<c:if test="${tourism.examineResult.itemKey == 'uncommitted' || tourism.examineResult.itemKey == 'rejected' }">
												<a href="./create.do?id=${tourism.itineraryId}">修改</a>
												<a href="javascript:deleteTourism(${tourism.itineraryId});">删除</a>
											</c:if>
											<c:if test="${tourism.examineResult.itemKey == 'approved'}">
												<a href="javascript:offLineTourism(${tourism.itineraryId});">下线</a>
											</c:if>
										</td>
									</tr>
								</c:forEach>
							</tbody>
						</table>
						<tags:idgPage pagedList="${pagedList}"/>
					</div>
				</div>
			</div>
			<!--End Advanced Tables -->
		</div>
	</div>
	</form>
	<footer>
		<p>
		</p>
	</footer>
</body>
</html>

