<%@ page import="com.eventbee.general.formatting.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.event.*,java.util.*,com.eventbee.authentication.*"%>
<%@ include file="/eventregister/includemethod.jsp" %>
<%
System.out.println("agentsdfdgf fgfggd ");
String eventid=request.getParameter("GROUPID");
String option=request.getParameter("login");
String loginname=request.getParameter("loginName");
String password=request.getParameter("password");
HashMap hm=new HashMap();
Authenticate au=null;
session.setAttribute(request.getParameter("GROUPID")+"_RSVP_EVENT",hm);
if("yes".equals(option)){
AuthDB authDB=new AuthDB();
au=authDB.authenticateMember(loginname, password,"13579");
if(au==null)
response.sendRedirect("/guesttasks/memberlogin.jsp?GROUPID="+request.getParameter("GROUPID")+"&iserror=yes");
else{
hm=getRsvpDetails(eventid,au.getUserID());
System.out.println("hmsddssdfs: "+hm);
if(hm==null){
hm=new HashMap();
hm.put("userid",au.getUserID());
hm.put("UNITID","13579");
hm.put("fname",au.getFirstName());
hm.put("lname",au.getLastName());
hm.put("emailid",au.getEmail());
}
session.setAttribute(request.getParameter("GROUPID")+"_RSVP_EVENT",hm);
response.sendRedirect("/guesttasks/eventrsvp.jsp?GROUPID="+request.getParameter("GROUPID"));
}
}
else
response.sendRedirect("/guesttasks/eventrsvp.jsp?GROUPID="+request.getParameter("GROUPID"));



%>
