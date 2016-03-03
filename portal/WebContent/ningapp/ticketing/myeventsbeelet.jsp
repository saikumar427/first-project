<%@ page import="com.eventbee.general.*" %>


<link rel="stylesheet" type="text/css" href="/home/index.css" />
<%

String oid=(String)session.getAttribute("ning_oid");
session.setAttribute(oid+"__ningsession",null);
%>
<jsp:include page="/ningapp/taskheader.jsp"> 
<jsp:param  name='from'  value='profile' />
</jsp:include>

<table width='100%' cellpadding="0"  cellspacing="0">
<tr><td width='50%' valign='top'><table>
<tr><td>
<jsp:include page='/ningapp/ticketing/listedevents.jsp' >
<jsp:param  name='Showmanage'  value='no' />
<jsp:param  name='oid'  value='<%=oid%>' />
</jsp:include>

</td></tr></table></td>
<td width='50%' valign='top'><table>
<tr><td width='50%' style="border: 1px solid #ddddff; padding:5px;" valign='top'>
<jsp:include page="/customconfig/logic/CustomContentBeelet.jsp">
<jsp:param name="portletid" value="NING_APP_PROFILE_OWNER" />
<jsp:param name="forgroup" value="13579" />

</jsp:include>


</td></tr></table></td></tr>
</table>

