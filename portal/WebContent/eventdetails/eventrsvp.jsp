<%@ page import="java.io.IOException,java.util.*,com.eventbee.event.RsvpDB,com.eventbee.event.EventDB"%>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.event.ticketinfo.EventTicketDB,com.eventbee.event.BeeletController,com.eventbee.general.*,com.eventbee.authentication.*,com.eventbee.editevent.*"%>

<%
		boolean showrsvp=false,showrsvplimit=false;
		String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
		String entryunitid=(String)session.getAttribute("entryunitid");
		HashMap hmgroupinfo=(HashMap)session.getAttribute("groupinfo");
		String UNITID=null;
		HashMap alreadyAttendee=null;
		HashMap alreadyRsvp=null;
		HashMap evtinfo=null;
		String groupid=null;
		String evtrole=null,evtunitid=null;
		String rsvp_type=null,rsvp_limit=null,rsvp_count=null;
		if(hmgroupinfo!=null){
			UNITID=(String)hmgroupinfo.get("UNITID");
			groupid=(String)hmgroupinfo.get("groupid");


	showrsvp=("13579".equals(UNITID))&&!("Yes".equalsIgnoreCase(EventTicketDB.getEventConfig(groupid, "event.poweredbyEB")));
		if(showrsvp){
		evtinfo=(new EditEventDB()).getEventInfo(groupid);
			evtrole=GenUtil.getHMvalue(evtinfo,"/role","",false).toLowerCase();
			evtunitid=GenUtil.getHMvalue(evtinfo,"eventunitid","",false);
			rsvp_limit="0".equals(GenUtil.getHMvalue(evtinfo,"rsvp_limit","",false))?"None":GenUtil.getHMvalue(evtinfo,"rsvp_limit","",false);
			rsvp_count=GenUtil.getHMvalue(evtinfo,"rsvp_count","",false);
			String grouptype=(String)hmgroupinfo.get("grouptype");

			if("manager".equals(evtrole)){

			}else{

				showrsvplimit=true;
			}

		}
			Authenticate authData=AuthUtil.getAuthData(pageContext);   
			if(authData!=null && hmgroupinfo!=null){
				String userid=authData.getUserID();
				alreadyAttendee=RsvpDB.getAttendeeInfo(groupid,userid);
				if(alreadyAttendee==null)
					alreadyRsvp=RsvpDB.getRsvpInfo(groupid,userid);
			}
		}

	   	String title=EbeeConstantsF.get("beelet.rsvp.title","");
		if("".equals(title.trim())) title=null;
			if(showrsvp){
String eventtype=DbUtil.getVal("select  type from eventinfo where eventid=?",new String []{groupid});
if("Eventbee".equals(EbeeConstantsF.get("application.name","Eventbee"))){
if(("event".equalsIgnoreCase(eventtype))||("class".equalsIgnoreCase(eventtype)))
showrsvp=false;
}
if(showrsvp){
%>
	<%
%>
<div class='memberbeelet-header'></div>
<form action="/portal/auth/listauth.jsp">
			 	<input type="hidden" name="purpose" value="eventrsvp"/>
				<%=PageUtil.writeEventHiddenCore(hmgroupinfo) %>
				<table width="100%">
				<tr>
				<td height="5">
					</td>
				</tr>
				<tr>
					<td align="center">
					<%	if(alreadyAttendee!=null)
							out.println(EbeeConstantsF.get("beelet.rsvp.alreadyregistered","You have already registered for this event"));
						else if(alreadyRsvp!=null)
							out.println(EbeeConstantsF.get("beelet.rsvp.alreadyrsvp","You are already in RSVP Attendee list"));
						else
							out.println(EbeeConstantsF.get("beelet.rsvp.wantrsvp","RSVP for this event?"));
					%>
					</td>
				</tr>
				<tr>
					<td height="5">
					</td>
				</tr>
				<tr>
					<td align="center">
<%					if(alreadyAttendee!=null){
							String attendeekey=(String)alreadyAttendee.get("attendeekey");
%>
							<a href="<%=PageUtil.appendLinkWithGroup(appname+"/search/transactionsearch.jsp?id="+attendeekey+"&submit=Go",hmgroupinfo)%>">
								Attendee Page</a>
<%
						}
						else if(alreadyRsvp!=null){

						}
						else{
%>
							<input type="submit" name="Submit" value="<%=EbeeConstantsF.get("beelet.rsvp.button","Yes")%>"/>
<%}%>
					</td>
				</tr>
<% if(showrsvplimit){%>
				<tr>
					<td height="5">
					</td>
				</tr>
				<tr>
					<td align="center">
						<%=EbeeConstantsF.get("beelet.rsvp.limit","RSVP Limit: ")%>
						<%=rsvp_limit%>
					<br/>
							<%=EbeeConstantsF.get("beelet.rsvp.limitcount","RSVPd Count: ")%>
							<%=rsvp_count%>
						</td>
				</tr>
			<%	}%>
			</table>
			</form>
<%
if(request.getParameter("frompagebuilder") !=null)
		out.println(PageUtil.endContent());
%>

		<%}}%>


