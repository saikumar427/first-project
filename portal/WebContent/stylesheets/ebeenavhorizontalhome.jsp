<%@ page import="com.eventbee.authentication.*,com.eventbee.general.*,java.util.*" %>
<%!
void getNavMap(String userid,String serveraddress,HashMap navmap){
navmap.put("My Pages",serveraddress+"/portal/myevents/myevents.jsp?type=Events");
navmap.put("My Profile",serveraddress+"/portal/editprofiles/memberprofile.jsp?isnew=yes&UNITID=13579");
navmap.put("My Page",serveraddress+"/portal/editprofiles/managemypage.jsp?userid="+userid+"&UNITID=13579");
navmap.put("My Preferences",serveraddress+"/portal/preferences/editpref.jsp?UNITID=13579");
navmap.put("My Settings",serveraddress+"/portal/editprofiles/memberprofile.jsp?type=Profile");
navmap.put("My Photos",serveraddress+"/portal/photoupload/photosmanage.jsp?UNITID=13579");
navmap.put("My Alerts",serveraddress+"/portal/alerts/myalert.jsp?UNITID=13579");
navmap.put("My Messages",serveraddress+"/portal/club/allMessages.jsp?UNITID=13579");
navmap.put("My Network",serveraddress+"/portal/nuser/mynethome.jsp?UNITID=13579");
navmap.put("My Guestbook",serveraddress+"/portal/guestbook/GBookManage.jsp?UNITID=13579");
navmap.put("My Hubs",serveraddress+"/portal/club/myhubs.jsp?UNITID=13579");
navmap.put("My Beehives",serveraddress+"/portal/club/myhubs.jsp?UNITID=13579");
navmap.put("My Surveys",serveraddress+"/portal/club/mysurveyspolls.jsp?UNITID=13579");
navmap.put("My Events",serveraddress+"/portal/myevents/myevents.jsp?type=Events&UNITID=13579");
navmap.put("My Classifieds",serveraddress+"/portal/classifieds/mypostings.jsp?UNITID=13579&GROUPID=13579");
navmap.put("My Services",serveraddress+"/portal/services/myservices.jsp?UNITID=13579");
navmap.put("My Reviews",serveraddress+"/portal/comments/mylogs.jsp?UNITID=13579");
navmap.put("My Photologs",serveraddress+"/portal/photologs/mylogs.jsp?UNITID=13579");
navmap.put("My Campaigns",serveraddress+"/portal/emailmarketing/marketing.jsp?UNITID=13579");
navmap.put("My Invitations",serveraddress+"/portal/invitation/invitation.jsp?UNITID=13579");
navmap.put("Logout",serveraddress+"/portal/community.jsp?logout=l&UNITID=13579");
navmap.put("My Lifestyle",serveraddress+"/portal/lifestyle/lifestyle.jsp?UNITID=13579");
navmap.put("My Fundraising",serveraddress+"/portal/fundraising/fundraisingview.jsp?UNITID=13579");
navmap.put("My Email Marketing",serveraddress+"/portal/emailmarketing/marketing.jsp");
navmap.put("My Themes",serveraddress+"/portal/mythemes/mythemes.jsp");
}
%>

<%
StringBuffer sb=new StringBuffer();
if(com.eventbee.general.AuthUtil.getAuthData(pageContext) !=null){

	String club_title=EbeeConstantsF.get("club.label","Bee Hive");
	System.out.println("club_title value is--------------"+club_title);
	String code=("Community".equalsIgnoreCase(club_title))?"My Beehives":"My Hubs";

	Authenticate authData=(Authenticate) com.eventbee.general.AuthUtil.getAuthData(pageContext);
	String userid=authData.getUserID();
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");

%>
<%
HashMap navmap=new HashMap();
getNavMap(userid,serveraddress,navmap);
String [] desinav={"My Lifestyle","My Hubs","My Classifieds","My Services","My Events","My Reviews","My Fundraising","My Surveys"};

String [] desisubtabs={"mylifestyle","myclubs","myclassifieds","service","My Events","weblogs","My Fundraising","My Surveys"};


boolean disupgradeimg=false;



com.eventbee.myaccount.MyAccount myacct=(com.eventbee.myaccount.MyAccount)authData.UserInfo.get("MyAccount");

if(myacct !=null){
 desinav=myacct.getLabelsofFeatures();

desisubtabs=myacct.getFeatures();

if("Basic".equalsIgnoreCase(myacct.getNameOFAccount() ) )disupgradeimg=true;

}

String [] ebeenav={"My Pages","My Email Marketing","My Themes","My Settings"};
		
String [] ebeesubtabs={"My Pages","My Email Marketing","My Themes","My Settings"};
String [] navs=null;
String [] subtabs=null;



if("My Hubs".equals(code)){
navs=desinav;
subtabs=desisubtabs;
}else{
navs=ebeenav;
subtabs=ebeesubtabs;
}

//sb.append("<table width='100%' border='0' cellpadding='0' cellspacing='0'  valign='top' bgcolor='#FFFFFF' >");
//sb.append("<tr> <td  align='left' valign='top'>");

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
	}sb.append("<a STYLE='text-decoration:none'  href='"+navmap.get(navs[i].trim())+"'>  <span class='menufont'>"+navs[i]+"</span></a>");
	if(i !=navslength-1 ){
		  sb.append("  | ");
	}
	}
if(disupgradeimg) {
//sb.append("<td align='right'><a href='/portal/accountupgrade/upgrade.jsp?UNITID=13579' style='text-decoration:none'> <img src='/home/images/upgrade.gif' border='0' /> </a></td>");
}
sb.append("<div><table width='100%'> <tr height='1' bgcolor='blue' width='100%'><td colspan='20'></td></tr></table></div>");

 }%>
<%=sb.toString()%>








