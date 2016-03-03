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
Authenticate authData=AuthUtil.getAuthData(pageContext);
if (authData==null){}
else{
	request.setAttribute("subtabtype","My Events");
}
String base="oddbase";
String groupid=request.getParameter("GROUPID");
String unitid=request.getParameter("UNITID");
String userid=null;
if(authData !=null){
	userid=authData.getUserID();
}
String partnerid=DbUtil.getVal("select partnerid from group_partner where userid=?",new String[]{userid});
%>
<form name="frm" action="/mytasks/agentcomm.jsp" method="post">
<input type="hidden" name="isnew" value="yes" />
<input type="hidden" name="GROUPID" value="<%=request.getParameter("GROUPID")%>" />
<input type="hidden" name="PS" value="<%=request.getParameter("PS")%>" />
<input type="hidden" name="UNITID" value="<%=request.getParameter("UNITID")%>" />
<input type="hidden" name="foroperation" value="<%=request.getParameter("foroperation")%>" />
<input type="hidden" name="setid" value="<%=request.getParameter("setid")%>" />
<input type="hidden" name="agentid" value="<%=partnerid%>" />

<%
HashMap scopemap=(new EventConfigScope()).getEventConfigValues(groupid,"Registration");
Vector v=new Vector();
Vector vec=getCommissiondetails(groupid,partnerid);

F2FEventDB.getCustomAgentData(v,groupid);
if(v.size()>0){
	for(int i=0;i<v.size();i++){
		HashMap hm=(HashMap)v.elementAt(i);
%>
		<center><b>Eventbee Network Ticket Selling Program</b></center> 
		<br><br>
		<table align="center"  width='60%'>  
		<tr><td colspan="3"><b><%=GenUtil.getHMvalue(hm,"tagline","")%></b></td> </tr> 
		<tr><td colspan="3"><%=GenUtil.textToHtml(GenUtil.getHMvalue(hm,"description",""))%></td></tr>
		<%
				String approval=GenUtil.getHMvalue(hm,"approvaltype","");
				if("yes".equalsIgnoreCase(approval))
					approval="No";
				else
					approval="Yes";
				%>
		<tr><td><b> Manager Approval Required:</b> <%=approval%></td></tr>
		<tr><td><b>Sales Limit: </b><%=GenUtil.getHMvalue(scopemap,"event.reg.currency.format","$")%><%=GenUtil.getHMvalue(hm,"saleslimit","")%></td></tr>
		
		<tr><td><b>Sales Commission:</b></td><table align="center" width="50%"><tr><td width="20%"><b>ticket Name</td><td width="20%"><b>price</td><td width="20%"><b>networkcommission</td></tr>
		<%
		if(vec!=null&&vec.size()>0){
		
		for(int k=0;k<vec.size();k++){
		HashMap gm=(HashMap)vec.elementAt(k);
		%>
		<tr><td><%=GenUtil.getHMvalue(gm,"ticket_name","")%></td>
		<td><%=GenUtil.getHMvalue(gm,"ticket_price","")%></td>
		
		<%if("%".equals(GenUtil.getHMvalue(hm,"commtype",""))){%>
		<td>	<%=GenUtil.getHMvalue(gm,"networkcommission","")%>%</td>
		<%}else{%>
		<td> <%=CurrencyFormat.getCurrencyFormat("$",GenUtil.getHMvalue(gm,"networkcommission",""),true)%></td>
		
			<!--td> <%=GenUtil.getHMvalue(scopemap,"event.reg.currency.format","$")%><%=GenUtil.getHMvalue(gm,"networkcommission","")%></td -->
		
		<%}
		
		%>
		
		
		</tr><%}}%></table>
		
		</td></tr>
		</table>
		<br><br>
		<center>
		<input type="submit" name="submit" value="Join Eventbee Network Ticket Selling Program " />
		</center>
		</form>
	<%}
}%>
