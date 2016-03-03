<%@ page import="com.eventbee.event.*"%>
<%
EventRegisterBean jBean=(EventRegisterBean)session.getAttribute("regEventBean");
String memberdiscount=request.getParameter("member");
String isapplied=null;

if(jBean!=null){
if("yes".equals(memberdiscount)){
isapplied=(String)session.getAttribute("MemCouponContent_"+jBean.getEventId());
}
else{
isapplied=(String)session.getAttribute("CouponContent_"+jBean.getEventId());
}
}
if(isapplied!=null)
out.println("<status>discountapplied</status>");

%>
