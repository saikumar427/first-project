<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.general.*" %>
<%
	String club_title=EbeeConstantsF.get("club.label","Community");
%>
<%
String homepageurl=EbeeConstantsF.get("group.homepage.url","www.eventbee.com");
session.removeAttribute("13579_EMAIL_HOMEPAGE");
%>
<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
     
<tr>
          <td  width="800" height="30">
            <table width="100%"  >
	    	<tr><td height="30" >&raquo;
		<span class='bigfont'><a href='/portal/auth/listauth.jsp?purpose=createhub' > Create a <%=club_title%></a></span>
		
		<span class='smallfont'>[<a href="/portal/helplinks/membershipmanagement.jsp">Instant special interest group...</a>]</span>
		</td></tr>
		<%
		String useragent = request.getHeader("User-Agent").toLowerCase();
		if(useragent.indexOf("msie") !=-1){
		%>
		<%
		}
		%>
		
		</table>
	</td>
</tr>

	

</table>
