<%@ page import="java.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.event.EventInfoDb" %>
<%@ page import="com.eventbee.eventpartner.*" %>

<%
String partnerid=request.getParameter("partnerid");
String foroperation=request.getParameter("foroperation");
String streamid=null,authid=null;
	
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData!=null)authid=authData.getUserID();
streamid=DbUtil.getVal("select streamid from streaming_details where userid=? and refid=? and purpose='partnerstreamer'",new String[] {authid,partnerid});

if(streamid==null||"".equals(streamid)){
	streamid=PartnerDB.insertAttributes(authid,"partnerstreamer",partnerid);
	PartnerDB.insertAttributes(request,streamid);
}else{
	PartnerDB.insertAttributes(request,streamid);
}
response.sendRedirect("/portal//ningapp/profileownerevtlisting.jsp");
%>
