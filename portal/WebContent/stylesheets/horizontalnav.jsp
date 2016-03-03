<%@ page import="com.eventbee.authentication.*,com.eventbee.general.*,java.util.*" %>
<%!
void getNavMap(String userid,String serveraddress,HashMap navmap){
navmap.put("My Pages",serveraddress+"/portal/myevents/myevents.jsp?type=Events");
	navmap.put("My Email Marketing",serveraddress+"/portal/emailmarketing/marketing.jsp");
	//navmap.put("My Surveys",serveraddress+"/portal/club/mysurveyspolls.jsp");
	//navmap.put("My Communities",serveraddress+"/portal/club/myhubs.jsp");
	navmap.put("My Services",serveraddress+"/portal/services/myservices.jsp");
	navmap.put("My Classifieds",serveraddress+"/portal/classifieds/mypostings.jsp?GROUPID=13579");
	//navmap.put("My Social Network",serveraddress+"/portal/nuser/NuserFriends.jsp?type=Friends");
	navmap.put("My Settings",serveraddress+"/portal/editprofiles/memberprofile.jsp?type=Profile");
	navmap.put("My Themes",serveraddress+"/portal/mythemes/mythemes.jsp");
	navmap.put("Eventbee Partner Network",serveraddress+"/portal/eventpartner/partnernetwork.jsp");
}
%>
<%
StringBuffer sb=new StringBuffer();
if(com.eventbee.general.AuthUtil.getAuthData(pageContext) !=null){

	String club_title=EbeeConstantsF.get("club.label","Bee Hive");
	String code=("Communities".equalsIgnoreCase(club_title))?"My Communities":"My Hubs";

	Authenticate authData=(Authenticate) com.eventbee.general.AuthUtil.getAuthData(pageContext);
	String userid=authData.getUserID();
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");

%>
<%
HashMap navmap=new HashMap();
getNavMap(userid,serveraddress,navmap);

String [] navs=new String [0];
		
String [] subtabs=new String [0];

boolean disupgradeimg=false;


com.eventbee.myaccount.MyAccount myacct=(com.eventbee.myaccount.MyAccount)authData.UserInfo.get("MyAccount");


if(myacct !=null){
navs=myacct.getLabelsofFeatures();
subtabs=myacct.getFeatures();
//if("Basic".equalsIgnoreCase(myacct.getNameOFAccount() ) )disupgradeimg=true;
if(authData.getAccountType()==null||"Basic".equalsIgnoreCase(authData.getAccountType()) )disupgradeimg=true;
}
sb.append("<table width='100%' border='0' cellpadding='0' cellspacing='0'  valign='top' bgcolor='#FFFFFF' >");
sb.append("<tr> <td  align='left' valign='top'>");

	String subtab_type=(String)request.getAttribute("subtabtype");
        if("LFPhotom".equals(subtab_type)) subtab_type="mylifestyle";
	int navslength=navs.length;
	
	for(int i=0;i<navs.length;i++){
	String subtabclass="menutab";
	String pointerimg="";
	String fcolor="#339933";
	if(subtabs[i].equals(subtab_type) )
	{
	subtabclass="selectedmenutab";
	fcolor="#FFFFFF";
	pointerimg="<img src='/home/images/pointervertical.gif'/>";
	request.setAttribute("displaydesiborderfull","true");
	}
	
sb.append("<table cellpadding='0' cellspacing='0' align='left' border='0'>");
sb.append("<tr>");
sb.append("<td valign='center' align='left'>");
                                                           
sb.append("<a STYLE='text-decoration:none'  href='"+navmap.get(navs[i])+"'>  <span class='menufont'>"+navs[i]+"</span></a>");
sb.append("</td>");
sb.append("<td align='center'>"+pointerimg +"</td>");
sb.append("<td>");
	if(i !=navslength-1 ){
		  sb.append(" &nbsp;|&nbsp;");
	}
		   sb.append("</td>");
		   sb.append("</tr>");
sb.append("</table>");
	}
sb.append("</td>");
if(disupgradeimg) {
sb.append("<td align='right'><a href='/portal/accountupgrade/upgrade.jsp' style='text-decoration:none'> <img src='/home/images/upgrade.gif' border='0' /> </a></td>");
}
//sb.append("</tr>");
sb.append("</tr> <tr height='2' bgcolor='blue' ><td colspan='20'></td></tr>");
sb.append("</table>");
     }else{
sb.append("<table width='1' border='0' cellpadding='0' cellspacing='0' >");
sb.append("<tr><td ></td></tr>");
sb.append("</table>");
 }%>








