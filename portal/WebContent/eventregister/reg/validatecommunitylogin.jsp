<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*,com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.event.*"%>

<%
EventRegisterBean jBean = (EventRegisterBean)session.getAttribute("regEventBean");
	
String username=request.getParameter("username");
String password=request.getParameter("password");
String eventid=request.getParameter("GROUPID");
HashMap hm=new HashMap();
hm.put("loginname",username);
hm.put("password",password);
session.setAttribute(eventid+"community_login",hm);
String userid="";
String validmem="";
Authenticate au=null;

if(username!=null){  
        

	AuthDB authDB=new AuthDB();
	
	au=authDB.authenticatePortalUser(username,password,"13579");
	
	if(au !=null){
                
		
	userid=au.getUserID();
	validmem=DbUtil.getVal("select 'yes' from club_member where userid=? and clubid  in (select clubid from event_communities where eventid=?)",new String[]{userid,eventid});
        
        System.out.println("validmem---"+validmem);
        
        if("yes".equals(validmem)){
         jBean.setCommunityLoginStatus("Success");
     
        out.println("<data>validMember</data>");
        }
        else
         out.println("<data>NotMember</data>");
         
         }

       else
       out.println("<data>Loginfailed</data>");
       

}	

else
out.println("<data>Loginfailed</data>");
       
%>