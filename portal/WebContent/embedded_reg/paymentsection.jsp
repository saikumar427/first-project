<%@ page import="java.io.*,java.util.*,com.eventbee.general.*,com.eventbee.general.formatting.CurrencyFormat,com.eventregister.*,com.customquestions.*,com.customquestions.beans.*" %>
<%@ page import="org.apache.velocity .*,org.apache.velocity.app.Velocity,org.apache.velocity.context.*,org.apache.velocity.exception.*,org.apache.velocity.app.*" %>
<%@ page import="org.json.*,com.event.dbhelpers.*"%>
<%@ page language="java" contentType="text/html; charset=utf-8"  pageEncoding="utf-8"%>
<%@ page import="com.eventbee.general.formatting.CurrencyFormat" %>
<%@ include file="profilepagedisplay.jsp" %>
<%@ include file="/globalprops.jsp" %>
<%
String  SSLProtocol=EbeeConstantsF.get("SSLProtocol","https");
String sslserveraddress=SSLProtocol+"://"+EbeeConstantsF.get("sslserveraddress","www.eventbee.com");
RegistrationTiketingManager regTktMgr=new RegistrationTiketingManager();
ProfilePageVm profilepage=new ProfilePageVm();
TicketsDB ticketInfo=new TicketsDB();
String tid=request.getParameter("tid");
String eid=request.getParameter("eid");
String regtype=request.getParameter("regtype");
String referral_ntscode=request.getParameter("referral_ntscode");
String ntsenable=request.getParameter("ntsenable");
System.out.println("ntsenable: "+ntsenable+", refcode: "+referral_ntscode);
String fbuid=request.getParameter("fbuid");
String paymentmode=request.getParameter("paymentmode");

HashMap configMap=ticketInfo.getConfigValuesFromDb(eid);
HashMap transactionAmounts=regTktMgr.getRegTotalAmounts(tid);
regTktMgr.setEventRegTempAction(eid,tid,"payment section");
double grandTotal=0;
String totalamount=GenUtil.getHMvalue(transactionAmounts,"grandtotamount","0");
String taxamount=GenUtil.getHMvalue(transactionAmounts,"tax","0");
String netamount=GenUtil.getHMvalue(transactionAmounts,"netamount","0");
String disamount=GenUtil.getHMvalue(transactionAmounts,"disamount","0");
String total=GenUtil.getHMvalue(transactionAmounts,"totamount","0");
String currencycode=GenUtil.getHMvalue(transactionAmounts,"currencycode","");
System.out.println("currencycode in paymentsection is:"+currencycode);
double totalTax=0;
double totalDiscount=0;



try{
totalDiscount=Double.parseDouble(disamount);
}
catch(Exception e){
totalDiscount=0;
}

try{
totalTax=Double.parseDouble(taxamount);
}
catch(Exception e){
totalTax=0;
}
try{
grandTotal=Double.parseDouble(totalamount);
}
catch(Exception e){
grandTotal=0;
}




VelocityContext context = new VelocityContext();
HashMap profilePageLabels=DisplayAttribsDB.getAttribValues(eid,"RegFlowWordings");
profilepage.fillVelocityContextForProfilePage(eid,context,profilePageLabels);
//************************************************************
String eventbeeButtonLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.eventbee.paybutton.label","Pay With Eventbee");
String paypalButtonLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.paypal.paybutton.label","Pay With Paypal");
String googleButtonLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.google.paybutton.label","Pay With Google");
String creditButtonLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.ebeecredit.paybutton.label","Pay With Eventbee Credits");
String otherButtonLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.other.paybutton.label","Other Payment");
String nopaymentButtonLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.zero.paybutton.label","Continue");
String backButtonLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.backtoprofile.label","Back To Profile");

//****************************************************************
String paymentsection="";
String buttonName=null;
String image=null;
String type=null;
String paypalsection="";
String googlesection="";
String othersection="";
String eventbeesection="";
String ebeecredits="";


String scheme=request.getHeader("x-forwarded-proto");
if(scheme==null)
scheme=request.getScheme();
System.out.println("scheme x forwarded::"+scheme);

if(grandTotal>0){
Vector paytypes=regTktMgr.getAllPaymentTypes(eid,"Event");
if(paytypes!=null)
{
for(int k=0;k<paytypes.size();k++){
HashMap payment=(HashMap)paytypes.get(k);
type=(String)payment.get("paytype");
if("paypal".equals(type)){
System.out.println("in paypal paymentmode: "+paymentmode);
buttonName=paypalButtonLabel;
image="<img src='/home/images/paypalcc.gif'    border='0' alt='PayPal Payment Processing'   />";
if("mobile".equals(regtype))
paypalsection="<input type='button' id='paymentbtn1' name='"+type+"' value='"+buttonName+"' onClick=clickcount++;SubmitForm('"+tid+"','"+type+"','"+sslserveraddress+"'); />";

else
paypalsection="<tr><td  align='left' class='yui-skin-sam'><span class='buyticketssubmit'><input type='button' id='paymentbtn1' name='"+type+"' value='"+buttonName+"' onClick=clickcount++;SubmitForm('"+tid+"','"+type+"','"+sslserveraddress+"'); class='buyticketsbutton' onmouseover='javascript:this.className=\"buyticketsbuttonhover\"' ; onmouseout='javascript:this.className=\"buyticketsbutton\"';/></span></td><td align='left' >"+image+"</td></tr>";



}
else  if("eventbee".equals(type)){


buttonName=eventbeeButtonLabel;
image="<img src='/home/images/eventbeecc.gif'    border='0' alt='Eventbee Payment Processing'   />";
if("mobile".equals(regtype))
eventbeesection="<input type='button' id='paymentbtn2' name='"+type+"' value='"+buttonName+"' onClick=clickcount++;SubmitForm('"+tid+"','"+type+"','"+sslserveraddress+"'); />";

else
eventbeesection="<tr><td  align='left' class='yui-skin-sam'><span class='buyticketssubmit'><input type='button' id='paymentbtn2' name='"+type+"' value='"+buttonName+"' onClick=clickcount++;SubmitForm('"+tid+"','"+type+"','"+sslserveraddress+"'); class='buyticketsbutton' onmouseover='javascript:this.className=\"buyticketsbuttonhover\"' ; onmouseout='javascript:this.className=\"buyticketsbutton\"';/></span></td><td align='left'  '>"+image+"</td></tr>";
}
else if("google".equals(type)){
buttonName=googleButtonLabel;
image="<img src='/home/images/googlecc.gif'    border='0' alt='Google Payment Processing'   />";
if("mobile".equals(regtype))
googlesection="<input type='button' id='paymentbtn3' name='"+type+"' value='"+buttonName+"' onClick=clickcount++;SubmitForm('"+tid+"','"+type+"','"+sslserveraddress+"'); />";

else
googlesection="<tr><td  align='left' class='yui-skin-sam'><span class='buyticketssubmit'><input type='button' id='paymentbtn3' name='"+type+"' value='"+buttonName+"' onClick=clickcount++;SubmitForm('"+tid+"','"+type+"','"+sslserveraddress+"'); class='buyticketsbutton' onmouseover='javascript:this.className=\"buyticketsbuttonhover\"' ; onmouseout='javascript:this.className=\"buyticketsbutton\"';/></span></td><td align='left'  >"+image+"</td></tr>";
}
else if("ebeecredits".equals(type)){
buttonName=creditButtonLabel;
image=(String)payment.get("desc");
if("mobile".equals(regtype)){
ebeecredits="<input type='button' id='paymentbtn6' name='"+type+"' value='"+buttonName+"' onClick=clickcount++;SubmitForm('"+tid+"','"+type+"','"+sslserveraddress+"'); />";
}else
	ebeecredits="<tr><td  align='left' class='yui-skin-sam' valign='top'><span class='buyticketssubmit'><input type='button' id='paymentbtn6' name='"+type+"' value='"+buttonName+"' onClick=clickcount++;SubmitForm('"+tid+"','"+type+"','"+sslserveraddress+"'); class='buyticketsbutton' onmouseover='javascript:this.className=\"buyticketsbuttonhover\"' ; onmouseout='javascript:this.className=\"buyticketsbutton\"';/></span></td><td align='left' valign='top' width='420'><pre style='font-family: verdana; font-size:12px; line-height:140%; padding-left:2px; margin:0px; white-space: pre-wrap; white-space: -moz-pre-wrap !important; white-space: -pre-wrap; white-space: -o-pre-wrap; word-wrap: break-word;'>"+image+"</pre></td></tr>";
if(fbuid!=null && !"".equals(fbuid)){
String availcredits=DbUtil.getVal("select cleared_credits from ebee_nts_partner where external_userid =?",new String[]{fbuid});
if(availcredits!=null){
double avcredits=Double.parseDouble(availcredits);
double totalamt=Double.parseDouble(totalamount);
if(avcredits<totalamt)
	ebeecredits="";
}
}	
//ebeecredits="";
}
else{
image=(String)payment.get("desc")+"<br><span class='small'>"+getPropValue("ps.proc.fee.msg",eid)+"</span>";
buttonName=otherButtonLabel;
if("mobile".equals(regtype)){
othersection="<input type='button' id='paymentbtn4' name='"+type+"' value='"+buttonName+"' onClick=clickcount++;SubmitForm('"+tid+"','"+type+"','"+sslserveraddress+"'); />";
othersection+="    <a id='showotherpaymentdesc'><img id='showotherimg' src='/home/images/expand.gif' alt=''></a><br><br><br><br><div id='otherpaymentdiv' style='display:none;'><pre style='font-family: verdana; font-size:12px; line-height:140%; padding-left:2px; margin:0px; white-space: pre-wrap; white-space: -moz-pre-wrap !important; white-space: -pre-wrap; white-space: -o-pre-wrap; word-wrap: break-word;'>"+image+"</pre></div>";
}
else
othersection="<tr><td  align='left' class='yui-skin-sam' valign='top'><span class='buyticketssubmit'><input type='button' id='paymentbtn4' name='"+type+"' value='"+buttonName+"' onClick=clickcount++;SubmitForm('"+tid+"','"+type+"','"+sslserveraddress+"'); class='buyticketsbutton' onmouseover='javascript:this.className=\"buyticketsbuttonhover\"' ; onmouseout='javascript:this.className=\"buyticketsbutton\"';/></span></td><td align='left' valign='top' width='420'><pre style='font-family: verdana; font-size:12px; line-height:140%; padding-left:2px; margin:0px; white-space: pre-wrap; white-space: -moz-pre-wrap !important; white-space: -pre-wrap; white-space: -o-pre-wrap; word-wrap: break-word;'>"+image+"</pre></td></tr>";
}
}
}
String ccvendor=DbUtil.getVal("select attrib_5 from payment_types where refid=? and paytype='eventbee'",new String[]{eid});
	if("Y".equals(ntsenable) && !"".equals(referral_ntscode)){
	System.out.println("eventid: "+eid+", nts enabled and referral nts code: "+referral_ntscode);
	if((paymentmode.equals("paypalx") && !"".equals(paypalsection))  || (!("".equals(eventbeesection)) && !"authorize.net".equals(ccvendor))){
		System.out.println("eid:"+eid+", "+" in paypalx or eventbee");
		if("authorize.net".equals(ccvendor))
			paymentsection=paypalsection+ebeecredits;
		else	
		paymentsection=paypalsection+eventbeesection+ebeecredits;
		}
		else{
			paymentsection=paypalsection+googlesection+eventbeesection+ebeecredits+othersection;
		}
	}else
		paymentsection=paypalsection+googlesection+eventbeesection+ebeecredits+othersection;

if("mobile".equals(regtype)){
	paymentsection="<center>"+paymentsection+"</center>";
}
}
else{
type="nopayment";
buttonName=nopaymentButtonLabel;
paymentsection="<tr><td  align='center'><span class='buyticketssubmit'><input type='button' id='paymentbtn5' name='"+type+"' value='"+buttonName+"' onClick=clickcount++;SubmitForm('"+tid+"','"+type+"','"+sslserveraddress+"'); class='buyticketsbutton' onmouseover='javascript:this.className=\"buyticketsbuttonhover\"' ; onmouseout='javascript:this.className=\"buyticketsbutton\"';/></span></td><td align='left' ></td></tr>";

}
String refundPolicy=(String)configMap.get("event.ticketpage.refundpolicy.statement");
String gtotal=totalamount;
String backbutton="<a href='#profile' class='slide whiteButtonlink'   onClick=getProfilePage(); >"+backButtonLabel+"</a>";
String continuebtn="<input type='button' name='continue'    value='continue' onClick=submitProfiles('"+tid+"'); >";
String template="";
if("mobile".equals(regtype)){
	backbutton="";
	template=regTktMgr.getVelocityTemplate(eid,"mobilepaymentspage");
	context.put("PaymentMethodLabel",context.get("PaymentMethodLabel")+"  <img src='/home/images/eventbeecc.gif'    border='0' alt=''   />");
}
else
	template=regTktMgr.getVelocityTemplate(eid,"paymentspage");

paymentsection=paymentsection+"<input type='hidden' id='scheme' value='"+scheme+"'/>";

try{
	 if("TWD".equalsIgnoreCase(currencycode) || "JPY".equalsIgnoreCase(currencycode) || "HUF".equalsIgnoreCase(currencycode)){
	    totalamount=Double.toString(Math.ceil(Double.parseDouble(netamount)+Double.parseDouble(taxamount)));
		totalamount=CurrencyFormat.getCurrencyFormat("", totalamount, false);
		DbUtil.executeUpdateQuery("update event_reg_details_temp set grandtotal=CAST(? as NUMERIC) where eventid=? and tid=? ", new String[]{totalamount,eid,tid});
		System.out.println("totalamount for thaiwan is:"+totalamount);
	 }
	}
	catch(Exception e){
		System.out.println("Exception occured when rounded the grandTotal value for event :: "+eid+" :: "+e.getMessage());
	}

context.put("refundPolicy",refundPolicy);
context.put("backLink",backbutton);
context.put("continue",continuebtn);
context.put("paymentSection",paymentsection);
if(totalDiscount>0){
context.put("discountAmount",CurrencyFormat.formatNumberWithCommas(disamount));
context.put("netAmount",CurrencyFormat.formatNumberWithCommas(netamount));
}
if(totalTax>0){
context.put("taxAmount",CurrencyFormat.formatNumberWithCommas(taxamount));
context.put("grandTotal",CurrencyFormat.formatNumberWithCommas(totalamount));
}
context.put("totalAmount",CurrencyFormat.formatNumberWithCommas(total));
VelocityEngine ve= new VelocityEngine(); 
try{
ve.init();
boolean abletopares=ve.evaluate(context,out,"ebeetemplate", template);
}
catch(Exception exp){
out.println("---"+exp.getMessage());
}  


%>