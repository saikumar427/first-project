
<%
java.util.Date date=new java.util.Date();
String contenturl="/ningapp/ticketing/login.jsp?tm="+date.getTime();
String oid=request.getParameter("oid");
String appname=request.getParameter("appname");
String domain=(String)session.getAttribute("domain");



if(session.getAttribute("ning_style_"+oid)!=null){%>
<style>
<%=(String)session.getAttribute("ning_style_"+oid)%>
<%}%>
</style>


<jsp:include page="/ningapp/taskheader.jsp" > 
<jsp:param  name='appname'  value='<%=appname%>' />
<jsp:param  name='showhome'  value='No' />

</jsp:include>


<div align="center">
<%@ include file="canvaslogin.jsp"%>
</div>



<div align="center">
<%@ include file="canvassignup.jsp"%>
</div>