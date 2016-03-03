<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%
//boolean loggedin=(com.eventbee.general.AuthUtil.getAuthData(pageContext)!=null);
String SERVERADDRESS="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");

%>
<table border="0" width="100%" cellspacing="0" cellpadding="0" class="portalback" height="100%">
	<tr><td align="center"><link rel="stylesheet" href="<%=SERVERADDRESS %>/home/index.css" type="text/css"/>
<script language="javascript" src="/home/js/popup.js">
 function dummy(){}
</script>

<table width="100%" border="0" cellpadding="0" cellspacing="0" align="center">
<tr>
    <td width="300" height="5" />
    <td width="5" />
    <td width="450" />
    <td width="5" />
    <td width="10" />
  </tr>
<tr>
	<td height="10" valign="top" colspan="3">
	  <div align="right">
	  <a href="<%=SERVERADDRESS%>">
			  <b><span class="linkfont"><%=EbeeConstantsF.get("application.name","Desihub")%></span></b>
			  </a><font face="Verdana, Arial, Helvetica, sans-serif" size="-2" color="#333333"> | </font>
	  <% if(com.eventbee.general.AuthUtil.getAuthData(pageContext)==null){%>
		  <a href="/portal/community.jsp">
			  <b><span class="linkfont">Login</span></b>
			  </a>
			  <font face="Verdana, Arial, Helvetica, sans-serif" size="-2" color="#333333"> | </font>
			   <a href="/portal/signup/signup.jsp?isnew=yes&amp;entryunitid=13579">
				  <b><span class="linkfont">Sign Up</span></b>
				  </a>

			  <% }else{%>
			  	<a href="/portal/community.jsp?logout=l">
				<b><span class="linkfont">Logout</span></b>
				</a>
				<font face="Verdana, Arial, Helvetica, sans-serif" size="-2" color="#333333"> | </font>
				<a href="javascript:popupwindow('/home/links/help.html','','800','600');;">
				<b><span class="linkfont">Help</span></b>
				</a>

			  <% }%>
			  <%--<font face="Verdana, Arial, Helvetica, sans-serif" size="-2" color="#333333"> | </font>
			  <a href="javascript:popupwindow('/home/links/updates.html','','800','600');">
			<b><span class="linkfont">Updates</span></b>
			</a>
			<font face="Verdana, Arial, Helvetica, sans-serif" size="-2" color="#333333"> | </font>
			<a href="javascript:popupwindow('/home/links/flag.html','','800','600');">
			<b><span class="linkfont">Flag</span></b>
			</a>
			<font face="Verdana, Arial, Helvetica, sans-serif" size="-2" color="#333333"> | </font>
			  <a href="javascript:popupwindow('/home/links/FAQ.html','','800','600');">
			  <b><span class="linkfont">FAQ</span></b>
			  </a>--%>
			  </div>

			</td>
			<td height="5" width="2%"> </td>
		  </tr>




		</table>



    </td>
  </tr>
 </table>

