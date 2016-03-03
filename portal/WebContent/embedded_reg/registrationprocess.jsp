<%@ page import="com.eventregister.*,org.json.*,com.eventbee.general.*" %>
<%
JSONObject obj=new JSONObject();
boolean resultflag=false;
String tid=request.getParameter("tid");
String eid=request.getParameter("eid");
String paytype=request.getParameter("paytype");
String alreadydone=request.getParameter("iscompleted");
if(alreadydone==null)alreadydone="";
int result=0;
int emailcount=0;
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.INFO, "Registration Process.jsp", "Registration Completed for the  event---"+eid+" and transactionid is --->"+tid+" and paytype is "+paytype, "", null);

if(eid!=null&&tid!=null){
if("".equals(alreadydone)){	
RegistrationProcessDB rgdb=new RegistrationProcessDB();
RegistrationConfirmationEmail regconfirm=new RegistrationConfirmationEmail();
DbUtil.executeUpdateQuery("update event_reg_details_temp set selectedpaytype=?,collected_servicefee=0 where tid=?",new String[]{paytype,tid});
result=rgdb.InsertRegistrationDb(tid,eid);
emailcount=regconfirm.sendRegistrationEmail(tid,eid);
}else{
result=1;
emailcount=1;
}
}
if(result==1&&emailcount==1)
resultflag=true;
if(resultflag)
obj.put("status","Success");
else
obj.put("status","Fail");
out.println(obj.toString());
%>

