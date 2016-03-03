<link rel="stylesheet" type="text/css" href="/home/index.css" />
<jsp:include page='mytabsmenu.jsp' >
<jsp:param  name='homelinkprofile'  value='ntsappprofile' />
</jsp:include>
<%

String oid=(String)session.getAttribute("ning_oid");
session.setAttribute(oid+"__ningsession",null);
%>

<table width='450' cellpadding="0"  cellspacing="0">
<tr><td >
<jsp:include page='/ntspartner/allntseventsbeelet.jsp'>
<jsp:param name="platform" value="ning" />
</jsp:include>
</td></tr>
<tr><td height="20"></td></tr>
<tr><td>
<jsp:include page="/ningapp/myearnings.jsp" />
</td></tr>

</table>
