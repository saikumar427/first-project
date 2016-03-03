package com.eventbee.mail;

import java.util.Properties;

import javax.mail.Address;
import javax.mail.Authenticator;
import javax.mail.Multipart;
import javax.mail.PasswordAuthentication;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;
import javax.naming.InitialContext;

import com.eventbee.general.EbeeConstantsF;
import com.eventbee.general.EmailObj;
import com.eventbee.general.EventbeeConnection;
import com.eventbee.general.EventbeeLogger;
import com.eventbee.general.SendMailStatus;

public class DirectEmail {
	
	public static void sendHtmlMailPlain(EmailObj emailobj){

		try{
				
			javax.mail.Session mailSession = getMailSession();
			MimeMessage msg = new MimeMessage( mailSession );
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"EventbeeMail.java","in sendHtmlMailPlain mail session is-------->:"+msg,"",null);
			if(msg!=null){
				msg.setFrom( new InternetAddress( emailobj.getFrom() ) );
				InternetAddress[]inarr= InternetAddress.parse(emailobj.getTo() , false );
				EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"EventbeeMail.java","in sendHtmlMailPlain after creating internetaddress object-------->:","",null);

				msg.setRecipients( javax.mail.Message.RecipientType.TO, inarr );
				setOtherRecepients(msg,emailobj);// cc and bcc
				msg.setSubject( emailobj.getSubject() ,"iso-8859-1");
				EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"EventbeeMail.java","in sendHtmlMailPlain after setting email object to mail session-------->:","",null);
				MimeBodyPart textpart=new MimeBodyPart();
				textpart.setText(emailobj.getTextMessage(),"iso-8859-1");
				textpart.addHeaderLine("Content-Type: text/plain; charset=\"iso-8859-1\"");
				textpart.addHeaderLine("Content-Transfer-Encoding: quoted-printable");

				MimeBodyPart htmlpart=new MimeBodyPart();
				htmlpart.setText(emailobj.getHtmlMessage(),"iso-8859-1");
				htmlpart.addHeaderLine("Content-Type: text/html; charset=\"iso-8859-1\"");
				htmlpart.addHeaderLine("Content-Transfer-Encoding: quoted-printable");
				EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"EventbeeMail.java","in sendHtmlMailPlain after setting email object to MimeBodyPart object-------->:","",null);
				Multipart mp2=new MimeMultipart("alternative");
				mp2.addBodyPart(textpart);
				mp2.addBodyPart(htmlpart);
				EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"EventbeeMail.java","in sendHtmlMailPlain after setting MimeBodyPart object to Multipart object-------->:","",null);
				msg.setContent(mp2);
				EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"EventbeeMail.java","in sendHtmlMailPlain after setting Multipart object to mailsession object-------->:","",null);
				String replyTo=emailobj.getReplyTo();
				if(replyTo==null)replyTo=emailobj.getFrom();
				msg.setReplyTo(new Address[]{new InternetAddress( replyTo ) });
				EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"EventbeeMail.java","in sendHtmlMailPlain after setting mailto object to mailsession object-------->:","",null);
				msg.setSentDate( new java.util.Date() );
				EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"EventbeeMail.java","in sendHtmlMailPlain Before Transaport.send-------->:","",null);
				Transport.send( msg );
				EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"EventbeeMail.java","in sendHtmlMailPlain After Transaport.send-------->:","",null);
				SendMailStatus smstat=emailobj.getSendMailStatus();
				//if(smstat != null)smstat.insertStatus();
			}//end of msg null
		}catch(Exception ex){
			System.out.println("Exception from DirectEmail.java: sendHtmlMailPlain() message ="+ex.getMessage());
		}
	}
	
	public static void sendTextMailPlain(EmailObj emailobj){
		try{
			
			javax.mail.Session mailSession = getMailSession();
			MimeMessage msg = new MimeMessage( mailSession );
			if(msg!=null){
				msg.setFrom( new InternetAddress( emailobj.getFrom() ) );
				InternetAddress[]inarr= InternetAddress.parse(emailobj.getTo() , false );
				msg.setRecipients( javax.mail.Message.RecipientType.TO, inarr );
				setOtherRecepients(msg,emailobj);// cc and bcc
				msg.setSubject( emailobj.getSubject(),"iso-8859-1" );
	
				msg.setText(emailobj.getTextMessage(),"iso-8859-1");
				String replyTo=emailobj.getReplyTo();
				if(replyTo==null)replyTo=emailobj.getFrom();
				msg.setReplyTo(new Address[]{new InternetAddress( replyTo ) });
				msg.setSentDate( new java.util.Date() );
				//msg.setHeader( "Event-Mailer", "eventbeeMailer" );
				Transport.send( msg );
				SendMailStatus smstat=emailobj.getSendMailStatus();
				if(smstat != null)smstat.insertStatus();
			}//end of msg null
		}catch(Exception ex){
			System.out.println("Exception from DirectEmail.java SendTextMailPlain():="+ex.getMessage());
		}
	}//end of text mail plain

	public static void sendHtmlMailCampaign(EmailObj emailobj){

		try{

			javax.mail.Session   mailSession=(javax.mail.Session) new InitialContext().lookup( "java:/Mail" );
			javax.mail.Message  msg=null;
	
			Properties prop=mailSession.getProperties() ;
	
			String emailto=emailobj.getCampId()+"-"+emailobj.getMemId();
			emailto="return-list-"+emailto+"@"+EbeeConstantsF.get("emailserver.name" ,"eventbee.com");
			prop.put("mail.smtp.from", emailto);
	
			msg = new MimeMessage( mailSession );
	
			if(msg!=null){
				msg.setFrom( new InternetAddress( emailobj.getFrom() ) );
				InternetAddress[]inarr= InternetAddress.parse(emailobj.getTo() , false );
				msg.setRecipients( javax.mail.Message.RecipientType.TO, inarr );
				setOtherRecepients(msg,emailobj);// cc and bcc
		
				msg.setSubject( emailobj.getSubject() );
		
		
				MimeBodyPart textpart=new MimeBodyPart();
		
				textpart.setText(emailobj.getTextMessage());
				textpart.addHeaderLine("Content-Type: text/plain; charset=\"iso-8859-1\"");
				textpart.addHeaderLine("Content-Transfer-Encoding: quoted-printable");
		
				MimeBodyPart htmlpart=new MimeBodyPart();
				htmlpart.setText(emailobj.getHtmlMessage());
				htmlpart.addHeaderLine("Content-Type: text/html; charset=\"iso-8859-1\"");
				htmlpart.addHeaderLine("Content-Transfer-Encoding: quoted-printable");
		
				Multipart mp2=new MimeMultipart("alternative");
				mp2.addBodyPart(textpart);
				mp2.addBodyPart(htmlpart);
				msg.setContent(mp2);
				String replyTo=emailobj.getReplyTo();
				if(replyTo==null)replyTo=emailobj.getFrom();
				msg.setReplyTo(new Address[]{new InternetAddress( replyTo ) });
				msg.setSentDate( new java.util.Date() );
				//msg.setHeader( "Event-Mailer", "eventbeeMailer" );
		
				Transport.send( msg );
				SendMailStatus smstat=emailobj.getSendMailStatus();
				if(smstat != null)smstat.insertStatus();
	
			}//end of msg null
				prop.put("mail.smtp.from", "");
		}catch(Exception ex){

			System.out.println("Exception from DirectEmail.java: html message ="+ex.getMessage());
		}
	}
	
	
	public static void sendTextMailCampaign(EmailObj emailobj){
		try{
			javax.mail.Session   mailSession=(javax.mail.Session) new InitialContext().lookup( "java:/Mail" );
			javax.mail.Message  msg=null;

			Properties prop=mailSession.getProperties() ;

			String emailto=emailobj.getCampId()+"-"+emailobj.getMemId();

			emailto="return-list-"+emailto+"@"+EbeeConstantsF.get("emailserver.name" ,"eventbee.com");
			prop.put("mail.smtp.from", emailto);

			msg = new MimeMessage( mailSession );

			if(msg!=null){
				msg.setFrom( new InternetAddress( emailobj.getFrom() ) );
				InternetAddress[]inarr= InternetAddress.parse(emailobj.getTo() , false );
				msg.setRecipients( javax.mail.Message.RecipientType.TO, inarr );
				setOtherRecepients(msg,emailobj);// cc and bcc
				msg.setSubject( emailobj.getSubject() );
	
				msg.setText(emailobj.getTextMessage());
				String replyTo=emailobj.getReplyTo();
				if(replyTo==null)replyTo=emailobj.getFrom();
				msg.setReplyTo(new Address[]{new InternetAddress( replyTo ) });
				msg.setSentDate( new java.util.Date() );
	
				//msg.setHeader( "Return-Path", "bounce-list-narayan=eventbee.com@eventbee.com" );
				//Return-Path
				Transport.send( msg );
	
				SendMailStatus smstat=emailobj.getSendMailStatus();
				if(smstat != null)smstat.insertStatus();
			}//end of msg null
			prop.put("mail.smtp.from", "");
		}catch(Exception ex){
			System.out.println("Exception from DirectEmail.java sendTextMailCampaign:="+ex.getMessage());
		}

	}//end of text mail


	private static void setOtherRecepients(javax.mail.Message  msg,EmailObj emailobj   ){
		if(msg!=null && emailobj !=null){
			try{
				if(emailobj.getCc() !=null && !"".equals(emailobj.getCc().trim() ) ){
					InternetAddress[]inarrcc= InternetAddress.parse(emailobj.getCc() , false );
					msg.setRecipients( javax.mail.Message.RecipientType.CC, inarrcc );
				}

			}catch(Exception ade){}
			try{
				if(emailobj.getBcc() !=null && !"".equals(emailobj.getBcc().trim() ) ){
					InternetAddress[]inarrbcc= InternetAddress.parse(emailobj.getBcc() , false );
					msg.setRecipients( javax.mail.Message.RecipientType.BCC, inarrbcc );
				}
				}catch(Exception ade){}
			}
		}
	
	private static javax.mail.Session getMailSession(){
		javax.mail.Session  mailSession=null;
		try{
			java.sql.Connection con=null;
			java.sql.PreparedStatement pstmt=null;
			java.sql.ResultSet rs=null;
			con=EventbeeConnection.getConnection();
			String query="select mail_host from admin_scheduler_mailserver where mail_type='DirectMail'";
			pstmt=con.prepareStatement(query);
			rs=pstmt.executeQuery();
			String smtpsource="";
			while(rs.next()){
				smtpsource = rs.getString("mail_host");
			}	
			System.out.println("\n mail sending using smtphost: "+smtpsource);
			rs.close();
			pstmt.close();
			con.close();
			
			Properties props=null;
			if("smail".equals(smtpsource)){
				props = new Properties();
				props.put("mail.transport.protocol", "smtp");
				props.put("mail.smtp.host", "smail.eventbee.com");
				props.put("mail.smtp.auth", "false");
				mailSession = Session.getInstance(props);
			}else{	
				props = new Properties();
				props.put("mail.transport.protocol", "smtp");
				props.put("mail.smtp.host", "smtp.sendgrid.net");
				props.put("mail.smtp.auth", "true");
				String uid = EbeeConstantsF.get("sendgrid.uid" ,"musrifbala@gmail.com");
				String pwd = EbeeConstantsF.get("sendgrid.pwd" ,"eventbee2112");
				Authenticator auth = new SMTPAuthenticator(uid,pwd);
				mailSession = Session.getInstance(props, auth);	
			}
			
		}catch(Exception e){
			System.out.println("Exception from DirectEmail.java getMailSession: "+e.getMessage());
		}
		return mailSession;
	}

}

class SMTPAuthenticator extends javax.mail.Authenticator {
	private String uid="";
	private String password="";
	public SMTPAuthenticator(String uid, String pwd){
		this.uid=uid;
		this.password=pwd;
	}
	public PasswordAuthentication getPasswordAuthentication() {
   		return new PasswordAuthentication(uid, password);
	}
}
