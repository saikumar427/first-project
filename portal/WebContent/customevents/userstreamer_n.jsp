<%@ page import="com.eventbee.eventpartner.*" %>
<%@ page import="com.eventbee.general.*" %>
<%@ page import="java.util.*" %>

<%

String serveraddress="http://"+EbeeConstantsF.get("serveraddress","")+"/";
String mgrid=request.getParameter("mgrid");

String partnerid=DbUtil.getVal("select partnerid from group_partner where userid=? and status='Active'",new String[]{mgrid});	


Map attribmap=PartnerDB.getStreamingAttributes(mgrid,partnerid);
	
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "in userstreamer.jsp", "in userstreamer.jsp", "attribmap is-------"+attribmap,null);
String title=GenUtil.getHMvalue(attribmap,"TITLE","");

if("".equals(title)||title==null) title="Recommended Events";
String retrievecount=GenUtil.getHMvalue(attribmap,"NO_OF_ITEMS","5");
String category=GenUtil.getHMvalue(attribmap,"CATEGORY","ALL");

String streamsize=GenUtil.getHMvalue(attribmap,"STREAMERSIZE","250");

String bgcolor=GenUtil.getHMvalue(attribmap,"BACKGROUND","#dce8ff");
String bigtextcolor=GenUtil.getHMvalue(attribmap,"BIGGER_TEXT_COLOR","#000000");
String bigfonttype=GenUtil.getHMvalue(attribmap,"BIGGER_FONT_TYPE","Verdana");
String bigfontsize=GenUtil.getHMvalue(attribmap,"BIGGER_FONT_SIZE","15px");

String medtextcolor=GenUtil.getHMvalue(attribmap,"MEDIUM_TEXT_COLOR","#000000");
String medfonttype=GenUtil.getHMvalue(attribmap,"MEDIUM_FONT_TYPE","Verdana");
String medfontsize=GenUtil.getHMvalue(attribmap,"MEDIUM_FONT_SIZE","11px");

String smalltextcolor=GenUtil.getHMvalue(attribmap,"SMALL_TEXT_COLOR","#D3D3D3");
String smallfonttype=GenUtil.getHMvalue(attribmap,"SMALL_FONT_TYPE","Verdana");
String smallfontsize=GenUtil.getHMvalue(attribmap,"SMALL_FONT_SIZE","8px");


String bordercolor=GenUtil.getHMvalue(attribmap,"BORDERCOLOR","#660033");
String linkcolor=GenUtil.getHMvalue(attribmap,"LINKCOLOR","#3300CC");
//String displaypowerlink=GenUtil.getHMvalue(attribmap,"DISPLAYEBEELINK","yes");
String displaypowerlink="no";

String str="";
if(title.indexOf("'")>-1){
	title=title.replaceAll("'","&#39;");
}
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, "in userstreamer.jsp", "in userstreamer.jsp", "title is-------"+title,null);
str="title="+title;
str=str+"&partnerid="+partnerid;

str=str+"&retrievecount="+retrievecount;
str=str+"&category="+category;
str=str+"&streamsize="+streamsize;

if(bgcolor.startsWith("http"))
	str=str+"&background=url("+bgcolor+")";
else
	str=str+"&background="+java.net.URLEncoder.encode(bgcolor);

str=str+"&bordercolor="+java.net.URLEncoder.encode(bordercolor);
str=str+"&linkcolor="+java.net.URLEncoder.encode(linkcolor);
str=str+"&bigtextcolor="+java.net.URLEncoder.encode(bigtextcolor);
str=str+"&bigfonttype="+java.net.URLEncoder.encode(bigfonttype);
str=str+"&bigfontsize="+java.net.URLEncoder.encode(bigfontsize);
str=str+"&medtextcolor="+java.net.URLEncoder.encode(medtextcolor);
str=str+"&medfonttype="+java.net.URLEncoder.encode(medfonttype);
str=str+"&medfontsize="+java.net.URLEncoder.encode(medfontsize);
str=str+"&smalltextcolor="+java.net.URLEncoder.encode(smalltextcolor);
str=str+"&smallfonttype="+java.net.URLEncoder.encode(smallfonttype);
str=str+"&smallfontsize="+java.net.URLEncoder.encode(smallfontsize);
str=str+"&displaypowerlink="+displaypowerlink;

String width=(String)request.getParameter("cols");
String height=(String)request.getParameter("rows");
String streamerurl=serveraddress+"portal/streaming/partnerstreaming_js.jsp?"+str;
String partnerstreamer="<script language=\"javascript\" src='"+streamerurl+"'></script>" ;
request.setAttribute("PARTNERSTREAMER",partnerstreamer);
%>