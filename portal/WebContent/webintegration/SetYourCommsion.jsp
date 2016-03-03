<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbeepartner.partnernetwork.PartnerLinks"%>
<%
   String groupid=request.getParameter("groupid");	
  String partnerid=request.getParameter("partnerid");
  PartnerLinks pl=new PartnerLinks(); 
  HashMap hmt=pl.Getcommisiondetails(groupid,partnerid);  
  int MySocialpercentage=50;
  int MyWebpercentage=100;
  HashMap detailsmap=pl.GetGroupAgentSettings(groupid);
  String participationtype="";
  String salecommission="";
  String webeditable="";
  String socialeditable="";
  String friendshare="";
  String webshare="";
	if(detailsmap!=null){
		participationtype=(String)detailsmap.get("participationtype");
		salecommission=(String)detailsmap.get("salecommission");
		webeditable=(String)detailsmap.get("webeditable");
		socialeditable=(String)detailsmap.get("socialeditable");
		friendshare=(String)detailsmap.get("friendshare");
		webshare=(String)detailsmap.get("webshare");
	}


String socialstatus="readonly";
String webstatus="readonly";
if("Yes".equals(socialeditable)) socialstatus="";
if("Yes".equals(webeditable)) webstatus="";
String frinedscommission = friendshare;
if("Yes".equals(socialeditable) && (hmt!=null)){
 frinedscommission =(String)hmt.get("friendscommission");
 }
 
int  x=Integer.parseInt(frinedscommission);
MySocialpercentage=100-x;

  
String otherscommision = webshare;
if("Yes".equals(webeditable) && (hmt!=null)){
 otherscommision =(String)hmt.get("otherscommision");
 }
int  y=Integer.parseInt(otherscommision);
MyWebpercentage=100-y;



%>
<form name='loginform' id='commissionupdate' method="POST"  action="/portal/webintegration/commission_update.jsp" onSubmit="submitcommission('<%=request.getParameter("groupid")%>','<%=request.getParameter("partnerid")%>');return false;">
<span align="center"  id="errordisp"/></span>
<br>


<%if("3".equals(participationtype) || "2".equals(participationtype)){%>
<span width="100%"><b>Selling with Inform Friends</b></span >


<table width="100%">

<tr>
	<td class="inputlabel" width="60%" height="30">I earn</td>
	<td width="40%">
	<input id="upassword" size="1" type="text" name="upassword" <%=socialstatus%> value='<%=MySocialpercentage%>' onkeyup="change()"/>% as commission</td>	
</tr>
		  
<tr>
	<td class="inputlabel"  width="60%" height="30">Friend gets</td>
	<td width="40%"><input id="friends" size="1" type="text"   name="friends" readonly value="<%=frinedscommission%>"/>% as ticket discount</td>
  </tr>
     
</table><br>
<%
}else{
%>
<input id="upassword"  type="hidden" name="upassword" value='<%=MySocialpercentage%>' />
<input id="friends"  type="hidden" name="friends" value='<%=frinedscommission%>' />
<%
}
%>
<br>
<%if("3".equals(participationtype) || "1".equals(participationtype)){%>
<span width="100%"><b>Selling with Website Integration</b></span>

<table width="100%">

<tr>
	<td class="inputlabel" width="59%" height="30">I earn</td>
	<td class="inputvalue" width="41%">
	<input id="Mypercentage" size="1" type="text" name="Mypercentage" <%=webstatus%> value='<%=MyWebpercentage %>' onkeyup='changeother()'/>% as commission</td>
</tr>
	<td class="inputlabel" width="59%"  height="30">Ticket buyer from my website gets</td>
	<td class="inputvalue" width="41%">	<input id="others" size="1" type="text" readonly  name="others" value='<%=otherscommision%>'/>% as ticket discount</td>

</tr>
</table>
<%
}else{
%>
<input id="Mypercentage"  type="hidden" name="Mypercentage" value='<%=MyWebpercentage%>' />
<input id="others"  type="hidden" name="others" value='<%=otherscommision%>' />
<%
}
%>
<br><br><br><br><br><br><center>
<input type='hidden' name='userid' value='<%=groupid%>' />
<input type='hidden' name='partnerid' value='<%=partnerid%>' />
<%
if("Yes".equals(socialeditable) || "Yes".equals(webeditable)){
%>
<input type="submit" name="btnChnge" id="btnChnge" value="Change" />
<%}
%>
<input type="button" value="Cancel" onClick="hide();" /></center>
</form>

