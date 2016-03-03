<%@ page import="com.eventbee.general.*,com.eventbee.event.*" %>

<%

String login_name=null;
String evtname=null;
String agentid=null;
String friendid=null;
String code=null;

request.setAttribute("CustomLNF_Type","EventDetails");
request.setAttribute("CustomLNF_ID",request.getParameter("GROUPID"));
EventRegisterBean jBean= (EventRegisterBean)session.getAttribute("regEventBean");
if(jBean!=null)

agentid=jBean.getAgentId();
friendid=jBean.getFriendId();
code=(String)session.getAttribute("discountcode_"+request.getParameter("GROUPID"));

String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");



if((String)session.getAttribute("evtname")!=null)
	evtname=(String)session.getAttribute("evtname");
else if((String)session.getAttribute("evtname")==null)
	evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{request.getParameter("GROUPID")});

String listurl=serveraddress+"/event;jsessionid="+session.getId()+"?eid="+request.getParameter("GROUPID");
String trckcode=(String)session.getAttribute("trckcode");
String trackcode=(String)session.getAttribute(request.getParameter("GROUPID")+"_"+trckcode);
if(trackcode!=null){
listurl=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{request.getParameter("GROUPID")});
if(listurl!=null)
listurl=listurl+"/track/"+trackcode;
}

if(agentid!=null)
listurl+="&participant="+agentid;
if(friendid!=null&&!"null".equals(friendid))
listurl+="&friendid="+friendid;
if(code!=null&&!"null".equals(code))
listurl+="&code="+code;
	  
if("FB".equals(request.getParameter("context"))){
	listurl+="&context=FB";
}
String evtlink="<a href='"+listurl+"'>"+evtname+"</a>";
String tktlink=null;
if("FB".equals(request.getParameter("context"))){
	tktlink="<a href='"+serveraddress+"/guesttasks/regticket.jsp?GROUPID="+request.getParameter("GROUPID")+"&context=FB'>Registration</a>";
}else{
        if(agentid!=null){

	 tktlink="<a href='"+serveraddress+"/guesttasks/regticket.jsp?GROUPID="+request.getParameter("GROUPID")+"&participant="+agentid+"'>Registration</a>";
	if(friendid!=null&&!"null".equals(friendid)&&!"".equals(friendid))
         tktlink="<a href='"+serveraddress+"/guesttasks/regticket.jsp?GROUPID="+request.getParameter("GROUPID")+"&participant="+agentid+"&friendid="+friendid+"'>Registration</a>";
	
	
	}
	else{
	   if(code!=null)
	    tktlink="<a href='"+serveraddress+"/guesttasks/regticket.jsp?GROUPID="+request.getParameter("GROUPID")+"&code="+code+"'>Registration</a>";
	    else
	     tktlink="<a href='"+serveraddress+"/guesttasks/regticket.jsp?GROUPID="+request.getParameter("GROUPID")+"'>Registration</a>";
	   
	}
        
}
String attdetlink="<a href='/guesttasks/personalInfo.jsp?GROUPID="+request.getParameter("GROUPID")+"'>Attendee Details</a>";
String previewlink="<a href='/guesttasks/regpreview.jsp?GROUPID="+request.getParameter("GROUPID")+"'>Preview</a>";
String securelink="<a href='javascript:popupwindow(\"/home/links/sslsecure.html\",\"Help\",\"600\",\"400\")'> <img src='/home/images/mastercard.gif'  border='0'/><img src='/home/images/visa.gif'  border='0'/><img src='/home/images/amex.gif'  border='0'/><img src='/home/images/sslsecure.gif'  border='0'/></a>";

request.setAttribute("tasktitle", evtlink+" > "+tktlink+ " > Payment "+securelink);
request.setAttribute("stype","Events");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/eventregister/reg/payment.jsp";
	footerpage="/main/eventfootermain.jsp";
	%>
	      		
	<%@ include file="/templates/taskpagebottom.jsp" %>
	