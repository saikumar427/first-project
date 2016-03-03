<%@ page import="javax.mail.internet.MimeUtility" %>
<%!
static String  serveraddress="http://"+EbeeConstantsF.get("serveraddress","");

HashMap getDomainValues(String tid,String eventid){
String query="select attrib1,attrib2,eventid from event_reg_details where eventid=? and tid=?";
DBManager db=new DBManager();
HashMap hm=new HashMap();
StatusObj sb=db.executeSelectQuery(query,new String[]{eventid,tid});
if(sb.getStatus()){
hm.put("oid",db.getValue(0,"attrib1",""));
hm.put("domain",db.getValue(0,"attrib2",""));
hm.put("eventid",db.getValue(0,"eventid",""));
}
return hm;
}
String getEncodedId(HashMap dMap){
String oid=(String)dMap.get("oid");
String domain=(String)dMap.get("domain");
String eventid=(String)dMap.get("eventid");
String encodedid=DbUtil.getVal("select encodedid from ning_event_tokens where eventid=? and ning_domain=?",new String[]{eventid,domain});
if(encodedid==null){
String tokenid=DbUtil.getVal("select nextval('ning_event_tokenid') as tid",new String[]{});
encodedid=EncodeNum.encodeNum(tokenid);
String userid=DbUtil.getVal("select ebeeid from ebee_ning_link where nid=?",new String[]{oid});
DbUtil.executeUpdateQuery("insert into ning_event_tokens(tokenid,encodedid,eventid,ningownerid,ning_domain,ebeeid,source,date) values(?,?,?,?,?,?,?,now())",new String[]{tokenid,encodedid,eventid,oid,domain,userid,"confirmationemail"});
}
return encodedid;
}
 String[] fillData(ProfileData[] pds,EventRegisterDataBean jBean,EmailTemplate emailtemplate){


		String eventid=jBean.getEventId();
		String unitid=jBean.getUnitId();
		String transactionid=jBean.getTransactionId();
		String ningeventurl=null;
		HashMap domainMap=getDomainValues(transactionid,eventid);
		if(domainMap!=null&&domainMap.size()>0){
		String encodedid=getEncodedId(domainMap);
		ningeventurl=serveraddress+"/ning/register?nid="+encodedid;
		}
		
		String isntsenabled=DbUtil.getVal("select enablenetworkticketing from group_agent_settings where groupid=? ",new String [] {eventid});

		String commission=DbUtil.getVal("select max(networkcommission) from price where evt_id=?",new String[]{eventid});
		commission="$"+commission;
		String feeconfiguration=DbUtil.getVal("select value   from config where name='event.feelabel' and config_id=(select config_id from eventinfo where eventid=?)",new String[]{eventid});
		if(feeconfiguration==null)
		feeconfiguration="Fee";
		
		String participateurl=serveraddress+"/participate.jsp?eid="+eventid;
		String learnmorelink=serveraddress+"/helplinks/partnernetwork.jsp";
		EventTicketDB edb=new EventTicketDB();
		HashMap evtmap=new HashMap();
		StatusObj sobj=edb.getEventInfo(eventid,evtmap);

		String emailcontent="This is email content send while in registration";
		String eventurl=null;
		String []reqTicket=jBean.getSelectReqTickets();
		String [] optTickets=jBean.getSelectOptTickets();
		String currencyformat=DbUtil.getVal("select html_symbol from currency_symbols where currency_code=(select currency_code from event_currency where eventid=?)",new String[]{jBean.getEventId()});
		if(currencyformat==null)
		currencyformat="$";
		eventurl=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{eventid});
		if(eventurl==null){
			eventurl=serveraddress+"/event?eid="+eventid;
		}
		
		if(ningeventurl!=null&&!"".equals(ningeventurl))
		eventurl=ningeventurl;
		//String buttonmsg="<a href = '"+eventurl+"' ><img border='0'  src='"+serveraddress+"/home/images/register.jpg'/></a>";

		
		double GrandTotal=jBean.getGrandTotal();
		double tax=jBean.getTaxAmount();
		
		double processfee=0;
		String startday=(String)evtmap.get("StartDate_Day");
		String starttime=(String)evtmap.get("STARTTIME");


		String endday=(String)evtmap.get("EndDate_Day");
		String endtime=(String)evtmap.get("ENDTIME");
		String venue=(String)evtmap.get("VENUE");
		String location=(String)evtmap.get("LOCATION");
		String urllink=eventurl;
		Vector attendees=new Vector();


		for (int i=0;i<pds.length;i++) {
		HashMap attendeemap=new HashMap();
		attendeemap.put("firstName",GenUtil.XMLEncode(pds[i].getFirstName()));
		attendeemap.put("lastName",GenUtil.XMLEncode(pds[i].getLastName()));
		attendeemap.put("email",GenUtil.XMLEncode(pds[i].getEmail())) ;
		attendees.add(attendeemap);    
		}

		Vector purchasedtickets=new Vector();
                String ticketname="";
                String  groupName="";
		if(reqTicket!=null){

             
		HashMap ticketmap=new HashMap();
		groupName=DbUtil.getVal("select groupname from event_ticket_groups where ticket_groupid=(select ticket_groupid from group_tickets where price_id=?)",new String[]{jBean.getReqTicketId()});
		if(!"".equals(groupName))
	        ticketname=groupName+"-"+jBean.getReqTicketName();
		else
		ticketname=jBean.getReqTicketName();
		ticketmap.put("ticketName",GenUtil.getEncodedXML(ticketname));
		ticketmap.put("ticketPrice",CurrencyFormat.getCurrencyFormat("",""+jBean.getTicketDisplayPrice(),true));
		ticketmap.put("processingFee",CurrencyFormat.getCurrencyFormat("",""+jBean.getTicketProcessFee(),true));
		ticketmap.put("discount",CurrencyFormat.getCurrencyFormat("",""+jBean.getReqTicketDiscount(),true));
		ticketmap.put("ticketQuantity",Integer.toString(jBean.getReqTicketQty()));
		ticketmap.put("totalAmount",CurrencyFormat.getCurrencyFormat("",""+jBean.getReqTicketTotal(),true));

		purchasedtickets.add(ticketmap);

		}


		if(optTickets!=null){
		for(int i=0;i<optTickets.length;i++){
		HashMap ticketmap=new HashMap();
		groupName=DbUtil.getVal("select groupname from event_ticket_groups where ticket_groupid=(select ticket_groupid from group_tickets where price_id=?)",new String[]{jBean.getOptTicketId()[i]});
		if(!"".equals(groupName))
		ticketname=groupName+"-"+jBean.getOptTicketName()[i];
		else
		ticketname=jBean.getOptTicketName()[i];
	     		
		ticketmap.put("ticketName",GenUtil.getEncodedXML(ticketname));

		ticketmap.put("ticketPrice",CurrencyFormat.getCurrencyFormat("",""+jBean.getOptTicketDisplayPrice()[i],true));

		ticketmap.put("processingFee",CurrencyFormat.getCurrencyFormat("",""+jBean.getOptTicketProcessFee()[i],true));


		ticketmap.put("ticketQuantity",Integer.toString(jBean.getOptTicketQty()[i]));
		ticketmap.put("discount",CurrencyFormat.getCurrencyFormat("",""+jBean.getOptTicketDiscount()[i],true));

		ticketmap.put("totalAmount",CurrencyFormat.getCurrencyFormat("",""+jBean.getOptTicketTotal()[i],true));
	purchasedtickets.add(ticketmap);



		}
		}

                String ordernumber=DbUtil.getVal("select ordernumber from event_reg_transactions where tid=?",new String []{jBean.getTransactionId()});

		String reftermsandcondtions=DbUtil.getVal("select value from config where name='event.ticketpage.refundpolicy.statement' and config_id=(select config_id from eventinfo where eventid=?)",new String[]{eventid});
		String refundpolicy=DbUtil.getVal("select value from config where name='event.confirmationemail.refundpolicy' and config_id=(select config_id from eventinfo where eventid=?)",new String[]{eventid});
		if(refundpolicy==null)
		refundpolicy="Yes";
		String grandtotal=CurrencyFormat.getCurrencyFormat(currencyformat,""+GrandTotal,false);
                String taxamount=CurrencyFormat.getCurrencyFormat(currencyformat,""+tax,false);
		

                String footer="";
        	VelocityContext mp = new VelocityContext();
		StringBuffer sb=new StringBuffer("");
		sb.append("/portal/attendeeview/attendeepage.jsp?UNITID=");
		sb.append(unitid);
		sb.append("&GROUPID="+eventid);
		sb.append("&attendeekey=");
		sb.append(jBean.getAttendeeKey()[0]);
		mp.put("firstName",pds[0].getFirstName());
		mp.put("lastName",pds[0].getLastName());
		mp.put("transactionURL",sb.toString());
		mp.put("eventName",(String)evtmap.get("EVENTNAME"));
		mp.put("transactionKey",transactionid);
		mp.put("attendeeKey",jBean.getAttendeeKey()[0]);
		mp.put("startDay",startday);
		mp.put("endDay",endday);
		mp.put("startTime",starttime);
		mp.put("endTime",endtime);
		if(tax>0){
		mp.put("tax",taxamount);
		}
		mp.put("processFeeLabel",feeconfiguration);
		mp.put("venue",venue);
		mp.put("location",location);
                mp.put("eventURL",urllink);
		mp.put("commission",commission);
		mp.put("mgrFirstName",(String)evtmap.get("FIRSTNAME"));
		mp.put("mgrLastName",(String)evtmap.get("LASTNAME"));
		mp.put("mgrEmail",(String)evtmap.get("EMAIL"));
		mp.put("mgrPhone",GenUtil.getHMvalue(evtmap,"PHONE"));
		mp.put("purchasedTickets",purchasedtickets);
		mp.put("attendees",attendees);
		mp.put("currencyFormat",currencyformat);
		mp.put("grandTotal",grandtotal);
                if("Yes".equalsIgnoreCase(isntsenabled)){
		mp.put("enabledNTS",isntsenabled);
              		
		}
	       mp.put("participateURL",participateurl);
               mp.put("learnMoreLink",learnmorelink);
               if("Yes".equalsIgnoreCase(refundpolicy)){               
               mp.put("refundPolicy",reftermsandcondtions);
               }
               mp.put("orderNumber",ordernumber);
               
               HashMap ptypehm=PaymentTypes.getPaymentTypeInfo(jBean.getEventId(),"Event","other");
	       		String otherdesc=null;
	       		if(ptypehm!=null){
	       		otherdesc=(String)ptypehm.get("attrib_1");
}	       

               if("other".equalsIgnoreCase(jBean.getPayType())){
	       	mp.put("otherPaymentDesc",otherdesc);
	                   
	       		
	       		}

               if("true".equals(jBean.getUpgradeRegStatus())){
               
               	mp.put("upgradeRegistration","yes");
	       
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


		return new String[]{message,frommail,subject,mailtype};
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



int sendRegistrationEmail(ProfileData[] pds,EventRegisterDataBean jBean){
	int status=0;
	EventConfigScope evt_scope=new EventConfigScope();
	String eventid=jBean.getEventId();
	String unitid=jBean.getUnitId();
	String emailyes=null;
	String emailtype="";
	HashMap scopemap=evt_scope.getEventConfigValues(eventid,"Registration");
	if(scopemap!=null)
	emailyes=GenUtil.getHMvalue(scopemap,"event.reg.email.sent","Yes");

	if("Yes".equalsIgnoreCase(emailyes)){
	try{

	EmailTemplate emailtemplate=null;
	String isformatexists=DbUtil.getVal("select 'yes' from email_templates where purpose='EVENT_REGISTARTION_CONFIRMATION' and groupid=?", new String []{eventid});
	if("yes".equals(isformatexists)){

	emailtemplate=new EmailTemplate("13579","EVENT_REGISTARTION_CONFIRMATION",eventid);
	}else{

	emailtemplate=new EmailTemplate("100","EVENT_REGISTARTION_CONFIRMATION");
	}



	EmailObj obj=EventbeeMail.getEmailObj();
	String toemailId=pds[0].getEmail();
	String[] formatmessage=fillData(pds,jBean,emailtemplate);
	String sendmailtoattendee=DbUtil.getVal("select value from config where name='event.sendmailtoattendee' and config_id=(select config_id from eventinfo where eventid=?)",new String[]{eventid});
	String sendmailtomgr=DbUtil.getVal("select value from config where name='event.sendmailtomgr' and config_id=(select config_id from eventinfo where eventid=?)",new String[]{eventid});
	String bcclist=EbeeConstantsF.get("ADMIN_EMAIL","sridevi@beeport.com");
	String bcclistfromDB=DbUtil.getVal("select value from config where name=? and config_id=(select config_id from eventinfo where eventid=?)",new String[]{"registration.email.cc.list",eventid});
	if(sendmailtomgr==null)
		sendmailtomgr="Yes";
	if("No".equalsIgnoreCase(sendmailtoattendee)){
		if("Yes".equalsIgnoreCase(sendmailtomgr)){ //A=N,M=Y
			toemailId=formatmessage[1];
			//Eventbee admin and bcc configured list will get bcc
			if(bcclistfromDB!=null&&!"".equals(bcclistfromDB))
				bcclist+=","+bcclistfromDB;
		}
		else{//A=N,M=N
			toemailId=EbeeConstantsF.get("ADMIN_EMAIL","sridevi@beeport.com");
			//Eventbee admin in to & configured list will get bcc
			bcclist=bcclistfromDB;
		}
	}else{
		if("Yes".equalsIgnoreCase(sendmailtomgr)){//A=Y,M=Y
			bcclist+=","+formatmessage[1];
		}
		else{//A=Y,M=N
			
		}
		if(bcclistfromDB!=null&&!"".equals(bcclistfromDB))
			bcclist+=","+bcclistfromDB;
	}
	obj.setTo(toemailId);
	emailtype=formatmessage[3];
	obj.setBcc(bcclist);
	obj.setFrom(formatmessage[1]);
	obj.setSubject(MimeUtility.encodeText(formatmessage[2],"ISO-8859-1","Q"));
	//obj.setSubject(formatmessage[2]);
	obj.setSendMailStatus(new SendMailStatus(unitid,"EVENT_REGISTARTION_CONFIRMATION",eventid,"1"));
	if("Html".equals(emailtype)){
	obj.setHtmlMessage(formatmessage[0]);
	EventbeeMail.sendHtmlMail(obj);
	}
	else if("Text".equals(emailtype))
	{
	obj.setTextMessage(formatmessage[0]);
	EventbeeMail.sendTextMail(obj);
	}
	status=1;
	}
	catch(Exception e){
	}
	}
	return status;

}
%>