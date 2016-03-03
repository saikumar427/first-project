package com.eventregister;

import java.util.HashMap;
import java.util.ArrayList;
import javax.servlet.jsp.JspWriter;
import org.apache.velocity .*;
import org.apache.velocity.app.*;
import org.json.JSONObject;
import com.eventbee.general.*;
import com.eventbee.general.formatting.CurrencyFormat;

import com.eventbee.event.ticketinfo.*;
import com.event.dbhelpers.*;


public class RegConfirmationDBHelper{
	String serveraddress="http://"+EbeeConstantsF.get("serveraddress","");
	
	
public void fillConfirmation(String tid,String eid,JspWriter out){
	try{
		RegistrationDBHelper regdb=new RegistrationDBHelper();
		RegistrationTiketingManager regmgr=new RegistrationTiketingManager();
		HashMap buyerdetails=null;
		String startday=null;
		String endday=null;
		String currencyformat=DbUtil.getVal("select html_symbol from currency_symbols where currency_code in (select currency_code from event_currency where eventid=?)",new String[]{eid});
		if(currencyformat==null)
		currencyformat="$";
		HashMap ticketPageLabels=DisplayAttribsDB.getAttribValues(eid,"RegFlowWordings");
		HashMap TransactionDetails=regdb.getTransactionDetails(tid);
		String totalamount=GenUtil.getHMvalue(TransactionDetails,"grandtotal","0.00");
		String tax=GenUtil.getHMvalue(TransactionDetails,"tax","0.00");
		double taxamt=0;
		try{
		taxamt=Double.parseDouble(tax);
		}
		catch(Exception e){
		taxamt=0;
		}
		
		TicketsDB tktdb=new TicketsDB();
		HashMap configMap = tktdb.getConfigValuesFromDb(eid);
		String eventdate=GenUtil.getHMvalue(TransactionDetails,"eventdate"," ");
		String orderNumber=GenUtil.getHMvalue(TransactionDetails,"ordernumber","0");
		String paymenttype=GenUtil.getHMvalue(TransactionDetails,"paymenttype","0");
		String extpayid=GenUtil.getHMvalue(TransactionDetails,"extpayid","0");
		String bookingdomain=GenUtil.getHMvalue(TransactionDetails,"bookingdomain","0");
		buyerdetails=regdb.getBuyerInfo(tid,eid);
		String ticketNameLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.ticket.name.label","Ticket Name");
		String ticketPriceLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.ticket.price.label","Price");
		String ticketQtyLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.ticket.qty.label","Quantity");
		String processFeeLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.processfee.label","Fee");
		String taxAmountLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.tax.amount.label","Tax");
		String GrandTotalLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.grandtotal.amount.label","Grand Total");
		String totalAmountLabel=GenUtil.getHMvalue(ticketPageLabels,"event.reg.total.amount.label","Total");
		String eventpageLink="<a href='#' onClick='refreshPage()'>Back To Event Page</a>";
		String fbconnapi=DbUtil.getVal("select value  from config where config_id=CAST(? AS INTEGER) and name='ebee.fbconnect.api'",new String[]{"1"});
		String fbbuttonframe="";
		fbbuttonframe="<table><tr><td><td id='confirmationfeed'>"
		      +"<a href='#' onclick=createFBSectionForHeader('"+fbconnapi+"','"+eid+"');>"
			  +"<img src='/home/images/fbconnect.gif' border='0'/>"
		      +"</td></tr></table>";
		EventTicketDB edb=new EventTicketDB();
		HashMap evtmap=new HashMap();
		StatusObj sobj=edb.getEventInfo(eid,evtmap);
		startday=(String)evtmap.get("StartDate_Day");
		endday=(String)evtmap.get("EndDate_Day");
		String starttime=(String)evtmap.get("STARTTIME");
		String endtime=(String)evtmap.get("ENDTIME");
		String venue=(String)evtmap.get("VENUE");
		String location=(String)evtmap.get("LOCATION");
		String ticketname="";
		String ticketgroupname="";
		String tickettype="";
		String fname="";
		String lname="";
		
		String qrcodeoption=(String)configMap.get("confirmationpage.qrcodes");
		if(qrcodeoption==null||"".equals(qrcodeoption))
		qrcodeoption="Attendee";
		ArrayList purchasedTickets=regdb.getConfirmationTicketDetails(tid,eid,eventdate);
		String buyerquestion="";
		buyerquestion=((HashMap)purchasedTickets.get(purchasedTickets.size()-1)).get("buyercustomQuestion")+"";
		purchasedTickets.remove(purchasedTickets.size()-1);
		try{
			for(int tickets=0;tickets<purchasedTickets.size();tickets++){
				HashMap eachProfile=(HashMap)purchasedTickets.get(tickets);
				eachProfile.put("discount",CurrencyFormat.formatNumberWithCommas((String)eachProfile.get("discount")));
				eachProfile.put("processingFee",CurrencyFormat.formatNumberWithCommas((String)eachProfile.get("processingFee")));
				eachProfile.put("ticketPrice",CurrencyFormat.formatNumberWithCommas((String)eachProfile.get("ticketPrice")));
				eachProfile.put("totalAmount",CurrencyFormat.formatNumberWithCommas((String)eachProfile.get("totalAmount")));				
			}
		}
		catch(Exception e){
			System.out.println("Exception while converting amounts to number format in RegConfirmationDBHelper portal"+e.getMessage());
		}
		ArrayList profileInfo=regdb.getProfileInfo(tid,eid);
		HashMap ticketsdetails=regmgr.getTicketDetails(eid);
		
		
		if(profileInfo!=null&&profileInfo.size()>0){
		try{
		for(int i=0;i<profileInfo.size();i++){
		JSONObject obj=new JSONObject();
		obj.put("eid",eid);
		obj.put("tid",tid);
		HashMap profile=(HashMap)profileInfo.get(i);
		String ticketid=(String)profile.get("ticketid");
		String seatcode=(String)profile.get("seatCodes");
		String profilekey=(String)profile.get("profilekey");
			
		fname=(String)profile.get("fname");
		lname=(String)profile.get("lname");
		
		if("".equals(fname)){
		fname=(String)buyerdetails.get("fname");
		lname=(String)buyerdetails.get("lname");
		}
		obj.put("pkey",profilekey);
		obj.put("fname",fname);
		obj.put("lname",lname);
		if(ticketsdetails.containsKey(ticketid)){
		HashMap ticketDetails=(HashMap)ticketsdetails.get(ticketid);
		if(!"".equals((String)ticketDetails.get("groupname"))){
		ticketgroupname=(String)ticketDetails.get("groupname");
		obj.put("ticketgrouptype",ticketgroupname);
		}
		ticketname=(String)ticketDetails.get("ticketname");
		 tickettype=(String)profile.get("tickettype");
		obj.put("tickettype",ticketname);
		}
		String qstring=obj.toString();
		
		
		profile.put("ticketname",ticketname);
		profile.put("ticketCount","Ticket # "+(i+1));
		if((!"None".equals(qrcodeoption))&&("Attendee".equals(qrcodeoption)&&("attendeeType".equals(tickettype)))|("All".equals(qrcodeoption))){
			HashMap qr_barcodemsg=regdb.getQrCodeBarCode(eid);
			String qrcode="",vbarcode="",hbarcode="";
			qrcode=(String)qr_barcodemsg.get("qrcode");
			vbarcode=(String)qr_barcodemsg.get("vbarcode");
			hbarcode=(String)qr_barcodemsg.get("hbarcode");
				
			try{
				String qr[]=qrcode.split("#msg");
				qrcode=qr[0]+java.net.URLEncoder.encode(qstring)+qr[1];
				String vbar[]=vbarcode.split("#msg");
				vbarcode=vbar[0]+obj.get("pkey")+vbar[1];
				String hbar[]=hbarcode.split("#msg");
				hbarcode=hbar[0]+obj.get("pkey")+hbar[1];
				String vserver[]=vbarcode.split("#serveraddress");
				vbarcode=vserver[0]+serveraddress+vserver[1];
				String hserver[]=hbarcode.split("#serveraddress");
				hbarcode=hserver[0]+serveraddress+hserver[1];
				
			}catch(Exception e){System.out.println("exception in try dbhelpers:"+e.getMessage());}
				
			
			

			profile.put("qrcode", qrcode);
			profile.put("barcode", hbarcode);
			profile.put("vBarcode", vbarcode);
			
		//profile.put("qrcode","<img src='http://chart.apis.google.com/chart?cht=qr&chs=100x100&chl="+java.net.URLEncoder.encode(qstring)+"'/>");
		//profile.put("barcode","<img width='200px' src='"+serveraddress+"/genbc?type=code128&msg="+obj.get("pkey")+"&height=0.75cm&hrsize=6pt&hrp=bottom&fmt=gif'>");
		//profile.put("vBarcode","<img width='200px' style='-webkit-transform: rotate(-270deg);-moz-transform: rotate(-270deg);filter: progid:DXImageTransform.Microsoft.BasicImage(rotation=1);' src='"+serveraddress+"/genbc?type=code128&msg="+obj.get("pkey")+"&height=0.75cm&hrsize=6pt&hrp=bottom&fmt=gif'>");
		
		}
		else{
			
		}
		profileInfo.set(i,profile);
		}
		}
		catch (Exception e){
		System.out.println("Exception in qrocde generation "+e.getMessage());
		}
		}
		
		VelocityContext context = new VelocityContext();
		context.put("transactionKey",tid);
		context.put("buyerDetails",buyerdetails);
		if(eventdate!=null&&!" ".equals(eventdate)&&!"null".equals(eventdate)){
		context.put("startDay",eventdate);
			}
		else{
		context.put("startDay",startday);
		context.put("endDay",endday);
		context.put("startTime",starttime);
		context.put("endTime",endtime);
		}
		context.put("venue",venue);
		context.put("location",location);
		context.put("eventName",(String)evtmap.get("EVENTNAME"));
		context.put("mgrFirstName",(String)evtmap.get("FIRSTNAME"));
		context.put("mgrLastName",(String)evtmap.get("LASTNAME"));
		context.put("mgrEmail",(String)evtmap.get("EMAIL"));
		context.put("purchasedTickets",purchasedTickets);
		context.put("currencyFormat",currencyformat);
		try{
			context.put("grandTotal",CurrencyFormat.formatNumberWithCommas((String)totalamount));			
		}catch(Exception e){			
			context.put("grandTotal",totalamount);
		}	
		if(buyerquestion!=null && !"".equals(buyerquestion) && !"null".equals(buyerquestion))
		context.put("buyercustomQuestions", buyerquestion);
		if(taxamt>0){
		context.put("tax",tax);
		}
		if(profileInfo!=null&&profileInfo.size()>0)
		context.put("profileData",profileInfo);
		context.put("ticketPriceLabel",ticketPriceLabel);
		context.put("ticketNameLabel",ticketNameLabel);
		context.put("taxAmountLabel",taxAmountLabel);
		context.put("GrandTotalLabel",GrandTotalLabel);
		context.put("grandTotalLabel",GrandTotalLabel);
		context.put("totalAmountLabel",totalAmountLabel);
		context.put("eventpageLink",eventpageLink);
		context.put("ticketQtyLabel",ticketQtyLabel);
		context.put("processFeeLabel",processFeeLabel);
		context.put("orderNumber",orderNumber);
		context.put("paymentType",paymenttype);
		context.put("extPayId",extpayid);
		context.put("seatcodes", regdb.getTransactionSeatcodes(tid));
		if("EB".equals(bookingdomain))
		context.put("FbConnectButton",fbbuttonframe);
		RegistrationTiketingManager regtktmgr=new RegistrationTiketingManager();
		String purpose="confirmationpage";
		String pageval=(String)configMap.get("event.confirmationpagebytype.enable");
		if(pageval==null)pageval="N";
		String paymentstatus=(String)TransactionDetails.get("paymentstatus");
		/*if("Y".equalsIgnoreCase(pageval)){*/
			if(paymentstatus==null)paymentstatus="Completed";
			if(("Need Approval").equalsIgnoreCase(paymentstatus)) purpose=purpose+"_pending";
			if(("Completed").equalsIgnoreCase(paymentstatus)) purpose=purpose+"_completed";
	/*	}*/
		System.out.println("the purpose is::"+purpose+"::paymentstatus::"+paymentstatus);
		String template= regtktmgr.getVelocityTemplate(eid,purpose);
		VelocityEngine ve= new VelocityEngine();
		try{
		ve.init();
		boolean abletopares=ve.evaluate(context,out,"ebeetemplate", template);
		}
		catch(Exception exp){
		out.println("---"+exp.getMessage());
		}
	}
	catch(Exception e){

	}
}


public void fillseatingstatus(String tid,String eid,String eventdate,String venueid){
	RegistrationDBHelper regdb=new RegistrationDBHelper();
	RegistrationTiketingManager regmgr=new RegistrationTiketingManager();
	ArrayList profileInfo=regdb.getallProfileInfo(tid,eid);
	if(venueid== null || "".equals(venueid)){
		venueid=regdb.getVenueID(eid);
	}
	if(profileInfo!=null&&profileInfo.size()>0){
		for(int i=0;i<profileInfo.size();i++){
			HashMap profile=(HashMap)profileInfo.get(i);
			String seatcode=(String)profile.get("seatCodes");
			String profilekey=(String)profile.get("profilekey");
			String ticketid=(String)profile.get("ticketid");
			String seatindex=(String)profile.get("seatIndex");
			String sectionid="";
			
			if(!"".equals(seatcode)&&seatcode!=null){
				
				try{
					sectionid=seatindex.split("_")[0];
				}
				catch(Exception e){}
				HashMap seatinghm=new HashMap();
				seatinghm.put("eventid",eid);
				seatinghm.put("eventdate",eventdate);
				seatinghm.put("ticketid",ticketid);
				seatinghm.put("profilekey",profilekey);
				seatinghm.put("tid",tid);
				seatinghm.put("section_id",sectionid);
				seatinghm.put("venue_id",venueid);
				seatinghm.put("seatindex", seatindex);
				try{
					regdb.insertSeatBookingStatus(seatinghm);
				}
				catch(Exception e){
					System.out.println("exception in inserting into seat_booking_status:"+e.getMessage());
				}
			}
			
		}
	}
	/*
	ArrayList ticketids=regmgr.getTicketIds(eid);
	HashMap seatingdetails=regmgr.getSeatingDetails(eid, tid, eventdate, ticketids);
	if(profileInfo!=null&&profileInfo.size()>0){
		for(int i=0;i<profileInfo.size();i++){
			HashMap profile=(HashMap)profileInfo.get(i);
			String seatcode=(String)profile.get("seatCodes");
			String profilekey=(String)profile.get("profilekey");
			String ticketid=(String)profile.get("ticketid");
			try{
				if(!"".equals(seatcode)||seatcode!=null){
					ArrayList seatcodes_tktID=(ArrayList)seatingdetails.get(ticketid);
					ArrayList seatindex_tktID=(ArrayList)seatingdetails.get("seatindex_"+ticketid);
					int indexofseatcode=seatcodes_tktID.indexOf(seatcode);
					String seatindex_atseatcode=(String)seatindex_tktID.get(indexofseatcode);
					seatcodes_tktID.remove(indexofseatcode);
					seatindex_tktID.remove(indexofseatcode);
					HashMap seatinghm=(HashMap)seatingdetails.get(ticketid+"_"+seatindex_atseatcode+"_"+seatcode);
					seatinghm.put("eventid",eid);
					seatinghm.put("eventdate",eventdate);
					seatinghm.put("ticketid",ticketid);
					seatinghm.put("profilekey",profilekey);
					seatinghm.put("tid",tid);
					
					regdb.insertSeatBookingStatus(seatinghm);
				}
		}catch(Exception e){	
		}
		}
}*/
}


}