<%@ page import="com.eventbee.event.*" %>
<%@ page import="com.eventbee.authentication.*" %>
<%@ page import="com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.general.GenUtil"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*"%>
<script>
function submitform(){
document.form1.elements["cocoon-action-next"].click();
}
</script>
<%@ include file='/xfhelpers/xffunc.jsp' %>


<%!
static String[] numbers=new String[]{ " One"," Two"," Three"," Four"," Five"," Six", " Seven", " Eight"," Nine"," Ten"," Eleven"," Tweleve"," Thirteen"," Fourteen" };
    String encode(String x){
	return GenUtil.getEncodedXML(x);
    }

  /*  String getXfWriteOneRow(String[] values){
	StringBuffer sb=new StringBuffer();
	for(int i=0;i<values.length;i++){
        	sb.append("<td class='inform' align='right' width='50%' valign='top'>");
		sb.append(values[i]);
        	sb.append("</td>");
	}
	return sb.toString();
    }
*/
    String rowdisplay(int count){
		if(count%2==0){
			return "<tr class='oddbase'>";
		}else{
			return "<tr class='evenbase'>";
	   	} 
    }
%>
<%
  EventRegisterBean jBean = (EventRegisterBean)session.getAttribute("regEventBean");   
  HashMap scopemap=jBean.getScopeMap();
   String currencyformat=GenUtil.getHMvalue(scopemap,"event.reg.currency.format","$");
%>


<% 
String event_name=DbUtil.getVal("select eventname from eventinfo where eventid=?", new String [] {request.getParameter("GROUPID")});
String username=DbUtil.getVal("select getMemberPref(mgr_id||'','pref:myurl','') as username from eventinfo where eventid=?", new String [] {request.getParameter("GROUPID")});
 	request.setAttribute("NavlinkNames",new String[]{event_name});
	
	String participant=jBean.getAgentId();
	if (participant!=null)	
		request.setAttribute("NavlinkURLs",new String[]{ShortUrlPattern.get(username)+"/event?eventid="+request.getParameter("GROUPID")+"&participant="+participant});
	else
		request.setAttribute("NavlinkURLs",new String[]{ShortUrlPattern.get(username)+"/event?eventid="+request.getParameter("GROUPID")});
	//request.setAttribute("NavlinkURLs",new String[]{"/portal/eventdetails/eventdetails.jsp"});
	request.setAttribute("tasktitle","Event Registration: Preview");
	request.setAttribute("tasksubtitle","Step 2 of 3");
	request.setAttribute("tabtype","event");
	
	
	
%>


<table width='100%' >
<script language="javascript" src="/home/js/enterkeypress.js" >
dummy23456=888;
</script>
<form name='form1' onSubmit="return checkform(this)" method="post" id="form-register-event" view="preview" action="/portal/eventregister/reg/confirm.jsp">
  	<input value="preview" name="cocoon-xmlform-view" type="hidden" />

<tr><td>
<%
Object obj=(Object)session.getAttribute("regerrors");
out.println(GenUtil.displayErrMsgs("<tr><td class='error' align='center'>",obj,"</td></tr>" ));
%>
</td></tr>
<!--tr><td class='colheader'>Preview</td></tr-->
 

<tr><td>
<%
  int rowcount=0;
 ProfileData[] pd=jBean.getProfileData();
 EventTicket reqTicket=jBean.getSelectedReqTicket();
 EventTicket[] optTickets=jBean.getSelectedOptTickets();
 PromoData promodata=jBean.getPromoData();
 double GrandTotal=jBean.getGrandTotal();
 double processfee=0;
   if ("attendee".equals(jBean.getAccountFee())){
          processfee=jBean.getAttendeeFee();
     }
%>
<table  width="100%" class='block'>

<tr><td class="subheader"><%=GenUtil.getHMvalue(scopemap,"event.reg.attendee.label","Attendee")%>s</td></tr>
<tr><td></td></tr>
<% 
     for (int i=0;i<pd.length;i++) { 
        out.println(rowdisplay(i+1));   
%>
<td class="subheader">
   <%=GenUtil.getHMvalue(scopemap,"event.reg.attendee.label","Attendee")%><%=numbers[i]%>
</td></tr>
<%=rowdisplay(i+1)%><td>
<%=GenUtil.XMLEncode(pd[i].getFirstName())%> <%=GenUtil.XMLEncode(pd[i].getLastName())%><br/>
<%=GenUtil.XMLEncode(pd[i].getEmail())%><br/>
<%=GenUtil.XMLEncode(pd[i].getPhone())%><br/></td></tr>
<% } %>
<tr><td></td></tr>
</table>

</td></tr>
<tr><td>
<table  class="block" width="100%">
  <tr><td class="subheader">Tickets</td></tr>

</td></tr>
<tr><td>
  <table   width="100%">
  <tr class="colheader">
<td width="40%">Ticket Name</td><td width="15%">Price (<%=currencyformat%>)</td><td width="10%">Number of Tickets</td><td width="15%">Discount (<%=currencyformat%>)</td><td width="20%">Total (<%=currencyformat%>)</td>
</tr>
<%
if(reqTicket!=null){

%>
    
<%
   out.println(rowdisplay(rowcount));
   rowcount++;
%>
<td><%=encode(reqTicket.getTicketName())%></td>
<td><%=CurrencyFormat.getCurrencyFormat("",""+reqTicket.getSelPrice(),true)%></td>
<td><%=reqTicket.getSelQty()%></td><td><%=CurrencyFormat.getCurrencyFormat("",""+reqTicket.getSelDiscount(),true)%></td><td><%=CurrencyFormat.getCurrencyFormat("",""+reqTicket.getTotalAmount(),true)%></td>
        </tr>
<%
}
%> 
<%
if(optTickets!=null){
for(int i=0;i<optTickets.length;i++){
%>

<%
  out.println(rowdisplay(rowcount));
  rowcount++;
%>
<td><%=encode(optTickets[i].getTicketName())%></td>
<td><%=CurrencyFormat.getCurrencyFormat("",""+optTickets[i].getSelPrice(),true)%></td>
<td><%=optTickets[i].getSelQty()%></td><td><%=CurrencyFormat.getCurrencyFormat("",""+optTickets[i].getSelDiscount(),true)%></td><td><%=CurrencyFormat.getCurrencyFormat("",""+optTickets[i].getTotalAmount(),true)%></td>
  </tr>
<%
}
}
%>

<%
     if(promodata!=null){
        if(jBean.getPromoSelect()){
            String PromoOrderType=promodata.getBuyType();
	    String promomsg="";
%>
    <tr><td class="subheader">Promotions</td></tr>
    
<%
    out.println(rowdisplay(rowcount));
    rowcount++;
if("reserve".equals(PromoOrderType)) promomsg="(Not included in grand total)";
%>
<td><%=encode(promodata.getName())%></td>
<td><%=CurrencyFormat.getCurrencyFormat("",""+promodata.getSelPrice(),true)%></td>
<td><%=promodata.getSelQty()%></td><td></td>
<td><%=CurrencyFormat.getCurrencyFormat("",""+promodata.getTotalAmount(),true)%><%=promomsg%></td>
 </tr>
<%
  }
    }
%>
  </table>
  
  </td></tr>
  </table>
<tr><td>
  
<table width="100%" class='block'>
<tr><td>
</td></tr> 
  <tr><td class="inform" width="30%">Total (<%=currencyformat%>)</td>
  <td width="20%" align="center"><%=CurrencyFormat.getCurrencyFormat(currencyformat,""+GrandTotal,false)%></td>
</tr>
<tr> 
    <td class="inform">Processing Fee (<%=currencyformat%>)</td>
    <td align="center"><%=CurrencyFormat.getCurrencyFormat(currencyformat,""+processfee,false)%></td>
</tr>
<tr>
      <td class="inform">Grand Total (<%=currencyformat%>)</td>
      <td align="center"><%=CurrencyFormat.getCurrencyFormat(currencyformat,""+jBean.getCardAmount(),false)%></td>
</tr>
<tr>
<td class="subheader">Refund Policy/Terms & Conditions *</td><td><%=getXfBoolean("/policy","I Accept",jBean.getPolicy() )%></td><tr><td colspan="2" class="inform">
 <% 
   out.println(getXfTextAreaRO("/refundPolicy",jBean.getRefundPolicy(),"10","60"));
  %>
 </td>
 </tr>
 </tr>
</table>

</td></tr>
<tr><td>

<table  align="center">
  <tr><td>
<input type='submit' name='submit' value='Continue' class='button' />
<input type='submit' name='submit' value='Back' class='button' />
<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %></td></tr>
     </table>
     </td></tr>

<%=PageUtil.writeHiddenCore((HashMap)request.getAttribute("REQMAP")) %>
</form>
</table>
