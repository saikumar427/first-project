<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.general.*,java.util.*" %>
<%
	String club_title=EbeeConstantsF.get("club.label","Bee Hive");
%>
<% out.println(PageUtil.startContent(null,request.getParameter("border"),request.getParameter("width"),true) ); %>
<table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
<form method='post' action="/portal/hub/upgradedone.jsp"/>
<input type='hidden' name='type' value='Community'/>

<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
     <tr>
          <td valign="top" width="800" height="30">
            <table width="100%" border="0" bgcolor="#663366" cellpadding="0" cellspacing="0" class1="beelet">
	    <tr><td height='5'></td></tr>
              <tr>
                <td height="30" align="center">
                       <input type='submit' name='submit' value='Upgrade <%=EventbeeStrings.getDisplayName(club_title,"Community")%>'/>
		    </td></tr>
		   <tr><td align='center'>
		    <font color='white'>Upgrading <%=EventbeeStrings.getDisplayName(club_title,"Community")%> allows you to customize <%=EventbeeStrings.getDisplayName(club_title,"Community")%> Content and Look & Feel</font>

                </td>
              </tr>
	     </table>
           </td>
      </tr>
      </form>
</table>
<% out.println(PageUtil.endContent()); %>
