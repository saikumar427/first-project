<%@ page import="java.util.*,com.eventbee.general.*,com.eventbee.authentication.*,com.eventbee.useraccount.*"%>

<%

String ninguserid=request.getParameter("oid");

String vid=request.getParameter("vid");
String domain=request.getParameter("domain");
session.setAttribute("domain",domain);
session.setAttribute("vid",vid);

session.setAttribute("oid",ninguserid);
String userid=DbUtil.getVal("select ebeeid from ebee_ning_link where nid=?",new String[]{ninguserid});


String partnerid=DbUtil.getVal("select partnerid from group_partner where userid=?",new String[]{userid});

String serveraddress=EbeeConstantsF.get("serveraddress","www.beeport.com");

%>


<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">


</script>
<div width='500' style='padding:10px'>
<script  type="text/javascript" language="javascript" src="http://<%=serveraddress%>/portal/streaming/ningpartnerstreaming_js.jsp?platform=ning&partnerid=<%=partnerid%>&from=profile"></script>
</div>
