<%@ page import="java.util.*,com.eventbee.general.*,com.eventbee.authentication.*,com.eventbee.useraccount.*"%>


<%
String oid=request.getParameter("oid");


String serveraddress=EbeeConstantsF.get("serveraddress","www.beeport.com");
%>

<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">

</script>

<div width='250'>
<script  type="text/javascript" language="javascript" src="http://<%=serveraddress%>/portal/ningapp/ticketing/ningmainpageevents.jsp"></script>
</div>
