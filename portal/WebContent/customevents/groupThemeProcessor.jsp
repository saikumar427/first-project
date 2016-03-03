<%@ page import="java.io.*, java.util.*,java.util.regex.*,java.sql.*" %>
<%@ page import="org.apache.oro.text.regex.*" %>
<%@ page import="com.themes.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="org.apache.velocity .*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
<%@ page import="com.eventbee.streamer.*"%>

<%!
String CLASS_NAME="customevents/groupThemeProcessor.jsp";
%>
<%@ include file='groupeventscontent.jsp' %>
<%
String userid=(String)request.getAttribute("userid");
if(userid==null)
 userid=DbUtil.getVal("select userid from user_groupevents where event_groupid=?",new String[]{event_groupid});
String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
String templatedata="";
String templatecss="";
String themetype=null;
String deftheme=null;
String [] themedata=null;
String thememodule=null;
String themeexist="yes";
String customcss="";





Vector vec1=(Vector)request.getAttribute("GROUP_EVENTS");

if(vec1!=null&&vec1.size()>0){

for(int i=0;i<vec1.size();i++){
HashMap eventmap=(HashMap)vec1.elementAt(i);
String eventid=(String)eventmap.get("eventid");

if(session.getAttribute("Custom_"+eventid)!=null){
session.removeAttribute("Custom_"+eventid);
}


}

}







if("ning".equals(session.getAttribute("platform")))
thememodule="groupevent_ning";
else
thememodule="groupevent";

String [] themeNameandType=ThemeController.getThemeCodeAndType(thememodule,event_groupid,"basic");
themetype=themeNameandType[0];
deftheme=themeNameandType[1];
thememodule=themeNameandType[3];
if(thememodule==null)
thememodule="groupevent"; 
if("ning".equals(session.getAttribute("platform"))){
if("DEFAULT".equals(themetype)&&"groupevent_ning".equals(thememodule)){
themeexist=DbUtil.getVal("select 'yes' from ebee_roller_def_themes where themecode=? and module=?",new String[]{deftheme,"groupevent_ning"});
if(!"yes".equals(themeexist))
deftheme="basic";
}
themedata=ThemeController.getSelectedThemeData(userid,thememodule,deftheme,"groupevent_ning",event_groupid,themetype);
}
else
{
if("DEFAULT".equals(themetype)&&"groupevent".equals(thememodule)){
themeexist=DbUtil.getVal("select 'yes' from ebee_roller_def_themes where themecode=? and module=?",new String[]{deftheme,"groupevent"});
if(!"yes".equals(themeexist))
deftheme="basic";
}
themedata=ThemeController.getSelectedThemeData(userid,thememodule,deftheme,"groupevent",event_groupid,themetype);
}


customcss=themedata[0];
templatedata=themedata[1];
customcss=customcss.replaceAll("/roller",rollercontext);
customcss=customcss.replaceAll("\\$customappctx",rollercontext);

try{
	VelocityContext context = new VelocityContext();
context.put ("customcss",customcss  );	
context.put ("eventName",request.getAttribute("GROUP_NAME"));
context.put ("groupevents",request.getAttribute("GROUP_EVENTS"));
context.put ("eventListedBy",request.getAttribute("GROUPEVENTLISTEDBY") );
context.put ("eventbeeHeader","" );
context.put ("eventbeeFooter",request.getAttribute("BASICEVENTFOOTER") );
context.put ("mgrEventsLink",request.getAttribute("MGREVENTSLINK"));
context.put ("eventbeeFooter",request.getAttribute("BASICEVENTFOOTER") );
context.put ("contactMgrlink",request.getAttribute("CONTACTMGRLINK") );
context.put ("contactMgrlink",request.getAttribute("CONTACTMGRLINK") );
context.put ("emailToFriendLink",request.getAttribute("EMAILTOFRIENDLINK") );
context.put ("creditCardLogos",request.getAttribute("CREDITCARDLOGOS") );
context.put ("eventURL",request.getAttribute("EVENTURL"));	
	 
	
VelocityEngine ve= new VelocityEngine(); ve.init();boolean abletopares=ve.evaluate(context,out,"ebeetemplate", templatedata );

}
catch(Exception exp){
	out.println(exp.getMessage());

}
	
%>
