package com.eventregister;
import java.util.ArrayList;
import java.util.HashMap;

import javax.mail.internet.MimeUtility;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;

import com.boxoffice.classes.BSendEmailThread;
import com.event.dbhelpers.BDisplayAttribsDB;
import com.eventbee.creditcard.PaymentTypes;
import com.eventbee.event.ticketinfo.EventTicketDB;
import com.eventbee.general.DbUtil;
import com.eventbee.general.EbeeConstantsF;
import com.eventbee.general.EmailObj;
import com.eventbee.general.EmailTemplate;
import com.eventbee.general.EventbeeLogger;
import com.eventbee.general.EventbeeMail;
import com.eventbee.general.GenUtil;
import com.eventbee.general.SendMailStatus;
import com.eventbee.general.StatusObj;


public class BRegistrationConfirmationEmail{
	String serveraddress="http://"+EbeeConstantsF.get("serveraddress","");
public int sendRegistrationEmail(String tid,String eid){
	HashMap<String,String> paramMap=new HashMap<String,String>();
	paramMap.put("tid",tid);
    paramMap.put("eid",eid);
    paramMap.put("bcc", "bcc");
    paramMap.put("powertype", "Ticketing");
    (new Thread(new BSendEmailThread(paramMap))).start();
	 return 1;  
}

String[] fillData(String tid,String eid,EmailTemplate emailtemplate,HashMap scopemap){
	String  serveraddress="http://"+EbeeConstantsF.get("serveraddress","");
	String eventid=eid;
	String transactionid=tid;
	BRegistrationDBHelper regdb=new BRegistrationDBHelper("confirmation_email");
	String feeconfiguration=GenUtil.getHMvalue(scopemap,"event.feelabel","Fee") ;
	EventTicketDB edb=new EventTicketDB();
	HashMap evtmap=new HashMap();
	StatusObj sobj=edb.getEventInfo(eventid,evtmap);
	String eventurl=null;
	String currencyformat=DbUtil.getVal("select html_symbol from currency_symbols where currency_code in (select currency_code from event_currency where eventid=?)",new String[]{eventid});
	if(currencyformat==null)
		currencyformat="$";
	eventurl=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{eventid});
	if(eventurl==null){
		eventurl=serveraddress+"/event?eid="+eventid;
	}
	HashMap regDetails=regdb.getTransactionDetails(tid);
	String endday=null;
	String startday=null;
	String eventdate=GenUtil.getHMvalue(regDetails,"eventdate"," ");
	startday=(String)evtmap.get("StartDate_Day");
	endday=(String)evtmap.get("EndDate_Day");
	String starttime=(String)evtmap.get("STARTTIME");
	String endtime=(String)evtmap.get("ENDTIME");
	String venue=(String)evtmap.get("VENUE");
	String location=(String)evtmap.get("LOCATION");
	String urllink=eventurl;
	HashMap buyerDetails=regdb.getBuyerInfo(tid,eid);;
	ArrayList purchasedtickets=regdb.getConfirmationTicketDetails(tid,eid,eventdate);
	String reftermsandcondtions=GenUtil.getHMvalue(scopemap,"event.ticketpage.refundpolicy.statement","") ;
	String seatingEnable=GenUtil.getHMvalue(scopemap,"event.seating.enabled","");
	String refundpolicy=GenUtil.getHMvalue(scopemap,"event.confirmationemail.refundpolicy","Yes");
	String grandtotal=GenUtil.getHMvalue(regDetails,"grandtotal","0.00");
	String taxamount=GenUtil.getHMvalue(regDetails,"tax","0.00");
	String paymenttype=GenUtil.getHMvalue(regDetails,"paymenttype","0.00");
	String extpayid=GenUtil.getHMvalue(regDetails,"extpayid","0");
	HashMap ticketPageLabels=BDisplayAttribsDB.getAttribValues(eid,"RegFlowWordings");
	//******************************************
	String ticketNameLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.ticket.name.label","Ticket Name");
	String ticketPriceLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.ticket.price.label","Price");
	String ticketQtyLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.ticket.qty.label","Quantity");
	String processFeeLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.processfee.label","Fee");
	String taxAmountLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.tax.amount.label","Tax");
	String GrandTotalLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.grandtotal.amount.label","Grand Total");
	String totalAmountLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.total.amount.label","Total");
	//*************************************************************
	String getTicketsurl=serveraddress+"/tickets/generatetickets.jsp?tid="+tid+"&eid="+eid;
	String getTicketsLink="<a href='"+getTicketsurl+"'>Click here</a>";
	String pdf_tickets_url=serveraddress+"/gettickets?tid="+tid+"&eid="+eid;
	VelocityContext mp = new VelocityContext();
	String firstName="";
	String lasName="";
	String toemail="";
	if(buyerDetails!=null){
		firstName=(String)buyerDetails.get("firstName");
		lasName=(String)buyerDetails.get("lastName");
		toemail=(String)buyerDetails.get("email");
	}
	mp.put("firstName",firstName);
	mp.put("lastName",lasName);
	mp.put("eventName",(String)evtmap.get("EVENTNAME"));
	mp.put("transactionKey",transactionid);
	if(eventdate!=null&&!" ".equals(eventdate)&&!"null".equals(eventdate)){
		mp.put("startDay",eventdate);
	}
	else{
		mp.put("startDay",startday);
		mp.put("endDay",endday);
		mp.put("startTime",starttime);
		mp.put("endTime",endtime);
	}
	if(Double.parseDouble(taxamount)>0){
		mp.put("tax",taxamount);
	}
	mp.put("processFeeLabel",feeconfiguration);
	mp.put("venue",venue);
	mp.put("location",location);
	mp.put("eventURL",urllink);
	mp.put("seatcodes", regdb.getTransactionSeatcodes(transactionid));
	String mgrname=DbUtil.getVal("select value from config where name='event.hostname' and config_id=" +
		"(select config_id from eventinfo where eventid=CAST(? AS INTEGER))", new String[]{eid});
	if(mgrname!=null){
		mp.put("mgrFirstName",mgrname);
		mp.put("mgrLastName","");
	}else{
		mp.put("mgrFirstName",(String)evtmap.get("FIRSTNAME"));
		mp.put("mgrLastName",(String)evtmap.get("LASTNAME"));
	}
	mp.put("mgrEmail",(String)evtmap.get("EMAIL"));
	mp.put("mgrPhone",GenUtil.getHMvalue(evtmap,"PHONE"));
	mp.put("purchasedTickets",purchasedtickets);
	mp.put("currencyFormat",currencyformat);
	mp.put("grandTotal",grandtotal);
	String attendeeurl=serveraddress+"/main/user/attendee?tid="+tid;
	mp.put("attendeeUrl",attendeeurl);
	if("Yes".equalsIgnoreCase(refundpolicy)){
		mp.put("refundPolicy",reftermsandcondtions);
	}
	String orderNumber=GenUtil.getHMvalue(regDetails,"ordernumber","0");
	String date=GenUtil.getHMvalue(regDetails,"transaction_date","");
	orderNumber=regdb.getUniqueOrderNumber(eid,orderNumber,tid,date);
	mp.put("orderNumber",orderNumber);
	mp.put("ticketPriceLabel",ticketPriceLabel);
	mp.put("ticketNameLabel",ticketNameLabel);
	mp.put("taxAmountLabel",taxAmountLabel);
	mp.put("GrandTotalLabel",GrandTotalLabel);
	mp.put("grandTotalLabel",GrandTotalLabel);
	mp.put("totalAmountLabel",totalAmountLabel);
	mp.put("ticketQtyLabel",ticketQtyLabel);
	mp.put("processFeeLabel",processFeeLabel);
	mp.put("buyerDetails",buyerDetails);
	mp.put("getTicketsLink",getTicketsLink);
	mp.put("ticketspdf",pdf_tickets_url);
	mp.put("paymentType",paymenttype);
	mp.put("extPayId",extpayid);
	HashMap ptypehm=PaymentTypes.getPaymentTypeInfo(eventid,"Event","other");
	String otherdesc=null;
	if(ptypehm!=null){
		otherdesc=(String)ptypehm.get("attrib_1");
	}
	if(paymenttype.indexOf("other")>-1){
		mp.put("otherPaymentDesc",otherdesc);
	}
	String mailtype="";
	String mailcontent=emailtemplate.getHtmlFormat();
	if(mailcontent==null||"".equals(mailcontent)){
		mailcontent=emailtemplate.getTextFormat();
		mailtype="Text";
	}
	else{
		mailtype="Html";
	}
	String message=getVelocityOutPut(mp,mailcontent);
	String frommail=(String)evtmap.get("EMAIL");
	String subject=getVelocityOutPut(mp,emailtemplate.getSubjectFormat());
	return new String[]{message,frommail,subject,mailtype,toemail};
}

String getVelocityOutPut(VelocityContext vc,String Template){
	StringBuffer str=new StringBuffer();
	java.io.StringWriter out1=new java.io.StringWriter();
	VelocityEngine ve= new VelocityEngine();
	try{
		ve.init();
		boolean abletopares=ve.evaluate(vc,out1,"ebeetemplate",Template );
		str=out1.getBuffer();
	}
	catch(Exception e){
		System.out.println(e.getMessage());
	}
	return str.toString();
}


}