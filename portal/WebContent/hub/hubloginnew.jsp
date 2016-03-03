<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*" %>	
<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.customconfig.*,com.eventbee.profiles.ProfileDB" %>
<%@ page import='java.net.*,java.io.*' %>
<%@ page import="com.eventbee.hub.HubMaster" %>

<%!
String CLASS_NAME="hub/hublogin.jsp";
String query="select userid from club_member where clubid=CAST(? AS INTEGER) and userid=? ";

%>

<%


String BACK_PAGE=(String)session.getAttribute("BACK_PAGE");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"BACK_PAGE from session is: "+BACK_PAGE,"",null);

String uname=request.getParameter("name");
String groupid=request.getParameter("GROUPID");
uname=(uname==null)?"":uname;		

EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"GROUPID is: "+groupid,"",null);
String password=request.getParameter("password");
password=(password==null)?"":password;
uname=uname.trim();
password=password.trim();
String authid=null;
String userid=null;
String iscustomlayout=request.getParameter("customlayout");
System.out.println("length: "+uname.length());
Authenticate au=null;
if(uname!=null && !"".equals(uname) && password!=null && !"".equals(password)){  
        
     uname=uname.trim();
	AuthDB authDB=new AuthDB();
	if(groupid==null) groupid="";
	System.out.println("authentication portal user");
	au=authDB.authenticatePortalUser(uname, request.getParameter("password"),"13579");
	String authquery="select acct_status from authentication a,club_member b where a.login_name=? and a.password=? and a.user_id=b.userid and b.clubid=CAST(? AS INTEGER)";
	String acctStatus=DbUtil.getVal(authquery,new String[]{uname,new StringEncrypter(StringEncrypter.DES_ENCRYPTION_SCHEME).encrypt(password),groupid});
	if(acctStatus!=null){
	session.setAttribute("authData",au);
		if("1".equals(acctStatus) || "3".equals(acctStatus)){
			//out.println("VALIDMEMBER");
			out.println("{'status':'VALIDMEMBER','msg':''}");
		}
		if("6".equals(acctStatus)){
			//out.println("VALIDMEMBER");
			out.println("{'status':'VALIDMEMBER','msg':''}");
		}
		if("2".equals(acctStatus)){
			session.removeAttribute("authData");
			String msg=DbUtil.getVal("select value from community_config_settings where clubid=? and key='CLUB_SUSPEND_STATUS_MESSSAGE' ",new String [] {groupid});
			if(msg==null) msg="Your account is not active";
			out.println("{'status':'SUSPENDED','msg':'"+msg+"'}");
			//out.println("SUSPENDED");
		}
		if("8".equals(acctStatus) || "9".equals(acctStatus)){
			//out.println("VALIDMEMBER");
			out.println("{'status':'VALIDMEMBER','msg':''}");
		}
	}
	else
		out.println("{'status':'INVALID','msg':'Invalid login'}");
}
else
	out.println("{'status':'INVALID','msg':'Invalid login'}");
%>




