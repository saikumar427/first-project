<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*,com.eventbee.authentication.*" %>
<%@ page import="com.eventbeepartner.partnernetwork.NetworkTicketSelling" %>
<%
   NetworkTicketSelling nts=new NetworkTicketSelling();
   String platform = request.getParameter("platform");
   if(platform==null) platform="";
   String URLBase="mytasks";
   if("ning".equals(platform)){
 	URLBase="ningapp";	
   }
   String userid="";
   String status="";
   String eventid=request.getParameter("groupid");
    String currency=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{eventid});
         if(currency==null)
		currency="$";
   Authenticate authData=AuthUtil.getAuthData(pageContext);
   if(authData !=null){
 	userid=authData.getUserID(); 	
   } 
   String serveraddress=EbeeConstantsF.get("serveraddress","www.eventbee.com");
   	if(!serveraddress.startsWith("http://")){
   		serveraddress="http://"+serveraddress;
	}
   Vector v1=null;
   String groupid=request.getParameter("groupid");
   String stype=request.getParameter("stype");
   String sby=request.getParameter("sby");
   
   if("".equals(sby)){		
	out.print("<font color=\"red\">Enter Partner Name or ID or email to search</font>");
   return;
   }
   try{
	sby=sby.toUpperCase();
   }
   catch(Exception e){}
   CurrencyFormat cf=new CurrencyFormat();	
   String base="oddbase";
   v1=nts.getUserdetails(sby,stype);
   if(v1.size()>0){
   if(v1!=null&&v1.size()>0){
%>
  <form name='form' id='amountupdate' action='/portal/eventbeeticket/update_partner_commission.jsp' method="post" onSubmit="submitamount();return false;">
<%
   int ticketIndex=0;
   for(int i=0;i<v1.size();i++){
	   if(i%2==0)
	  		base="evenbase";
	  	else
		base="oddbase";
		  HashMap hmt=(HashMap)v1.elementAt(i);
		  String first_name=(String)hmt.get("first_name");	
		  String last_name=(String)hmt.get("last_name");		 
		  String title=(String)hmt.get("title");
		  String email =(String)hmt.get("email");
		  String url=(String)hmt.get("url");
		  if("".equals(url)){
			  url="None";
		  }
		  String partnerid=(String)hmt.get("partnerid");	
		  String agentstatus=nts.getPartnerNTSStatus(partnerid, eventid); 		 
 		  if ("".equalsIgnoreCase(agentstatus)){
 		  String apprvstatus=DbUtil.getVal("select nts_approvaltype from group_agent_settings where groupid=?",new String[]{eventid});
 		  if("Auto".equals(apprvstatus))
 			agentstatus="Approved";		
 		  else
 			agentstatus="Need Approval";
 		  }
 		  String username=DbUtil.getVal("select login_name from authentication where user_id=(select userid from group_partner where partnerid=?)",new String[]{partnerid});
		  String usernetwork=ShortUrlPattern.get(username)+"/network";
		  String creditedearning=nts.getEarningsInfo( "credited", partnerid, eventid);
		  String waitforcreditearning=nts.getEarningsInfo( "waiting for credit", partnerid, eventid);
		  String eventurl=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{eventid});
		    if(eventurl!=null){
		  eventurl=eventurl+"?participant="+partnerid;
			}
		  if(eventurl==null){
		   eventurl= serveraddress+"/eventdetails/event.jsp?eventid="+eventid+"&participant="+partnerid;
		   }
%>
		
<TABLE  class='portaltable' cellpadding="0" cellspacing="0" width="100%">
<tr><td class="<%=base%>">
<b>Name:</b> <a href='<%=usernetwork%>' ><%=first_name%> <%=last_name%></a> <b>Email:</b> <a href="mailto:<%=email %>"><%=email %></a>
</td></tr>		  
<tr><td class="<%=base%>" colspan="5" id="partnerstatus_<%=partnerid%>"><b>Status:</b> <%=agentstatus%>
<%if("Suspended".equals(agentstatus)){ %> 
<input type="button" value="Approve" onclick="changestatus(<%=partnerid%>,<%=eventid%>,'Approved');"/>
<%}
else if("Approved".equals(agentstatus)){
%>
<input type="button" value="Suspend" onclick="changestatus(<%=partnerid%>,<%=eventid%>,'Suspended');"/>
<%}
else if("Pending".equals(agentstatus)){
%>
<input type="button" value="Approve" onclick="changestatus(<%=partnerid%>,<%=eventid%>,'Approved');"/>
<%}else{
%>
<input type="button" value="Approve" onclick="changestatus(<%=partnerid%>,<%=eventid%>,'Approved');"/>
<%}%>
</td></tr>
<!--<tr > 
<td align="left" class="<%=base%>" colspan="5"><b>Earnings: </b> <%=cf.getCurrencyFormat(""+currency+"",creditedearning,true)%> (credited)
<%=cf.getCurrencyFormat(""+currency+"",waitforcreditearning,true)%> (waiting for credit)
<a href="/portal/<%=URLBase%>/partner_reports.jsp?UNITID=13579&filter=manager&GROUPID=<%=eventid%>&agentid=<%=partnerid%>&platform=<%=platform%>">Report </a></td>
</tr>
-->
<tr><td class="<%=base%>" colspan="5"><b>URL: </b>&nbsp;<%=eventurl%>
<%
  Vector tickets=nts.getEventtickets(groupid,partnerid);
  if(tickets!=null&&tickets.size()>0){ 
%>
<tr><td class="<%=base%>" align="left">
<TABLE  class='portaltable' cellpadding="0" cellspacing="0" width="100%">
<tr>
<td class="colheader">Ticket</td>
<td class="colheader">Price</td>
<td class="colheader" colspan='2'>Commission</td>
<td class="colheader" >Ticket Allocation</td>
<td class="colheader" >Sold</td>
<td class="colheader" ><a href="/portal/<%=URLBase%>/partner_reports.jsp?UNITID=13579&filter=manager&GROUPID=<%=eventid%>&agentid=<%=partnerid%>&platform=<%=platform%>">Report </a></td>
</tr>
<%	
 for(int j=0;j<tickets.size();j++){	  
	ticketIndex++;
	HashMap ticketshashmap=(HashMap)tickets.elementAt(j);
	String ticket_name=(String)ticketshashmap.get("ticket_name");
	String commission=(String)ticketshashmap.get("commision");	
	if(commission=="") commission="0";
	String priceid=(String)ticketshashmap.get("priceid");
	String ticket_price=(String)ticketshashmap.get("ticket_price");
	String partnerlimit=(String)ticketshashmap.get("partnerlimit");
	String sold=DbUtil.getVal("select sold_qty from price where evt_id=? and ticket_name=?",new String[]{eventid,ticket_name});
%>		 
<tr><td class="error" align="left" id='errordisp<%=ticketIndex%>' align="center"></td></tr>
<tr>           
<td><%=ticket_name%></td> 		 
<td><%=CurrencyFormat.getCurrencyFormat(""+currency+"",ticket_price,true)%></td>
<td colspan='2' >
<table>
<tr><td align="right" id="editamount<%=ticketIndex%>" ><%=CurrencyFormat.getCurrencyFormat("$",commission,true)%></td><td id='comissioncancellink<%=ticketIndex%>'></td>
<td align="right" id="editlink<%=ticketIndex%>" ><span style="cursor: pointer; text-decoration: underline" onclick="editprice('<%=ticketIndex%>','<%=commission%>','<%=priceid%>','<%=partnerid%>','comission','<%=partnerlimit%>')">Edit</span></td>
</tr>
</table>
</td>

<td>
<table>
<tr><td align="right" class='<%=base%>' id='ticketcount<%=ticketIndex%>'><%=partnerlimit%></td><td id='countcancellink<%=ticketIndex%>'></td>
<td align="right" id='editcntlink<%=ticketIndex%>'><span  style="cursor: pointer; text-decoration: underline" onClick="editprice('<%=ticketIndex%>','<%=partnerlimit%>','<%=priceid%>','<%=partnerid%>','ticketcount','<%=commission%>');">Edit</span></td>
</tr>

</table>
</td>

<td><%=sold%></td>
<td></td>
<input type='hidden' id='purpose' name='purpose' value=''/>
<input type='hidden' id='commission' name='commission' value=''/>
<input type='hidden' id='partnerlimit' name='partnerlimit' value=''/>
<input type='hidden' id='priceid' name='priceid' value='<%=priceid%>'/>
<input type='hidden' id='partnerid' name='partnerid' value='<%=partnerid%>'/>
<input type='hidden' id='partnerlimit' name='partnerlimit' value=''/>
<input type='hidden' name='userid' value='<%=groupid%>'/>
</tr>
<%}%>
</TABLE></td></tr>
<%
}
%>
</TABLE>
<%
}%>
</form>	
<%
}}
else{
out.print("No Records");
}
%>   
   	