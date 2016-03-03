package com.eventbee.layout;
import com.eventbee.general.DbUtil;
public class EventDBHelper {
	
	public static void insertOrganizerEmail(String purpose, String refId,String fromName,String mailFrom,String subject,String message){
		System.out.println("In insertOrganizerEmail");
		String mailTo=DbUtil.getVal("select email from eventinfo where eventid=CAST(? AS INTEGER)",new String[]{refId});
		String query="insert into organizer_email(purpose,refid,mail_to,mail_from,subject, "
			+" name,message) values (?,?,?,?,?,?,?)";
		String[] params={purpose, refId, mailTo, mailFrom, subject, fromName, message};
		DbUtil.executeUpdateQuery(query, params);
	}

}
