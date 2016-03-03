
<%
java.util.Date date=new java.util.Date();
String contenturl="/ningapp/ticketing/login.jsp?tm="+date.getTime();
String oid=request.getParameter("oid");
String appname=request.getParameter("appname");
String from=request.getParameter("from");

%>
<jsp:include page="/ningapp/taskheader.jsp" > 
<jsp:param  name='appname'  value='<%=appname%>' />
<jsp:param  name='showhome'  value='No' />
</jsp:include>
<table width="100%" align="center" >
<tr><td><div align="center">
<%@ include file="login.jsp"%>
</div></td></tr>
<tr><td>
<div align="center">
<%@ include file="signup.jsp"%>
</div>
</td></tr>
</table>
