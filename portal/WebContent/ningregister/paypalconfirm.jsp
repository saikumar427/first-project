<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*,com.eventbee.event.*,com.eventbee.event.ticketinfo.*"%>

<%
String tid=request.getParameter("tid");
String eid=request.getParameter("eid");
String regxml=DbUtil.getVal("select ebee_xml_data  from paypal_payment_data where ebee_tran_id=? and refid=?",new String[]{tid,eid});
EventRegisterDataBean edb= new EventRegisterDataBean();
EventRegisterManager.initEventRegXmlData(regxml,edb);
request.setAttribute("regdatabean",edb);
DbUtil.executeUpdateQuery("update event_reg_details set status='Completed' where eid=? and tid=?",new String[]{eid,tid});
%>

<jsp:forward page="regend.jsp" />
