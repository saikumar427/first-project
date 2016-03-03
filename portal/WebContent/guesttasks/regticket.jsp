<%@ page import="com.eventbee.general.*,com.eventbee.event.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";

String groupid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","groupid","GROUPID"});

String login_name="";
String evtname="";
String listurl=null;
String agentid=null;
String friendid=null;
String code=null;
request.setAttribute("CustomLNF_Type","EventDetails");
request.setAttribute("CustomLNF_ID",groupid);
EventRegisterBean jBean= (EventRegisterBean)session.getAttribute("regEventBean");
if(jBean!=null){

agentid=jBean.getAgentId();
friendid=jBean.getFriendId();
}
code=request.getParameter("code");
if(code==null)
code=(String)session.getAttribute("discountcode_"+groupid);


evtname=DbUtil.getVal("select eventname from eventinfo where eventid=?",new String[]{groupid});
listurl=serveraddress+"event;jsessionid="+session.getId()+"?eid="+groupid;
String trckcode=(String)session.getAttribute("trckcode");
String trackcode=(String)session.getAttribute(groupid+"_"+trckcode);
if(trackcode!=null){
listurl=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{groupid});
if(listurl!=null)
listurl=listurl+"/track/"+trackcode;
}
if(agentid!=null)
listurl+="&participant="+agentid;
if(friendid!=null&&!"null".equals(friendid)&&!"".equals(friendid))
listurl+="&friendid="+friendid;
if(code!=null&&!"null".equals(code))
listurl+="&code="+code;

if("FB".equals(request.getParameter("context"))){
	listurl+="&context=FB";
}


String platform=(String)session.getAttribute("platform");
if("ning".equals(platform)){
listurl+="&platform=ning";
}
String evtlink="<a href='"+listurl+" ' id='tkterr'>"+evtname+"</a>";
request.setAttribute("stype","Events");
if(jBean.getUpgradeRegStatus())
request.setAttribute("tasktitle",evtlink+" > Upgrade/Edit Registration");
else
request.setAttribute("tasktitle",evtlink+" > Registration");

%>

<%@ include file="/templates/taskpagetop.jsp" %>

<%

	taskpage="/eventregister/reg/ticket.jsp";
	footerpage="/main/eventfootermain.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
		      		