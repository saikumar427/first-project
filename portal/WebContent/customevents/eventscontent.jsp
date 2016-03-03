<%@ page import="java.util.*,java.sql.*,java.text.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%@ page import="com.eventbee.useraccount.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.event.*" %>
<%@ page import="com.eventbee.event.ticketinfo.*" %>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.noticeboard.NoticeboardDB" %>
<%@ page import="com.eventbee.contentbeelet.*"%>
<%@ page import="com.eventbee.event.EventsContent" %>
<%@ page import="com.eventbee.authentication.AuthDB.*" %>

<%-- @ include file="/../plaxo_js.jsp" --%>
<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy() { }
</script>

<script type="text/javascript" language="JavaScript" src="/home/js/Tokenizer.js">
        function dummy1() { }
</script>
<%
String groupid=Presentation.GetRequestParam(request, new String []{"eid","eventid", "id","GROUPID"});
//String groupid=request.getParameter("eventid");
String participantid=Presentation.GetRequestParam(request,  new String []{"pid","partnerid", "participantid","participant"});
request.setAttribute("GROUPID",groupid);


String userid=(String)request.getAttribute("userid");

HashMap userhm=(HashMap)request.getAttribute("userhm");
String loginname=null;
if(userhm!=null)
loginname=(String)userhm.get("login_name");
else 
loginname=DbUtil.getVal("select login_name from authentication where auth_id=?",new String [] {userid});
UserInfo usrInfo=AccountDB.getUserProfile(userid);

request.setAttribute("USERINFO",usrInfo);
String	userfullname="";
HashMap hm=new HashMap();
if(usrInfo!=null || userid=="-1"){
String	userfirstname=(usrInfo!=null)?usrInfo.getFirstName().trim():"";
String	userlastname=(usrInfo!=null)?usrInfo.getLastName().trim():"";
userfullname=(userfirstname+" "+userlastname).trim();


	request.setAttribute("USERFIRSTNAME",userfirstname);
	request.setAttribute("USERLASTNAME",userlastname);
	request.setAttribute("USERFULLNAME",userfullname);
}

String networklink="<a href='"+ShortUrlPattern.get(loginname)+"/network'>Network Page</a>";
String Bloglink="<a href='"+ShortUrlPattern.get(loginname)+"/blog'>Blog Page</a>";
String photoslink="<a href='"+ShortUrlPattern.get(loginname)+"/photos'>Photos Page</a>";
String communitylink="<a href='"+ShortUrlPattern.get(loginname)+"/community'>Community Page</a>";
String eventslink="<a href='"+ShortUrlPattern.get(loginname)+"/events'>Events Page</a>";

//request.setAttribute("NETWORKLINK",networklink);
//request.setAttribute("BLOGLINK",Bloglink);
//request.setAttribute("PHOTOSLINK",photoslink);
//request.setAttribute("COMMUNITYLINK",communitylink);
request.setAttribute("EVENTSLINK",eventslink);

%>

<% 
/* ######## YAHOO AND GOOGLE ADS FOR EVENTS PAGE 04/04/2007 rajesh #######
String content="";
HashMap customcontent_yahooad=null;
customcontent_yahooad=CustomContentDB.getCustomContent("THEME_YAHOO_AD", "13579");
if(customcontent_yahooad!=null){
 content=GenUtil.getHMvalue(customcontent_yahooad,"desc" );
}
if(content==null)content="";
request.setAttribute("YAHOOADS",content);


HashMap customcontent_ad=null;
customcontent_ad=CustomContentDB.getCustomContent("THEME_GOOGLE_AD", "13579");
if(customcontent_ad!=null){
content=GenUtil.getHMvalue(customcontent_ad,"desc" );
}
if(content==null)content="";
request.setAttribute("GEOOGLEADS",content);*/
/*####### END OF YAHOO AND GOOGLE ADS CONTENT ############*/

%>

<%
Vector notices=EventsContent.getAllNotices(groupid);
request.setAttribute("NOTICES",notices);
%>
<%
String totalsales=DbUtil.getVal("select sum(to_number(totalamount,'9999.99')) from transaction where refid=? and agentid=? ",new String[]{groupid,participantid});
request.setAttribute("TOTALSALES",totalsales);
%>
<jsp:include page='/customevents/eventinfo.jsp'/>
<jsp:include page='/customevents/ticket.jsp'/>
<jsp:include page='/customevents/agent.jsp'/>
<jsp:include page='/customevents/links.jsp'/>
<jsp:include page='/customevents/googlemap.jsp'/>
<%--
<jsp:include page='/customevents/sponsor.jsp'/>
--%>
<%--
#######Commented by rajesh, based on requirement.04/04/2007 Now ADS content added in above #############
<jsp:include page='/customevents/contentbeelets.jsp'/

>--%>


<jsp:include page='/main/Themebeeheader.jsp' />
<jsp:include page='/main/eventfooter.jsp' />

<%
String header="";
String footer=null;

String hasheader=DbUtil.getVal("select 'yes' from layout_config where refid=? and idtype=?",new String [] {groupid,"eventdetails"});
		if("yes".equals(hasheader)){
			DBManager dbmanager=new DBManager();
			StatusObj statobj=dbmanager.executeSelectQuery("select * from configure_looknfeel where refid=? and idtype=? ",new String []{groupid,"eventdetails"});
			if(statobj.getStatus()){
				header=dbmanager.getValue(0,"headerhtml",null);
				footer=dbmanager.getValue(0,"footerhtml",null);
			}
		}

String preview=request.getParameter("preview");

if("eventdetails".equalsIgnoreCase(preview))
{
	request.setAttribute("BASIC_EVENT_HEADER",request.getParameter("headerhtml"));
	request.setAttribute("BASICEVENTFOOTER",request.getParameter("footerhtml"));


}else{
	if(header!=null)
		request.setAttribute("BASIC_EVENT_HEADER",header);
	if(footer!=null && !"".equals(footer))
		request.setAttribute("BASICEVENTFOOTER",footer);
	}
%>


<%--
String attendephotourl=null; 
String requestid=request.getParameter("sponsorrequestid");
HashMap hmap=new HashMap();
Vector vec=new Vector();
String sponsor_transaction_id=null;
vec=EventsContent.getSponsorRequestInfo(vec,requestid);
for(int i=0;i<vec.size();i++){
hmap=(HashMap)vec.elementAt(i);
}
String sponsormessage=GenUtil.textToHtml(GenUtil.getHMvalue(hmap,"sponsormessage",""));
attendephotourl=(String)hmap.get("photourl");

if (attendephotourl!="" && attendephotourl==null )

attendephotourl="<img src='"+EbeeConstantsF.get("thumbnail.photo.image.webpath","")+"/"+(String)hmap.get("photourl")+"' />";
else
attendephotourl=null;
sponsor_transaction_id=GenUtil.getHMvalue(hmap,"transactionid","");
String sponsor_request_name="<a href='"+ShortUrlPattern.get(GenUtil.getHMvalue(hmap,"loginname",""))+"/network'>"+GenUtil.getHMvalue(hmap,"name","")+"</a>";
request.setAttribute("SPONSORREQUESTNAME",sponsor_request_name);
request.setAttribute("SPONSORMESSAGE",sponsormessage);
request.setAttribute("ATTENDEPHOTOURL",attendephotourl);



String sponsormefrom="";
String main_event_link=null;
String displayed=null;

if (requestid!=null){
	sponsormefrom+="<form name='sponsorme' action='/portal/sponsorpatron/checkSponsorRequestStatus.jsp' method='post' />";
	sponsormefrom+="<input type='hidden' name='GROUPID' value='"+groupid+"' />";
	sponsormefrom+="<input type='hidden' name='transactionid' value='"+sponsor_transaction_id+"'/>";
	sponsormefrom+="<input type='submit' name='submit' value='Sponsor Me'/>";
	sponsormefrom+="</form>";
	main_event_link="<a href="+ShortUrlPattern.get(loginname)+"/event?eventid="+request.getParameter("eventid")+" >"+"Visit Main Event Page"+"</a>";
	registerform=""; 
	buttonmsgform=""; 
	selectagents=null; 
	emailfriendButton=null; 
	eventprintableversionButton=null; 
	addCalendarButton=null; 
	emailfriendLink=null;
	addCalendarLink=null;
	addBlogLink=null;
	listeddate=null;
	userfullnamelink=null;
	mgr_email=null;
	vm_pub=null;
	description="";
	displayed="yes";
	requestforsponsor=null;
	header=null;
	f2fTagline=null;
	agents=null;
	groupheader=null;
	event_link=null;
	sponsormgrheader=null;
	topsellers=null;
	notices=null;
	 }
 --%>

