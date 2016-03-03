<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.authentication.*"%>
<%
String username=request.getParameter("username");
String password=request.getParameter("password");
String eid=request.getParameter("eid");
String tid=request.getParameter("tid");
String userid="";
String validmem="N";
Authenticate au=null;
if(username!=null){  
 	AuthDB authDB=new AuthDB();
	au=authDB.authenticatePortalUser(username,password,"13579");
	if(au !=null){		
	userid=au.getUserID();
	validmem=DbUtil.getVal("select 'Y' from club_member where userid=? and clubid  in (select clubid from event_communities where eventid=?)",new String[]{userid,eid});
        if("Y".equals(validmem)){        
        DbUtil.executeUpdateQuery("update event_reg_details set clubuserid=? where tid=? and eventid=?",new String[]{userid,tid,eid});
        }
        else
         validmem="N";
       
       }
}	
   
%>
{"isMemberLoggedIn":"<%=validmem%>"}