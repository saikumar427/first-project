<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.authentication.Authenticate"%>

<%
request.setAttribute("mtype","Network Ticket Selling");
request.setAttribute("stype","My Network Ticket Selling");
request.setAttribute("layout", "EE");
Authenticate authData=AuthUtil.getAuthData(pageContext);
String userid=(authData !=null)?authData.getUserID():""; 	
String agentid=DbUtil.getVal("select partnerid from group_partner where userid=?",new String[]{userid});
session.setAttribute(userid+"_partnerid",agentid);


%>
<%@ include file="/templates/beeletspagetop.jsp" %>

<%

	com.eventbee.web.presentation.beans.BeeletItem item;       

	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("PartnerContentBeelet");
	item.setResource("/customconfig/logic/CustomContentBeelet.jsp?portletid=EVENTBEE_PARTNER_NETWORK&forgroup=13579");
	leftItems.add(item);

	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("member");
	item.setResource("/ntspartner/allntseventsbeelet.jsp");
	leftItems.add(item);

	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("Top Network Ticket Selling Events");
	item.setResource("/ntspartner/topntseventsbeelet.jsp");
	rightItems.add(item);  
	item= new com.eventbee.web.presentation.beans.BeeletItem();
	item.setBeeletId("Network Ticket Selling");
	item.setResource("/ntspartner/ntsearningsbeelet.jsp");
    	rightItems.add(item);
    	
%>
	      		
<%@ include file="/templates/beeletspagebottom.jsp" %>
	