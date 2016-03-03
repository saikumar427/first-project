<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%
String eventtab="maintab1";
String othertab="maintab2";
String bottomtab="tab1";
boolean tabexists=true;

boolean loggedin=(com.eventbee.general.AuthUtil.getAuthData(pageContext)!=null);
String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
String serveraddress_https="https://"+EbeeConstantsF.get("sslserveraddress","www.desihub.com");

StringBuffer sbuffer=new StringBuffer();

sbuffer.append("<table border='0' width1='100%' width='800' cellspacing='0' cellpadding='0' class='portalback' align='center' >");
sbuffer.append("<tr><td align='center' valign='top' >");

sbuffer.append("<table border='0' width='100%' cellspacing='0' cellpadding='0' class='portalback' height='100%'>");
sbuffer.append("<tr><td align='center'><link rel='stylesheet' href='"+((request.isSecure())?serveraddress_https:serveraddress)+"/home/index.css' type='text/css'/>");
sbuffer.append("<script language='javascript' src='/home/js/popup.js'>");
sbuffer.append(" function dummy(){}");
sbuffer.append("</script>");


	sbuffer.append("<table width='100%' border='0' cellpadding='0' cellspacing='0' align='center'>");
		sbuffer.append(" <tr>");
			sbuffer.append("    <td width='300' height='0' />");
			sbuffer.append("   <td width='5' />");
			sbuffer.append("  <td width='450' />");
			sbuffer.append("   <td width='5' />");
			sbuffer.append("   <td width='10' />");
		sbuffer.append(" </tr>");
		sbuffer.append(" <tr>");
			sbuffer.append("  <td height='5'></td>");
			sbuffer.append("  <td></td>");

			sbuffer.append("  <td></td>");
			sbuffer.append("  <td></td>");
			sbuffer.append("  <td></td>");
		sbuffer.append(" </tr>");
		sbuffer.append(" <tr>");
		sbuffer.append("<td colspan='5' valign='top' width='30%'>");
			sbuffer.append("<table width='100%' border='0' cellpadding='0' cellspacing='0' >");
			sbuffer.append(" <tr>");
				sbuffer.append("<td width='250' height='25' >");
				sbuffer.append("<div align='left'>");
				sbuffer.append("<a href='"+serveraddress +"/portal/home.jsp'>");
				sbuffer.append("<img src='/home/images/logo_big.jpg' border='0' height='75'/></a></div>");
			sbuffer.append("</td></tr>");
			sbuffer.append("</table>");
		sbuffer.append("</td>");

		sbuffer.append("<td><table width='100%' align='center' cellpadding='0' cellspacing='0'>");
		sbuffer.append("<tr>");
			sbuffer.append("<td colspan='20' height='60' valign='middle' align='center'>");
			sbuffer.append("<div align='right'>");
if(!loggedin){
				sbuffer.append("<a href='"+serveraddress +"/portal/community.jsp' STYLE='text-decoration: none'>");
					sbuffer.append("<b><span class='linkfont'>Login</span></b>");
				sbuffer.append("</a>");
				sbuffer.append("<font face='Verdana, Arial, Helvetica, sans-serif' size='-2' color='#333333'> | </font>");
				sbuffer.append("<a href='"+serveraddress +"/portal/signup/signup.jsp?isnew=yes' STYLE='text-decoration: none'>");
					sbuffer.append("<b><span class='linkfont'>Sign Up</span></b>");
				sbuffer.append(" </a>");
}else{
				sbuffer.append("<a href='"+serveraddress +"/portal/community.jsp?logout=l' STYLE='text-decoration: none'>");
					sbuffer.append("<b><span class='linkfont' >Logout</span></b>");
				sbuffer.append("</a>");
				sbuffer.append("<font face='Verdana, Arial, Helvetica, sans-serif' size='-2' color='#333333'> | </font>");
				sbuffer.append("<a href=javascript:popupwindow('"+serveraddress +"'/home/links/help.html','','800','600'); STYLE='text-decoration: none'>");
					sbuffer.append("<b><span class='linkfont'>Help</span></b>");
				sbuffer.append("</a>");
}
				
				sbuffer.append(" </div>");
			sbuffer.append("</td>");
		sbuffer.append(" </tr>");
		sbuffer.append("<tr align='right' id='maintab'>");
			sbuffer.append("<td  class='"+eventtab+"' >");
				sbuffer.append(" <div align='center'><a href='"+serveraddress +"/portal/eventdetails/events.jsp?evttype=event' >");
				sbuffer.append("Events </a></div>");
				//sbuffer.append(" <div align='center'> <a href='"+serveraddress +"/portal/lifestyle/lifestyleview.jsp?UNITID=13579' >");
				//sbuffer.append("Lifestyle </a></div>");
			sbuffer.append("</td>");
			sbuffer.append("<td  class='"+othertab+"' >");
				sbuffer.append(" <div align='center'><a href='"+serveraddress +"/portal/eventdetails/events.jsp?evttype=class' >");
				sbuffer.append("Classes </a></div>");
				
				//sbuffer.append("<div align='center'> <a href='"+serveraddress +"/portal/hub/clubsview.jsp?UNITID=13579' >");
				//sbuffer.append("Hubs</a></div>");
			sbuffer.append("</td>");
			//sbuffer.append("<td class='"+othertab+"' >");
				//sbuffer.append(" <div align='center'><a href='"+serveraddress +"/portal/lifestyle/lifestyleview.jsp?evttype=activity&UNITID=13579' >");
				//sbuffer.append("Blogs </a></div>");
				//sbuffer.append("<div align='center'> <a href='"+serveraddress +"/portal/classifieds/classifiedview.jsp?purpose=classified&UNITID=13579' >");
				//sbuffer.append("Classifieds</a> </div>");
			//sbuffer.append("  </td>");
			//sbuffer.append(" <td  class='"+eventtab+"' >");
				//sbuffer.append(" <div align='center'><a href='"+serveraddress +"/portal/photogallery/photosview.jsp?UNITID=13579' >");
				//sbuffer.append("Photos </a></div>");
				//sbuffer.append("<div align='center'> <a href='"+serveraddress +"/portal/eventdetails/events.jsp?evttype=event&UNITID=13579' >");
				//sbuffer.append("Events</a> </div>");
			//sbuffer.append("</td>");
			sbuffer.append("<td  class='"+othertab+"' >");
				sbuffer.append(" <div align='center'><a href='"+serveraddress +"/portal/hub/clubsview.jsp' >");
				sbuffer.append("Communities </a></div>");
			sbuffer.append(" </td>");
			
			sbuffer.append("<td  class='"+othertab+"' >");
				sbuffer.append(" <div align='center'><a href='"+serveraddress +"/portal/listtabs/moretab.jsp' >");
				sbuffer.append("More &raquo;</a></div>");
			sbuffer.append(" </td>");	
			/*      sbuffer.append("<div align='center'> <a href='"+serveraddress +"/portal/services/services.jsp?UNITID=13579' >");
				sbuffer.append("Services</a> </div>");
			sbuffer.append(" </td>");
			
			sbuffer.append("<td class='"+othertab+"' >");
			
				sbuffer.append(" <div align='center'><a href='"+serveraddress +"/portal/services/services.jsp?UNITID=13579' >");
				sbuffer.append("Services </a></div>");
				sbuffer.append("<div align='center'> <a href='"+serveraddress +"/portal/comments/logview.jsp?UNITID=13579' >");
				sbuffer.append(" Reviews</a> </div>");
			sbuffer.append("</td>");
			
			sbuffer.append("<td  class='"+othertab+"' >");
				sbuffer.append(" <div align='center'><a href='"+serveraddress +"/portal/classifieds/classifiedview.jsp?purpose=classified&UNITID=13579' >");
				sbuffer.append("Classifieds </a></div>");
				sbuffer.append(" <div align='center'> <a href='"+serveraddress +"/portal/photogallery/photosview.jsp?UNITID=13579' >");
				sbuffer.append(" Photos</a> </div>");
			sbuffer.append("</td>");
			//sbuffer.append("<td class='"+othertab+"' >");
			//	sbuffer.append(" <div align='center'> <a href='"+serveraddress +"/portal/news/news.jsp?UNITID=13579' >");
			//	sbuffer.append("News</a> </div>");
			//sbuffer.append(" </td>");*/
		sbuffer.append("</tr>");
		sbuffer.append("</table>");
	sbuffer.append("</td>");
	sbuffer.append("</tr>");
	sbuffer.append("<tr>");
	sbuffer.append("<td height='1' colspan='20' bgcolor='blue' ></td>");
     	sbuffer.append("</tr>");
    	sbuffer.append("</table>");
sbuffer.append(" </td>");
sbuffer.append("</tr>");
sbuffer.append("</table>");

	
	request.setAttribute("BASICEVENTHEADER",sbuffer.toString());
%>
<jsp:include page='basicnav.jsp' />
