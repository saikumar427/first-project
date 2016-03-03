<%@ page import="com.eventbee.general.*"%>

<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";

String login_name=null;
String evtname=null;
String code=(String)session.getAttribute("discountcode_"+request.getParameter("GROUPID"));

request.setAttribute("CustomLNF_Type","EventDetails");
request.setAttribute("CustomLNF_ID",request.getParameter("GROUPID"));

	
if((String)session.getAttribute("evtname")!=null)
	evtname=(String)session.getAttribute("evtname");
else if((String)session.getAttribute("evtname")==null)
	evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{request.getParameter("GROUPID")});


String listurl=serveraddress+"event;jsessionid="+session.getId()+"?eid="+request.getParameter("GROUPID");
String trckcode=(String)session.getAttribute("trckcode");
String trackcode=(String)session.getAttribute(request.getParameter("GROUPID")+"_"+trckcode);
if(trackcode!=null){
listurl=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{request.getParameter("GROUPID")});
if(listurl!=null)
listurl=listurl+"/track/"+trackcode;
}

if("FB".equals(request.getParameter("context"))){
	listurl+="&context=FB";
}
if(code!=null&&!"null".equals(code))
listurl+="&code="+code;
String evtlink="<a href='"+listurl+"'>"+evtname+"</a>";
request.setAttribute("tasktitle","Event Registration > "+evtlink+" > Success");
//request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/eventregister/reg/end.jsp";
	footerpage="/main/eventfootermain.jsp";
	%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
		