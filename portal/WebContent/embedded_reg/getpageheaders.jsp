<%@ page import="java.util.HashMap,org.json.*,com.event.dbhelpers.*,com.eventbee.general.*"%>
<%
String eid=request.getParameter("eid");
HashMap profilePageLabels=DisplayAttribsDB.getAttribValues(eid,"RegFlowWordings");
String profilePageHeader=GenUtil.getHMvalue(profilePageLabels,"event.reg.profile.page.Header","");
String ticketsPageHeader=GenUtil.getHMvalue(profilePageLabels,"event.reg.ticket.page.Header"," ");
String paymentsPageHeader=GenUtil.getHMvalue(profilePageLabels,"event.reg.payments.page.Header"," ");
String confirmationPageHeader=GenUtil.getHMvalue(profilePageLabels,"event.reg.confirmation.page.Header"," ");


JSONObject obj=new JSONObject();
try{
obj.put("ticketspage",ticketsPageHeader);
obj.put("profilepage",profilePageHeader);
obj.put("paymentpage",paymentsPageHeader);
obj.put("confirmationpage",confirmationPageHeader);
}
catch(Exception e){
System.out.println("Exception occured is "+e.getMessage());
}

out.println(obj.toString());
%>