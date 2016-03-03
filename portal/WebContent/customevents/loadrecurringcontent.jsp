<%@page import="com.eventbee.cachemanage.CacheManager"%>
<%@ include file='/customevents/recurring.jsp' %>
<%! 
public void initReccuring(String groupid){
	 TicketsDBZ tktdb=new TicketsDBZ();
     HashMap recuringload=new HashMap();
    String recurringselect=tktdb.getRecurringEventDates(groupid,"tickets");
     if(recurringselect==null)
	 recurringselect="<select onchange=getTicketsJson('"+groupid+"'); id='eventdate' name='eventdate'></select>";
     String recurreningAttendeeSelect=tktdb.getRecurringEventDates(groupid,"attendeelist");
     if(recurreningAttendeeSelect==null)
	 recurreningAttendeeSelect="<select onchange=showAttendeesList('"+groupid+"'); id='event_date' name='event_date' style='display: block;'></select>";
	 recuringload.put("recurringselect",recurringselect);
	 recuringload.put("recurreningsttendeeselect",recurreningAttendeeSelect);
	 recuringload.put("recurringdateslabel",tktdb.getRecurringDatesTicketsHeaderLabels(groupid, true));
	 CacheManager.updateData(groupid+"_eventinfo", recuringload, false);
	 
	 //System.out.println("recuringload:::"+recuringload);
	 
	 
	 System.out.println("reccureing content loading successfully...");
	}

%>
<% 
String groupid=request.getParameter("groupid");
System.out.println("groupid:::"+groupid);
initReccuring(groupid);

%>