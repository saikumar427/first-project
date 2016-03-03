<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.event.*,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.f2f.F2FEventDB"%> 

<%!

Vector getCommissiondetails(String groupid,String agentid){
 String query="select a.ticket_name,a.networkcommission as networkcommission ,a.price_id,a.ticket_price from price a where evt_id=? and a.price_id not in(select c.price_id from price b,partner_ticket_commision c where  c.price_id=b.price_id and c.partnerid=?) UNION select b.ticket_name,c.commision,c.price_id,b.ticket_price from price b,partner_ticket_commision c where c.price_id=b.price_id and b.evt_id=c.eventid and b.evt_id=? and c.partnerid=?";
 
 DBManager dbmanager=new DBManager();
 		StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{groupid,agentid,groupid,agentid});
 
 			Vector vec=new Vector();
 			if(statobj.getStatus()){
 			String [] columnnames=dbmanager.getColumnNames();
 			for(int i=0;i<statobj.getCount();i++){
 					HashMap hm=new HashMap();
 					for(int j=0;j<columnnames.length;j++){
 						hm.put(columnnames[j],dbmanager.getValue(i,columnnames[j],""));
 						 }
 					           
 					vec.add(hm);
 					
 				}
 						}
 						
 						return vec;
 		}




%>

<%
String userid="";
String agentid=request.getParameter("agentid");
String groupid=request.getParameter("GROUPID");
String setid=request.getParameter("setid");
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData==null){
	response.sendRedirect("/portal/auth/listauth.jsp?PS="+request.getParameter("PS")+"&UNITID="+request.getParameter("UNITID")+"&purpose=addagent&GROUPID="+groupid+"&id=yes&setid="+setid);
	return;
}else{
userid=authData.getUserID();
String foroperation=request.getParameter("foroperation");
if("yes".equals(request.getParameter("isnew"))){
	userid=authData.getUserID();
	//agentid=F2FEventDB.getVal(F2FEventDB.agentid_query,userid,setid);
	
	if(agentid!=null)foroperation="edit";
	else
		foroperation="add";
}

HashMap mgrmap=F2FEventDB.getEvtMgrDetails(groupid);
String mgrtitle="";
String description="";
String salescomm="";
String saleslimit="";
if(mgrmap!=null){
	mgrtitle=GenUtil.getHMvalue(mgrmap,"tagline","",true);
	description=GenUtil.getHMvalue(mgrmap,"description","",true);
	salescomm=GenUtil.getHMvalue(mgrmap,"salecommission","",true);
	saleslimit=GenUtil.getHMvalue(mgrmap,"saleslimit","",true);
}
%>

<script language="javascript">	
function checkform(){
var service=document.frm.service;
if(service.checked){return true;}
else{
alert('Accept Terms of Service');
return false;}
}
</script>

<%
String linkpath="http://"+EbeeConstantsF.get("serveraddress","www.beeport.com")+"/home/links";
String appname=null;
appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"manager":"portal";
String TERMSCONDQ="select terms_conditions from group_agent_settings where groupid=?";
String agentinfoq="select title,message,goalamount,showsales from group_agent where agentid=? and settingid=?";
String termscond=F2FEventDB.getVal(F2FEventDB.TERMSCONDQ,groupid); 
Vector v1=getCommissiondetails(groupid,agentid);
HashMap agentmap=new HashMap();
if(setid==null||"".equals(setid)){
	setid="0";
}
if("0".equals(agentid))agentid=null;
if("yes".equals(request.getParameter("isnew"))&&("edit").equals(foroperation)){
	agentmap=F2FEventDB.getAgentInformation(agentmap,agentinfoq,agentid,setid);
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"agentcomm.jsp","null","agentmap is---->  :"+agentmap,null);
	session.setAttribute(agentid+"_agent_map",agentmap);
	
}else if("yes".equalsIgnoreCase(request.getParameter("isnew"))){
session.setAttribute("0_agent_map",new HashMap());
}
if (agentid==null)
	agentid="0";
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"agentcomm.jsp"," Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
Vector errorVector=null;
List grouplist=new ArrayList();
if("yes".equals(request.getParameter("error"))){
	errorVector=(Vector)session.getAttribute("CREATE_TASK_DATA_ERROR_DATA");
}
agentmap=(HashMap)session.getAttribute(agentid+"_agent_map");
String isagent=F2FEventDB.getVal(F2FEventDB.ISAGENT_QUERY,userid,groupid);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"agentcomm.jsp","isagent value is: "+isagent,"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
HashMap scopemap=(new EventConfigScope()).getEventConfigValues(groupid,"Registration");
request.setAttribute("subtabtype","My Pages"); 
%>

<table class="block" cellspacing="0" cellpadding='5' width='100%' colspan="2" >
<form  name="frm" action="/eventbeeticket/confirm" method="post" onsubmit="return checkform()"> 
<input type="hidden" name="response1" value="<%=isagent%>"/>
<tr><td colspan="2" height="5"></td></tr>
<tr><td colspan="2">
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<%=GenUtil.displayErrMsgs("<tr><td class='error'>",errorVector,"</td></tr>")%>
	</table>
</td></tr>
<tr>
<td class='inputlabel' valign='top'  height="30" colspan="2"><%=mgrtitle%></td></tr>
<tr><td class='inputvalue' valign='top'  height="30" colspan="2"><%=description%></td></tr>
<tr><td class='inputvalue' valign='top'  height="30">Sales Commission:</td><td><table align="left" width="50%">
<tr><td width="30%"><b>Ticket Name</td>
<td width="10%"><b>Price</td><td width="10%"><b>Giveout</td></tr>
<%if(v1!=null&&v1.size()>0){
		
		for(int k=0;k<v1.size();k++){
		HashMap gm=(HashMap)v1.elementAt(k);
		%>
		<tr><td><%=GenUtil.getHMvalue(gm,"ticket_name","")%></td>
		<td><%=CurrencyFormat.getCurrencyFormat("$",GenUtil.getHMvalue(gm,"ticket_price",""),true)%></td>
		
		<td> <%=CurrencyFormat.getCurrencyFormat("$",GenUtil.getHMvalue(gm,"networkcommission",""),true)%></td>
		
		<!--td> <%=GenUtil.getHMvalue(scopemap,"event.reg.currency.format","$")%><%=GenUtil.getHMvalue(gm,"networkcommission","")%></td-->
		
		
		
		
		
		</tr><%}}%></table>

<tr>
<tr><td class='inputvalue' valign='top'  height="30"> Sales Limit: <%=CurrencyFormat.getCurrencyFormat("$",GenUtil.getHMvalue(mgrmap,"saleslimit",""),true)%></td></tr>
<tr>
<tr><td colspan="2" height="5"></td></tr>

<td class='inputlabel' width="30%" height="30">My Participation Page Title </td>
<td class='inputvalue'><input type="text" name='title' size="80" value="<%=GenUtil.getHMvalue(agentmap,"title","",true)%>"/></td></tr>
<tr>
<td class='inputlabel' valign='top'  height="30">Message to My Participation Page Visitors</td>
<td class='inputvalue'><textarea name="message"  rows='15' cols='60'><%=GenUtil.getHMvalue(agentmap,"message","",true)%></textarea></td></tr>
<tr>
<td class='inputlabel'  height="30" >My Ticket Sales Goal Amount </td>
<td class='inputvalue'><%=GenUtil.getHMvalue(scopemap,"event.reg.currency.format","$")%> <input type='text' size="5" name='goalamount'  value="<%=GenUtil.getHMvalue(agentmap,"goalamount","",true)%>"/></td></tr>
</tr>
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
<tr>
<td class='inputlabel'  height="30">Display Goal/Sales Amount on My Participation Page  
</td>
<td class='inputvalue' ><input type='radio' name='showsales' value='Yes' <%=WriteSelectHTML.isRadioChecked("Yes",GenUtil.getHMvalue(agentmap,"showsales",""))%> checked/>Yes
<input type='radio' name='showsales' value='No' <%=WriteSelectHTML.isRadioChecked("No",GenUtil.getHMvalue(agentmap,"showsales",""))%> />No</td>
</tr>
<%--<tr>
<td class="inputlabel"  valign='top'>Manager Terms and Conditions </td>
<td class="inputvalue"><textarea name="terms_conditions"  rows='20' cols='60' disabled><%=termscond%></textarea></td>
</td>
</tr>
<%if(!"edit".equals(foroperation)){%>
<tr>
<td colspan="2" align="center" class="inputvalue">                                  																							
<input type="checkbox" name="service" value="yes"/> By clicking Submit, I accept <%=EbeeConstantsF.get("application.name","Desihub")%> Manager Terms & Conditions and Eventbee Network Ticket Selling Event <a href="javascript:popupwindow('<%=linkpath%>/eventbeeticketterms.html','Tags','600','400')">Terms & Conditions</a></td> 
</tr>
<%}%> --%>
<tr><td colspan='2'>
<input type='hidden' name='foroperation' value='<%=foroperation%>'/>
<input type='hidden' name='agentid' value='<%=agentid%>'/>
<input type="hidden" name="setid" value="<%=request.getParameter("setid")%>"/>
<input type="hidden" name="groupid" value="<%=request.getParameter("GROUPID")%>"/>
<input type="hidden" name="GROUPID" value="<%=request.getParameter("GROUPID")%>"/>
<input type="hidden" name="PS" value="<%=request.getParameter("PS")%>"/>
<center><input type='submit' value="Create Page" name="submit"/>
<input type='button' name='cancel' value='Cancel' onclick="javascript:window.history.back()"/>
</center></td>
</tr>
</form>  
</table>
<%}%>


