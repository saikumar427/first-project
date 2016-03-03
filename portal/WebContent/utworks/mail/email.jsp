<%@ page import="com.eventbee.general.*,org.json.*,java.util.*,javax.naming.*,javax.activation.*,java.util.*,javax.mail.*,javax.mail.event.*,javax.mail.internet.*,java.sql.*"%>
<%!
public void sendEmail(HashMap hm){
    try{
        EmailObj obj=getEmailObj();
        obj.setTo((String)hm.get("to"));
	obj.setFrom((String)hm.get("from"));
	obj.setBcc("jayachand4u@gmail.com");
	String subject = (String)hm.get("subject");
	obj.setSubject(MimeUtility.encodeText(subject,"ISO-8859-1","Q"));
	String text = (String)hm.get("message");
	obj.setTextMessage(MimeUtility.encodeText(text,"ISO-8859-1","Q"));
        obj.setSendMailStatus(new SendMailStatus("511","BeeID_SignUp","511","1"));
        sendTextMail(obj);
        processEmailStray();
    }
    catch(Exception e){
       System.out.println("Exception :***"+e);
    }
       System.out.println("sent mail");
}

        public static EmailObj getEmailObj(){
		return new EmailObj();
	}   

	public static void insertStrayEmail(EmailObj emailobj,String emailtype){
		
		 Connection con=null;
		 java.sql.PreparedStatement pstmt=null;
		 SendMailStatus smstat=emailobj.getSendMailStatus();
		 if(smstat==null){
			 smstat=new SendMailStatus("0","sent mail status not set while sending email","0","0");
		 }
		 try{
			 con=EventbeeConnection.getConnection();
			 String query="insert into stray_email( unit_id,purpose,ref_id,mail_count,mail_to,mail_from,mail_subject, "
			 +" mail_replyto,text_message,html_message,sch_time,status,emailtype,mail_cc,mail_bcc) "
			 +" values (?,?,?, ?,?,?,?,?, ?, ?, now(), 'P',?,?,?)";
			 pstmt=con.prepareStatement(query);
			 pstmt.setString(1,smstat.getUnitId());
			  pstmt.setString(2,smstat.getPurpose());
			   pstmt.setString(3,smstat.getRefId());
			    pstmt.setString(4,smstat.getMailCount());
			    pstmt.setString(5,emailobj.getTo());
			     pstmt.setString(6,emailobj.getFrom());
			      pstmt.setString(7,emailobj.getSubject());
			   pstmt.setString(8,emailobj.getReplyTo());
			    pstmt.setString(9,emailobj.getTextMessage());
			     pstmt.setString(10,emailobj.getHtmlMessage());
			     pstmt.setString(11,emailtype);
			  pstmt.setString(12,emailobj.getCc());
			  pstmt.setString(13,emailobj.getBcc());
			int rs=pstmt.executeUpdate();
			 	
			
			 pstmt.close();
			 con.close();
		 }catch(Exception e){
		System.out.println("excep from club db insert stray table:="+e.getMessage());
		}
		finally{
			try{
				if (pstmt!=null) pstmt.close();
				
				if(con!=null) con.close();
			}catch(Exception e){}
		}	
	}//end of insert
	
	public static void processEmailStray(){
		 Connection con=null;
		 java.sql.PreparedStatement pstmt=null;
		 
		 try{
			 con=EventbeeConnection.getConnection();
			 
			 String query="select  unit_id,purpose,ref_id,mail_count,mail_to,mail_from,mail_subject, "
			 +" mail_replyto,text_message,html_message,sch_time,status,emailtype,mail_cc,mail_bcc from stray_email where status='P' and ref_id=511";
			 

			 
			 pstmt=con.prepareStatement(query);
			
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
					if(emailtype.equalsIgnoreCase("html")){
						//sendHtmlMailCampaign( emailobj);
						sendHtmlMailPlain(emailobj);
					}else{
						//sendTextMailCampaign( emailobj);
						sendTextMailPlain( emailobj);
					}


					updateStray( unitid, mail_to);
					
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
		Connection con=null;
		 java.sql.PreparedStatement pstmt=null;
		 
		 try{
			 con=EventbeeConnection.getConnection();
			String query="update stray_email set  status='S' where mail_to=? and unit_id=?";
			 

			 
			 pstmt=con.prepareStatement(query);
			 pstmt.setString(1,email);
			  pstmt.setString(2,unitid);
			
			int rs=pstmt.executeUpdate();
			
			
			 pstmt.close();
			 con.close();
		 }catch(Exception e){
		System.out.println("excep from eventbeemail updateStray() insert stray table:="+e.getMessage());
		}
		finally{
			try{
				if (pstmt!=null) pstmt.close();
				
				if(con!=null) con.close();
			}catch(Exception e){}
		}
	}//update stray


	public static void sendHtmlMail(EmailObj emailobj){
		insertStrayEmail( emailobj,"html");

	}

	public static void sendTextMail(EmailObj emailobj){
		insertStrayEmail( emailobj,"text");
	}


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
				System.out.println("Exception from EventbeeMail.java: html message ="+ex.getMessage());
			}
			
	}

/*** plain no db interactions***********/

	public static void sendHtmlMailPlain(EmailObj emailobj){
		
			try{
			
			
			javax.mail.Session   mailSession=(javax.mail.Session) new InitialContext().lookup( "java:/Mail" );
			javax.mail.Message  msg=null;
			
			Properties prop=mailSession.getProperties() ;
			
			
		
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
			
			
			
			 Transport.send( msg );
			 SendMailStatus smstat=emailobj.getSendMailStatus();
			 if(smstat != null)smstat.insertStatus();

			}//end of msg null
			}catch(Exception ex){
				System.out.println("Exception from EventbeeMail.java: sendHtmlMailPlain() message ="+ex.getMessage());
			}
		
	}

	public static void sendTextMailPlain(EmailObj emailobj){
		try{			
			//javax.mail.Message  msg = getMimeMessage();
			javax.mail.Session   mailSession=(javax.mail.Session) new InitialContext().lookup( "java:/Mail" );
			javax.mail.Message  msg=null;
			
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
			
			//msg.setHeader( "Event-Mailer", "eventbeeMailer" );
			
			
			 Transport.send( msg );
			  SendMailStatus smstat=emailobj.getSendMailStatus();
			 if(smstat != null)smstat.insertStatus();
			}//end of msg null
			}catch(Exception ex){
				System.out.println("Exception from SendTextMailPlain():="+ex.getMessage());
			}
	}//end of text mail plain
	
	private static void setOtherRecepients(javax.mail.Message  msg,EmailObj emailobj   ){
		if(msg!=null && emailobj !=null){

			try{
				if(emailobj.getCc() !=null && !"".equals(emailobj.getCc().trim() ) ){
				InternetAddress[]inarrcc= InternetAddress.parse(emailobj.getCc() , false );
				msg.setRecipients( javax.mail.Message.RecipientType.CC, inarrcc );
				}

			}catch(Exception ade){
			}

			try{
				if(emailobj.getBcc() !=null && !"".equals(emailobj.getBcc().trim() ) ){
				InternetAddress[]inarrbcc= InternetAddress.parse(emailobj.getBcc() , false );
				msg.setRecipients( javax.mail.Message.RecipientType.BCC, inarrbcc );
				}

			}catch(Exception ade){
			}


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
				System.out.println("Exception from EventbeeMail.java:="+ex.getMessage());
			}
			
	}//end of text mail


	private static javax.mail.Message getMimeMessage() {
		javax.mail.Message  msg=null;
		try{
			/*Properties prop = new Properties();
			prop.put("mail.smtp.host","202.88.191.70");
			prop.put("mail.from","bounce-list-narayan=eventbee.com@eventbee.com");
			prop.put("mail.smtp.from", "bounce-list-narayan=eventbee.com@eventbee.com");
		//javax.mail.Session   mailSession=(javax.mail.Session) new InitialContext().lookup( "java:/Mail" );
		javax.mail.Session   mailSession=javax.mail.Session.getInstance(prop, null);
		 msg = new MimeMessage( mailSession );*/
		}catch(Exception ex){
			System.out.println("EventbeeMail.java lookup(java:/Mail) failed:="+ex.getMessage());
		}
		return msg;		
	}//end of MimeMessage
%>
<%
JSONObject jsonobj = new JSONObject();
jsonobj.put("status","success");
String to=request.getParameter("to");
String from=request.getParameter("from");
String subject=request.getParameter("subject");
String message=request.getParameter("msg");
System.out.println(message);
HashMap emailHMap = new HashMap();
emailHMap.put("to",to);
emailHMap.put("from",from);
emailHMap.put("subject",subject);
emailHMap.put("message",message);
sendEmail(emailHMap);
out.println(jsonobj);
%>