<%@ page import="java.util.*,com.eventbee.general.*,com.eventbee.authentication.*" %>




<%
String ningoid=request.getParameter("oid");
session.setAttribute("ningoid",ningoid);
session.setAttribute("platform","ning");


String ningviewerid=request.getParameter("vid");
session.setAttribute("ningvid",ningviewerid);

String eventid=(String)session.getAttribute(ningviewerid+"_EventDisplay");


if(eventid==null)
eventid=request.getParameter("eventid");

if(eventid==null)

eventid=(String)session.getAttribute("eventid");



HashMap regmap=(HashMap)session.getAttribute(eventid+"_"+ningoid+"_registration");
session.setAttribute(eventid+"_"+ningoid+"_registration",null);



if(eventid!=null){

if(regmap!=null){

String paymenttype=(String)regmap.get("paymenttype");
String purpose=(String)regmap.get("purpose");

String transactionid=(String)regmap.get("transactionid");

if("Registration_Done".equals(purpose))

response.sendRedirect("/ningapp/ticketing/processdata.jsp?id="+transactionid+"&source="+paymenttype+"&GROUPID="+eventid);
else

response.sendRedirect("/guesttasks/regticket.jsp?GROUPID="+eventid);

}
else{%>


<jsp:forward page="/eventdetails/event.jsp" > 
<jsp:param name="eventid" value="<%=eventid%>" />
<jsp:param name="platform" value="ning" />

</jsp:forward> 


<%}
}

else
{

String ebeeid=DbUtil.getVal("select ebeeid from ebee_ning_link where nid=?",new String[]{ningoid});
String username=DbUtil.getVal("select login_name from authentication where user_id=?",new String[]{ebeeid});
request.setAttribute("username",username);
HashMap hm=(new  AuthDB()).getUserPreferenceInfo(username);

String userid=(String)hm.get("user_id");

HashMap hm1=(new AuthDB()).getUserInfoByUserID(userid);

String fullusername=DbUtil.getVal( "select getMemberName(?) as fullusername" ,new String[]{userid} );

request.setAttribute("userid",userid);
request.setAttribute("userhm",hm1    );
request.setAttribute("fullusername",fullusername);


%>
<jsp:forward page="/customevents/eventspage.jsp" > 
<jsp:param name="platform" value="ning" />
<jsp:param name="ningviwer" value="<%=ningviewerid%>" />
<jsp:param name="ningowner" value="<%=ningoid%>" />
<jsp:param name="name" value="<%=username%>" />
</jsp:forward> 
<%}%>


