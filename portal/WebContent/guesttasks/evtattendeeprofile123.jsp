<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.event.ticketinfo.EventTicketDB" %>
<%@ page import="com.eventbee.useraccount.*" %>
<%@ page import="com.eventbee.nuser.*" %>


	<%	
	String  attendeeid=request.getParameter("attendeeid");
	AccountDB accDB=new AccountDB();		
		StatusObj stob=new StatusObj(false,"","");
	        String  attendeekey=DbUtil.getVal("Select attendeekey from eventattendee where attendeeid=?",new String[]{attendeeid});
		
		stob=accDB.getAttendeeProfile(attendeekey);
		if(stob.getStatus()){
			HashMap hm=(HashMap)stob.getData();
			if(hm!=null){
		request.setAttribute("tasktitle",GenUtil.getEncodedXML((String)hm.get("firstname"))+" "+GenUtil.getEncodedXML((String)hm.get("lastname"))+"'s Profile");
		request.setAttribute("tasksubtitle","");

			}
			}
  request.setAttribute("mtype","My Console");
  request.setAttribute("stype","Events");

  
 %>


<%@ include file="/templates/taskpagetop.jsp" %>


<%

	taskpage="/sms/evtattendeeprofile.jsp";
%>
	      		
<%@ include file="/templates/taskpagebottom.jsp" %>
	

	