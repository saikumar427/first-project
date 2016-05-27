<%@ page import="java.io.*,java.util.*,com.eventbee.general.*,com.eventregister.*,com.customquestions.beans.*" %>
<%@ page import="org.json.*,com.event.dbhelpers.*"%>
<%@ page import="com.eventbee.general.formatting.CurrencyFormat" %>
<%@page trimDirectiveWhitespaces="true"%>
<%@ page language="java" contentType="application/json; charset=utf-8"
	pageEncoding="utf-8"%>
	<%@ include file="cors.jsp" %>
 <%@include file="/embedded_reg/PaypalXPaymentDetails.jsp"%> 
<%
try{
	
	String total_label="Total";
	
	String  SSLProtocol=EbeeConstantsF.get("SSLProtocol","https");
	//SSLProtocol="http";
	String sslserveraddress=SSLProtocol+"://"+EbeeConstantsF.get("sslserveraddress","localhost");
	BRegistrationTiketingManager regTktMgr=new BRegistrationTiketingManager();
	TicketsDB ticketInfo=new TicketsDB();
	String tid=request.getParameter("transaction_id");
	String eid=request.getParameter("event_id");
	String apiKey=request.getParameter("api_key");
	System.out.println("tid:"+tid+":eid"+eid+"::apikey:"+apiKey);
	JSONObject responseJSON=null;
	if(apiKey==null)apiKey="123";
	
	try{
		if (eid == null||"".equals(eid) || tid == null||"".equals(tid)||apiKey == null||"".equals(apiKey)) {
			responseJSON=new JSONObject();
			responseJSON.put("status", "fail");
			responseJSON.put("reason", "required parameters missing");
			out.println(responseJSON+"");
			return;
		}
	}catch(Exception e){ }
	
	responseJSON=new JSONObject();
	String regtype=request.getParameter("regtype");
	String referral_ntscode=request.getParameter("referral_ntscode");
	String ntsenable=request.getParameter("ntsenable");
	String fbuid=request.getParameter("fbuid");
	String scheme=request.getHeader("x-forwarded-proto");
	if(scheme==null)
	scheme=request.getScheme();
	responseJSON.put("scheme",scheme);
	responseJSON.put("sslserveraddress",sslserveraddress);
	
	HashMap configMap=ticketInfo.getConfigValuesFromDb(eid);
	HashMap transactionAmounts=regTktMgr.getRegTotalAmounts(tid);
	regTktMgr.setEventRegTempAction(eid,tid,"payment section");
	
	String isseatingevent=GenUtil.getHMvalue(configMap,"event.seating.enabled","NO");
	String venueid=GenUtil.getHMvalue(configMap,"event.seating.venueid","0");
	responseJSON.put("seatingenabled",isseatingevent);
	responseJSON.put("venueid",venueid);
	PaypalXPaymentDetails paypalxdetails=new PaypalXPaymentDetails();
	String paymentmode=paypalxdetails.getPaymentMode(eid);
	if("".equals(paymentmode))paymentmode="paypal";
	responseJSON.put("paymentmode",paymentmode);
	
	double grandTotal=0;
	String totalamount=GenUtil.getHMvalue(transactionAmounts,"grandtotamount","0");
	String taxamount=GenUtil.getHMvalue(transactionAmounts,"tax","0");
	String netamount=GenUtil.getHMvalue(transactionAmounts,"netamount","0");
	String disamount=GenUtil.getHMvalue(transactionAmounts,"disamount","0");
	String total=GenUtil.getHMvalue(transactionAmounts,"totamount","0");
	String currencycode=GenUtil.getHMvalue(transactionAmounts,"currencycode","");
	
	String currencyformat=DbUtil.getVal("select currency_symbol from currency_symbols where currency_code in (select currency_code from event_currency where eventid=?)",new String[]{eid});
	if(currencyformat==null)
		currencyformat="$";
	
	double totalTax=0;
	double totalDiscount=0;
	
	try{
		responseJSON.put("status","success");
		responseJSON.put("currency_format",currencyformat);
	}catch(Exception e){}
	
	try{
		totalDiscount=Double.parseDouble(disamount);
	}catch(Exception e){
		totalDiscount=0;
	}
	
	try{
		totalTax=Double.parseDouble(taxamount);
	}catch(Exception e){
		totalTax=0;
	}
	
	try{
		grandTotal=Double.parseDouble(totalamount);
	}catch(Exception e){
		grandTotal=0;
	}
	
	//HashMap profilePageLabels=BDisplayAttribsDB.getAttribValues(eid,"RegFlowWordings");
	HashMap profilePageLabels=CDisplayAttribsDB.getAttribValues(eid,"RegFlowWordings");
	//profilepage.fillVelocityContextForProfilePage(eid,context,profilePageLabels);
	//************************************************************
	String eventbeeButtonLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.eventbee.paybutton.label","Pay With Credit Card");
	String paypalButtonLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.paypal.paybutton.label","Pay With PayPal OR Credit Card");
	String otherButtonLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.other.paybutton.label","Other Payment");
	
	//String googleButtonLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.google.paybutton.label","Pay With Google");
	String creditButtonLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.ebeecredit.paybutton.label","Pay With Eventbee Credits"); // no
	String nopaymentButtonLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.zero.paybutton.label","Continue");
	String backButtonLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.backtoprofile.label","Back To Profile");
	String refundpolicylabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.refund.label","Refund Policy");
	total_label=GenUtil.getHMvalue(profilePageLabels,"event.reg.total.amount.label","Total");
	String grandtotallabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.grandtotal.amount.label","Grand Total");
	String processing_fee_label=GenUtil.getHMvalue(profilePageLabels,"event.reg.tax.amount.label","Processing Fee");
	String paymentheader=GenUtil.getHMvalue(profilePageLabels,"event.reg.paymentsheader.label","Payment");
	String discountAmountLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.discount.amount.label","Discount");
	String NetAmountLabel=GenUtil.getHMvalue(profilePageLabels,"event.reg.net.amount.label","Net Amount");
	
	try{
		responseJSON.put("continue_zero_payment",nopaymentButtonLabel); 
		responseJSON.put("refund_policy",refundpolicylabel);
		responseJSON.put("payment_header_label",paymentheader);
		responseJSON.put("backbutton",GenUtil.getHMvalue(profilePageLabels,"event.reg.backtoprofile.label","Back To Profile"));
	}catch(Exception e){ }
	
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
	
	JSONArray paymentTypes=new JSONArray();
	try{
		if(grandTotal>0){
		Vector paytypes=regTktMgr.getAllPaymentTypes(eid,"Event");
		if(paytypes!=null){
			for(int k=0;k<paytypes.size();k++){
				HashMap payment=(HashMap)paytypes.get(k);
				type=(String)payment.get("paytype");
				JSONObject eachpaymentType=new JSONObject();
				if("paypal".equals(type))
					eachpaymentType.put("type","paypal").put("label",paypalButtonLabel);
				else if("eventbee".equals(type))
					eachpaymentType.put("type","cc").put("label",eventbeeButtonLabel);
				else if("other".equals(type))
					eachpaymentType.put("type","other").put("label",otherButtonLabel).put("text",(String)payment.get("desc")).put("small_text","Processing Fee is not applicable to this payment method");
				paymentTypes.put(eachpaymentType);
			} 
		 	responseJSON.put("payment_types",paymentTypes);
		}
		
		//need to implement with rambabu sir start
		String ccvendor=DbUtil.getVal("select attrib_5 from payment_types where refid=? and paytype='eventbee'",new String[]{eid});
			if("Y".equals(ntsenable) && !"".equals(referral_ntscode)){
				if((paymentmode.equals("paypalx") && !"".equals(paypalsection))  || (!("".equals(eventbeesection)) && !"authorize.net".equals(ccvendor))){
					if("authorize.net".equals(ccvendor))
						paymentsection=paypalsection+ebeecredits;
					else	
						paymentsection=paypalsection+eventbeesection+ebeecredits;
				}else{
					paymentsection=paypalsection+googlesection+eventbeesection+ebeecredits+othersection;
				}
			}else
				paymentsection=paypalsection+googlesection+eventbeesection+ebeecredits+othersection;
		}
	}catch(Exception e){ }
	//need to implement with rambabu sir end
	
	String refundPolicy=(String)configMap.get("event.ticketpage.refundpolicy.statement");
	
	responseJSON.put("refund_policy_text",refundPolicy);
	String template="";
	
	System.out.println("the currency code is::"+currencycode);
	
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
	
	JSONArray paymentdetails=new JSONArray();
	try{
		paymentdetails.put(new JSONObject().put("label",total_label).put("value",total+""));
		if(totalDiscount>0){
			paymentdetails.put(new JSONObject().put("label",discountAmountLabel).put("value",disamount));
			paymentdetails.put(new JSONObject().put("label",NetAmountLabel).put("value",netamount));
		}
		paymentdetails.put(new JSONObject().put("label",processing_fee_label).put("value",taxamount));
		paymentdetails.put(new JSONObject().put("label",grandtotallabel).put("value",totalamount));
		
		responseJSON.put("payment_details",paymentdetails);
		
		String configval=DbUtil.getVal("select value from config a,eventinfo b where a.config_id= b.config_id and b.eventid=CAST(? AS BIGINT) and a.name=?",new String[]{eid, "timeout"});
		if(configval==null)configval="15"; 
		int configvalint=Integer.parseInt(configval);
		if(configvalint!=15)
			configvalint+=1;
		
		int totalDiff=0;
		int totalSecDiff=60;
		
		String timeQuery="select to_char(now()- locked_time,'MI:SS') as  Difference from event_reg_locked_tickets where eventid=? and tid=? order by locked_time desc  limit 1";
		String temp=DbUtil.getVal(timeQuery, new String[]{eid,tid});
		
		String timeminarr[] = new String[3];
		String timediffence="";
		String secdiffence="";
		try{
			timeminarr= temp.split(":");
			timediffence=timeminarr[0];
		secdiffence=timeminarr[1];
		}catch(Exception e){
			timediffence = "15";
			secdiffence ="00";
		}
		
		if(secdiffence==null || "".equals(secdiffence))
			secdiffence="00";
		if(timediffence==null || "".equals(timediffence))
		   timediffence="0";
		
		try{
			int timediffininteger = Integer.parseInt(timediffence);
			int intsecdiffrence = Integer.parseInt(secdiffence);
			if(timediffininteger<=0)
				timediffininteger=0;
			totalDiff = configvalint - timediffininteger;
			totalSecDiff = totalSecDiff - intsecdiffrence ;
			if(intsecdiffrence>0 || totalSecDiff>=60)totalDiff=totalDiff-1;
			if(totalDiff<=0)totalDiff=0;
			if(intsecdiffrence<=0 || intsecdiffrence>=60) intsecdiffrence=0;
		}catch(Exception e){
			totalDiff = configvalint;
		}
		responseJSON.put("timediffrence",totalDiff+"");
		responseJSON.put("secdiffrence",totalSecDiff+"");
		out.println(responseJSON.toString(2));
	}catch(Exception e){}

}catch(Exception e){
	System.out.println("exception occured in getPaymentJSON::"+e.getMessage());
}
%>
