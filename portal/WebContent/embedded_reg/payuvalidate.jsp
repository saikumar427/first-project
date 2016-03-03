<%@ include file="payulatampayment.jsp" %>
<%
	HashMap<String,String> dataMap=new HashMap<String,String>();
	String payUapikey=request.getParameter("payUapikey");
	String payUapilogin=request.getParameter("payUapilogin");
	String eventid = request.getParameter("eid");
	dataMap.put("payUapikey", payUapikey);
	dataMap.put("payUapilogin", payUapilogin);
	dataMap.put("eid", eventid);
	PayULatamPayProcess obj = new PayULatamPayProcess();
	HashMap<String,String> result =obj.validatePayUdetails(dataMap);
	String status = result.get("status");
	out.println(status);
%>