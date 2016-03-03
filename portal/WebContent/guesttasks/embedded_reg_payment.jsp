<%@ include file="/templates/taskpagetop.jsp" %>
<%
request.setAttribute("CustomLNF_Type","EventDetails");
request.setAttribute("CustomLNF_ID",request.getParameter("GROUPID"));

taskpage="/embedded_reg/payment.jsp";
footerpage="/main/eventfootermain.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
