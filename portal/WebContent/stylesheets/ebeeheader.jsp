<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>

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

%>
<link rel="stylesheet" href="<%=(request.isSecure())?serveraddress_https:serveraddress %>/home/index.css" type="text/css"/>
<script language="javascript" src="/home/js/popup.js">
 function dummy(){}
</script>

<table border="0" width="850" cellspacing="0" cellpadding="0" class="portalback" >
	<tr><td align="center">

<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
  <tr height="10">
    <td width="300" height="0" />
    <td width="5" />
    <td width="450" />
    <td width="5" />
    <td width="10" />
  </tr>
 <tr>

    <td width="23%" valign="top" height="50" colspan="5">



		<table width="100%" border="0" cellpadding="0" cellspacing="0">
			<tr>
			  <td height="16" valign="top" width="19%">
			    <div align="left"><a href="<%=serveraddress %>/portal/home.jsp">
			    <img src="/home/images/logo_big.jpg" border="0"/></a></div>
			  </td></tr>
		</table>
	<td width="77%" height="10" valign="top" >
		<table width="100%" align="center" border="0" cellpadding="5" cellspacing="0"><tr>
			<td width="50%" colspan="20" height="40" valign="middle" align="center">
			  <div align="right">
			   <a href="<%=serveraddress%>" STYLE="text-decoration: none">
			  <b><span class="linkfont"><%=EbeeConstantsF.get("application.name","Eventbee")%></span></b>
			  </a><font face="Verdana, Arial, Helvetica, sans-serif" size="-2" color="#333333"> | </font>

			  <% if(!loggedin){%>
				  <a href="<%=serveraddress %>/portal/community.jsp" STYLE="text-decoration: none">
				  <b><span class="linkfont">Login</span></b>
				  </a>
				  <font face="Verdana, Arial, Helvetica, sans-serif" size="-2" color="#333333"> | </font>
				   <a href="<%=serveraddress %>/portal/signup/signup.jsp?isnew=yes&entryunitid=13579" STYLE="text-decoration: none">

				  <b><span class="linkfont">Sign Up</span></b>
				  </a>

			  <% }else{%>
				<a href="<%=serveraddress %>/portal/community.jsp?logout=l" STYLE="text-decoration: none">
				<b><span class="linkfont">Logout</span></b>
				</a>
				<font face="Verdana, Arial, Helvetica, sans-serif" size="-2" color="#333333"> | </font>
				<a href="javascript:popupwindow('<%=serveraddress %>/home/links/help.html','','800','600');" STYLE="text-decoration: none">
				<b><span class="linkfont">Help</span></b>
				</a>

			  <% }%>
			<font face="Verdana, Arial, Helvetica, sans-serif" size="-2" color="#333333"> | </font>
			  <a href="javascript:popupwindow('<%=serveraddress %>/home/links/FAQ.html','','800','600');" STYLE="text-decoration: none">
			  <b><span class="linkfont">FAQ</span></b>
			  </a>
			  </div>

			</td>
		  </tr>

  <tr height="35" id="maintab">
   
		  <td  class="<%=eventtab%>" >
	            <div align="center"> <a href="<%=serveraddress %>/portal/eventdetails/events.jsp?evttype=event" >
	              <span class="tabfont">Events</span> </a> </div>
	          </td>
		  
		  <td class="<%=classtab%>" >
		    <div align="center"> <a href="<%=serveraddress %>/portal/eventdetails/events.jsp?evttype=class" >
		      <span class="tabfont">Classes</span> </a> </div>
	          </td>
		  
		   <td class="<%=clubtab%>" >
	            <div align="center"> <a href="<%=serveraddress %>/portal/hub/clubsview.jsp" >
	              <span class="tabfont">Communities</span> </a></div>
	          </td>
		  
		  
		  <td class="<%=moretab%>" >
	            <div align="center"> <a href="<%=serveraddress %>/portal/listtabs/moretab.jsp" >
	              <span class="tabfont">More &raquo;</span> </a></div>
	          </td>
		
		</tr></table></td></tr>
	        <tr bgcolor="blue">
	          <td height="1" colspan="25"  ></td>
        </tr> 
      </table>
    
    

    </td>

  </tr>
 </table>
 

