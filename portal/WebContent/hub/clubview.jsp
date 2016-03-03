<%@page import="com.eventbee.general.EbeeConstantsF"%>               
 <%
 String groupId=request.getParameter("GROUPID");
 String severadd=EbeeConstantsF.get("serveraddress", "www.eventbee.com");
 severadd="http://"+severadd;
 System.out.println("groupId:"+groupId+"  severadd:"+severadd);
 System.out.println("************:");
 response.sendRedirect(severadd+"/community/communityview?groupId="+groupId);
 
%>