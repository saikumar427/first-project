<%@ page import="java.util.*,java.sql.*" %>
<%@ page import="com.eventbee.event.EventsContent" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>

<%@ page import="com.eventbee.editevent.*" %>
<%@ page import="com.eventbee.event.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.eventpartner.*" %>
<%!

HashMap getGroupDetails(String eventid){
DBManager db=new DBManager();
HashMap hm=new HashMap();
StatusObj sb=db.executeSelectQuery("select g.event_groupid,group_title from user_groupevents u,group_events g where u.event_groupid=g.event_groupid and g.eventid=?",new String[]{eventid});
if(sb.getStatus()){
hm.put("event_groupid",db.getValue(0,"event_groupid",""));
hm.put("group_title",db.getValue(0,"group_title",""));
}
return hm;
}
%>
<%
String eventgroupid=request.getParameter("eventgroupid");
if(eventgroupid==null)
eventgroupid=(String)session.getAttribute("eventgroupid");
if(eventgroupid!=null)
session.setAttribute("eventgroupid",eventgroupid);
String groupid=Presentation.GetRequestParam(request, new String []{"eid","eventid", "id","GROUPID"});
String participantid=Presentation.GetRequestParam(request,  new String []{"pid","partnerid", "participantid","participant"});
String friendid=request.getParameter("friendid");
EditEventDB evtDB=new EditEventDB();
HashMap evtinfo=EventDB.getMgrEvtDetails(groupid);
HashMap confighm=evtDB.getEventInfo(groupid);
request.setAttribute("EVENT_INFORMATION",evtinfo);
request.setAttribute("EVENT_CONFIG_INFORMATION",confighm);
HashMap user=(HashMap)request.getAttribute("userhm");
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
String loginname=null;
if(user!=null)
loginname=(String)user.get("login_name");
String registerform="";
String eventname="";
String startdate="";
String enddate="";
String description="";
String mgr_email="";
String contact_label="";
String comments="";
String moreinfo="";
String state="";
String country="";
String phone="";
String descriptionlabel="";
String location="";
String address="";
String city="";
String endlabel="";
String startlabel="";
String printableversion="";
String emailtofriend="";
String rsvp_limit="";
String rsvp_count="";
String listeddate="";
String evtmgrname="";
String mgr_events_link="";
String userfullnamelink="";
String trackcode="";
String trckcode="";
String trackPartnerMessage="";
String trackPartnerPhoto="";
String configid="";
String confid="";
if(evtinfo!=null){
eventname=(String)evtinfo.get("eventname");
session.setAttribute("evtname",eventname);
evtmgrname=(String)evtinfo.get("loginname");
session.setAttribute("evtmgrname",evtmgrname);
startdate=(String)evtinfo.get("eventstartdate")+", "+(String)evtinfo.get("starttime");
enddate=(String)evtinfo.get("eventenddate")+", "+(String)evtinfo.get("endtime");
mgr_email="<a href=mailto:"+(String)evtinfo.get("email")+" >"+(String)evtinfo.get("email")+"</a>";
String desctype=GenUtil.getHMvalue(confighm,"descriptiontype","");
if("text".equalsIgnoreCase(desctype))
description=GenUtil.textToHtml(GenUtil.getHMvalue(evtinfo,"description",""),true);
else
description=GenUtil.getHMvalue(evtinfo,"description","");
trckcode=(String)session.getAttribute("trckcode");
trackcode=(String)session.getAttribute((String)evtinfo.get("eventid")+"_"+trckcode);
if(trackcode!=null){
trackPartnerMessage=DbUtil.getVal("select message from trackURLs where eventid=? and trackingcode=?",new String[]{(String)evtinfo.get("eventid"),trackcode});
if(trackPartnerMessage==null){
configid="select config_id from eventinfo where eventid=?";
confid=DbUtil.getVal(configid, new String[]{groupid});
trackPartnerMessage=DbUtil.getVal("select value from config where name='eventpage.logo.message' and config_id=?",new String[]{confid});
}
}else{
configid="select config_id from eventinfo where eventid=?";
confid=DbUtil.getVal(configid, new String[]{groupid});
trackPartnerMessage=DbUtil.getVal("select value from config where name='eventpage.logo.message' and config_id=?",new String[]{confid});
}
comments=GenUtil.textToHtml((String)evtinfo.get("comments"),true);
phone=(String)evtinfo.get("phone");
address=GenUtil.getCSVData(new String[]{(String)evtinfo.get("city"),(String)evtinfo.get("state"), (String)evtinfo.get("country")});
city=(String)evtinfo.get("city");
state=(String)evtinfo.get("state");
country=(String)evtinfo.get("country");
rsvp_limit="0".equals(GenUtil.getHMvalue(evtinfo,"rsvp_limit","",false))?"None":GenUtil.getHMvalue(evtinfo,"rsvp_limit","",false);
rsvp_count=GenUtil.getHMvalue(evtinfo,"rsvp_count","",false);
listeddate=GenUtil.getHMvalue(confighm,"display_date","");
}
String groupname="";
String groupUrl="";
if(eventgroupid!=null){
groupname=DbUtil.getVal("select group_title from user_groupevents where event_groupid=? ",new String[]{eventgroupid});
String participant=(participantid!=null)?participantid="&participantid="+participantid+"":"";
String friendids=(friendid!=null)?friendid="&friendid="+friendid+"":"";
groupUrl=serveraddress+"event?eid="+eventgroupid+participant+friendids;
}
String mgrid=DbUtil.getVal("select mgr_id from eventinfo where eventid=?",new String[]{(String)evtinfo.get("eventid")});
String partnerid=DbUtil.getVal("select partnerid from group_partner where userid=? and status='Active'",new String[]{mgrid});	
Map attribmap=PartnerDB.getStreamingAttributes(mgrid,partnerid);
String streamershow=GenUtil.getHMvalue(confighm,"eventpage.streamer.show","Yes");
String company=DbUtil.getVal("select company from user_profile where user_id=?",new String[]{mgrid});
 if(company!=null&&!"".equals(company)){
  userfullnamelink="<a href='"+ShortUrlPattern.get(loginname)+"/network' >Listed by "+company+"</a>";
  mgr_events_link="<a href='"+ShortUrlPattern.get(evtmgrname)+"/events' >View other events by "+company+"</a>";
if("ning".equals(session.getAttribute("platform"))){
userfullnamelink="Listed by "+company;
}
}
else{
mgr_events_link="<a href='"+ShortUrlPattern.get(evtmgrname)+"/events' >View other events by "+request.getAttribute("USERFULLNAME")+"</a>";
 userfullnamelink="<a href='"+ShortUrlPattern.get(loginname)+"/network' >Listed by "+request.getAttribute("USERFULLNAME")+"</a>";

if("ning".equals(session.getAttribute("platform"))){
userfullnamelink="Listed by "+request.getAttribute("USERFULLNAME");
}

}
%>
<%@ include file="userstreamer.jsp" %>
			
<%
//end of Partner Streamer

request.setAttribute("EVENTNAME",eventname);
request.setAttribute("STARDATE",startdate);
request.setAttribute("ENDDATE",enddate);
request.setAttribute("EVENTPHONENUMBER",phone);
request.setAttribute("EVENTCOMMENTS",comments);
request.setAttribute("DESCRIPTION",description);
request.setAttribute("MANAGEREMAIL",mgr_email);
request.setAttribute("EVENTLISTEDBY",userfullnamelink);
request.setAttribute("EVENTLISTEDON",listeddate);
request.setAttribute("RSVPCOUNT",rsvp_count);
request.setAttribute("RSVPLIMIT",rsvp_limit);
request.setAttribute("MGREVENTSLINK",mgr_events_link);
request.setAttribute("PARTNERSTREAMER",partnerstreamer);
request.setAttribute("TRACKMESSAGE",trackPartnerMessage);

if(!"".equals(groupUrl)){
request.setAttribute("GROUPURL",groupUrl);
request.setAttribute("GROUPNAME",groupname);

}
if("Yes".equals(streamershow))
	request.setAttribute("PARTNERSTREAMERSHOW",streamershow);

%>


<%
String GET_EVENT_PHOTO="select a.photourl as photourl,b.caption as caption from"
   +" eventinfo a,member_photos b where a.photourl=b.uploadurl and a.eventid=?";
boolean exists=false;
HashMap photohash=null;
String webpathname="photo.image.webpath";
String imgname="",caption="";
webpathname="big.photo.image.webpath";
DBManager dbmanager1=new DBManager();
StatusObj statobj1=dbmanager1.executeSelectQuery(GET_EVENT_PHOTO,new String[]{groupid} );
if(statobj1.getStatus()){
exists=true;
photohash=new HashMap();
for(int i=0;i<statobj1.getCount();i++){
imgname="<img src='"+EbeeConstantsF.get(webpathname,"")+"/"+dbmanager1.getValue(i,"photourl","")+"' />";
caption=dbmanager1.getValue(i,"caption","");
}
}
trckcode=(String)session.getAttribute("trckcode");
trackcode=(String)session.getAttribute((String)evtinfo.get("eventid")+"_"+trckcode);

if(trackcode!=null){
trackPartnerPhoto=DbUtil.getVal("select photo  from trackURLs where eventid=? and trackingcode=?",new String[]{groupid,trackcode});
if(trackPartnerPhoto!=null){
trackPartnerPhoto="<img src='"+trackPartnerPhoto+"' width='200'/>";
}else{
configid="select config_id from eventinfo where eventid=?";
confid=DbUtil.getVal(configid, new String[]{groupid});	
trackPartnerPhoto=DbUtil.getVal("select value  from config where name='eventpage.logo.url' and config_id=?",new String[]{confid});
if(trackPartnerPhoto!=null){
trackPartnerPhoto="<img src='"+trackPartnerPhoto+"' width='200'/>";
}
}
}else{
configid="select config_id from eventinfo where eventid=?";
confid=DbUtil.getVal(configid, new String[]{groupid});	
trackPartnerPhoto=DbUtil.getVal("select value  from config where name='eventpage.logo.url' and config_id=?",new String[]{confid});
if(trackPartnerPhoto!=null){
trackPartnerPhoto="<img src='"+trackPartnerPhoto+"' width='200'/>";
}
}
request.setAttribute("EVENTPHOTO",imgname);
request.setAttribute("TRACKPHOTO",trackPartnerPhoto);
request.setAttribute("EVENTPHOTOCAPTION",caption);
%>
