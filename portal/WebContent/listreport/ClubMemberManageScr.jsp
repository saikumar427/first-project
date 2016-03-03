<%@ page import="java.io.*, java.util.*,java.sql.*,com.eventbee.clubs.*,com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.context.ContextConstants" %>

<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"ClubMemberManageScr.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
Authenticate authData=AuthUtil.getAuthData(pageContext);

String manid=authData.getUserID();
String clubid=request.getParameter("mshipclub");

String query="select membership_id,membership_name from club_membership_master where clubid=? order by created_at";
Map mshipmap=MemAccountStatus.getMemberships(clubid,query);

String [] mshipids=(String [])mshipmap.get("memids");
String [] mshipnames=(String [])mshipmap.get("memnames");
session.setAttribute("mshipmap",mshipmap);

int mshipsize=0;
if(mshipmap!=null){
mshipsize=mshipmap.size();
}

%>


<%

if(mshipsize>0){

%>

<% request.setAttribute("subtabtype","Communities");
	

%>

<table align="center" width='100%' class="taskblock">
<tr><td>
<form  name="clubmemberscr1" action="/mytasks/ClubMemberManageScr1.jsp" method="post"   >
<input type='hidden' name='landf' value='yes'>
<input type='hidden' name='type' value='Community'>

<table align="center" class='block'>
	
	<tr><td   class="subheader">Member Search Filter </td></tr>
	<tr><td  align="left" class="inputlabel"><input type="radio" name="membopt" value="All" checked="checked"/>All</td></tr>
	<tr><td  align="left" class="inputlabel"><input type="radio" name="membopt" value="str" />Name</td><td class="inputvalue"> <input type="text" size="33"  name="name"/></td></tr>
	<tr><td  align="left" class="inputlabel"><input type="radio" name="membopt" value="email" />Email Id</td><td class="inputvalue"> <input type="text" size="33" name="email"/></td></tr>

	<tr><td  align="left" class="inputlabel"><input type="radio" name="membopt" value="mship" />Membership</td><td class="inputvalue"> <%=GenUtil.getSelectHtml( mshipnames, mshipids,"mshipid","") %></td></tr>
	<tr><td  align="left" class="inputlabel"><input type="radio" name="membopt" value="status" />Status </td><td class="inputvalue"> <%=GenUtil.getSelectHtml( MemAccountStatus.typeval,"statusid","") %></td></tr>

	<tr><td colspan="2"><table class="block">
	<tr><td class="inputlabel"><input type="radio" name="membopt" value="dates" colspan="2" />Join Date</td></tr>
	
	<tr>
	<td colspan="2" align="left">
	<table >
		<tr><td width='5'></td><td class="inputlabel"><input type="radio" name="dateopt" value="after" checked="checked"/> After</td><td class="inputvalue">
		<%=EventbeeStrings.getMonthHtml(Calendar.getInstance().get(Calendar.MONTH),"montha")%>
	<%=EventbeeStrings.getDayHtml(Calendar.getInstance().get(Calendar.DAY_OF_MONTH ),"daya")%>
	<%=EventbeeStrings.getYearHtml(Calendar.getInstance().get(Calendar.YEAR)-1,5,Calendar.getInstance().get(Calendar.YEAR),"yeara")%>
		</td></tr>
		<tr><td width='5'></td><td class="inputlabel"><input type="radio" name="dateopt" value="before"/> Before</td><td class="inputvalue">
		<%=EventbeeStrings.getMonthHtml(Calendar.getInstance().get(Calendar.MONTH),"monthb")%>
	<%=EventbeeStrings.getDayHtml(Calendar.getInstance().get(Calendar.DAY_OF_MONTH ),"dayb")%>
	<%=EventbeeStrings.getYearHtml(Calendar.getInstance().get(Calendar.YEAR)-1,5,Calendar.getInstance().get(Calendar.YEAR),"yearb")%>
		</td></tr>
		<tr><td width='5'></td><td class="inputlabel"><input type="radio" name="dateopt" value="betw"/> Between</td><td class="inputvalue">
		<%=EventbeeStrings.getMonthHtml(Calendar.getInstance().get(Calendar.MONTH),"month1")%>
	<%=EventbeeStrings.getDayHtml(Calendar.getInstance().get(Calendar.DAY_OF_MONTH ),"day1")%>
	<%=EventbeeStrings.getYearHtml(Calendar.getInstance().get(Calendar.YEAR)-1,5,Calendar.getInstance().get(Calendar.YEAR),"year1")%>
		And
		<%=EventbeeStrings.getMonthHtml(Calendar.getInstance().get(Calendar.MONTH),"month2")%>
	<%=EventbeeStrings.getDayHtml(Calendar.getInstance().get(Calendar.DAY_OF_MONTH ),"day2")%>
	<%=EventbeeStrings.getYearHtml(Calendar.getInstance().get(Calendar.YEAR)-1,5,Calendar.getInstance().get(Calendar.YEAR),"year2")%>
		</td></tr>


	</table>
	</td>
	</tr>
	</table></td></tr>
	<tr><td colspan='2'><table class="block">
	<tr><td  align="left" class="inputlabel" colspan='3'><input type="radio" name="membopt" value="subscription" />Due</td></tr>
	<tr><td width='5'></td><td class="inputlabel" width='20%'><input type='radio' name='duechoice' value='pastdue' checked='checked'/>Past due </td><td></td></tr>
	<tr><td width='5'></td><td class="inputlabel" width='20%'><input type='radio' name='duechoice' value='morethan' />Past due by </td><td><input type="text" name="subscrdaysmore" size='4'/> Days </td></tr>
	<tr><td width='5'></td><td class="inputlabel" width='20%'><input type='radio' name='duechoice' value='within'/>Due in next </td><td>    <input type="text" name="subscrdays" size='4'/> Days </td></tr>
	</table></td></tr>
	<tr><td  align="center" colspan="2" ><input type="submit" value="Continue"/><input type="button" name="bbbb"  value="Cancel" onClick="javascript:history.back()"/></td></tr>
</table>
<input type='hidden' name='GROUPID' value='<%=clubid%>'>
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>

</form>
</td></tr>
</table>
<%
}else{


String message="No Membership found. Create a club Membership";
session.setAttribute("message",message);
response.sendRedirect("Done.jsp?operation=Add Members");
}
%>

