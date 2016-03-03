<%@ page import="com.eventbee.general.*,com.eventbee.event.*,com.eventbee.event.ticketinfo.*"%>
<%@ page import="com.eventbee.authentication.ProfileData"%>
<%@ page import="org.apache.velocity.*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
<%@ page import="com.eventbee.creditcard.*,com.eventbee.general.formatting.*"%>
<%@ include file="regxmlgenerator.jsp" %>
<%@ include file="/eventregister/reg/regemail.jsp" %>
<%
String tid=request.getParameter("tid");
String eid=request.getParameter("eid");
String paytype=request.getParameter("paytype");
DbUtil.executeUpdateQuery("update event_reg_details set selectedpaytype=? where eventid=? and tid=?",new String[]{paytype,eid,tid});
String regxml=getXmlContent(eid,tid);
EventRegisterDataBean edb= new EventRegisterDataBean();
EventRegisterManager.initEventRegXmlData(regxml,edb);
request.setAttribute("regdatabean",edb);
String iscompleted=DbUtil.getVal("select status from event_reg_details where tid=? and eventid=?",new String[]{tid,eid});
if("Completed".equals(iscompleted)){
%>
<jsp:forward page="regend.jsp" />
<%
}else{
String isexists=DbUtil.getVal("select transactionid from eventbee_payment_data where transactionid=?",new String[]{tid});
if(isexists==null){
DbUtil.executeUpdateQuery("insert into eventbee_payment_data (transactionid,ebee_xml,trandate,refid,ref_type) values(?,?,now(),?,?)", new String []{tid,regxml,eid,"EVENT"});
}
else{
DbUtil.executeUpdateQuery("update eventbee_payment_data set ebee_xml=? where transactionid=? and refid=? and ref_type=?", new String []{regxml,tid,eid,"EVENT"});
}
EventRegisterManager erm=new EventRegisterManager();
StatusObj statobj=erm.insertRegData(edb);
ProfileData[] pd=edb.getProfileData();
int mailstatus=sendRegistrationEmail(pd,edb);
if(statobj.getStatus()){
StatusObj sb=DbUtil.executeUpdateQuery("update event_reg_details set status='Completed' where eventid=? and tid=?",new String[]{eid,tid});
DbUtil.executeUpdateQuery("update transaction set payment_status='Completed' where  transactionid=?",new String[]{tid});
%>
<jsp:forward page="regend.jsp" />
<%
}else{
response.sendRedirect("/ningregister/regerror.jsp?tid="+tid);
}
}
%>