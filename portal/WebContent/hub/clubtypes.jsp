<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.customconfig.*" %>
<%
String club_title=EbeeConstantsF.get("club.label","Bee Hive");
List categoryCode=DbUtil.getValues("select code from categories where purpose=? order by displayname",new String[]{club_title});
List categoryName=DbUtil.getValues("select displayname from categories where purpose=? order by displayname",new String[]{club_title});
%>
<% out.println(PageUtil.startContent(null,request.getParameter("border"),request.getParameter("width"),true) ); %>
<table width="100%"  border="0" cellpadding="0" cellspacing="0" bgcolor="#d0d3ff">

  <tr>
    <td colspan='7' align='right' valign='center' height='20'>
      <a href='clubsview.jsp?type=All'>View All <%=EventbeeStrings.getDisplayName(club_title,"Bee Hive")%>s</a>
    </td>

  </tr>
   <tr>
    <td width="40" height="0"></td>
    <td width="100"></td>
    <td width="34"></td>
    <td width="100"></td>
    <td width="34"></td>
    <td width="100"></td>
    <td width="50"></td>
  </tr>
<%
int i=0;
String [] names=(String[])categoryName.toArray(new String[categoryName.size()+1]);
String [] codes=(String[])categoryCode.toArray(new String[categoryCode.size()+1]);
names[categoryName.size()]="Other";
codes[categoryName.size()]="Other";
int size1=(categoryCode.size()%3>0)?categoryCode.size()/3+1:categoryCode.size()/3;
for(int k=0;k<size1;k++)
{
%>
<tr>
 <td height="30"></td>
<%
for(int j=0;j<3;j++)
{
%>
    <td valign="center" width="32%" height="100" align='center' bgcolor="#99CCFF">
           <font color="#FFFFFF" face="Verdana, Arial, Helvetica, sans-serif" size="2">
            <b>
            <a href='clubsview.jsp?type=<%=codes[i]%>'><%=names[i]%>
	    </a>
            </b></font>
    </td>
    <td width="10"></td>
    <%
i++;
if(i>categoryCode.size()) break;
}%>
</tr>
<tr>
    <td height="10">

    </td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
    <td></td>
	<td></td>
  </tr>
<%}%>
<tr>
    <td colspan='7' align='right' valign='center'>
      <a href='clubsview.jsp?type=All'>View All <%=EventbeeStrings.getDisplayName(club_title,"Bee Hive")%>s</a>
    </td>

  </tr>
</table>
<% out.println(PageUtil.endContent()); %>
