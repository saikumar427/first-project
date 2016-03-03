<%@ page import="org.apache.velocity .*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
<%@ page import="com.event.dbhelpers.*,com.eventregister.*,com.eventbee.general.*"%>
<%@ page import="java.util.*"%>

<%!
static String  serveraddress="http://"+EbeeConstantsF.get("serveraddress","");
void fillTicketsVm(HashMap ticketPageLabels,String eid,VelocityContext context){
String ticketsPageHeader=GenUtil.getHMvalue(ticketPageLabels,"event.reg.ticket.page.Header"," ");
String ticketNameLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.ticket.name.label","Ticket Name");
String ticketPriceLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.ticket.price.label","Price");
String ticketQtyLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.ticket.qty.label","Quantity");
String processFeeLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.processfee.label","Fee");
if("".equals(ticketsPageHeader))
	ticketsPageHeader=null;
context.put("ticketPriceLabel",ticketPriceLabel);
context.put("ticketNameLabel",ticketNameLabel);
context.put("ticketQtyLabel",ticketQtyLabel);
context.put("processFeeLabel",processFeeLabel);
context.put("ticketsPageHeader",ticketsPageHeader);
}
%>
<%
RegistrationTiketingManager regTktMgr=new RegistrationTiketingManager();
String discount="0";
String GrandTotal="0";
String netAmount="0";
String tickets="";
TicketsPageJson ticketPage=new TicketsPageJson();
TicketingInfo t=new TicketingInfo();
String eid=request.getParameter("eid");
String ticketurlcode=request.getParameter("ticketurl");
String evtdate=request.getParameter("evtdate");
String track=request.getParameter("track");
String discountcode=request.getParameter("discountcode");
if(discountcode==null||"null".equals(discountcode))
discountcode="";
t.intialize(eid,ticketurlcode,evtdate);
String eventid=request.getParameter("eid");
HashMap ticketPageLabels=DisplayAttribsDB.getAttribValues(eid,"RegFlowWordings");
String eventstatus=DbUtil.getVal("select status from eventinfo where eventid=CAST(? AS BIGINT)",new String[]{eid});

if("PENDING".equals(eventstatus)){
out.print("<script type='javascript' language='javascript'>document.getElementById('pageheader').innerHTML='"+GenUtil.getHMvalue(ticketPageLabels,"event.reg.ticket.page.Header","Tickets")+"';   document.getElementById('ticketrecurring').style.display='none';</script><center><b>Tickets are currently unavailable</b></center>");
}
else{
try{
	HashMap ticketsObject=ticketPage.getGroupTicketsVec(eid,ticketurlcode,evtdate);
	Vector ticketGroupsVector=(Vector)ticketsObject.get("ticketVec");
	String ticketsArray[]=(String[])ticketsObject.get("ticketsarray");
	HashMap configEntries=(HashMap)ticketsObject.get("configEntries");
	tickets=GenUtil.stringArrayToStr(ticketsArray,",");
	VelocityContext context = new VelocityContext();

fillTicketsVm(ticketPageLabels,eid,context);
//************************************************************
String discountBoxLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.discount.box.label","Have a discount code, enter it here");
String discountApplyLabel=GenUtil.getHMvalue(ticketPageLabels,"discount.code.applybutton.label","Apply");
String orderButtonLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.orderbutton.label","Buy Tickets");
String totalLinkLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.totallink.label","Show Grand Total");
String totalAmountLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.total.amount.label","Total");
String discountAmountLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.discount.amount.label","Discount");
String NetAmountLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.net.amount.label","Net Amount");
String taxAmountLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.tax.amount.label","Tax");
String GrandTotalLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.grandtotal.amount.label","Grand Total");

//****************************************************************

String seating_enabled=GenUtil.getHMvalue(configEntries,"event.seating.enabled","NO");
String currencyformat=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code in (select currency_code from event_currency where eventid=?)",new String[]{eventid});
if(currencyformat==null)
currencyformat="$";
String enable="";
String amountlinksdisplay="block";

if("ACTIVE".equals(eventstatus)){
enable="";
amountlinksdisplay="block";
}
else{
enable="disabled";
amountlinksdisplay="none";
}
			
String Discountbox="<input type='text' name='couponcode' id='couponcode' size='10' value='"+discountcode+"' onkeypress='return ignorekeypress(event)'/>";			
String applybutton="<input type='button' name='submit' id ='discountsbtn' value='"+discountApplyLabel+"'  onClick='getDiscountAmounts();' '"+enable+"' />";
String regForm="<form id='regform' name='regform' action='/embedded_reg/regformaction.jsp' method='post' ><input type='hidden' name='ticketids' id='ticketids' value='"+tickets+"' /><input type='hidden' name='eid' id='eid' value='"+eventid+"' /><input type='hidden' name='tid' id='tid' value='' /><input type='hidden' name='track' id='track' value='"+track+"' /><input type='hidden' name='clubuserid' id='clubuserid' value='' /><input type='hidden' name='ticketurlcode' id='ticketurlcode' value='"+ticketurlcode+"'/>";
String regformSubmit="<input type='hidden' id='actiontype' name='actiontype' value='' /><input type='button' name='submit'  id='orderbutton' value='"+orderButtonLabel+"' '"+enable+"' onClick='validateTickets();'  />";
String regFormClose="</form>";

//for mobile register

if("mobile".equals(request.getParameter("regtype"))){
regformSubmit="<input type='hidden' id='actiontype' name='actiontype' value='' /><li><a><input type='button' class='buybutton' name='submit'  id='orderbutton' value='"+orderButtonLabel+"' '"+enable+"' onClick='validateTickets();'  /></a></li>";
}

String templatedata=regTktMgr.getVelocityTemplate(eid,"ticketpage");
String caluclateAmountLink="<a href='#'  onClick='getTotalAmounts();' style='display:"+amountlinksdisplay+"'>"+totalLinkLabel+"</a>";
String tktWidget="<script type='text/javascript' language='JavaScript' src='/home/js/tktWedget.js'>";
String tax=GenUtil.getHMvalue(configEntries,"event.tax.amount","0");
String totalAmount="<table id='totalamount' style='display:none' align='right' width='100%'>"
+"<tr><td width='100%' align='right'><table id='totaldiv' style='display:none' width='100%'><tr><td  align='left' >"+totalAmountLabel+" ("+currencyformat+"): </td><td width='10'></td><td  id='totamount'  align='left'>$$$</td></tr></table></td></tr>"
+"<tr><td width='100%' align='right'><table id='discountdiv' style='display:none' width='100%'><tr><td  align='left' >"+discountAmountLabel+" ("+currencyformat+"): </td><td width='10'></td><td  id='disamount'  align='left'> $$$</td></tr></table></td></tr>"
+"<tr><td width='100%' align='right'><table id='netamountdiv' style='display:none' width='100%'><tr><td  align='left'>"+NetAmountLabel+"("+currencyformat+"): </td><td width='10'></td><td  id='netamount' align='left' > $$$</td></tr></table></td></tr>"
+"<tr><td width='100%' align='right'><table id='taxdiv' style='display:none' width='100%'><tr><td  align='left'>"+taxAmountLabel+"-"+tax+"%("+currencyformat+") : </td><td width='10'></td><td id='taxamount'  align='left' > $$$</td></tr></table></td></tr>"
+"<tr><td width='100%' align='right'><table id='gtotaldiv' style='display:none' width='100%'><tr><td  align='left'>"+GrandTotalLabel+"("+currencyformat+"): </td><td width='10'></td><td  id='grandtotamount' align='left'> $$$</td></tr></table></td></tr>"
+"</table>";
if(ticketGroupsVector.size()>0)
context.put("ticketGroups",ticketGroupsVector);
if(t.isDiscountExists){
context.put("discountBox",Discountbox);
context.put("discountApplyButton",applybutton);
}


 seating_enabled=GenUtil.getHMvalue(configEntries,"event.seating.enabled","NO");
if("YES".equals(seating_enabled)){
	String venueid=GenUtil.getHMvalue(configEntries,"event.seating.venueid","0");
	String seatingSection="";
	regForm=regForm+"<input type='hidden' name='venueid' id='venueid' value='"+venueid+"'/>";
	
	context.put("seatingSection",seatingSection);
}

context.put("regForm",regForm);
context.put("regformSubmit",regformSubmit);
context.put("regFormClose",regFormClose);
context.put("totalAmount",totalAmount);
context.put("caluclateAmountLink",caluclateAmountLink);
context.put("currencyFormat",currencyformat);
context.put("tktWidget",tktWidget);
context.put("discountBoxLabel",discountBoxLabel);
if(discountcode!=null&&!"".equals(discountcode)){
context.put("fromDiscountCodeUrls","yes");
}


/*String seating_enabled=DbUtil.getVal("select value from config where name='event.seating.enabled' and  config_id=(select config_id from eventinfo where eventid=CAST(? AS BIGINT))",new String[]{eventid});
if("YES".equals(seating_enabled)){
String seatingSection="";
context.put("seatingSection",seatingSection);
}*/
VelocityEngine ve= new VelocityEngine(); 
try{
ve.init();
boolean abletopares=ve.evaluate(context,out,"ebeetemplate", templatedata );
}
catch(Exception exp){
System.out.println(exp.getMessage());
}  
}

catch(Exception e)
{
System.out.println("Exception occured while displaying tickets Vm"+e.getMessage());
out.print("<script type='javascript' language='javascript'>document.getElementById('pageheader').innerHTML='"+GenUtil.getHMvalue(ticketPageLabels,"event.reg.ticket.page.Header","Tickets")+"';   document.getElementById('ticketrecurring').style.display='none';</script><center><b>Tickets are currently unavailable</b></center>");
}
}
%>




