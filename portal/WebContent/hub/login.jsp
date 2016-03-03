<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*" %>	
<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.customconfig.*,com.eventbee.profiles.ProfileDB" %>
<%@ page import='java.net.*,java.io.*' %>
<%@ page import="com.eventbee.hub.HubMaster" %>

<%!
String CLASS_NAME="hub/login.jsp";
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
Authenticate au=null;
if(uname!=null){

	AuthDB authDB=new AuthDB();
	au=authDB.authenticateMember(request.getParameter("name"), request.getParameter("password"),"13579");
	//au=authDB.authenticatePortalUser(request.getParameter("name"), request.getParameter("password"),"13579");
	if(au !=null){

		String statusid=au.getAcctStatusID();
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"user account statusid--->: "+statusid,"",null);
		
		authid=au.getUserID();
		if(groupid!=null&&!"null".equals(groupid)){		
			userid=DbUtil.getVal(query,new String[]{groupid,authid});
		}
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"userid (club member or not)--->: "+userid,"",null);

		if(userid!=null&&!"".equals(userid)&&!"10".equals(statusid))
		{
		
			
			session.setAttribute("TEMPauthData",au);
			session.setAttribute("authData",au);
			out.println("HUBMEMBER");
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME," HUBMEMBER ","",null);

		}
		else if((userid==null||"".equals(userid))&&!"10".equals(statusid)){
			out.println("NOTHUBMEMBER");
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME," NOTHUBMEMBER ","",null);
			session.setAttribute("authData",au);
			Cookie cookie1 = new Cookie("SESSION_TRACKID",authid+"~"+session.getId()+"~"+(InetAddress.getLocalHost() ).getHostName()+"~"+(new java.util.Date()).toString());
			response.addCookie(cookie1);
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"hub.login.jsp","SESSION_TRACKID for Authid: "+authid+" is: "+authid+"~"+session.getId()+"~"+(InetAddress.getLocalHost() ).getHostName()+"~"+(new java.util.Date()).toString(),"sessionid: "+session.getId()+",login time: "+(new java.util.Date()).toString(),null);

			if(((String)session.getAttribute(authid+"PROFILEINSERT"))==null){
				HashMap hm=new HashMap();
				hm.put("userid",authid);	
				hm.put("sid",session.getId());
				int logincount=ProfileDB.insertLoginDetails(hm);
				session.setAttribute(authid+"PROFILEINSERT","Y");
			}
		}
		else if(userid!=null&&!"".equals(userid)&&"10".equals(statusid))
		{
			out.println("HUBMEMBER_NEEDLOGINCHANGE");
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME," HUBMEMBER_NEEDLOGINCHANGE ","",null);
			session.setAttribute("TEMPauthData",au);
		}
		else if((userid==null||"".equals(userid))&&"10".equals(statusid)){
			out.println("NOTHUBMEMBER_NEEDLOGINCHANGE");
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME," NOTHUBMEMBER_NEEDLOGINCHANGE ","",null);
			session.setAttribute("TEMPauthData",au);
		}
	}
	else{
		out.println("INVALID");
	}
}else{

%>

<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy() { }
</script>
<script type="text/javascript" language="JavaScript" src="/home/js/ajax.js">
        function dummy() { }
</script>

<script>


	function demo() {
	    advAJAX.submit(document.getElementById("loginform"), {
	    onSuccess : function(obj) {
	    var restxt=obj.responseText;
		if(restxt.indexOf("INVALID")>-1){   	
	    	document.getElementById("loginerrormsg").innerHTML='Invalid login';
	    	document.getElementById("loginerrormsg").className='error';
	    }
	    else if(restxt.indexOf("NOTHUBMEMBER_NEEDLOGINCHANGE")>-1){
	    	    			
	     	makeRequest('/portal/hub/changelogindetails.jsp','logincontent');		
	    
	    }
	    else if(restxt.indexOf("HUBMEMBER_NEEDLOGINCHANGE")>-1){
		    			
	    	 makeRequest('/portal/hub/changelogindetails.jsp','logincontent');
		    	    
	    }
	    else if(restxt.indexOf("NOTHUBMEMBER")>-1){
		
	    	<%if(("".equals(BACK_PAGE))||(BACK_PAGE==null)) {%>
			    	window.location.href="/portal/mytasks/myevents.jsp";
	    	<%}else{%>
	    	    	window.location.href="/portal/networking/redirectnetwork.jsp";
	    
	    	<%}%> 	
	   }
	    else if(restxt.indexOf("HUBMEMBER")>-1){
		     window.location.href='/portal/mytasks/hubmemberdue.jsp?GROUPID=<%=groupid%>';
    	    }
	    },
	    onError : function(obj) { alert("Error: " + obj.status);}
	});
	}
</script>

<script>

	function validatelogin() {

		advAJAX.submit(document.getElementById("validateloginform"),{
		    onSuccess : function(obj) {
		    var restxt=obj.responseText;
		    if(restxt.indexOf("Success")>-1){
    			    			
			<%if(("".equals(BACK_PAGE))||(BACK_PAGE==null)) {%>
				window.location.href="";
			<%}else{%>
				window.location.href="/portal/networking/redirectnetwork.jsp";
			<%}%> 
    	
		    }
		    else{
			    document.getElementById("changeloginerrormsg").innerHTML=restxt;
			    document.getElementById("changeloginerrormsg").className="error";

			}
		    },
		    onError : function(obj) { alert("Error: " + obj.status);}
		});
	}
</script>


<table cellspacing="0" class="inputvalue" width="100%" valign="top" border="0" id="container">

<tr class='evenbase'><td width='100%'>
<div class='memberbeelet-header'>Login</div>


<div id="logincontent">
<form name='loginform' id="loginform" method="POST"  action="/hub/login.jsp" onSubmit='demo(); return false;'>
<div align="center" id="loginerrormsg"></div>

<table  cellspacing="0" class="inputvalue" width="100%" valign="top" border="0">

<tr>

<td colspan="2" width="10" height="10" /></tr>
<tr>
	<td>Bee ID</td>
	<td class="inputvalue"><input description="User" length="10" type="text" name="name" /></td>
</tr>
<tr>
	<td>Password</td>
	<td class="inputvalue">	<input description="Password" length="10" type="password" name="password" /></td>
</tr>

<tr>
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
	<td align="center" colspan="2"><input value="Go" name="go" type="submit" /></td>
</tr>
<tr><td colspan="2" width="10" heigth="100" /></tr>
<tr>
	<td align="center" colspan="2">
		<a HREF="/portal/guesttasks/loginproblem.jsp?entryunitid=13579&isnew=yes">Login help?</a>
	</td>
</tr>
<tr>
	<td colspan="2" width="10" height="10" />
</tr>
<input type="hidden" name="GROUPID" value="<%=request.getParameter("GROUPID")%>">
<input type="hidden" name="UNITID" value="13579">
</form>
</table>

</div></td></tr></table>


<%}%>
