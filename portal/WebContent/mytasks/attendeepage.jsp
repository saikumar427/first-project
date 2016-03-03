<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.customconfig.*,com.eventbee.event.BeeletController,com.eventbee.editevent.*,com.eventbee.event.*" %>
<%
//request.setAttribute("subtabtype","My Page");
request.setAttribute("mtype","My Console");
request.setAttribute("stype","Events");
request.setAttribute("layout", "DEFAULT");

%>

<%


        String groupid=request.getParameter("GROUPID");
	String unitid=request.getParameter("UNITID");
	String attendeekey=request.getParameter("attendeekey").trim();
	String evttype=DbUtil.getVal("select type from eventinfo where eventid=?",new String [] {groupid});
	String evtlevel=null;
	if(groupid !=null){
		HashMap groupinfo=(HashMap)session.getAttribute("groupinfo");
		if(groupinfo==null)
		groupinfo=new HashMap();
		groupinfo.put("GROUPID",groupid);
		groupinfo.put("groupid",groupid);

		if(unitid!=null){
			groupinfo.put("UNITID",unitid);
			groupinfo.put("unitid",unitid);
		}
		groupinfo.put("GROUPTYPE","Event");
		groupinfo.put("grouptype","Event");
		groupinfo.put("PS","attendeeview");
		groupinfo.put("usertype","attendee");
		groupinfo.put("evttype",evttype);
		EditEventDB evtDB=new EditEventDB();
		if(evtlevel==null){
			evtlevel=""+evtDB.getEventLevel(Integer.parseInt(groupid));
			groupinfo.put("evtlevel",evtlevel);
		}
		//BeeletController bc=new BeeletController();
		//bc.setEventConfigs(groupid,evtDB.getConfig(groupid,EventConstants.POWERED_BY),evtlevel);
		
		session.setAttribute("groupinfo",groupinfo);
		String authid=null;
		Authenticate authData=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
		if(authData!=null)authid=authData.getUserID();
		String sessid=(String)session.getId();
	}
	
	
	
%>





<%@ include file="/templates/beeletspagetop.jsp" %>
<%

com.eventbee.web.presentation.beans.BeeletItem item;       
   
        item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("photoad");
	item.setResource("/eventdetails/eventphoto.jsp");
	leftItems.add(item);
	
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("contentbeelet");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=EVENT_VIEW_PAGE");
	leftItems.add(item);
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("geteventinfo");
      //item.setResource("/eventdetails/eventInfoBeelet.jsp");
	leftItems.add(item);
			
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("ticketinfo");
	item.setResource("/eventdetails/eventticketdetails.jsp");
        leftItems.add(item);
        
        item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("enterzone");
	item.setResource("/eventdetails/eventlistedby.jsp");
	rightItems.add(item);
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("eventrsvp");
	item.setResource("/eventdetails/eventrsvp.jsp");
	rightItems.add(item);
	
        
	item= new com.eventbee.web.presentation.beans.BeeletItem();
		item.setBeeletId("attendeelist");
		item.setResource("/attendeeview/attendeelistbeelet.jsp?attendeekey="+attendeekey);
		rightItems.add(item);
	
   
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("polls1");
	item.setResource("/polls/logic/PollViewBeelet.jsp?location=POST_REG_EVENT_VIEW_PAGE_LEFT");
	//leftItems.add(item);
	
	
	
	
	
	
	
		
	
	
	

	
%>
      		
<%@ include file="/templates/beeletspagebottom.jsp" %>

