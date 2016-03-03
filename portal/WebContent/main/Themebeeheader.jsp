<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ include file="../getresourcespath.jsp" %>
<%
String [] tab_array={"event","activity","class","club","classified","volunteer","photos","service","more"};
String eventtab="event".equals((String)request.getAttribute("tabtype"))?"maintab1":"maintab2";
String activitytab="activity".equals((String)request.getAttribute("tabtype"))?"maintab1":"maintab2";
String classtab="class".equals((String)request.getAttribute("tabtype"))?"maintab1":"maintab2";
String clubtab="club".equals((String)request.getAttribute("tabtype"))?"maintab1":"maintab2";
String classifiedtab="classified".equals((String)request.getAttribute("tabtype"))?"maintab1":"maintab2";
String volunteertab="volunteer".equals((String)request.getAttribute("tabtype"))?"maintab1":"maintab2";
String phototab="photos".equals((String)request.getAttribute("tabtype"))?"maintab1":"maintab2";
String hometab="home".equals((String)request.getAttribute("tabtype"))?"maintab1":"maintab2";
String communitytab="community".equals((String)request.getAttribute("tabtype"))?"maintab1":"maintab2";
String servicetab="service".equals((String)request.getAttribute("tabtype"))?"maintab1":"maintab2";
String bottomtab="maintab1";
String blogtab="blog".equals((String)request.getAttribute("tabtype"))?"maintab1":"maintab2";

String moretab="more".equals((String)request.getAttribute("tabtype"))?"maintab1":"maintab2";

boolean tabexists=false;

for(int i=0;i<tab_array.length;i++){
	if(tab_array[i].equals((String)request.getAttribute("tabtype"))){
	tabexists=true;
	break;
	}
}
bottomtab=((String)request.getAttribute("tabtype")==null||(!tabexists))?"tab1":"tab1";


boolean loggedin=(com.eventbee.general.AuthUtil.getAuthData(pageContext)!=null);

String serveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
String serveraddress_https="https://"+EbeeConstantsF.get("sslserveraddress","www.eventbee.com");
StringBuffer sbuffer=new StringBuffer();



sbuffer.append("<link rel='stylesheet' href='"+serveraddress +"/home/index.css' type='text/css'/>");
sbuffer.append("<script language='javascript' src='"+resourceaddress+"/home/js/popup.js'>");
sbuffer.append(" function dummy(){}");
sbuffer.append("</script>");

sbuffer.append("<table border='0' width='840' cellspacing='0' cellpadding='0' class='portalback' >");
sbuffer.append("<tr><td align='center'>");

sbuffer.append("<table width='100%' border='0' cellpadding='0' cellspacing='0' align='center'>");
sbuffer.append("<tr height='10'>");
 sbuffer.append("<td width='300' height='0' />");
    sbuffer.append("<td width='5' />");
    sbuffer.append("<td width='450' />");
    sbuffer.append("<td width='5' />");
    sbuffer.append("<td width='10' />");
  sbuffer.append("</tr>");
sbuffer.append("<tr>");

    sbuffer.append("<td width='53%' valign='top' height='50' colspan='5'>");



		sbuffer.append("<table width='100%' border='0' cellpadding='0' cellspacing='0'>");
			sbuffer.append("<tr>");
			  sbuffer.append("<td height='65' valign='bottom' width='19%'>");
			    sbuffer.append("<div align='left'><a href='"+serveraddress +"/portal/home.jsp'>");
			    sbuffer.append("<img src='"+resourceaddress+"/home/images/logo_big.jpg' border='0'/></a></div>");
			  sbuffer.append("</td></tr>");
		sbuffer.append("</table>");
		 
	sbuffer.append("<td width='47%' height='10' valign='top' >");
		sbuffer.append("<table width='100%' align='center' border='0' cellpadding='5' cellspacing='0'><tr>");
			sbuffer.append("<td width='50%' colspan='20' height='40' valign='middle' align='center'>");
			  sbuffer.append("<div align='right'>");
			   sbuffer.append("<a href='"+serveraddress+"' STYLE='text-decoration: none'>");
			  sbuffer.append("<b><span class='linkfont'>Eventbee</span></b>");
			  sbuffer.append("</a><font face='Verdana, Arial, Helvetica, sans-serif' size='-2' color='#333333'> | </font>");

			  if(!loggedin){
				  sbuffer.append("<a href='"+serveraddress +"/portal/community.jsp' STYLE='text-decoration: none'>");
				  sbuffer.append("<b><span class='linkfont'>Login</span></b>");
				  sbuffer.append("</a>");
				  sbuffer.append("<font face='Verdana, Arial, Helvetica, sans-serif' size='-2' color='#333333'> | </font>");
				   sbuffer.append("<a href='"+serveraddress +"/portal/guesttasks/signup.jsp?isnew=yes&entryunitid=13579' STYLE='text-decoration: none'>");

				 sbuffer.append(" <b><span class='linkfont'>Sign Up</span></b>");
				 sbuffer.append(" </a>");

		}else{
				sbuffer.append("<a href='"+serveraddress +"/portal/community.jsp?logout=l' STYLE='text-decoration: none'>");
				sbuffer.append("<b><span class='linkfont'>Logout</span></b>");
				sbuffer.append("</a>");
				sbuffer.append("<font face='Verdana, Arial, Helvetica, sans-serif' size='-2' color='#333333'> | </font>");
				sbuffer.append("<a href=javascript:popupwindow('"+serveraddress +"/home/links/help.html','','800','600'); STYLE='text-decoration: none'>");
				sbuffer.append("<b><span class='linkfont'>Help</span></b>");
				sbuffer.append("</a>");

			   }
			
			  sbuffer.append("</div>");

			sbuffer.append("</td>");
		  sbuffer.append("</tr>");

  sbuffer.append("<tr height='35' id='maintab'>");
   
		  sbuffer.append("<td width='22%' class='"+eventtab+"' >");
	            sbuffer.append("<div align='center'> <a href='"+serveraddress +"/portal/eventdetails/events.jsp?evttype=event&UNITID=13579' >");
	              sbuffer.append("<span class='tabfont'>Events</span> </a> </div>");
	          sbuffer.append("</td>");
		  
		  sbuffer.append("<td width='22%' class='"+classtab+"' >");
		    sbuffer.append("<div align='center'> <a href='"+serveraddress +"/portal/eventdetails/events.jsp?evttype=class&UNITID=13579' >");
		      sbuffer.append("<span class='tabfont'>Classes</span> </a> </div>");
	          sbuffer.append("</td>");
		  
		   sbuffer.append("<td width='34%' class='"+clubtab+"' >");
	            sbuffer.append("<div align='center'> <a href='"+serveraddress +"/portal/hub/clubsview.jsp' >");
	              sbuffer.append("<span class='tabfont'>Communities</span> </a></div>");
	          sbuffer.append("</td>");
		  
		  
		  /*sbuffer.append("<td width='22%' class='"+moretab+"' >");
	            sbuffer.append("<div align='center'> <a href='"+serveraddress +"/portal/listtabs/moretab.jsp' >");
	              sbuffer.append("<span class='tabfont'>More &raquo;</span> </a></div>");
	          sbuffer.append("</td>");*/
		
		sbuffer.append("</tr></table></td></tr>");
	        sbuffer.append("<tr bgcolor='blue'>");
	          sbuffer.append("<td height='1' colspan='25'  ></td>");
       sbuffer.append(" </tr> ");
      sbuffer.append("</table>");
    
    

    sbuffer.append("</td>");

  sbuffer.append("</tr>");
 sbuffer.append("</table>");

 request.setAttribute("BASIC_EVENT_HEADER",sbuffer.toString());


%>
