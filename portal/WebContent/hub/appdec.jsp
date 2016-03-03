<%@ page import="java.io.*, java.util.*" %>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.hub.*" %>
<%@ page import="com.eventbee.customconfig.*" %>
<%
	String memuserid=request.getParameter("memuserid");
	String name=request.getParameter("name");
	String email=request.getParameter("email");
	HashMap hubinfohash=com.eventbee.hub.hubDB.getHubInfo(request.getParameter("GROUPID"),null);
	String clubname=GenUtil.getHMvalue(hubinfohash,"clubname","");
	String formname=request.getParameter("formname");
	boolean forapproval=("approve".equalsIgnoreCase(formname));
	String messagetouser="Your request to join "+clubname+" is approved";
	if(!forapproval)
	messagetouser="Your request to join "+clubname+" is declined";
	String dissubtitile=(forapproval)?"Approve":"Decline";
	String memlink=PageUtil.appendLinkWithGroup("/portal/mytasks/networkuserprofile?userid="+memuserid+"&entryunitid="+request.getParameter("UNITID"),(HashMap)request.getAttribute("REQMAP") );

%>


<% 
	
	//request.setAttribute("tasktitle","Member");
	//request.setAttribute("tasksubtitle",dissubtitile);
	//request.setAttribute("tabtype","club");
	request.setAttribute("subtabtype","Communities");
	request.setAttribute("NavlinkNames",new String[]{clubname});
	request.setAttribute("NavlinkURLs",new String[]{"/portal/hub/clubmanage.jsp" });
%>

 <script language="JavaScript" src="<%=EbeeConstantsF.get("js.webpath","/home/js") %>/messagevalidate.js">
           var s1="dummy";
   </script>
<form action="/portal/hub/members.jsp" method="post" name="form" onSubmit="return checkmessage(document.form.personalmessage.value)">  
  <table cellspacing="0"  width='100%'>
    <tr> 
      <td class="inputlabel">To </td><td class="inputvalue"><a href='<%=memlink%>' target='_blank'><%=name %></a></td></tr>
    <tr> 
      <td class="inputlabel">Personal Message *</td>
      <td class="inputvalue"> 
        <textarea name="personalmessage" cols="40" rows="10" onfocus="this.value=(this.value==' ')?'':this.value"><%=messagetouser %> </textarea>
      </td>
    </tr>
    
    <tr> 
      <td colspan="2" align="center"> 
      <%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
      
      <input type='hidden' name="formname" value='appdec' />
      <input type='hidden' name="purpose" value='<%=formname %>' />
      <input type='hidden' name="memuserid" value='<%=memuserid %>' />
      <input type='hidden' name="email" value='<%=email %>' />
      <input type='hidden' name='GROUPID' value='<%=request.getParameter("GROUPID") %>' />
        <input type="button" name="bbbbb" value="Back" onClick="javascript:history.back();" />
        <input type="Submit" name="Submit" value="Submit" />
      </td>
    </tr>
  </table>  
</form>

