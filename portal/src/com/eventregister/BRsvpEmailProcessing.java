package com.eventregister;
import java.util.HashMap;

import com.event.i18n.dbmanager.ConfirmationEmailDAO;
import com.eventbee.general.*;
import com.eventbee.layout.DBHelper;
import com.eventbee.event.ticketinfo.*;
import org.apache.velocity .*;
import org.apache.velocity.app.*;
public class BRsvpEmailProcessing{

	static String  serveraddress="http://"+EbeeConstantsF.get("serveraddress","");

	static String[] fillData(HashMap hm,String eventid,HashMap<String, String> emailTemplate){
		EventTicketDB edb=new EventTicketDB();
		HashMap evtmap=new HashMap();
		edb.getEventInfo(eventid,evtmap);
		String eventurl=null;
		eventurl=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{eventid});
		if(eventurl==null){
			eventurl=serveraddress+"/event?eid="+eventid;
		}
		String startday=(String)evtmap.get("StartDate_Day");
		String starttime=(String)evtmap.get("STARTTIME");
		String endday=(String)evtmap.get("EndDate_Day");
		String endtime=(String)evtmap.get("ENDTIME");
		String venue=(String)evtmap.get("VENUE");
		String location=(String)evtmap.get("LOCATION");
		String urllink=eventurl;
		HashMap attendeemap=new HashMap();
		attendeemap.put("firstName",GenUtil.XMLEncode((String)hm.get("fname")));
		attendeemap.put("lastName",GenUtil.XMLEncode((String)hm.get("lname")));
		attendeemap.put("email",GenUtil.XMLEncode((String)hm.get("emailid"))) ;
		VelocityContext mp = new VelocityContext();
		mp.put("firstName",(String)hm.get("fname"));
		mp.put("lastName",(String)hm.get("lname"));
		mp.put("eventName",(String)evtmap.get("EVENTNAME"));
		mp.put("attendeeKey",(String)hm.get("attendeeid"));
		mp.put("startDay",startday);
		mp.put("endDay",endday);
		mp.put("startTime",starttime);
		mp.put("endTime",endtime);
		mp.put("venue",venue);
		mp.put("location",location);
		mp.put("eventURL",urllink);
		mp.put("mgrFirstName",(String)evtmap.get("FIRSTNAME"));
		mp.put("mgrLastName",(String)evtmap.get("LASTNAME"));
		mp.put("mgrEmail",(String)evtmap.get("EMAIL"));
		mp.put("mgrPhone",GenUtil.getHMvalue(evtmap,"PHONE"));
		mp.put("attendees",attendeemap);
		String mailtype="";
		String mailcontent=emailTemplate.get("htmlFormat");//emailtemplate.getHtmlFormat();
		if(mailcontent==null||"".equals(mailcontent)){
			mailcontent=emailTemplate.get("textFormat");//emailtemplate.getTextFormat();
			mailtype="Text";
		}
		else{
			mailtype="Html";
		}
		String message=getVelocityOutPut(mp,mailcontent);
		String frommail=(String)evtmap.get("EMAIL");
		String subject=getVelocityOutPut(mp,emailTemplate.get("subjectFormat"));
		return new String[]{message,frommail,subject,mailtype};
	}
	static String getVelocityOutPut(VelocityContext vc,String Template){
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
	public static int sendRsvpEmail(HashMap hmap){
		String eventid=(String) hmap.get("GROUPID");
		int status=0;
		try{
			/*EmailTemplate emailtemplate=null;
			String isformatexists=DbUtil.getVal("select 'yes' from email_templates where purpose='RSVP_CONFIRMATION' and groupid=?", new String []{eventid});
			if("yes".equals(isformatexists)){
				emailtemplate=new EmailTemplate("13579","RSVP_CONFIRMATION",eventid);
			}else{
				emailtemplate=new EmailTemplate("100","RSVP_CONFIRMATION");
			}*/
			HashMap<String, String> purposeHm= new HashMap<String,String>();
			purposeHm.put("purpose", "RSVP_CONFIRMATION");
			purposeHm.put("isCustomFeature", "Y");
			String lang=DBHelper.getLanguageFromDB(eventid);
			HashMap<String, String> emailTemplate=new HashMap<String, String>();
			ConfirmationEmailDAO emailDao=new ConfirmationEmailDAO();
			emailTemplate=(HashMap<String, String>)emailDao.getData(purposeHm, lang, eventid).get("emailTemplate");

			EmailObj obj=EventbeeMail.getEmailObj();
			String tomail=(String)hmap.get("emailid");
			obj.setTo(tomail);
			String[] formatmessage=fillData(hmap,eventid,emailTemplate);
			String emailtype=formatmessage[3];
			obj.setBcc(formatmessage[1]+","+EbeeConstantsF.get("ADMIN_EMAIL","sridevi@beeport.com") );
			obj.setFrom(formatmessage[1]);
			obj.setSubject(formatmessage[2]);
			obj.setSendMailStatus(new SendMailStatus("13579","RSVP_CONFIRMATION",eventid,"1"));
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
		return status;

	}
}