<%@ page import="java.util.*,com.eventbee.authentication.*,com.eventbee.context.ContextConstants" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.customconfig.*,com.eventbee.profiles.ProfileDB" %>
<jsp:include page="/stylesheets/CoreRequestMap.jsp" />


<%

boolean displayloginblock=true;

if(request.getParameter("submit")!=null){
	displayloginblock=false;
	
	AuthDB authDB=new AuthDB();
	Authenticate authData=authDB.authenticatePortalUser(request.getParameter("name"), request.getParameter("password"),"13579");
	
	if(authData==null){
		displayloginblock=true;
		request.setAttribute("errormsg", "Invalid Login" );
	}else{
		
		String authid=authData.getUserID();
		String unitid=authData.getUnitID();
		String accstatid=authData.getAcctStatusID();
		String role=authData.getRoleName();
		boolean isactive=authData.isActiveAccount();

		String BACK_PAGE=(String)session.getAttribute("BACK_PAGE");
		if(((String)session.getAttribute(authid+"PROFILEINSERT"))==null){
			HashMap hm=new HashMap();
			hm.put("userid",authid);	
			hm.put("sid",session.getId());
			int logincount=ProfileDB.insertLoginDetails(hm);
			session.setAttribute(authid+"PROFILEINSERT","Y");
		}
		String   nextPage="";
		if((isactive) && ("1".equals(accstatid))){
			
			//session.setAttribute("authData",authData);
			
			session.setAttribute("13579_authData",authData);
			
			if(("".equals(BACK_PAGE))||(BACK_PAGE==null)) { 
				nextPage="/hub/clubview.jsp";
				//nextPage="/clubpage/clubpage.jsp";
			}else
				nextPage= ("/portal/networking/redirectnetwork.jsp");
				
				Cookie cookie1 = new Cookie("userid",authid+"~"+authData.getRoleCode() );
				cookie1.setPath("/");
				response.addCookie(cookie1);
				//System.out.println("after setting cookie at :"+new Date());
		
				
				
		}else if(("6".equals(accstatid))||("9".equals(accstatid))){
			
			session.setAttribute("TEMPauthData",authData);
			session.setAttribute("13579_TEMPauthData",authData);
			
			nextPage= ("/editprofiles/editAccStatus.jsp");
			
		}else if("8".equals(accstatid)){
			
			session.setAttribute("TEMPauthData",authData);
			session.setAttribute("13579_TEMPauthData",authData);
			nextPage= ("/guesttasks/renewMembership.jsp?GROUPID="+request.getParameter("GROUPID"));
		}else{
			session.setAttribute("13579_TEMPauthData",authData);
			nextPage= ("/guesttasks/suspended.jsp");// new inactive scrren
		}
		//response.sendRedirect(PageUtil.appendLinkWithGroup(nextPage,(HashMap)request.getAttribute("REQMAP") ));
		GenUtil.Redirect(response,PageUtil.appendLinkWithGroup(nextPage,(HashMap)request.getAttribute("REQMAP") ));
			
	}

}

if(displayloginblock){

	 String navName=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String[]{request.getParameter("GROUPID")});
	 //request.setAttribute("tasktitle","Login");
	 request.setAttribute("NavlinkNames",new String[]{navName});
	 request.setAttribute("NavlinkURLs",new String[]{PageUtil.appendLinkWithGroup("/portal/clubdetails/clubdetails.jsp",(HashMap)request.getAttribute("REQMAP"))});
	 //request.setAttribute("tabtype","club");

String logintitle=DbUtil.getVal("select value from config where config_id =(select config_id from clubinfo where unitid=?) and name='login.custom.msg'",new String [] {"13579"});
if(logintitle==null||"".equals(logintitle.trim()))
logintitle="";


%>
<table  width="100%" >
<form name='loginform' method="POST"  action="pmemberlogin.jsp">

<tr><td colspan="2" width="10" height="10" /></tr>
<tr><td colspan="2" ><%=logintitle%></td></tr>
<tr><td align="center" class="error" colspan="2" /><%=(request.getAttribute("errormsg")!=null)?(String)request.getAttribute("errormsg") :"" %></tr>
<tr>
<td class="inputlabel" width='30%'>User Name</td>
<td class="inputvalue" width='70%'><input description="User"  type="text" name="name" /></td>
</tr>
<script language="JavaScript">
<!--

document.loginform.name.focus();

//-->
</script>
<tr>
<td class="inputlabel">Password</td>
<td class="inputvalue"><input description="Password"   type="password" name="password" /></td>
</tr>
<tr>
<td align="center" colspan="2"><input value="Go" name="submit" type="submit" /></td>
</tr><tr><td colspan="2" width="10" heigth="100" />
</tr>
<tr>
<td align="center" colspan="2">
<a HREF="<%=com.eventbee.general.PageUtil.appendLinkWithGroup("/portal/guesttasks/loginproblem.jsp",(HashMap) request.getAttribute("REQMAP"))%>">Login help?</a></td>

</tr><tr><td colspan="2" width="10" height="10" />
</tr>


<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>	
</form>
</table>
<%
}
%>
