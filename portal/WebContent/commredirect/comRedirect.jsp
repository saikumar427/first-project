<%@page import="com.eventbee.general.EbeeConstantsF"%>               
 <%
 String purpose=request.getParameter("purpose");
 String groupId=request.getParameter("groupId");
 String severadd=EbeeConstantsF.get("serveraddress", "www.eventbee.com");
 severadd="http://"+severadd;
 System.out.println("purpose:"+purpose+" groupId:"+groupId+"  severadd:"+severadd);
 System.out.println("************:");
 if("view".equals(purpose))
 {
 System.out.println("************:"+severadd+"/community/communityview?groupId="+groupId);
 response.sendRedirect(severadd+"/community/communityview?groupId="+groupId);}
 else if("login".equals(purpose))
 {response.sendRedirect(severadd+"/community/communityview!loginView?groupId="+groupId);}
 else if("signup".equals(purpose))
 { System.out.println("************:"+severadd+"/community/signup?groupId="+groupId);
 response.sendRedirect(severadd+"/community/signupview?groupId="+groupId);}
 else if("renew".equals(purpose))
 {response.sendRedirect(severadd+"/community/communityview!renew?groupId="+groupId);}
 else
 {response.sendRedirect(severadd+"/community/communityview?groupId="+groupId);
 }
 %>