<%@ page import="org.apache.velocity .*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*,java.net.*,java.util.*" %>
<%@include file="widgetcss.jsp"%>

<%

	

VelocityContext context = new VelocityContext();
context.put("pageCSS",csscontent);
context.put("eid",eid);
context.put("scriptTag",scriptTag);
context.put("eventLevelVariable",eventlevelvariable);



if(isrsvpd){
context.put("isRsvpEvent","Yes");
}
else if(registrationAllowed){
context.put("isTicketingEvent","Yes");
if(isrecurringevent)
context.put("recurreningSelect",ticketInfo.getRecurringEventDates(eid,"tickets"));
}
VelocityEngine ve= new VelocityEngine(); 

try{
ve.init();
boolean abletopares=ve.evaluate(context,out,"ebeetemplate",template );
}
catch(Exception exp){
System.out.println(exp.getMessage());
}  
%>




