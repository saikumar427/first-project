<%@ page import="java.util.*,com.eventbee.event.*,com.eventbee.event.ticketinfo.*"%>
<%@ page import="com.eventbee.authentication.Authenticate"%>
<%@ page import="com.eventbee.authentication.ProfileData"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.creditcard.*"%>
<%@ page import="org.apache.velocity.*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
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

<%@ include file="regemail.jsp" %>

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
	
	
	
HashMap getConfigSettings(String eventid){
DBManager db=new DBManager();
HashMap configMap=new HashMap();
StatusObj sb=db.executeSelectQuery("select * from config where config_id in(select config_id from eventinfo where eventid=?)",new String []{eventid});
if(sb.getStatus()){
for(int i=0;i<sb.getCount();i++){
configMap.put(db.getValue(i,"name",""),db.getValue(i,"value","Yes"));
}
}
return configMap;
}
	
	
%>





<%
String platform=(String)session.getAttribute("platform");

String groupid=request.getParameter("GROUPID");
String linkpath="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com")+"/home/links";

String isreload=request.getParameter("isreload");
String feeconfiguration=null;
System.out.println();
    
if((EventRegisterBean)session.getAttribute("regEventBean")==null){
	GenUtil.Redirect(response,"/guesttasks/transdonemsg.jsp?GROUPID="+groupid);
}else{

String appname=EbeeConstantsF.get("application.name","Eventbee");
   EventRegisterBean jBean = (EventRegisterBean)session.getAttribute("regEventBean");
   Authenticate Auth=(Authenticate)com.eventbee.general.AuthUtil.getAuthData(pageContext);
   HashMap configMap=getConfigSettings(jBean.getEventId());
   HashMap scopemap=jBean.getScopeMap();
   String currencyformat=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{jBean.getEventId()});
	if(currencyformat==null)
	currencyformat="$";
	if(configMap!=null){
	feeconfiguration=(String)configMap.get("event.feelabel");
	}
	if(feeconfiguration==null)
	feeconfiguration="Fee";


String ordernumber=DbUtil.getVal("select ordernumber from event_reg_transactions where tid=?",new String []{jBean.getTransactionId()});
String showFbBtn=(String)configMap.get("event.show.fbblock.confirmationscreen");
boolean isShowEbeePage=("No".equals((String)session.getAttribute("fromcontext")));
    int rowcount=0;
   
    EventRegisterDataBean edb= new EventRegisterDataBean();
   String xmlregdata=DbUtil.getVal("select ebee_xml  from eventbee_payment_data where transactionid=?", new String []{jBean.getTransactionId()}); 
   EventRegisterManager erm=new EventRegisterManager();
   if(xmlregdata!=null)
   EventRegisterManager.initEventRegXmlData(xmlregdata,edb);
  
    if(jBean.getUpgradeRegStatus()){
    String result=DbUtil.getVal("select mergeTransactions(?,?) as result", new String []{jBean.getOldTransactionId(),jBean.getTransactionId()}); 
    EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"end.jsp Transaction upgraded","OLD TRANSACTION ID---"+jBean.getOldTransactionId()+"----NEW TRANSACTION ID---"+jBean.getTransactionId(),"",null);
   }
  ProfileData[] pd=edb.getProfileData();
 int mailstatus=sendRegistrationEmail(pd,edb);

   EventTicket reqTicket=jBean.getSelectedReqTicket();
   EventTicket[] optTickets=jBean.getSelectedOptTickets();
    double GrandTotal=jBean.getGrandTotal();
    double processfee=0;
   if ("attendee".equals(jBean.getAccountFee())){
          processfee=jBean.getAttendeeFee();
     }	
   
   StringBuffer confmessage=new StringBuffer();
   
 
   String message=EbeeConstantsF.get("eventregistration.done","Your event registration is completed sucessfully. Please keep<br/> a record of your Transaction code.You may visit event updates page anytime<br/> by using this code.");
   String message1=EbeeConstantsF.get("eventregistration.done.cofirmationkey","your Confirmation Key:");
   String link=EbeeConstantsF.get("link.home.page","Back to My Home");
   String link1=EbeeConstantsF.get("link.ebee.page","Back to Eventbee Page");
   String link2=EbeeConstantsF.get("link.event.page","Back to Event Page");
   
   
   
   String attendee=GenUtil.getHMvalue(scopemap,"event.reg.attendee.label","Attendee");
   String attendeeshow=GenUtil.getHMvalue(scopemap,"event.reg.attendeekey.show","Yes");
   String attendeelink=GenUtil.getHMvalue(scopemap,"event.reg.attendeelink.show","Yes");

%>

<%

String isntsenabled=DbUtil.getVal("select enablenetworkticketing from group_agent_settings where groupid=? ",new String [] {groupid});
String commission=DbUtil.getVal("select max(networkcommission) from price where evt_id=?",new String[]{groupid});	
commission="$"+commission;
String networkticketmsg="";
if("Yes".equals(isntsenabled)){
networkticketmsg+="<table id='ntsbox'><tr><td colspan='2'> Promote this event, and get paid up to "+commission+" per each ticket"
				+" sale. Powered by Eventbee Network Ticket Selling. </td></tr>";
				if("ning".equals(platform)){
			networkticketmsg=networkticketmsg+" <tr><td width='50%'>&raquo; Add Eventbee Partner Network Application</td></tr></table>";
			}
			else	{
			networkticketmsg=networkticketmsg +" <tr><td width='50%'>&raquo; <a href='#' onclick=getAuthdata('/portal/mytasks/partnerlinks.jsp?groupid="+groupid+"','/portal/fbauth/authdatacheck.jsp');>"+EbeeConstantsF.get("eventpage.networkselling.participation.link","Participate")+"</a> </td>";
			
			
			
			networkticketmsg=networkticketmsg+" <td width='50%'>&raquo; <a href='http://www.eventbee.com/portal/helplinks/partnernetwork.jsp' target='_blank'>Learn More</a></td></tr></table>";
			}	
				
}





%>



<% 
String processing_fee="";
String event_name=DbUtil.getVal("select eventname from eventinfo where eventid=?", new String [] {request.getParameter("GROUPID")});
String username=DbUtil.getVal("select getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo where eventid=?", new String [] {request.getParameter("GROUPID")});
String  serveraddress="http://"+EbeeConstantsF.get("serveraddress","");
String eventurl=serveraddress+"/event?eid="+request.getParameter("GROUPID");	

 	request.setAttribute("NavlinkNames",new String[]{event_name});
	String participant=jBean.getAgentId();
	

	String config_id="0";
		String fbconnapi=(String)session.getAttribute("FBCONNECTAPIKEY");
		
		if(fbconnapi==null){
			fbconnapi=DbUtil.getVal("select value from config where name='ebee.fbconnect.api' and config_id=?",new String[]{"0"});
    	
			session.setAttribute("FBCONNECTAPIKEY", fbconnapi);
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
       
<!-- new start -->
 <%
 
 
       if("Yes".equalsIgnoreCase(attendeeshow))
       {
       %>
 <tr>
    <td id="content" valign="top"> 

	<table  width="100%">
	<tr><td>


        <% if(jBean.getUpgradeRegStatus()){%>
     Your have successfully edited/upgraded your existing event registration       
      <% }
	else{%>
       Your event registration is completed successfully.
	<%}
	%>
	A confirmation email with the following information will be sent to <%=pd[0].getEmail() %>.
	</td></tr>
	<tr><td ><font class='error'><br/>
		NOTE: If you do not find confirmation email in your Inbox, please do check 
	your Bulk folder, and update your spam filter settings to allow Eventbee 
	emails.
	<%if("eventbee".equalsIgnoreCase(jBean.getSelectPayType())){%>
	
	Online registration is processed by Eventbee payment processing. 
	Eventbee appears on your credit card statement.
	<%}%>
	</font><br/>
	<br/>
	<%
		 if(pd !=null && pd[0] !=null){
	 
	 
	 if(jBean.getUpgradeRegStatus()){%>
	 
	 
	 Your new Transaction ID is <%=jBean.getTransactionId()%>.
	 Note, your old Transaction ID is no  longer valid. <a href="#" onclick="window.print()"/>Print this page</a> (or confirmation email), and bring it to the event venue.
		 
	<%}
	else{%>
	  
	Your Transaction ID is <%=jBean.getTransactionId()%> and Order Number is <%=ordernumber%>. <a href="#" onclick="window.print()"/>Print this page</a> (or confirmation email), and bring it to the event venue.
	<%}
	}
	%>
	</td></tr>
	<tr><td>
	<tr><td ><font class='medium'>Event:</font> <br/><%=event_name%><br/>
		Event URL - <%=eventurl%><br/>
		When - Starts <%=jBean.getObject("STARTDATE")+" "+jBean.getObject("STARTTIME")%>, Ends <%=jBean.getObject("ENDDATE")+" "+jBean.getObject("ENDTIME")%>
		<br/>
		
		Where -<%if(!"".equals(jBean.getObject("VENUE"))){%><%=jBean.getObject("VENUE")%>,<%}%> <%=jBean.getObject("LOCATION")%>
		        
	</td></tr>
	
<tr><td class="medium"><%=GenUtil.getHMvalue(scopemap,"event.reg.attendee.label","Attendee")%>s:</td></tr>

<% 
	String contextpath="/manager".equals( request.getContextPath() )?"/manager":"/portal"; 
     
     for (int i=0;i<pd.length;i++) { 
          ///portal/attendeeview/attendeepage.jsp?UNITID=13579&GROUPID=14419&attendeekey=AKPVWOFMMM
	 String attlink=contextpath+"/attendeeview/attendeepage.jsp?GROUPID="+jBean.getEventId()+"&attendeekey="+jBean.getAttendeekeys()[i];
%>

<tr><%=rowdisplay(i+1)%>
<%=GenUtil.XMLEncode(pd[i].getFirstName())%> <%=GenUtil.XMLEncode(pd[i].getLastName())%>, <%=GenUtil.XMLEncode(pd[i].getEmail())%>,
<%if(GenUtil.XMLEncode(pd[i].getPhone())!=null&&!"".equals(GenUtil.XMLEncode(pd[i].getPhone()))){%>
 <%=GenUtil.XMLEncode(pd[i].getPhone())%>
<%}%>
</td>
</tr>
<% } %>
<tr><td></td></tr>

  <tr><td class="medium">Tickets:</td></tr>
    <tr><td>
  <table   width="100%" cellpadding="5">
  <tr class="colheader">
<td width="40%">Ticket Name</td><td width="15%">Price (<%=currencyformat%>)</td><td width="10%">Quantity</td><td width="15%">Discount (<%=currencyformat%>)</td><td width="15%"><%=feeconfiguration%> (<%=currencyformat%>)</td><td width="20%">Total (<%=currencyformat%>)</td>
</tr>
<%
if(reqTicket!=null){

%>
    
<%
   out.println("<tr>");
   rowcount++;
%>
<%=rowdisplay(rowcount)%><%=encode(reqTicket.getTicketName())%></td>
<%=rowdisplay(rowcount)%><%=CurrencyFormat.getCurrencyFormat("",""+reqTicket.getTicketDisplayPrice(),true)%></td>
<%=rowdisplay(rowcount)%><%=reqTicket.getSelQty()%></td>
<%=rowdisplay(rowcount)%><%=CurrencyFormat.getCurrencyFormat("",""+reqTicket.getSelDiscount(),true)%></td>
<%=rowdisplay(rowcount)%><%=CurrencyFormat.getCurrencyFormat("",""+reqTicket.getTicketProcessFee(),true)%></td>
<%=rowdisplay(rowcount)%><%=CurrencyFormat.getCurrencyFormat("",""+reqTicket.getTotalAmount(),true)%></td>
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
<%=rowdisplay(i+1)%><%=encode(optTickets[i].getTicketName())%></td>
<%=rowdisplay(i+1)%><%=CurrencyFormat.getCurrencyFormat("",""+optTickets[i].getTicketDisplayPrice(),true)%></td>
<%=rowdisplay(i+1)%><%=optTickets[i].getSelQty()%></td>
<%=rowdisplay(i+1)%><%=CurrencyFormat.getCurrencyFormat("",""+optTickets[i].getSelDiscount(),true)%></td>
<%=rowdisplay(i+1)%><%=CurrencyFormat.getCurrencyFormat("",""+optTickets[i].getTicketProcessFee(),true)%></td>
<%=rowdisplay(i+1)%><%=CurrencyFormat.getCurrencyFormat("",""+optTickets[i].getTotalAmount(),true)%></td>
  </tr>
<%
}
}
%>


<tr>
<td height='10'></td>
</tr> 

<%
if(jBean.getTaxAmount()>0){%>
 <tr>
  <td class="inform" width="30%">Tax (<%=currencyformat%>)</td>
  <td ></td>
  <td ></td>
  <td ></td>
  <td ></td>

  <td width="20%" ><%=CurrencyFormat.getCurrencyFormat(currencyformat,""+jBean.getTaxAmount(),false)%></td>
</tr>


<%}%>


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
	
	<tr><td>
	
	<%if(( "card".equalsIgnoreCase(jBean.getSelectPayType()))&&(jBean.getGrandTotal()>0) ){%>
	Please print or save this information for your records.
	<%}else if("other".equalsIgnoreCase(jBean.getSelectPayType())){
	
	
	HashMap ptypehm=PaymentTypes.getPaymentTypeInfo(jBean.getEventId(),"Event","other");
	String otherdesc=null;
	
	if(ptypehm!=null){
		otherdesc=(String)ptypehm.get("attrib_1");
	
}
	
	%>
	<b>Payment:</b> <%=GenUtil.XMLEncode(otherdesc)  %>
	<%}%>
	</td></tr>



	
	
	 <%
       
       }
       %>
<!-- new end -->

    
   <tr>
      <td>
       <table>
       
       
     <%  if(!"ning".equals((String)session.getAttribute("platform"))){%>

         <tr>
      <% if (isShowEbeePage){ %>

            <td align="right" class="inform">
                <a target="_top" href="/portal/home.jsp"><%=link1%></a>
            </td> 
        <%  } %>

        <% 
        String code=(String)session.getAttribute("discountcode_"+request.getParameter("GROUPID"));

        String evtlink=serveraddress+"/event?eid="+request.getParameter("GROUPID");
        String trckcode=(String)session.getAttribute("trckcode");
	String trackcode=(String)session.getAttribute(groupid+"_"+trckcode);
	if(trackcode!=null){
	evtlink=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{request.getParameter("GROUPID")});
	if(evtlink!=null)
	evtlink=evtlink+"/track/"+trackcode;
	}
        if(code!=null)
        evtlink=evtlink+"&code="+code;
        if("FB".equals(request.getParameter("context"))){
        	evtlink="http://apps.facebook.com/"+EbeeConstantsF.get("fbapp.eventregapp.name","eventregister")+"/register?Gid="+request.getParameter("GROUPID")+"&context=FB";
        }
        %>
            
            
        <td align="right" class="inform">
        <a target="_top" href="<%=evtlink%>"><%=link2%></a>
             </td>
       
   </tr><%}%>
       </table>
       
        </td></tr></table></td>
         <%
         if(!"No".equals(showFbBtn)){%>
		
	    <td id="navi" valign="top">
	      <table width="100%">
	        <!--<tr>
	       	
	          <td id="ntsbox"><%=networkticketmsg%></td>
	        </tr>-->
			<tr><td height="10"></td></tr>
			  <tr >
			  <td id="confirmationfeed">
			  <table class='portaltable' cellpadding="0" cellspacing="0" >
			  <tr><td colspan='2' class='evenbase'>
			  <%
			   if("Yes".equals(isntsenabled)){%>
			  Let your Facebook friends know that you are attending this event by clicking the button below. Moreover, get paid upto <%=commission%> on each ticket purchase made by your Facebook friends! Powered by Eventbee Network Ticket Selling [<a href="javascript:popupwindow('<%=linkpath%>/networkticketselling.html','Tags','600','400')">?</a>].
			  <%}else{%>
			  Let your Facebook friends know that you are attending this event by clicking the button below.
			  <%}
			  %></td></tr>
			  <tr><td width='50%' class='evenbase'><a href="#" onclick="Confirmationpagefbfeed('<%=groupid%>');"><img src="/home/images/fbconnect.gif" border='0'/></a></td></tr>
			  </table>
			  </td>
		        </tr>
		        
		      </table>
		    </td>
		    <%}%>
	  </tr>
	  
	
</table>
		<%
		session.removeAttribute("regEventBean");
		session.removeAttribute("CouponContent_"+groupid);
		session.removeAttribute("MemCouponContent_"+groupid);
		session.removeAttribute(groupid+"community_login");
		}
		%>
