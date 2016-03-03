<%@ page language="java" contentType="text/html" pageEncoding="UTF-8"%>
<style>
.radiobutton {
margin:0px;
padding:0px;
}
</style>
<%@ page import="java.util.HashMap,com.event.dbhelpers.*,com.eventbee.general.*,org.js.*"%>
<%@ include file='/globalprops.jsp' %>
<%!
	HashMap getcompletedcount(String eventid,String isrecurring){
		String surecomcount,notsurecomcount;
		String rsvplimitallowed=DbUtil.getVal("select totallimit from rsvp_settings where eventid=?",new String[]{eventid});
		if(rsvplimitallowed == null){
			rsvplimitallowed = "0";
		}
		if("Y".equals(isrecurring)){
			surecomcount = "0";
			notsurecomcount = "0";
		}
		else{
			surecomcount=DbUtil.getVal("select sum(yescount) from rsvp_transactions where eventid=?",new String[]{eventid});
			if(surecomcount == null){
				surecomcount = "0";
			}
			notsurecomcount=DbUtil.getVal("select sum(notsurecount) from rsvp_transactions where eventid=?",new String[]{eventid});
			if(notsurecomcount == null){
				notsurecomcount = "0";
			}
		}
		int attendeecount=Integer.parseInt(surecomcount)+Integer.parseInt(notsurecomcount);
		
		HashMap count=new HashMap();
		count.put("attendeecount",attendeecount);
		count.put("rsvplimitallowed",rsvplimitallowed);
		return count;
}

%>
<%
String get_key=null,get_value=null;
String str="";
String eventid=request.getParameter("eventid");

HashMap profilePageLabels=DisplayAttribsDB.getAttribValues(eventid,"RSVPFlowWordings");
String alertmsg=GenUtil.getHMvalue(profilePageLabels,"event.reg.response.error.message","Please select Attending Qantity to Continue");
String pageheaders=GenUtil.getHMvalue(profilePageLabels,"event.reg.rsvppage.header","RSVP");
String confirmationpageheader=GenUtil.getHMvalue(profilePageLabels,"event.reg.confirmationpage.header","Confirmation");
String rsvprecdateslable=GenUtil.getHMvalue(profilePageLabels,"event.reg.recurringdates.label","Select a date and time to attend");
if(rsvprecdateslable==null || "".equals(rsvprecdateslable))rsvprecdateslable="Select a date and time to attend";
//String rsvplimitallowed=DbUtil.getVal("select value from config where name='event.rsvp.limit' and config_id=(select config_id from eventinfo where eventid=to_number(?,'999999999999999999'))",new String[]{eventid});

String rsvprecurring=DbUtil.getVal("Select value from config where name='event.recurring' and config_id=(select config_id from eventinfo where eventid=CAST(? AS BIGINT))",new String[]{eventid});

String attendlimitallowed=DbUtil.getVal("select attendeelimit from rsvp_settings where eventid=?",new String[]{eventid});
String notattendingallowed=DbUtil.getVal("select notattending from rsvp_settings where eventid=?",new String[]{eventid});
String notsurelimitallowed=DbUtil.getVal("select notsurelimit from rsvp_settings where eventid=?",new String[]{eventid});


if(attendlimitallowed == null){

	attendlimitallowed="1";
}
else if("0".equals(attendlimitallowed)){
	attendlimitallowed="1";
}
if(notsurelimitallowed == null){
	notsurelimitallowed="0";
}
HashMap completedcount=new HashMap();
completedcount=getcompletedcount(eventid,rsvprecurring);
//String rsvpcompletedcount=DbUtil.getVal("select sum(to_number(attendeecount,'9999999999')) from rsvpattendee where eventid=to_number(?,'99999999999999999') and attendingevent=?",new String []{eventid,"yes"});


if("Y".equals(rsvprecurring)){
	System.out.println("RSVP Recurring Event");
	
	String Rsvp_RECURRING_EVEBT_DATES = "select date_display,date_key from event_dates where eventid=CAST(? AS BIGINT) and (zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ))>=current_date order by date_key";
			DBManager dbmanager = new DBManager();
			StatusObj statobj = dbmanager.executeSelectQuery(Rsvp_RECURRING_EVEBT_DATES, new String[]{eventid});
			int rsvpcount = statobj.getCount();
			
			if (statobj.getStatus() && rsvpcount > 0) {
				str="<select name='rsvp_event_date' id='rsvp_event_date' onchange='rsvp_recurring_change_list()'>";
				str=str+"<option value='--Select Date--'>"+getPropValue("rsvp.sel.date",eventid)+"</option>";
				for (int k = 0; k < rsvpcount; k++) {
					get_value = dbmanager.getValue(k, "date_display", "");
					get_key = dbmanager.getValue(k, "date_key", "");
					str=str+"<option value='"+get_value+"'>"+get_value+"</option>";
					

					}
				str=str+"</select>";
				
			}
}

else{
	System.out.println("Regular RSVP Event");
	}

	


int limit=0;
int count=0;
try{
	limit=Integer.parseInt(completedcount.get("rsvplimitallowed").toString());
	count=Integer.parseInt(completedcount.get("attendeecount").toString());
	if(limit == 0){
		limit=100000000;
	}
	if(count == 0 && limit == 0){
		count=0;
		limit=100000000;
	}	
}
catch(Exception e){
	count=0;
	limit=100000000;
}
String rsvpstatus=DbUtil.getVal("select status from eventinfo where eventid=CAST(? AS BIGINT)",new String[]{eventid});
%>
<table border="0" cellpadding="0" cellspacing="0">
	<tr>
	<td width="100%">
<input type="hidden" name="notsureattend" id="notsureattend" value="<%=notsurelimitallowed%>" />
<input type="hidden" name="sureattend" id="sureattend" value="<%=attendlimitallowed%>" />
<input type="hidden" name="notattending" id="notattending" value="<%=notattendingallowed%>" />
<input type="hidden" name="eventid" id="eid" value="<%=eventid%>" />
<input type="hidden" name="rsvprecurringval" id="rsvprecurringval" value="<%=rsvprecurring%>" />
<input type="hidden" name="alertmsg" id="alertmsg" value="<%=alertmsg%>" />
<input type="hidden" name="pageheaders" id="pageheaders" value="<%=pageheaders%>" />
<input type="hidden" name="confirmationpageheader" id="confirmationpageheader" value="<%=confirmationpageheader%>" />
<input type="hidden" name="rsvpstatus" id="rsvpstatus" value="<%=rsvpstatus%>">
</td></tr></table>
<%
if("CLOSED".equals(rsvpstatus)){
out.println("<center><b>RSVP for this event are closed</b></center>");
}
else if("CANCEL".equals(rsvpstatus)){
	out.println("<center><b>Currently this event is not available</b></center>");
}
else if(count<limit){
%>
<%
	if(!"".equals(str)){
	%>
	
	<table border="0" cellpadding="0" cellspacing="0" class="tableborder" width="100%">
	<tr>
	<td width="100%">
	<%=rsvprecdateslable%>: <%=str%></td></tr></table>

<%}%>

<%if(!"Y".equals(notattendingallowed) && "1".equals(attendlimitallowed) && "0".equals(notsurelimitallowed)){
	if("Y".equals(rsvprecurring)){%>
		<input type="hidden" name="rsvpoption" id="attendeeyes" value="yes">
	<%}
}
else{%>
	<%if("Y".equals(notattendingallowed) || Integer.parseInt(notsurelimitallowed)>0){%>
<table width="100%" border="0" cellpadding="0" cellspacing="0" class="tableborder">
<%if("Y".equals(rsvprecurring)){%><br /><%}%>

<tr>


<td align="left" width="1%" valign="top">
<input type="radio" name="rsvpoption" id="attendeeyes" value="yes" style="margin:1px;" onclick="display_attendee_show(<%=eventid%>)">
</td><td align="left" valign="top">
<%=GenUtil.getHMvalue(profilePageLabels,"event.reg.response.attending.label","Attending")%>
</td>
<td align="left"  valign="top">
<%if(Integer.parseInt(attendlimitallowed)>1){%>
<select name="suretoattendlist" id="suretoattendlist" disabled="true" theme="simple" onchange="disp_rsvp_onchange()" />
<%}%>
</td>


<%
if(Integer.parseInt(notsurelimitallowed)>0){%>
<td align="left" width="1%" valign="top">
<input type="radio" name="rsvpoption" value="notsure" id="attendeenotsure"  onClick="display_attendee_show(<%=eventid%>)"/>
</td>
<td align="left"  valign="top">
<%=GenUtil.getHMvalue(profilePageLabels,"event.reg.response.notsuretoattend.label","Maybe")%>
</td>

<%if(Integer.parseInt(notsurelimitallowed)>1){%>
<td align="left"  valign="top">
<select name="notsuretoattend" id="notsuretoattend" disabled="true" theme="simple" onchange="disp_rsvp_onchange()" />
</td>
<%}%>

<%}else{%>
<td align="left" width="5%" valign="top"></td>

<%}
if("Y".equals(notattendingallowed)){%>
<td align="left" width="1%" valign="top">
<input type="radio" name="rsvpoption" value="no" id="attendeeno"  onClick="getRsvpquestionsJson('<%=eventid%>','0','0')"/>
</td>
<td align="left"  valign="top">
<%=GenUtil.getHMvalue(profilePageLabels,"event.reg.response.notattending.label","Not Attending")%>
</td>
<%}
if(!"Y".equals(notattendingallowed)){%>
<td width='30%'></td>
<%}%>


</tr></table>
<%}

else if(!"Y".equals(notattendingallowed) && Integer.parseInt(notsurelimitallowed)==0){%>
<br>
<table width="100%" class="tableborder"><tr><td width="100%" align="left"><input type="radio" name="rsvpoption" id="attendeeyes" checked style="display:none;" value="yes" ><%=GenUtil.getHMvalue(profilePageLabels,"event.reg.response.attending.label","Attending")%>
<%if(Integer.parseInt(attendlimitallowed)>1){%>
<select name="suretoattendlist" id="suretoattendlist" theme="simple" onchange="disp_rsvp_onchange()" />
<%}%>

</td></tr>
</table>
<%}

else{
%>
<input type="hidden" name="rsvpoption" id="attendeeyes" value="yes">

<%}%>

<%}
}
else{
%>
<center>
<%=GenUtil.getHMvalue(profilePageLabels,"event.rsvp.closed.statusmsg","RSVP closed for this event")%>
</center>
<%}
%>