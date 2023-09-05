<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ include file="../_inc/inc_head_fr.jsp" %>
<%
request.setCharacterEncoding("utf-8");
List<ProductInfo> productList = (List<ProductInfo>)request.getAttribute("productList");
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<style>
del { font-size:0.7em; color:#a0a0a0;}
.saleStock { font-size:0.7em; }
#list { width:1200px;}
</style>
<body>
<h2 align="center">NEW/신상품</h2>
<table id="list" cellpadding="30" cellspacing="0" align="center">

<%	for(int i = 0 ; i < productList.size(); i++) {
	if (i % 4 == 0) out.println("<tr>");
	ProductInfo pi = productList.get(i);
	String price = pi.getPi_price() + "원";		
	if (pi.getPi_dc() > 0) {  //할인율이 있으면
		price = Math.round(pi.getPi_price() * (1 - pi.getPi_dc()) )+ "원"; //실제 판매가
		price = "<del>" + pi.getPi_price() + "</del>&nbsp;&nbsp;&nbsp;" + price;
	}
%>
<td width="25%" align="center" onmouseover="this.bgColor='#efefef';" onmouseout="this.bgColor='';">
	<a href="productView?piid=<%=pi.getPi_id()%>">
		<img src="resources/img/product/<%=pi.getPi_img1() %>" width="150" height="150" border="0"><br>
	<%=pi.getPi_name() %><br>
	</a>
	<br><%=price %><br>
</td>
<%
if (i % 4 == 3) out.println("</tr>");
%>
<%} %>
</table>

<%@ include file="../_inc/inc_foot_fr.jsp" %>