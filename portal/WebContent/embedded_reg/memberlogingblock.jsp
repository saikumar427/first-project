<%@ page import="com.eventregister.*" %>
<%@ page import="java.util.*,com.eventbee.general.*"%>
<%
String eid=request.getParameter("eid");
String clubname="";
String clubid="";
String loginmsg="";
String signupmsg="";
String description="";
HashMap clubdetails=MemberTicketsDB.getHubDetails(request.getParameter("eid"));

if(clubdetails!=null&&clubdetails.size()>0){
 clubname=(String)clubdetails.get("clubname");
 clubid=(String)clubdetails.get("clubid");
 HashMap messagemap=MemberTicketsDB.getEventCustomMessages(request.getParameter("eid"));

 if((messagemap!=null&&messagemap.size()==0)||messagemap==null)
 messagemap=MemberTicketsDB.getUserCustomMessages(eid);

 if(messagemap!=null&&messagemap.size()>0){
loginmsg=(String)messagemap.get("loginmsg");
signupmsg=(String)messagemap.get("signupmsg");
description=(String)messagemap.get("description");
}

if("".equals(loginmsg))
loginmsg="If you are a existing "+clubname+" member, please login to avail Member Only Tickets";
if("".equals(signupmsg))
signupmsg="Click here to become a Member";
if(description!=null&&!"".equals(description))
description="(" +description+ ")";
 }
HashMap pricemap=MemberTicketsDB.getMemberTicketIds(request.getParameter("eid")); 

if(pricemap!=null&pricemap.size()>0){
HashMap clubinfo=MemberTicketsDB.getMemberCommunityInfo(clubid);

String userid=(String)clubinfo.get("mgr_id");
System.out.println("userid--"+userid);
String loginname=DbUtil.getVal("select login_name from authentication where user_id=?", new String []{userid});
String cluburl="";


cluburl=ShortUrlPattern.get(loginname)+"/community/"+(String)clubinfo.get("code")+"/signup";


String memberloginmsg=DbUtil.getVal("select loginmsg from user_communities where clubid=?",new String[]{clubid});




%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"

"http://www.w3.org/TR/xhtml1/DTD/transitional.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<META Http-Equiv="Cache-Control" Content="no-cache">
<META Http-Equiv="Pragma" Content="no-cache">
<META Http-Equiv="Expires" Content="0">
<%@include file="eventpagecss.jsp"%>
<script type='text/javascript' language='JavaScript' src='/home/js/registration.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/jQuery.js'></script>
<script type='text/javascript' language='JavaScript' src='/home/js/prototype.js'></script>
</head>
<body>
<form  id='membercommunity'  name='membercommunity' action="memberloginaction.jsp"  method='post' />
<div class='box'>
<table width='100%' align='center' class='boxcontent' >

  <tr><td id="membererror" class="error"></td></tr>
  
  <% if(!"".equals(memberloginmsg) && memberloginmsg!=null){%>
    
    <tr><td><%=memberloginmsg%></tr></td>
    
    <%}else{%>
    
     <tr ><td >As a member of <%=clubname%>, you can avail Member Only Tickets</td></tr>
    
   <% }%>
  
  
  
  
  <tr><td >
    <table><tr ><td class="subheader"> </td></tr>
    <tr>
    <td>
      <table width="100%">
      <tr>
      <td class="inputlabel" width="35%">User Name</td>
      <td class="inputvalue" align="left"><input type="text" name="username" id="username" size="15" value="" onkeypress='return ignorekeypress(event)'/> </td>
      <tr>
      <td align="left" width="35%">Password</td>
      <td class="inputvalue" align="left"><input type="password" name="password" id="password"  size="15" value="" onkeypress='return ignorekeypress(event)'/></td>
      </tr>
      </table>
    </td></tr>
    <tr><td align="center">
    <input type="button" name="submit" value="Login" onClick="submitMemberLogin();" />
    </td></tr>
    <tr><td align="center"><a HREF="/portal/guesttasks/loginproblem.jsp?entryunitid=13579&UNITID=13579" target="_blank">Login help?</a>
    </td></tr>
    <tr><td align="left"><a href="<%=cluburl%>" target="_blank"><%=signupmsg%></a></td><tr>
    <tr><td class="subheader"><%=description%><br/><font class='smallestfont'>Member Only Tickets will be enabled after login</font>
    </td>
    </tr>
    </table>
  </td></tr>
  <input type="hidden"  name="clubid" value="<%=clubid%>" />
  <input type='hidden' name="GROUPID" value="<%=request.getParameter("eid")%>" />

</table>
</div>
</form>
<%
}%>
</body>
</html>
  