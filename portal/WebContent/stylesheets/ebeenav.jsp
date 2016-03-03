<%@ page import="com.eventbee.authentication.*,com.eventbee.general.*,java.util.*" %>
<%!
void getNavMap(String userid,String serveraddress,HashMap navmap){
navmap.put("My Profile",serveraddress+"/portal/editprofiles/memberprofile.jsp?isnew=yes");
navmap.put("My Page",serveraddress+"/portal/editprofiles/managemypage.jsp?userid="+userid);
navmap.put("My Preferences",serveraddress+"/portal/preferences/editpref.jsp");
navmap.put("My Settings",serveraddress+"/portal/preferences/editpref.jsp");
navmap.put("My Photos",serveraddress+"/portal/photoupload/photosmanage.jsp");
navmap.put("My Alerts",serveraddress+"/portal/alerts/myalert.jsp");
navmap.put("My Messages",serveraddress+"/portal/club/allMessages.jsp");
//navmap.put("My Network",serveraddress+"/portal/nuser/NuserFriends.jsp?UNITID=13579");
navmap.put("My Network",serveraddress+"/portal/nuser/mynethome.jsp");
navmap.put("My Guestbook",serveraddress+"/portal/guestbook/GBookManage.jsp");
navmap.put("My Hubs",serveraddress+"/portal/club/myhubs.jsp");
navmap.put("My Communities",serveraddress+"/portal/club/myhubs.jsp");
navmap.put("My Surveys",serveraddress+"/portal/club/mysurveyspolls.jsp");
navmap.put("My Events",serveraddress+"/portal/myevents/myevents.jsp?type=Events");
navmap.put("My Classifieds",serveraddress+"/portal/classifieds/mypostings.jsp?GROUPID=13579");
navmap.put("My Services",serveraddress+"/portal/services/myservices.jsp");
navmap.put("My Reviews",serveraddress+"/portal/comments/mylogs.jsp");
navmap.put("My Photologs",serveraddress+"/portal/photologs/mylogs.jsp");
navmap.put("My Campaigns",serveraddress+"/portal/emailmarketing/marketing.jsp");
navmap.put("My Invitations",serveraddress+"/portal/invitation/invitation.jsp");
navmap.put("Logout",serveraddress+"/portal/community.jsp?logout=l");
navmap.put("My Lifestyle",serveraddress+"/portal/lifestyle/lifestyle.jsp");
}
%>
<%
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
/*String [] desinav={"My Network","My Hubs","My Classifieds","My Services","My Events","My Invitations","My Photos",
                  "My Weblogs","My Photologs","My Surveys","My Alerts","My Messages","My Guestbook","My Preferences","My Profile",
		  "My Page","Logout"};

String [] desisubtabs={"mynetwork","myclubs","myclassifieds","service","My Events","My Invitations","My Photos",
                  "weblogs","photologs","My Surveys","My Alerts","mymessages","My Guestbook","My Preferences","My Profile",
		  "My Page","Logout"};
*/
String [] desinav={"My Lifestyle","My Hubs","My Classifieds","My Services","My Events","My Reviews","My Settings","Logout"};

String [] desisubtabs={"mylifestyle","myclubs","myclassifieds","service","My Events","weblogs","My Settings","Logout"};

String [] ebeenav={"My Events","My Campaigns","My Surveys","My Invitations","My Classifieds",
		"My Services","My Communities","My Messages","My Profile","My Page","My Photos","My Photologs",
		"My Network","My Guestbook","My Alerts","My Preferences","Logout"};
		
String [] ebeesubtabs={"My Events","My Campaigns","My Surveys","My Invitations","myclassifieds",
		"service","myclubs","mymessages","My Profile","My Page","My Photos","photologs",
		"mynetwork","My Guestbook","My Alerts","My Preferences","Logout"};
String [] navs=null;
String [] subtabs=null;

if("My Hubs".equals(code)){
navs=desinav;
subtabs=desisubtabs;
}else{
navs=ebeenav;
subtabs=ebeesubtabs;
}
%>


	<table width="122" border="0" cellpadding="0" cellspacing="0"  height="100%">
          <tr>
            <td width="5" height="10"></td>
            <td width="116" height="10"></td>
            <td width="1" height="10"></td>
          </tr>
          <tr>
            <td height1="349" width="5"></td>
            <td valign="top" width="116">
              <table border1='2' cellpadding='0' cellspacing='0' align='left' bordercolor="#CCCCCC" width="116">
	<%
	
	/*String tempnav=null;
	String tempsubtab=null;
	String ttype=(String)request.getAttribute("subtabtype");
	int k=0;
	for(int j=0;j<navs.length;j++){
		if(subtabs[j].equals(ttype))
		{
		tempnav=navs[j];
		tempsubtab=subtabs[j];
			for(k=j;k>0;k--)
			{
			navs[k]=navs[k-1];
			subtabs[k]=subtabs[k-1];
			}

			navs[k]=tempnav;
			subtabs[k]=tempsubtab;
			break;
		}
	}*/


	for(int i=0;i<navs.length;i++){
	String subtabclass="menutab";
	String pointerimg="";
	String fcolor="#339933";
	if(subtabs[i].equals((String)request.getAttribute("subtabtype")))
	{
	subtabclass="selectedmenutab";
	fcolor="#FFFFFF";
	pointerimg="<img src='/home/images/pointer.gif'/>";
	}

	%>
                <tr>
                  <td height='30' class='<%=subtabclass%>' align='left' valign='center' >
                  <a STYLE="text-decoration:none"
                  href='<%=navmap.get(navs[i]) %>'>
                    <font  color=<%=fcolor%>><%=navs[i]%></font></a> </td><td><%=pointerimg%></td>
                </tr>
		<tr><td height='5'/></tr>
	<%}%>
              </table>
            </td>
            <td width="1"></td>
          </tr>
          <tr>
            <td height="20" width="5"></td>
            <td width="116"></td>
            <td width="1"></td>
          </tr>
	  </table>
      <%}else{%>
      <table width="1" border="0" cellpadding="0" cellspacing="0"  height="100%">
      	<tr><td ></td></tr>
      </table>
 <%}%>


