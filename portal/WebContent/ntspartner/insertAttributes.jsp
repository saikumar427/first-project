<%@ page import="com.eventbee.general.AuthUtil,com.eventbee.general.DbUtil,com.eventbee.authentication.Authenticate" %>
<%@ page import="com.eventbee.eventpartner.PartnerDB" %>

<%
String partnerid=request.getParameter("partnerid");
String foroperation=request.getParameter("foroperation");
String streamid=null,authid=null;
	
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData!=null)authid=authData.getUserID();
String platform = request.getParameter("platform");	
	String URLBase="/portal/mytasks/networkticketsellingpage.jsp";
	if("ning".equals(platform)){		
		URLBase="/ningapp/ntstab";
	}

streamid=DbUtil.getVal("select streamid from streaming_details where userid=? and refid=? and purpose='partnerstreamer'",new String[] {authid,partnerid});

if(streamid==null||"".equals(streamid)){
	streamid=PartnerDB.insertAttributes(authid,"partnerstreamer",partnerid);
	PartnerDB.insertAttributes(request,streamid);
}else{
	PartnerDB.insertAttributes(request,streamid);
}
response.sendRedirect(URLBase);
%>
