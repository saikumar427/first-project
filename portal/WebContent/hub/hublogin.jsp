<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*" %>	
<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.customconfig.*,com.eventbee.profiles.ProfileDB" %>
<%@ page import='java.net.*,java.io.*' %>
<%@ page import="com.eventbee.hub.HubMaster" %>

<%!
String CLASS_NAME="hub/hublogin.jsp";
String query="select userid from club_member where clubid=? and userid=? ";

%>

<%


String BACK_PAGE=(String)session.getAttribute("BACK_PAGE");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"BACK_PAGE from session is: "+BACK_PAGE,"",null);

String uname=request.getParameter("name");
String groupid=request.getParameter("GROUPID");
		

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"GROUPID is: "+groupid,"",null);
String password=request.getParameter("password");
String authid=null;
String userid=null;
String iscustomlayout=request.getParameter("customlayout");

Authenticate au=null;
if(uname!=null){  
        
     uname=uname.trim();
	AuthDB authDB=new AuthDB();
	
	au=authDB.authenticatePortalUser(uname, request.getParameter("password"),"13579");
	//  au=authDB.authenticateMember(uname, request.getParameter("password"),"13579");
	
	if(au !=null){
                
		String statusid=au.getAcctStatusID();
		
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"user account statusid--->: "+statusid,"",null);
		
		authid=au.getUserID();
		
		 if(groupid!=null&&!"null".equals(groupid)){		
			userid=DbUtil.getVal(query,new String[]{groupid,authid});
			
			if("null".equals(userid))userid="";
		}
		
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"userid (club member or not)--->: "+userid,"",null);
		if("13".equals(statusid)){
			out.println("STATUS12_MEMBER");		
			session.setAttribute("TEMPauthData",au);
		}
		
					
		else if(userid!=null&&!"".equals(userid)&&!"6".equals(statusid))
		{
			session.setAttribute("authData",au);	
			session.setAttribute("13579_TEMPauthData",au);
			session.setAttribute("13579_authData",au);
						
			if("sendsms".equals(request.getParameter("customloginpurpose")))
				out.println("HUBMEMBERMESSPAGE");
			else if(!"".equals(request.getParameter("customloginpurpose"))&&request.getParameter("customloginpurpose")!=null)
			out.println("HUBMEMBERREQPAGE");
			else
			out.println("HUBMEMBER");
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME," HUBMEMBER ","",null);

		}
		else if(((userid==null||"".equals(userid))&&!"6".equals(statusid))&&"yes".equals(iscustomlayout)){
			out.println("NOTCUSTOMHUBMEMBER");
		}
		
		else if((userid==null||"".equals(userid))&&!"6".equals(statusid)){
		
			
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME," NOTHUBMEMBER ","",null);
			//session.setAttribute("13579_authData",au);
			//session.setAttribute("authData",au);
			Cookie cookie1 = new Cookie("SESSION_TRACKID",authid+"~"+session.getId()+"~"+(InetAddress.getLocalHost() ).getHostName()+"~"+(new java.util.Date()).toString());
			response.addCookie(cookie1);
			
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"hub.login.jsp","SESSION_TRACKID for Authid: "+authid+" is: "+authid+"~"+session.getId()+"~"+(InetAddress.getLocalHost() ).getHostName()+"~"+(new java.util.Date()).toString(),"sessionid: "+session.getId()+",login time: "+(new java.util.Date()).toString(),null);

			if(((String)session.getAttribute(authid+"PROFILEINSERT"))==null){
				HashMap hm=new HashMap();
				hm.put("userid",authid);	
				hm.put("sid",session.getId());
				int logincount=ProfileDB.insertLoginDetails(hm);
				
				//session.setAttribute(authid+"PROFILEINSERT","Y");
			}
			out.println("NOTHUBMEMBER");

		}
		else if(userid!=null&&!"".equals(userid)&&"6".equals(statusid))
		{    
		
		
		    	out.println("HUBMEMBER_NEEDLOGINCHANGE");
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME," HUBMEMBER_NEEDLOGINCHANGE ","",null);
			session.setAttribute("TEMPauthData",au);
		}
		else if((userid==null||"".equals(userid))&&"6".equals(statusid)){
			out.println("NOTHUBMEMBER_NEEDLOGINCHANGE");
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME," NOTHUBMEMBER_NEEDLOGINCHANGE ","",null);
			session.setAttribute("TEMPauthData",au);
		}
	}
	else{
		out.println("INVALID");
	}
}


%>




