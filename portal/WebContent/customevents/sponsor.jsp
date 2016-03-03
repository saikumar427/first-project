<%@ page import="java.util.*,java.text.*,java.sql.*" %>
<%@ page import="com.eventbee.event.EventsContent" %>
<%@ page import="com.eventbee.event.*" %>
<%@ page import="com.eventbee.general.*" %>
<%--
HashMap evtinfo=(HashMap)request.getAttribute("EVENT_INFORMATION");
HashMap confighm=(HashMap)request.getAttribute("EVENT_CONFIG_INFORMATION");
String groupid=(String)request.getAttribute("GROUPID");
String particpantid=request.getParameter("participant");
HashMap user=(HashMap)request.getAttribute("userhm");
String salelimit=(String)request.getAttribute("SALESLIMIT");
String totalsales=(String)request.getAttribute("TOTALSALES");
String message=EbeeConstantsF.get("groupticket.saleslimit.exceed","The Participant through whom you registering has crossed his permitted limit");
String loginname=null;
if(user!=null)
loginname=(String)user.get("login_name");
if (totalsales==null)
totalsales="0";
String sponsorid=DbUtil.getVal("select sponsorid from mgr_sponsor_settings where refid=?",new String[]{groupid});
String buttonmsgform="";
String header="";
String buttonmsg="";
HashMap hmp=new HashMap(); 
hmp=EventsContent.getSponsorRequestdetails(groupid);              
buttonmsg=GenUtil.getHMvalue(hmp,"ButtonHeader","");

String sponsormsglink="";
String linkpath="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/home/links";
String isenabled=GenUtil.getHMvalue(confighm,"event.enable.f2fsponsor.settings","no");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"eventscontent.jsp"," to get the event is F2FSponsored  ","isenabled value is :"+isenabled,null);
if ("Yes".equalsIgnoreCase(isenabled)){
	String purpose="addsponsor";									              	
	buttonmsgform+="<form name='sponsorregister' action='/portal/auth/listauth.jsp' method='post'  onSubmit=\"return validateAgent('"+salelimit+"','"+totalsales+"','"+message+"')\"/>";
	buttonmsgform+="<input type='hidden' name='GROUPID' value='"+groupid+"' />";
	buttonmsgform+="<input type='hidden' name='id' value='yes'/>";
	buttonmsgform+="<input type='hidden' name='purpose' value='"+purpose+"'/>";
	buttonmsgform+="<input type='hidden' name='sponsorid' value='"+sponsorid+"'/>";
	if(request.getParameter("participant")!=null)
	buttonmsgform+="<input type='hidden' name='participant' value='"+request.getParameter("participant")+"'/>";
	buttonmsgform+="<input type='submit' name='submit' value='"+buttonmsg+"'/>";
	buttonmsgform+="<a href=\"javascript:popupwindow('"+linkpath+"/groupticketselling.html','Tags','600','400')\">[?]</a>";
	buttonmsgform+="</form>";
	}


%> 

<%
Vector vect=new Vector();
vect=EventsContent.getSponsorRequestInfoNames(vect,groupid);
%>
<%


String sponsormgrheader="";
StringBuffer requestforsponsor=new StringBuffer();
if(vect.size()>0){
sponsormgrheader=GenUtil.getHMvalue(hmp,"Header","");


for(int i=0;i<vect.size();i++){
HashMap hma=(HashMap)vect.elementAt(i);
requestforsponsor.append("<a href="+ShortUrlPattern.get(GenUtil.getHMvalue(hma,"username",""))+"/event?eventid="+request.getParameter("eventid")+"&sponsorrequestid="+GenUtil.getHMvalue(hma,"requestid","")+">"+GenUtil.getHMvalue(hma,"name","")+"</a><br>");
}
}

//request.setAttribute("REQUESTFORSPONSOR",requestforsponsor);
--%>
