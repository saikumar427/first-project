<%@ page import="com.eventbee.general.*" %>



<%!

 String CONFIG_GET = " select value as desc from config "
				  +" where config_id=(select config_id from clubinfo where "
                                  +" clubid=?) and name=?";
%>
<%
String refid=request.getParameter("GROUPID");
String custombutton="";
String custombutton1="";

custombutton=DbUtil.getVal(CONFIG_GET,new String[]{refid,"club.custom.joinbutton"});

if(custombutton==null||"null".equals(custombutton)||"".equals(custombutton)){
	custombutton="Join Community";
}


custombutton1=custombutton;

if(custombutton.indexOf("'")>-1){
custombutton1=custombutton.replaceAll("'","&#39;");

}

%>

<form id="custombuttonform" name="custombuttonform" method="post" action="/portal/hub/logic/updatejoinbutton.jsp" onSubmit="submitHubButton();return false;">
<input type="hidden" name="customjoinbutton" value='<%=custombutton1%>'>
<div id="HubButton" class="editlink" > 

<%=custombutton%>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span style="cursor: pointer; text-decoration: underline" onclick="editHubButton();"/>Edit</span>
</div>
<input type="hidden" name="GROUPID" value="<%=refid%>"/>

</form>