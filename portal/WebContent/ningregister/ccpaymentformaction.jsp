<%@ page import="com.eventbee.general.*,com.eventbee.event.*,com.eventbee.event.ticketinfo.*"%>
<%@ include file="regxmlgenerator.jsp" %>
<%@ page import="org.json.*"%>

<%
String tid=request.getParameter("tid");
String eid=request.getParameter("eid");
String paytype="eventbee";
DbUtil.executeUpdateQuery("update event_reg_details set selectedpaytype=? where eventid=? and tid=?",new String[]{paytype,eid,tid});
String regxml=getXmlContent(eid,tid);

String isexists=DbUtil.getVal("select transactionid from eventbee_payment_data where transactionid=?",new String[]{tid});
if(isexists==null){
DbUtil.executeUpdateQuery("insert into eventbee_payment_data (transactionid,ebee_xml,trandate,refid,ref_type) values(?,?,now(),?,?)", new String []{tid,regxml,eid,"EVENT"});
}
else{

DbUtil.executeUpdateQuery("update eventbee_payment_data set ebee_xml=? where transactionid=? and refid=? and ref_type=?", new String []{regxml,tid,eid,"EVENT"});

}
JSONObject object=new JSONObject();
object.put("status","success");
%>
<%=object.toString()%>