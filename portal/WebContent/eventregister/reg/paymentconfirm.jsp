<%@ page import="com.eventbee.event.*"%>
<%@ page import="com.eventbee.authentication.Authenticate"%>
<%@ page import="com.eventbee.authentication.ProfileData"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.event.ticketinfo.*"%>
<%@ page import="com.eventbeepartner.partnernetwork.PartnerLinks" %>

<script language="javascript" src="/home/js/webintegration.js">
         function dummy(){}
</script>
<script src="http://static.ak.connect.facebook.com/js/api_lib/v0.4/FeatureLoader.js.php" type="text/javascript">
	function fbdummy(){ }
</script>
<script language="JavaScript" type="text/javascript" src="/home/js/fbconnect.js" >
	function dummyfbconnect() { }
</script>
<script language="javascript" src="/home/js/popup.js">
         	function dummy(){}
	</script>	
<%!


    String encode(String x){
	return GenUtil.getEncodedXML(x);
    }

      String rowdisplay(int count){
		if(count%2==0){
			return "<td class='oddbase'>";
		}else{
			return "<td class='evenbase'>";
	   	}
	}
	
	
	
%>


<%
	String orderstatus= request.getParameter("orderstatus");
	String source=request.getParameter("source");
	EventRegisterDataBean jBean= (EventRegisterDataBean)request.getAttribute("EVENT_REG_DATA_BEAN");
	
	
	int rowcount=0;
    ProfileData[] pd=jBean.getProfileData();
    String [] reqTicket=jBean.getSelectReqTickets();
	String [] optTickets=jBean.getSelectOptTickets();
	String eventid=jBean.getEventId();
	double GrandTotal=jBean.getGrandTotal();
	StringBuffer confmessage=new StringBuffer();
	double processfee=0;
	
	//HashMap scopemap=getConfigData(jBean.getEventId());
	EventTicketDB edb=new EventTicketDB();
	HashMap scopemap=new HashMap();
	StatusObj sobj=edb.getEventInfo(eventid,scopemap);
	 String currencyformat=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{jBean.getEventId()});
        if(currencyformat==null)
    	currencyformat="$";	
	String feeconfiguration=DbUtil.getVal("select value   from config where name='event.feelabel' and config_id=(select config_id from eventinfo where eventid=?)",new String[]{eventid});
	if(feeconfiguration==null)
	feeconfiguration="Fee";


        String ordernumber=DbUtil.getVal("select ordernumber from event_reg_transactions where tid=?",new String []{jBean.getTransactionId()});

	String startdate=null;
	String enddate=null;
	String venue=null;
	String starttime=null;
	String endtime=null;
	String location=null;
	
	if(sobj.getStatus()){
	
	    startdate=GenUtil.getHMvalue(scopemap,"STARTDATE","");
		enddate=GenUtil.getHMvalue(scopemap,"ENDDATE","");
		venue=GenUtil.getHMvalue(scopemap,"VENUE","");
		starttime=GenUtil.getHMvalue(scopemap,"STARTTIME","");
		endtime=GenUtil.getHMvalue(scopemap,"ENDTIME","");
		location=GenUtil.getHMvalue(scopemap,"LOCATION","");
	}

			
	String link=EbeeConstantsF.get("link.ebee.page","Back to Eventbee Page");
	String link1=EbeeConstantsF.get("link.ebee.page","Back to Eventbee Page");
	String link2=EbeeConstantsF.get("link.event.page","Back to Event Page");
		
	String attendee=GenUtil.getHMvalue(scopemap,"event.reg.attendee.label","Attendee");
	String attendeeshow=GenUtil.getHMvalue(scopemap,"event.reg.attendeekey.show","Yes");
	String attendeelink=GenUtil.getHMvalue(scopemap,"event.reg.attendeelink.show","Yes");
	
	String event_name=DbUtil.getVal("select eventname from eventinfo where eventid=?", new String [] {eventid});
	String username=DbUtil.getVal("select getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo where eventid=?", new String [] {eventid});
	String pattserver=ShortUrlPattern.get(username); 
	String eventurl=pattserver+"/event?eid="+eventid;
	
	String config_id="0";
		String fbconnapi=(String)session.getAttribute("FBCONNECTAPIKEY");
		
		if(fbconnapi==null){
			fbconnapi=DbUtil.getVal("select value from config where name='ebee.fbconnect.api' and config_id=?",new String[]{"0"});
			session.setAttribute("FBCONNECTAPIKEY", fbconnapi);
		}
	
%>




<%
String platform=(String)session.getAttribute("platform");
String linkpath="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/home/links";
String isntsenabled=DbUtil.getVal("select enablenetworkticketing from group_agent_settings where groupid=? ",new String [] {eventid});
String commission=DbUtil.getVal("select max(networkcommission) from price where evt_id=?",new String[]{eventid});	
commission="$"+commission;
String networkticketmsg="";

if("Yes".equals(isntsenabled)){
networkticketmsg+="<table id='ntsbox'><tr><td colspan='2'> Sell this event tickets, and get paid up to "+commission+" per each ticket"
				+" sale. Powered by Eventbee Network Ticket Selling. </td></tr>";

		if("ning".equals(platform)){
			networkticketmsg=networkticketmsg+" <tr><td width='50%'>&raquo;&nbsp; Add Eventbee Partner Network Application</td></tr></table>";
			}
			else	{
			networkticketmsg=networkticketmsg +" <tr><td width='50%'>&raquo;&nbsp; <a href='#' onclick=getAuthdata('/portal/mytasks/partnerlinks.jsp?groupid="+eventid+"','/portal/fbauth/authdatacheck.jsp');>"+EbeeConstantsF.get("eventpage.networkselling.participation.link","Participate")+"</a> </td>";
			
		networkticketmsg=networkticketmsg+"<td width='50%'>&raquo;&nbsp;<a href='http://www.eventbee.com/portal/helplinks/partnernetwork.jsp' target='_blank'>Learn More</a></td></tr></table>";
		
				
}
}

%>
<script>
function CreateFBInit(){
FB_RequireFeatures(["XFBML"], function()
    {
      FB.Facebook.init("<%=fbconnapi%>", "/portal/xd_receiver.jsp");
      
         
    });
}
CreateFBInit();
</script>

<table align="center" cellspacing="10">
<%
	if("Yes".equalsIgnoreCase(attendeeshow))
       {
%>
<tr><td>
	<table  width="100%">
 <%
 if("Google".equals(source))
 {
 	if("CHARGED".equals(orderstatus))
 		 orderstatus="OK";
 	else if("PAYMENT_DECLINED".equals(orderstatus))
 	     orderstatus="Failure";
 	  
 }else if("Paypal".equals(source)){
 	if("VERIFIED".equals(orderstatus))
 		 orderstatus="OK";
 	else if("INVALID".equals(orderstatus))
 	     orderstatus="Failure";	 
 
 }
 
 
 if("OK".equals(orderstatus)){%>
	<tr><td>
	<%if("true".equals(jBean.getUpgradeRegStatus())){
	%>
	   Your have successfully edited/upgraded your existing event registration       
      <%}
      
      else{
      %>
	
	Your event registration is completed successfully.
	
	<%}%>
	
	
	A confirmation email with the following information will be sent to <%=pd[0].getEmail() %>.
	</tr></td>
	<%} else if("Failure".equals(orderstatus)){%>
		Failed transaction, <a href='<%=eventurl%>'>please go back to event registration page</a>. If you
		see this message again, please select different payment option in the
		registration process, or contact support@eventbee.com
	
	<%}else{%>
	Your event registration process is completed. You will get an email
	notification after we get final confirmation from <%=source%> Payment.

	<%}%>
	<tr><td class='inform'><font class='error'><br/>
		NOTE: If you do not find confirmation email in your Inbox, please do check 
	your Bulk folder, and update your spam filter settings to allow Eventbee 
	emails. Google/Paypal takes few minutes to send us successful payment information.
	For any reason your payment is declined by Google/Paypal, this
	confirmation becomes INVALID. We will notify you by email if there is any
	problem with your Google/Paypal payment.
</font><br/>
	<br/>
	<%
		 if(pd !=null && pd[0] !=null){
		 
		 
        if("true".equals(jBean.getUpgradeRegStatus())){%>
			 
	 Your new Transaction ID is <%=jBean.getTransactionId()%>.
	 Note, your old Transaction ID is no  longer valid. <a href="#" onclick="window.print()"/>Print this page</a> (or confirmation email), and bring it to the event venue.
		 
	<%}
	else{%>	 
	Your Transaction ID is <%=jBean.getTransactionId()%> and Order Number is <%=ordernumber%>. <a href="#" onclick="window.print()"/>Print this page</a> (or confirmation email), and bring it to the event venue.
	<%
	}}
	%>
	</td></tr>
	
	<tr><td>
	<table cellpadding ='0' width='100%' > 
	<br/>
	<tr><td ><font class='medium'>Event:</font> <br/><%=event_name%><br/>
		Event URL - <%=eventurl%><br/>
		When - Starts <%=startdate+" "+starttime%>, Ends <%=enddate+" "+endtime%>
		<br/>
		
		Where - <%=venue%>, <%=location%>
		        
	</td></tr>
	</table>
</td></tr>
<tr><td class="medium"><%=GenUtil.getHMvalue(scopemap,"event.reg.attendee.label","Attendee")%>s:</td></tr>

<%
	if(pd!=null){
		for (int i=0;i<pd.length;i++) { 
%>		
<tr>
<%=rowdisplay(i+1)%><%=GenUtil.XMLEncode(pd[i].getFirstName())%> <%=GenUtil.XMLEncode(pd[i].getLastName())%>, <%=GenUtil.XMLEncode(pd[i].getEmail())%>
<%if(GenUtil.XMLEncode(pd[i].getPhone())!=null&&!"".equals(GenUtil.XMLEncode(pd[i].getPhone()))){%>
, <%=GenUtil.XMLEncode(pd[i].getPhone())%>
<%}%>
</td>
</tr>		
		
<%		}



}%>
<tr><td></td></tr>
 <tr><td class="medium">Tickets:</td></tr>
    <tr><td>
  <table   width="100%" >
  <tr class="colheader">
<td width="40%">Ticket Name</td><td width="15%">Price (<%=currencyformat%>)</td><td width="15%"><%=feeconfiguration%> (<%=currencyformat%>)</td><td width="10%">Quantity</td><td width="15%">Discount (<%=currencyformat%>)</td><td width="20%">Total (<%=currencyformat%>)</td>
</tr>
<%
if(reqTicket!=null){

%>
    
<%
   out.println("<tr>");
   rowcount++;
%>
<%=rowdisplay(rowcount)%><%=encode(jBean.getReqTicketName())%></td>
<%=rowdisplay(rowcount)%><%=CurrencyFormat.getCurrencyFormat("",""+jBean.getTicketDisplayPrice(),true)%></td>
<%=rowdisplay(rowcount)%><%=CurrencyFormat.getCurrencyFormat("",""+jBean.getTicketProcessFee(),true)%></td>
<%=rowdisplay(rowcount)%><%=jBean.getReqTicketQty()%></td>
<%=rowdisplay(rowcount)%><%=CurrencyFormat.getCurrencyFormat("",""+jBean.getReqTicketDiscount(),true)%></td>
<%=rowdisplay(rowcount)%><%=CurrencyFormat.getCurrencyFormat("",""+jBean.getReqTicketTotal(),true)%></td>
        </tr>
<%
}
%> 

<%
if(optTickets!=null){
for(int i=0;i<optTickets.length;i++){
%>

<%
  out.println("<tr>");
  rowcount++;
%>
<%=rowdisplay(rowcount)%><%=encode(jBean.getOptTicketName()[i])%></td>
<%=rowdisplay(rowcount)%><%=CurrencyFormat.getCurrencyFormat("",""+jBean.getOptTicketDisplayPrice()[i],true)%></td>
<%=rowdisplay(rowcount)%><%=CurrencyFormat.getCurrencyFormat("",""+jBean.getOptTicketProcessFee()[i],true)%></td>

<%=rowdisplay(rowcount)%><%=jBean.getOptTicketQty()[i]%></td>
<%=rowdisplay(rowcount)%><%=CurrencyFormat.getCurrencyFormat("",""+jBean.getOptTicketDiscount()[i],true)%></td>
<%=rowdisplay(rowcount)%><%=CurrencyFormat.getCurrencyFormat("",""+jBean.getOptTicketTotal()[i],true)%></td>
  </tr>
<%
}
}
%>

<tr>
<td height='10'></td>
</tr> 
  <tr>
  <td class="inform" width="30%">Total (<%=currencyformat%>)</td>
  <td ></td>
  <td ></td>
  <td ></td>
   <td ></td>
 
  <td width="20%" ><%=CurrencyFormat.getCurrencyFormat(currencyformat,""+GrandTotal,false)%></td>
</tr>
</table>

</td></tr>
<tr><td>Please print or save this information for your records.</td></tr>
	
<%}%>


<%
if(!"ning".equals((String)session.getAttribute("platform"))){%>
 
 <tr><td align="left" class="inform">
        <a target="_top" href="<%=eventurl%>"><%=link2%></a>
             </td>
  
  </tr>
  <%}%>
       </table></td>
       
       
       <td id="navi" valign="top">
	      <table width="100%">
	      <!--  <tr>
	          <td id="ntsbox"><%=networkticketmsg%></td>
	        </tr>-->
			<tr><td height="10"></td></tr>
			<!--tr><td id="box"></td></tr-->
		  <tr >
		  <td id="confirmationfeed">
		  <table class='portaltable' cellpadding="0" cellspacing="0" >
		  <tr><td colspan='2' class='evenbase'>
		  <%if("Yes".equals(isntsenabled)){%>
		  Let your Facebook friends know that you are attending this event by clicking the button below. Moreover, get paid upto <%=commission%> on each ticket purchase made by your Facebook friends! Powered by Eventbee Network Ticket Selling [<a href="javascript:popupwindow('<%=linkpath%>/networkticketselling.html','Tags','600','400')">?</a>].
		  <%}else{%>
		  Let your Facebook friends know that you are attending this event by clicking the button below.
		  <%}%></td></tr>
		  <tr><td width='50%' class='evenbase'><a href="#" onclick="Confirmationpagefbfeed('<%=eventid%>');"><img src="/home/images/fbconnect.gif" border='0'/></a></td></tr>
		  </table>
		  </td>
	        </tr>
	      </table>
	    </td>
	  </tr>
	 
	
</table>      

