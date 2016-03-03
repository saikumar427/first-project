<%@ page import="com.eventbee.event.*,com.eventbee.event.ticketinfo.*"%>
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.general.GenUtil"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.survey.*"%>
<%@ page import="com.eventbee.creditcard.*"%>
<%@ page import="com.eventbee.useraccount.*" %>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>

<%@ include file='/xfhelpers/xffunc.jsp' %>


<%!

String rowdisplay(int count){
		if(count%2==0){
			return "<td class='evenbase'>";
		}else{
			return "<td class='oddbase'>";
		}
	}
   



%>


<%@ include file='ticketingHelper.jsp' %>

<script language="javascript" src="/home/js/ajax.js">
         function dummy(){}
</script>

<%!
 	String TicketsDisplay(EventRegisterBean jBean,String title,String selectOneRef, 
			String baseRef,EventTicket[] Tickets,  boolean selectOneNeeded, 
			boolean selectManyNeeded,
			boolean isQtyFixed, boolean couponExists,String description,
			boolean includebasefee, Map reqMap,int count,String option,Vector v,HashMap ticketidsmap,HashMap donationsMap){
	String qty="";
	String minqty="";
	String maxqty="";
	boolean isDonation=false;
	HashMap scopemap=jBean.getScopeMap();
	String currencyformat=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{jBean.getEventId()});

	if(currencyformat==null)
		currencyformat="$";
	  String feeconfiguration=DbUtil.getVal("select value   from config where name='event.feelabel' and config_id=(select config_id from eventinfo where eventid=?)",new String[]{jBean.getEventId()});
		if(feeconfiguration==null)
		feeconfiguration="Fee";
	StringBuffer sb=new StringBuffer("");
	sb.append("<table width='100%'>");
	sb.append("<tr><td>");
	sb.append("<table width='100%'>");
	sb.append("<tr><td class='colheader' width='5%'/>" );
	sb.append("<td class='colheader' width='65%' ></td>");
	sb.append("<td class='colheader' width='10%' >Price ("+currencyformat+")</td>");
	sb.append("<td class='colheader' width='10%' >"+feeconfiguration+" ("+currencyformat+")</td>");
	sb.append("<td class='colheader' width='5%'>Quantity</td>");
	sb.append("<td width='10%' style='{font: 62.5% verdana, sans-serif;}'></td>");
	sb.append("</tr>");

     	 String grpnam="";
     	 String gname="";
     	 String grpdesc="";
     	 int i=0;
     	 String base="oddbase";
     	 int groupindex=0;
     	 boolean isgroupticket=false;
        	for ( i=0;i<Tickets.length; i++) {
        	      isgroupticket=false;
        	      isDonation=false;
        	       if(v!=null&&v.size()>0&&i<v.size()){
        	        
        	        HashMap hm1=(HashMap)v.elementAt(i);
        	       
        	         String grpnam1=(String)hm1.get("name");
        	         grpdesc=(String)hm1.get("description");
        	         if(!"".equals(grpnam1)){
        	         if(gname.equals(grpnam1)){
			    grpnam="";
			    grpdesc="";
			    }
		        else{
			    groupindex++; 
			    grpnam=grpnam1 ;
        	           }
        	         isgroupticket=true;
        	         }
        	         else
        	         {
        	         groupindex++;
        	         grpnam="";
			    grpdesc="";
        	         
        	         }
        	                	        
        	        gname=grpnam1;
   	          	     
        	    }
			sb.append("<input type='hidden' name='cost"+option+i+"' id='cost"+option+i+"' value='"+CurrencyFormat.getCurrencyFormat("",Tickets[i].getTicketDisplayPrice(),true)+"'>");
			sb.append("<input type='hidden' name='processfee"+option+i+"' id='processfee"+option+i+"' value='"+jBean.getTotalProcessfee(Tickets[i],1)+"'>");
			sb.append("<input type='hidden' name='discost_"+Tickets[i].getTicketId()+"' id='discost_"+Tickets[i].getTicketId()+"' value=''>");
			sb.append("<input type='hidden' name='discount_"+Tickets[i].getTicketId()+"' id='discount_"+Tickets[i].getTicketId()+"' value='' >");
			sb.append("<input type='hidden' name='discountcode' id='discountcode' value='"+Tickets[i].getCouponCode()+"' >");
			sb.append("<input type='hidden' name='processfee_"+Tickets[i].getTicketId()+"' id='processfee_"+Tickets[i].getTicketId()+"' value='"+Tickets[i].getTicketProcessFee()+"' >");
			boolean memberticket=false;
			String Ticketname=Tickets[i].getTicketName();
			String disable="";
			String checked="checked";
			if(ticketidsmap.containsKey(Tickets[i].getTicketId())){
			
			memberticket=true;
			Ticketname=Ticketname;
			disable="disabled";
			checked="";
			}
			if(donationsMap.containsKey(Tickets[i].getTicketId())){
			isDonation=true;
			}
			
			if("Success".equals(jBean.getCommunityLoginStatus())){
			disable="";
			checked="checked";
			}
			
			int coupon=Tickets[i].getCouponCount();
			int j=count+i;
			String tktqty="";
			if("/publicTickets".equals(baseRef)){
				tktqty=(jBean.getPublicTickets())[i].getTicketQty();
				if("".equals(tktqty)) tktqty=Tickets[i].getMinQty()+"";

			}
			else if("/optTickets".equals(baseRef)){
				tktqty=(jBean.getOptTickets())[i].getTicketQty();
			}
			
			if(groupindex%2!=0)
			base="evenbase";
			else
			base="oddbase";
			if(!"".equals(grpnam)){
		        sb.append("<tr><td colspan='5' class='"+base+"'><strong>"+grpnam+"</strong><br/><br/>"+grpdesc+"</td></tr>");
        	    	}sb.append("<tr>");  
			
			if(selectOneNeeded){
				
			if(isgroupticket)	
			{
			
			sb.append("<td width='20' class='"+base+"'> </td>");
			sb.append("<td valign='center' class='"+base+"' ><span class='inform'><strong>");
			}
			else{
			sb.append("<td colspan='2' valign='center' class='"+base+"'><span class='inform'><strong>");
			}
				
			sb.append(getXfSelectOneRadio(selectOneRef, new String[]{Tickets[i].getTicketId()}, new String[]{GenUtil.XMLEncode(Ticketname)},jBean.getTicketSelect() ," "+disable+"  onclick=SubmitTicketOnBlur();getTotalAmt(); ","price_"+Tickets[i].getTicketId()));
			
			}else if(selectManyNeeded){
				if(isgroupticket)	
							{
							
							sb.append("<td width='20' class='"+base+"' > </td>");
							sb.append("<td valign='center' class='"+base+"' ><span class='inform'><strong>");
							}
			       else{
			       sb.append("<td colspan='2' valign='center' class='"+base+"' ><span class='inform'><strong>");
			       			}
			   	sb.append(getXfSelectMany(selectOneRef, new String[]{Tickets[i].getTicketId()}, new String[]{GenUtil.XMLEncode(Ticketname)},jBean.getOptTicketsSelect()," "+disable+"   onclick=setDonation("+Tickets[i].getTicketId()+","+i+",'"+option+"');getTotalAmt();  ","price_"+Tickets[i].getTicketId() ));
				
		       
		       }else{
		       
		       
		                if(isgroupticket)	
				{

				sb.append("<td width='20' class='"+base+"'> </td>");
				sb.append("<td valign='center' class='"+base+"'  ><span class='inform'><strong>");
				}
			else{
			   sb.append("<td colspan='2' valign='center' class='"+base+"' ><span class='inform'><strong>");
			    }   sb.append("<input type='checkbox' id='price_"+Tickets[i].getTicketId()+"' name='onlyonereq' "+checked+"  disabled  onClick='SubmitTicketOnBlur()' >");
				
				sb.append(getXfHidden(selectOneRef, Tickets[i].getTicketId()));
				sb.append(GenUtil.XMLEncode(Ticketname));
				sb.append("<br/>");
			}
			
                        if(ticketidsmap.containsKey(Tickets[i].getTicketId())){
			sb.append("</strong>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<span class='smallestfont'>Member Only Option</span>&nbsp;&nbsp;<span style='cursor: pointer; text-decoration: underline' class='smallestfont' id='login_"+Tickets[i].getTicketId()+"' name='login'  onclick='memberlogin();' >Login</span><br/><br/>"+ GenUtil.textToHtml(GenUtil.XMLEncode(Tickets[i].getDescription())));
			}else{
			sb.append("</strong><br/>"+ GenUtil.textToHtml(GenUtil.XMLEncode(Tickets[i].getDescription())));
			}
			sb.append("</span></td><td class='"+base+"'><table><tr>");
			
			sb.append("<td id='ticket_"+Tickets[i].getTicketId()+"'  valign='center'><span class='inform'>");
			
			if(isDonation){
			sb.append("<div id='donationerror_"+Tickets[i].getTicketId()+"' class='error'></div>");
			sb.append("<input type='text' id='donation_"+Tickets[i].getTicketId()+"' name='donation_"+Tickets[i].getTicketId()+"' size='3' value='"+CurrencyFormat.getCurrencyFormat("",Tickets[i].getTicketPrice(),true)+"'  onBlur=setDonation("+Tickets[i].getTicketId()+","+i+",'"+option+"');>");
			sb.append("<input type='hidden' id='qty"+option+i+"' name='qty"+option+i+"' value='1' />");
			sb.append(getXfHidden(baseRef+"["+(i+1)+"]/ticketQty", "1"));
			}
			else{
			sb.append(CurrencyFormat.getCurrencyFormat("",Tickets[i].getTicketDisplayPrice(),true));
			}
			sb.append("</td><td id='upticket_"+Tickets[i].getTicketId()+"' valign='center'><span class='inform'></td></tr></table></td>");
			
			sb.append("<td id='processfee_"+Tickets[i].getTicketId()+"'  class='"+base+"'  valign='center' ><span class='inform'>");
			if(!isDonation){
			sb.append(CurrencyFormat.getCurrencyFormat("",Tickets[i].getTicketProcessFee(),true));
			}
			else{
			//sb.append("<input type='button' name='ticketdonation' value='donate' />");
			
			}
			sb.append("</span></td><td align='center' class='"+base+"'  valign='center'><span class='inform'>");
			
			
			if (isQtyFixed){
               			sb.append(getXfHidden(baseRef+"["+(i+1)+"]/ticketQty", "1"));
				sb.append("1");
			}else{
				
				sb.append("<input type='hidden' name='price_value' id='ival_"+Tickets[i].getTicketId()+"' value='"+i+"'>");
				sb.append("<input type='hidden'         name='priceidoption' id='option_"+Tickets[i].getTicketId()+"' value='"+option+"'>");


				if(!isDonation){
				sb.append("<select   id='qty"+option+i+"' name='"+GenUtil.getEncodedXML(baseRef+"["+(i+1)+"]/ticketQty")+"' "+disable+"  ");

				if(tktqty!=null){
				minqty=Integer.toString(Tickets[i].getMinQty());
				maxqty=Integer.toString(Tickets[i].getMaxQty());

					if(selectOneNeeded){
					qty=jBean.getPublicTickets()[i].getTicketQty();
					
					sb.append(" onKeyPress=' keypress2(event,this,"+j+")' value='"+GenUtil.getEncodedXML(tktqty)+"' onChange=' selectOne(this,"+j+");' >" );

					for(int k=Tickets[i].getMinQty();k<=Tickets[i].getMaxQty();k++){
					sb.append("<option name='"+k+"' value='"+k+"' ");
					if(qty.equals(Integer.toString(k))){
					sb.append("selected=selected");
					}
					sb.append(" >"+k+"</option>");
									
					}

					
					
					}else{
					if("/publicTickets".equals(baseRef))
					qty=jBean.getPublicTickets()[i].getTicketQty();
					else
					qty=jBean.getOptTickets()[i].getTicketQty();
					sb.append(" onKeyPress='keypress(event,this)' value='"+GenUtil.getEncodedXML(tktqty)+"' onChange='SubmitTicketOnBlur();' > " );
					for(int k=Tickets[i].getMinQty();k<=Tickets[i].getMaxQty();k++){
					sb.append("<option name='"+k+"' value='"+k+"' ");
					if(qty.equals(Integer.toString(k))){
					sb.append("selected=selected");
					}
					sb.append(" >"+k+"</option>");
				
					}
					

    						
				}}

    				
    				sb.append("</select>");
    				}
    				
    			}
			sb.append("</span></td>");

        		
			
    			sb.append("</tr>");
   		}// end for loop
		sb.append("</table></td></tr></table>");
		return sb.toString();
		
 	}
 %>

<%

        String oldpaymenttype="";
	Map reqMap=(Map)session.getAttribute("reg_ticket");
	String evtid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid"});
	EventRegisterBean jBean = (EventRegisterBean)session.getAttribute("regEventBean");
	HashMap donationsMap=getDonationTicketIds(jBean.getEventId());
	
	if(donationsMap!=null&&donationsMap.size()>0){%>
	
	<input type='hidden' name='donationsExists' id='donationsExists' value='Yes' />
	
	<%}

	%>
<%@ include file='setsurveys.jsp' %>
	

<%
String eventid=jBean.getEventId();
	EventConfigScope evt_scope=new EventConfigScope();
	HashMap scopemap=evt_scope.getEventConfigValues(eventid,"Registration");
	String currencyformat=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{jBean.getEventId()});
        if(currencyformat==null)
	currencyformat="$";

	int pubTicketCount=0;
	int optTicketCount=0;
	int count=0;
	Vector v=null;
	Vector v1=null;
        boolean isQtyFixed=(("no").equals(jBean.getBookingType()));
	EventTicketDB eb=new EventTicketDB();
	EventTicket[] publicTickets=jBean.getPublicTickets();
	
	  if(publicTickets!=null)
	 v=getReqGroupDetails(evtid,publicTickets,"Public");
	
	EventTicket[] optionalTickets=jBean.getOptTickets();
	if(optionalTickets!=null)
	 v1=getReqGroupDetails(evtid,optionalTickets,"Optional");
	
	if (publicTickets!=null){
	pubTicketCount=publicTickets.length;
	publicTickets=orderTickets(publicTickets,v);
	
	jBean.setPublicTickets(publicTickets);
	}
	if (optionalTickets!=null)
	{optTicketCount=optionalTickets.length;
	
	
	optionalTickets=orderTickets(optionalTickets,v1);
	jBean.setOptTickets(optionalTickets);
	
	}
	
	
	boolean selectOneNeeded=(pubTicketCount>1);
	
	Authenticate au=AuthUtil.getAuthData(pageContext);
	String authid=null;
	if(au!=null)
		authid=au.getUserID();
	
	String event_name=DbUtil.getVal("select eventname from eventinfo where eventid=?", new String [] {evtid});
	String username=DbUtil.getVal("select getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo where eventid=?", new String [] {evtid});
	request.setAttribute("NavlinkNames",new String[]{event_name});

	String participant=jBean.getAgentId();

	if (participant!=null)	
	request.setAttribute("NavlinkURLs",new String[]{ShortUrlPattern.get(username)+"/event?eventid="+evtid+"&participant="+participant});
	else
	request.setAttribute("NavlinkURLs",new String[]{ShortUrlPattern.get(username)+"/event?eventid="+evtid});

	request.setAttribute("tasktitle","Select Tickets");
	request.setAttribute("tasksubtitle","Step 1 of  3");
	request.setAttribute("tabtype","event");
boolean frompartner=jBean.getAgentId()!=null &&! "".equals(jBean.getAgentId());	
	
String taxpercentage=jBean.getTaxPercentage();
if(taxpercentage==null||"".equals(taxpercentage)){
taxpercentage="0";
jBean.setTaxPercentage(taxpercentage);	
}
String couponExists=DbUtil.getVal("select distinct 'yes' from coupon_master where groupid=? and coupontype='General'",new String []{eventid});

%>
<%if("yes".equals(couponExists)){
%>
<input type="hidden" name="generalCoupon" id="generalCoupon" value="yes" />
<%}

String MemcouponExists=DbUtil.getVal("select distinct 'yes' from coupon_master where groupid=? and coupontype='Member'",new String []{eventid});

if("yes".equals(MemcouponExists)){
%>
<input type="hidden" name="MemCoupon" id="MemCoupon" value="yes" />
<%}%>
<%if(jBean.getAgentId()!=null&&!"".equals(jBean.getAgentId())&&!"null".equals(jBean.getAgentId())){
%>

<input type='hidden' name="isfrompartnersite" value="yes"  id="isfrompartnersite"/>
<%}
%>


<script>
var jid='<%=session.getId()%>';
</script>

<script type="text/javascript" language="JavaScript" src="/home/js/advajax.js">
        function dummy1() { }
</script>
<script type="text/javascript" language="JavaScript" src="/home/js/eventreg.js">
 	function dummy2() { }
</script>
<script language="javascript" src="/home/js/enterkeypress.js" >
	dummy23456=888;
</script>
<script language="javascript" src="/home/js/popup.js"></script>
<script type="text/javascript" language="JavaScript" >
	var evtid=<%=evtid%>;
	var audata=<%=authid%>;
	var xy='false';
	var val='evtmem';
	function submitform(){
		document.form1.elements["cocoon-action-next"].click();
	}
	function  keypress2(event1,tes,i){
		if( ( document.all && event1.keyCode == 13 ) || event1.which == 13 ){
			selectOne(tes,i);
 			submitform();
		}
	}
</script>
<script>
function memberlogin(){
document.getElementById('username').focus();
}
</script>

<%

boolean isUpgrade=jBean.getUpgradeRegStatus();
 String ismember=DbUtil.getVal("select 'yes' from event_communities where eventid=?",new String[]{jBean.getEventId()}); 
String login="";
String pass="";
String clubname="";
String clubid="";
String loginmsg="";
String signupmsg="";
String description="";
HashMap clubdetails=getHubDetails(jBean.getEventId());
if(clubdetails!=null&&clubdetails.size()>0){
 clubname=(String)clubdetails.get("clubname");
 clubid=(String)clubdetails.get("clubid");
 HashMap messagemap=getEventCustomMessages(jBean.getEventId());
 
 if((messagemap!=null&&messagemap.size()==0)||messagemap==null)
 messagemap=getUserCustomMessages(jBean.getEventId());
 

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
HashMap pricemap=getMemberTicketIds(jBean.getEventId()); 
if(pricemap!=null&pricemap.size()>0){
HashMap loginmap=(HashMap)session.getAttribute(jBean.getEventId()+"community_login");
HashMap clubinfo=AccountDB.getClubInfo(clubid);
String userid=(String)clubinfo.get("mgr_id");
String loginname=DbUtil.getVal("select login_name from authentication where auth_id=?", new String []{userid});
String cluburl="";

cluburl=ShortUrlPattern.get(loginname)+"/community/"+(String)clubinfo.get("code")+"/signup";;
if(loginmap!=null){
 login=(String)loginmap.get("loginname");
 pass=(String)loginmap.get("password");
 
if(login==null)
login="";

if(pass==null)
pass="";
}
String msgdisplay="none";
String logindisplay="block";


if("Success".equals(jBean.getCommunityLoginStatus())){
msgdisplay="block";
logindisplay="none";
}

%>

<table width='100%' align='center' >
<tr><td>

<form  id='membercommunity'  name='membercommunity' action="/portal/eventregister/reg/validatecommunitylogin.jsp"  method='post' />
<input type='hidden' name='loginsubmitted' id="loginsubmitted" value='<%=jBean.getCommunityLoginStatus()%>' />

<div id='communitylogin'>

<table cellspacing="0" class="taskbox" width="99%"  align="center" valign="top" border="0">
<tr><td id="membererror" class="error"></td></tr>

			
<tr ><td class="subheader"><div id='loginmsg' style='display:<%=msgdisplay%>;'>As a member of <%=clubname%>, you can avail Member Only Tickets</div></td></tr>
<tr><td id='hublogin' style='display:<%=logindisplay%>;'><table><tr ><td class="subheader"><%=loginmsg%> </td></tr>
<tr>
<td class="inputlabel" >User Name <input type="text" name="username" id="username" size="15" value="<%=login%>" />   Password  <input type="password" name="password" id="password"  size="15" value="<%=pass%>" />   <input type="button" name="submit" value="Login" onClick="SubmitLogin('isnew');" />  <a HREF="/portal/guesttasks/loginproblem.jsp?entryunitid=13579&UNITID=13579" target="_blank">Login help?</a> <a href="<%=cluburl%>" target="_blank"><%=signupmsg%></a></tr><tr><td class="subheader"><%=description%><br/><font class='smallestfont'>Member Only Tickets will be enabled after login</font></td>
		
	</tr></table></td></tr>



<input type='hidden' name="GROUPID" value="<%=jBean.getEventId()%>" />
</table></div></form></td></tr></table>
<%
}%>

<script>
var memberTickets=new Array();
<%
if(pricemap!=null&&pricemap.size()>0){
Set ss=pricemap.keySet();
Iterator im=ss.iterator();
while(im.hasNext()){
String str=(String)im.next();
%>
memberTickets.push(<%=str%>);

<%}}%>

</script>



<script>
var DonationTickets=new Array();
<%
if(donationsMap!=null&&donationsMap.size()>0){
Set ss=donationsMap.keySet();
Iterator ip=ss.iterator();
while(ip.hasNext()){
String str1=(String)ip.next();
%>
DonationTickets.push(<%=str1%>);

<%}}%>
</script>

<form id='attendeefrm' name='form1'  method="post"  view="ticket" action="/portal/eventregister/reg/ticketController.jsp;jsessionid=<%=session.getId()%>" > 
<input value="ticket" name="cocoon-xmlform-view" type="hidden" />
<input type="hidden" name="optTicketCount" value="<%=optTicketCount%>" id="optTicketCount"/>
<input type="hidden" name="pubTicketCount" value="<%=pubTicketCount%>" id="pubTicketCount"/>
<input type="hidden" name="taxAmount" value="" id="taxAmount"/>
<input type="hidden" name="memberTicket" id="memberTicket" value="<%=jBean.getCommunityLoginStatus()%>" />
<input type='hidden' name='formname' value='ticket' />
<input type='hidden' name='/selectPayType' value=''  id="/selectPayType"/>
<input type='hidden' name='taxfee' value='<%=taxpercentage%>'  id="taxfee"/>
<input type='hidden' id='upgrade' name='upgrade' value='<%=isUpgrade%>' />

<table width='100%' align='center' >
<%if(isUpgrade){
%>
<tr><td class='medium'>Existing Registration</td></tr>
<tr><td id='existingblock'>
<%out.println(showRegiteredTickets(jBean));
%></td></tr>
<%}
%>




<tr><td id='showerror' class='error' ></td></tr>
<tr><td id='showtkterror' class='error' ></td></tr>
<tr><td align='left' id='showattendeeerror' class='error' ></td></tr>
<%


if(pubTicketCount>0&&!isUpgrade){
 String requiredticketlabel=DbUtil.getVal("select value   from config where name='ticket.requiredticketslabel' and config_id=(select config_id from eventinfo where eventid=?)",new String[]{jBean.getEventId()});
		  	if(requiredticketlabel==null)
		  	requiredticketlabel="Select Required Ticket";
%>
<tr><td class='medium'><%=requiredticketlabel%></td></tr>
<tr><td id='pubticketblock'>

<%

       
	out.println(TicketsDisplay( jBean,"","ticketSelect", "/publicTickets",
		publicTickets, selectOneNeeded, false, isQtyFixed, jBean.getPublicCouponsExist(),
		(String)jBean.getObject("event.ticketpage.publicticket.statement"),false,
		reqMap,count,"publicTickets",v,pricemap,donationsMap));
	count=count+pubTicketCount;
}
out.println("</td></tr>");

double s=jBean.getGrandTotal();
if(optTicketCount>0){
 String optionalticketlabel=DbUtil.getVal("select value   from config where name='ticket.optionalticketslabel' and config_id=(select config_id from eventinfo where eventid=?)",new String[]{jBean.getEventId()});
		  	if(optionalticketlabel==null)
		  	optionalticketlabel="Select Ticket Types";
out.println("<tr><td class='medium'>"+optionalticketlabel+"</td></tr>");
out.println("<tr><td id='optionalticketsblock'>");
	
      		out.println(TicketsDisplay(jBean,"","optTicketsSelect", "/optTickets",
		optionalTickets, false,	true, false, jBean.getOptCouponsExist(),(String)jBean.getObject("event.ticketpage.optionalticket.statement"),true,reqMap,count,"Optional",v1,pricemap,donationsMap));
	out.println("</td></tr>");
}
%>
<%
if(pricemap!=null&&pricemap.size()>0){
Set ss=pricemap.keySet();
Iterator im=ss.iterator();
while(im.hasNext()){
String str=(String)im.next();
%>
<input type="hidden" name="member_<%=str%>" id="member_<%=str%>"  value="Yes">

<%}}%>


<tr><td width='100%' align="right"><table >
<tr><td width='75%' align="right"></td><td width='15%' align="left">Total (<%=currencyformat%>)</td><td id="totamount">$0.00</td><td width='10%'></td></tr>
<tr><td width='75%' align="right"></td><td width='15%' align="left">Discounts (<%=currencyformat%>)</td><td id="disamount">$0.00</td><td width='10%'></td></tr>
<tr><td width='75%' align="right"></td><td width='15%' align="left">Net Amount (<%=currencyformat%>)</td><td id="netamount">$0.00</td><td width='10%'></td></tr>


<%
double tax=0;
try{

tax=Double.parseDouble(taxpercentage);
}

catch(Exception e){
tax=0;
}

if(tax>0){

String TaxLabel=DbUtil.getVal("select value from config where name='tax.label' and config_id=(select config_id from eventinfo where eventid=?)",new String[]{jBean.getEventId()});

if(TaxLabel==null)
TaxLabel="Tax";
%>
<tr><td width='75%' align="right"></td><td width='15%' align="left"><%=TaxLabel%>-<%=taxpercentage%>% (<%=currencyformat%>)</td><td id="tax">$0.00</td><td width='10%'></td></tr>
<tr><td width='75%' align="right"></td><td width='15%' align="left">Grand Total (<%=currencyformat%>)</td><td id="grandtotamount">$0.00</td><td width='10%'></td></tr>
<%}%>
</table></td></tr>
<input type="hidden" name="reload" id="reload"  value="no">
</table> 

</form>


<tr><td ><div id='paydata'></div></td></tr>



<table>
<tr><td align='left' id='showacouponerror' class='error' ></td></tr>
<tr><td id='couponBlock'></td><td align='left' id='showacouponstatus' class='error' ></td></tr>
<tr><td align='left' id='memshowacouponerror' class='error' ></td></tr>
<tr><td id='memcouponBlock' ></td><td align='left' id='memshowacouponstatus' class='error' ></td></tr></table>


<table  width='100%' >
<tr><td class='error' id="msgtab"></td></tr>

<%

String embeddeddiscount=request.getParameter("code");
if(embeddeddiscount!=null&&!"".equals(embeddeddiscount)&&!"null".equals(embeddeddiscount)){
%>
<input type='hidden' id='embeddeddiscount'  name='embeddeddiscount' value='yes' />

<%
session.setAttribute("discountcode_"+eventid,embeddeddiscount);
}



HashMap ptypehm=PaymentTypes.getPaymentTypeInfo(evtid,"Event","other");
String otherdesc=null;

if(ptypehm!=null){
	otherdesc=(String)ptypehm.get("attrib_1");

}


ProfileData[] m_ProfileData=jBean.getProfileData();



String display="none";

String showloginsignup=DbUtil.getVal("select showlogin from eventinfo e,config c where e.config_id=c.config_id and c.name='event.poweredbyEB' and c.value='yes' and e.eventid=?",new String[]{evtid});
if(showloginsignup==null) showloginsignup="No";
if(au==null&&("Yes".equals(showloginsignup))){ 
String defaultradio=request.getParameter("memberType");




%>

<tr><td>
<form id='attendeelogininfo' name='attendeelogininfo'  method="post" action="/portal/eventregister/attendeeauth/processattendeeauth.jsp;jsessionid=<%=session.getId()%>"  onsubmit="submitLoginForm(); return false;" >
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
<div id='loginerrmsg' align='center'></div>
<table width='100%'>

<tr>
<td class='medium'>Attendee Information</td>
<td>
<input type='radio' name='memberType' value='evtmem'  <%=WriteSelectHTML.isRadioChecked("evtmem", ((defaultradio==null)||("".equals((defaultradio).trim())))?"evtmem":defaultradio)%> onclick='showMemberBlock();'  /> Eventbee Member 
<input type='radio' name='memberType' value='newmem' <%=WriteSelectHTML.isRadioChecked("newmem", defaultradio)%> onclick='showMemberBlock();' /> New to Eventbee
</td></tr>
<tr><td colspan='2'><div id='attendeeBlock'></div></td></tr>


</table>
</form>
</td></tr>
<script type="text/javascript">
	showMemberBlock();
</script>
<%}else if(au==null&&("No".equals(showloginsignup))){%>
	
	<tr><td class='medium'>Attendee Information</td></tr>
	<script type="text/javascript" language="JavaScript" >
		var val='newmem';
	</script>
<%}else if(au!=null){%>
	<tr><td class='medium'>Attendee Information</td></tr>
<%}%>
 	
<tr><td> 
        
	<div id='submsg' class='medium' style='display:none'>Attendee Info</div>
	<div id="attendeePersonalInfo" style='display:'<%=display%>'>
	</div>
</td></tr>
</table>
<table width='100%' >
<tr><td>
<form id='finalform' name='frm' action='/portal/eventregister/reg/confirm.jsp;jsessionid=<%=session.getId()%>'  method='post' >
<input type='hidden' name='GROUPID' value='<%=evtid%>' />
<input type='hidden' name='discountavailable' id='discountavailable' value='' />

<%if("FB".equals(request.getParameter("context"))){%>
<input type='hidden' name='context' id="fbcontext" value='FB' />
<%}%>
<%if("NING".equals(request.getParameter("context"))){%>
<input type='hidden' name='context' id="ningcontext" value='Ning' />
<%}%>


<table width='100%' cellpadding='0' cellspacing='0'>
<tr><td><table width='100%'  align='center' cellpadding='0' cellspacing='0'>
	<tr><td class="medium">Refund Policy/Terms & Conditions </td></tr>
	<tr height='10'><td/></tr>

	<tr><td  >
	<table cellpadding='0' style="width: 100%; table-layout: fixed;"><tr><td> 
	<pre class='smallestfont'  style="font-size: 13px; margin:0px; padding-left:6px;white-space: pre-wrap;white-space: -moz-pre-wrap !important;white-space: -pre-wrap; white-space: -o-pre-wrap;word-wrap: break-word; "><%=jBean.getRefundPolicy()%></pre>
	</td></tr>
	</table>
    </td></tr></table>
</td></tr></table>
<%

 
 if(jBean.getPaymentType()!=null && !"".equals(jBean.getPaymentType())){
 %>
 <div id='paymentbuttons' >
<table width='100%' cellpadding='0' cellspacing='0'>
<tr height='10'><td/></tr>
<tr><td class="medium">Payment Method</td></tr>
<tr height='10'><td/></tr>
<tr><td><table>

 <%
 }
  if(isUpgrade){
  HashMap hm=jBean.getTransactionInfo();
 if(hm!=null){			
oldpaymenttype=(String)hm.get("Old_Payment_Type");

String paytype="";
if("eventbee".equals(oldpaymenttype))
jBean.setPaymentType("EXXX");
else if("google".equals(oldpaymenttype))
jBean.setPaymentType("XGXX");

else if("paypal".equals(oldpaymenttype))
jBean.setPaymentType("XXPX");

else if("other".equals(oldpaymenttype))
jBean.setPaymentType("XXXO"); 

}
}



if(jBean.getPaymentType().indexOf("P")!=-1){%>
  <tr height='30'><td align='left' width='45%'><input type='radio' name='paymentbutton' value="paypal">PayPal Credit Card Processing <img src='/home/images/paypalcc.gif'    border='0' alt='PayPal Payment Processing'   /> <font class='smallestfont'> (No PayPal account required)</font></td>
</tr>

<%}


if(jBean.getPaymentType().indexOf("G")!=-1){%>
  <tr height='30'><td align='left'  width='45%'><input type='radio' name='paymentbutton' value="google">Google Credit Card processing <img src='/home/images/googlecc.gif'   border='0' alt='Google Payment Processing' /><font class='smallestfont'> (Google account required)</font>
</td></tr>

<%}

  if(jBean.getPaymentType().indexOf("E")!=-1 ){%>
 <tr height='30'> <td align='left' width='45%'><input type='radio' name='paymentbutton' value="eventbee">Eventbee Credit Card Processing <img src='/home/images/eventbeecc.gif' border='0'  alt='Eventbee Payment Processing' /><font class='smallestfont'> (No Eventbee login required)</font></td></tr>

<%}
	
	
if(jBean.getPaymentType().indexOf("O")!=-1){%>
<tr height='30'><td width='45%'><input type='radio' name='paymentbutton' value="other">Other Payment Method<br/>
 &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<font class='smallestfont'><%=otherdesc%> </font></td>
<%}%>
</tr>

<tr height='30'><td width='45%' ><div id='nopaymentbutton' style='display:none'><input type='radio' name='paymentbutton' value="nopayment">No Payment <font class='smallestfont'>(Choose this option if Grand Total is 0)</font>
</div></td>
</tr>
</table>
<table width='100%' cellpadding='0' cellspacing='0'>
<tr><td height='20'></td></tr>
<tr><td  align='center' width='40%'>
<input type='button' name='continue' Value='Continue' onClick="selectPayType();return false;"/>
</table></td></tr></table>
</div>
</form>
</td></tr>
</table>


<script type="text/javascript">
if(document.getElementById("membercommunity")){
	MemberLoginCheck();
}
if(document.getElementById("generalCoupon")){
getCouponBlock('isnew');
  CheckCouponCodes();
}
if(document.getElementById("MemCoupon")){
getMemCouponBlock('isnew'); 
CheckMemCoupon();
}
if(document.getElementById('embeddeddiscount')){
assignDiscounts('<%=evtid%>','<%=embeddeddiscount%>');

}
	
SubmitTicketOnBlur();
getEventAttendees();
</script>
<script type="text/javascript">
if(document.getElementById('isfrompartnersite')){
getPartnerCommision('<%=evtid%>','<%=jBean.getAgentId()%>','<%=jBean.getFriendId()%>');
}
</script>

