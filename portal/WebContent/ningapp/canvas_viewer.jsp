<%@ page import="java.util.*,com.eventbee.general.*,com.eventbee.authentication.*,com.eventbee.useraccount.*"%>

<%

String ninguserid=request.getParameter("oid");
String vid=request.getParameter("vid");


HashMap hm=(HashMap)session.getAttribute("partnersession");


if(hm!=null){



String eventid=(String)hm.get("eid");

String pid=(String)hm.get("pid");
%>

<jsp:forward page="/eventdetails/event.jsp" > 
<jsp:param name="eventid" value="<%=eventid%>" />
<jsp:param name="platform" value="ning" />
<jsp:param name="pid" value="<%=pid%>" />

</jsp:forward> 







<%}
else
{
String owner=request.getParameter("owner");

String userid=DbUtil.getVal("select ebeeid from ebee_ning_link where nid=?",new String[]{ninguserid});


String partnerid=DbUtil.getVal("select partnerid from group_partner where userid=?",new String[]{userid});

String serveraddress=EbeeConstantsF.get("serveraddress","www.beeport.com");
%>



<div width='250'>
<script  type="text/javascript" language="javascript" src="http://<%=serveraddress%>/portal/streaming/ningpartnerstreaming_js.jsp?partnerid=<%=partnerid%>&from=canvas"></script>
</div>
<%}%>