package com.eventbee.general;

import com.eventbee.mail.DirectEmail;

import java.sql.*;


public class EventbeeMail  {

	public static EmailObj getEmailObj(){
		return new EmailObj();
	}



	public static void insertStrayEmail(EmailObj emailobj,String emailtype){
		insertStrayEmail(emailobj,emailtype,"P");
	}


	public static void insertStrayEmail(EmailObj emailobj,String emailtype,String status){

		SendMailStatus smstat=emailobj.getSendMailStatus();
		if(smstat==null){
			 smstat=new SendMailStatus("0","sent mail status not set while sending email","0","0");
		 }
    		String query="insert into stray_email( unit_id,purpose,ref_id,mail_count,mail_to,mail_from,mail_subject, "
    			+" mail_replyto,text_message,html_message,sch_time,emailtype,mail_cc,mail_bcc,status) "
    			+" values (to_number(?,'99999999999999'),?,?, to_number(?,'99999999999999'),?,?,?,?, ?, ?, to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?,?,?)";
    		String[] params={smstat.getUnitId(),
    						smstat.getPurpose(),
    						smstat.getRefId(),
    						smstat.getMailCount(),
    						emailobj.getTo(),
    						emailobj.getFrom(),
    						emailobj.getSubject(),
    						emailobj.getReplyTo(),
    						emailobj.getTextMessage(),
    						emailobj.getHtmlMessage(),
    						DateUtil.getCurrDBFormatDate(),
    						emailtype,
    						emailobj.getCc(),
    						emailobj.getBcc(),
    						status};
    		DbUtil.executeUpdateQuery(query, params);
	}//end of insert




	public static void processEmailStray(){
		 Connection con=null;
		 java.sql.PreparedStatement pstmt=null;
		 try{
			 con=EventbeeConnection.getConnection();


			 String query="select  unit_id,purpose,ref_id,mail_count,mail_to,mail_from,mail_subject, "
			 +" mail_replyto,text_message,html_message,sch_time,status,emailtype,mail_cc,mail_bcc from stray_email where status='P' ";



			 pstmt=con.prepareStatement(query);
		    EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"EventbeeEmail","in processStrayEmail--pstmt is-------->:"+pstmt,"",null);


			ResultSet rs=pstmt.executeQuery();
			if(rs.next()){
				do{
					EmailObj emailobj=new EmailObj();
					String unitid=rs.getString("unit_id");
					String purpose=rs.getString("purpose");
					String ref_id=rs.getString("ref_id");
					String mail_count=rs.getString("mail_count");
					SendMailStatus smstat=new SendMailStatus(unitid,purpose,ref_id,mail_count);
					emailobj.setSendMailStatus(smstat);
					String mail_to=rs.getString("mail_to");
					emailobj.setTo(mail_to);
					String mail_from=rs.getString("mail_from");
					emailobj.setFrom(mail_from);
					String mail_subject=rs.getString("mail_subject");
					emailobj.setSubject(mail_subject);
					String mail_replyto=rs.getString("mail_replyto");
					emailobj.setReplyTo(mail_replyto);
					String text_message=rs.getString("text_message");
					emailobj.setTextMessage(text_message);
					String html_message=rs.getString("html_message");
					emailobj.setHtmlMessage(html_message);

					String mail_cc=rs.getString("mail_cc");
					emailobj.setCc(mail_cc);
					String mail_bcc=rs.getString("mail_bcc");
					emailobj.setBcc(mail_bcc);

					String emailtype=rs.getString("emailtype");

			        EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"EventbeeEmail","in processStrayEmail--emailtype is-------->:"+emailtype,"",null);


                    EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"EventbeeEmail","in processStrayEmail--before SendHtmlmail-------->:","",null);

					if(emailtype.equalsIgnoreCase("html")){
						//sendHtmlMailPlain(emailobj);
						DirectEmail.sendHtmlMailPlain(emailobj);
					}else{
						//sendTextMailPlain( emailobj);
						DirectEmail.sendTextMailPlain(emailobj);
					}

                    EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"EventbeeEmail","in processStrayEmail--After SendHtmlmail-------->:","",null);

					updateStray( unitid, mail_to);
					EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"EventbeeEmail","in processStrayEmail--After Update Stray(); SendHtmlmail-------->:","",null);


				}while(rs.next());
			}

			 pstmt.close();
			 con.close();
		 }catch(Exception e){
		System.out.println("excep from eventbeemail  insert stray table:="+e.getMessage());

		}
		finally{
			try{
				if (pstmt!=null) pstmt.close();

				if(con!=null) con.close();
			}catch(Exception e){}
		}

	}//get process stray
	public static void updateStray(String unitid,String email){
			String query="update stray_email set  status='S' where mail_to=? and unit_id=?";
			DbUtil.executeUpdateQuery(query, new String[]{email,unitid});
	}//update stray


	public static void sendHtmlMail(EmailObj emailobj){
		insertStrayEmail( emailobj,"html");

	}

	public static void sendTextMail(EmailObj emailobj){
		insertStrayEmail( emailobj,"text");
	}


	public static void sendHtmlMailCampaign(EmailObj emailobj){
		DirectEmail.sendHtmlMailCampaign(emailobj);
	}

/*** plain no db interactions***********/

	public static void sendHtmlMailPlain(EmailObj emailobj){
		DirectEmail.sendHtmlMailPlain(emailobj);	
	}


	public static void sendTextMailPlain(EmailObj emailobj){
		DirectEmail.sendTextMailPlain(emailobj);
	}


/*************/

	public static void sendTextMailCampaign(EmailObj emailobj){
		DirectEmail.sendTextMailCampaign(emailobj);
	}
	

}
