<%@ page import="com.eventbee.general.DbUtil"%>
<%
String tid=request.getParameter("tid");
String eventid=request.getParameter("eid");
String ntscode=request.getParameter("ntscode");
String eventregdetailstempupdatequery="update event_reg_details_temp set buyer_ntscode=?, nts_selected_action='Became Partner' where eventid=? and tid=?";
String eventregtranupdatequery="update event_reg_transactions set buyer_ntscode=? where eventid=? and tid=?";
DbUtil.executeUpdateQuery(eventregdetailstempupdatequery,new String[]{ntscode,eventid,tid});
DbUtil.executeUpdateQuery(eventregtranupdatequery,new String[]{ntscode,eventid,tid});
%>