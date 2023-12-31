<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../_inc/inc_head_fr.jsp" %>
<%@ page import="java.util.*" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%

request.setCharacterEncoding("utf-8");
List<ProductInfo> productList = (List<ProductInfo>)request.getAttribute("productList");

long realPrice = productList.get(0).getPi_price();   // 수량 변경에 따른 가격 연산을 위한 변수
String price = productList.get(0).getPi_price() + "원"; // 가격 출력을 위한 변수
if (productList.get(0).getPi_dc() > 0) { //할인율이 있으면
   realPrice = Math.round(realPrice * (1- productList.get(0).getPi_dc()));
   price = "<del>" + productList.get(0).getPi_price() + "</del>" + "&nbsp;&nbsp;&nbsp;" + realPrice + "원";
}

%>

<style>
#info td { font-size:1.2em; }
#cnt { width:20px; text-ailgn:right;}
.smt { width:150px; height:30px;}
#review { display:none; }

option {border: 1px solid black;}
.input {
  outline: none; display: inline-block; border: 1px solid black; width:30px; height:15px; cursor:pointer; text-align:center; 
}
.block {
display: inline-block;  width:45px; height:15px; border: 1px solid black; text-align:center; color:#efefef;
}


.hand { cursor:pointer; }
</style>

<script src="resources/js/jquery-3.6.4.js"></script>
<script>
function swapIng(img){
   var big = document.getElementById("bigImg"); 
   //큰이미지를 보여주는 img태그를 big이라는 이름의 객체로 받아줌
   big.src = "resources/img/product/" + img ;
}


function setCnt(op) {
   var price = <%=realPrice %>;
   var frm = document.frm;
   //var size = frm.size.value();    //10:150 ->  ps_idx:ps_stock
   var ss = "";
   var size = frm.size; // size라는 이름의 컨트롤들을 배열로 받아옴

   for(var i = 0; i < size.length ; i++){
      if(size[i].style.backgroundColor)   ss += "s" +size[i].value;   
   }
   
   if (ss != "") {
      var cnt = parseInt(frm.cnt.value);
   
      var max = 10;  // 재고가 10이상일 경우10을 최대값으로 지정
      
      if (op == "+" && cnt < max) frm.cnt.value = cnt + 1;   
      else if (op == "-" && cnt > 1)  frm.cnt.value = cnt - 1;
      
      var total =  document.getElementById('total');
      total.innerHTML = price * frm.cnt.value;
   
   } else {
      alert("옵션을 먼저 선택하세요.");
   } 
}

var preSize = "";
function chgColor(click) {
   var cnt = parseInt(frm.cnt.value);
   var size1 = document.getElementById(preSize);
   if(preSize != "")   {
      size1.style.backgroundColor="";
      frm.cnt.value = 1;   // size변경시 cnt값을 다시 1로 지정
      // size변경시 total값을 다시 1로 지정
      var total =  document.getElementById('total');
      total.innerHTML = <%=realPrice %>;
   }

   var size2 = document.getElementById(click);
   if(size2.style.backgroundColor)   size2.style.backgroundColor="";
   else                     size2.style.backgroundColor="rgb(170, 170, 170)";
   preSize = click;
}

function buy(kind) {
   <% if (isLogin) {%>
   var frm = document.frm;
   var ss = "";
   var size = frm.size; 
   var cnt = parseInt(frm.cnt.value);
   
   for(var i = 0; i < size.length ; i++){
      if(size[i].style.backgroundColor)   ss += size[i].value;   
   }
   
   if(ss == ""){
      alert("옵션(사이즈)을 선택하세요.");  
      return;
   } 
   
   if (kind == "c") {//장바구니 담기일 경우   
      $.ajax({
         type :"POST" , url:"cartProcIn",
         data:{"piid" : "<%=productList.get(0).getPi_id() %>", "psidx" : ss, "cnt": cnt},
         success :function(chkRs){//장바구니 담기에 실패했을 경우
            alert("chkRs :" +chkRs);
            if(chkRs == 0){
               alert("장바구니 담기에 실패하였습니다.\n다시 시도해 주세요.");
               return;
         } else { //장바구니 담기에 성공했을 경우
            if(confirm("장바구니에 담았습니다.\n장바구니로 이동하시겠습니까?")){
               location.href="orderCart";
            }
         }
      }
     }); 
    } else {// 바로 구매하기일 경우
      alert("바로구매");
      document.frm2.size.value = ss;
      document.frm2.cnt.value = cnt;
      document.frm2.submit(); 
      
    }
<% } else {%> 
   location.href = "login?url=/shoeshort/productView?piid=<%=productList.get(0).getPi_id() %>";
<%}%>
}
   
function showTap(chk) {
   var obj1 = document.getElementById("desc");
   obj1.style.display="none"
   var obj2 = document.getElementById("review");
   obj2.style.display="none";
   
   var obj3 = document.getElementById(chk);
   obj3.style.display="block"

}



</script>
<h2>상품 상세화면</h2>
 
<table width="1200" cellpadding="5">
<tr align="center">
<td width="50%" align="center">
<!-- 이미지 관련 영역 -->
   <table width="100%" cellpadding="5">
   <tr><td colspan="3" align="center">
   <% 
   for(ProductInfo pl: productList){%>
      <img src="resources/img/product/<%=pl.getPi_img1()%>" width="400" height="400" id="bigImg">
      </td></tr>      
      <tr align="center">
      <td width="33.33%">
         <img src="resources/img/product/<%=pl.getPi_img1()%>" width="100" height="100" onclick="swapIng('<%=pl.getPi_img1()%>')" class="hand">
      </td>
      <td width="33.33%">
      <img src="resources/img/product/<%=pl.getPi_img2()%>" width="100" height="100" onclick="swapIng('<%=pl.getPi_img2()%>')" class="hand">   
   
      </td>
      <td width="33.33%">
   <img src="resources/img/product/<%=pl.getPi_img3()%>" width="100" height="100" onclick="swapIng('<%=pl.getPi_img3()%>')" class="hand">   
            
      </td>
      </tr>   
      </table>
      <form name="frm2" method="post" action="orderForm">
   <input type="hidden" name="piid" value="<%=pl.getPi_id()%>">
   <input type="hidden" name="kind" value="d">
   <input type="hidden" name="size" value="">
   <input type="hidden" name="cnt" value="">
</form>  
<td width="35%" valign="top">
<!-- 상품 정보 관련 영역 -->
   <form name="frm" method="post">
   <input type="hidden" name="kind" value="d">
   <input type="hidden" name="piid" value="<%=pl.getPi_id()%>">
   <table width="100%" cellpadding="5" border="1" id="info">   
   <tr>
      <td colspan="2">&nbsp;&nbsp;&nbsp;<%=pl.getPb_name()%></td>
   </tr>
   <tr>
      <td width="20%" align="right">상품명</td><td width="*"><%=pl.getPi_name()%></td></tr>
      <tr><td align="right">브랜드</td><td><%=pl.getPb_name()%></td></tr>
      <tr><td align="right">제조사</td><td><%=pl.getPi_com() %></td></tr>
      <tr><td align="right">가격</td><td><%=realPrice %></td></tr>   
   <tr>
   <td align="right">옵션</td>
   <td>   
      <c:forEach items="${stockList }" var="sl" >
  			<c:if test="${sl.getPs_stock() == 0 }">
				<input type="text" name="size" id="${sl.getPs_size() }"  value="${sl.getPs_size() }"  class="block" style="width:30px; height:15px;" > 
			</c:if>
			<c:if test="${sl.getPs_stock() != 0 }">
     			<input type="text" name="size" id="${sl.getPs_size() }"  value="${sl.getPs_size() }"  onclick="chgColor('${sl.getPs_size() }');" 
    			class="input" style="width:30px; height:15px;" readonly="readonly">  
    		</c:if>
		</c:forEach>
   </td>
   </tr>
   <tr>
   <td align="right">수량</td>
   <td>
   <input type="button" value="-" onclick="setCnt(this.value);">
   <input type="text" name="cnt" id="cnt"  value="1" readonly="readonly" >
   <input type="button" value="+" onclick="setCnt(this.value);">
   </td>
   </tr>
   <tr><td colspan="2" align="right">
      구매 가격 : <span id="total"></span>원
   </td></tr>
   <tr><td colspan="2" align="center">
   <input type="button" value="장바구니 담기" class="btn btn-white" style="background-color: #FF4646;"  onclick="buy('c');">
   <input type="button" value="바로 구매하기" class="btn btn-success" onclick="buy('d');">
   </table>
   </form>
</td>
</tr>
<tr>
</table>
<hr>
<input type="button" value="상품설명" onclick="showTap('desc');">
<input type="button" value="구매후기" onclick="showTap('review');"><br>
<div id="desc" >
   <img src="resources/img/product/<%= pl.getPi_desc() %>" width="1200" height="1000">
   <img src="resources/img/product/<%=pl.getPi_desc()  %>" width="1200" height="1000">
</div>
   
   <%} %>
   
<div id="review" >
   구매후기
</div>
<%@ include file="../_inc/inc_foot_fr.jsp" %>