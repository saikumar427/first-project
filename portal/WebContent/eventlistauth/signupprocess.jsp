<%@ page import="com.eventbee.classifieds.*,com.eventbee.general.*"%>

<%!

	final String ROLLERPASSWORD="desihubeventbeebeeport";
	final String CLASS_NAME="/eventlistauth/signupprocess.jsp";
	
	String FILE_NAME="/eventlistauth/signupprocess.jsp";
    // the follwing used as roller password while form submiting:    06f2ea14bb6b113d44611ff33bf337b06a837cb0   and roller dbentry will be 590ea037cbde9658f4b828ddc8b964e4405843fb
    
    
    /** 
    This method is copied from  or.roller.util.Utilities.java 
    *used for password encryprion of passwords of roller
    */
    
public  String encodePassword(String password, String algorithm) {
	byte[] unencodedPassword = password.getBytes();
	java.security.MessageDigest md = null;

	try {
		// first create an instance, given the provider
		md = java.security.MessageDigest.getInstance(algorithm);
	}catch (Exception e) {
		return password;
	}

	md.reset();

	// call the update method one or more times
	// (useful when you don't know the size of your data, eg. stream)
	md.update(unencodedPassword);

	// now calculate the hash
	byte[] encodedPassword = md.digest();

	StringBuffer buf = new StringBuffer();

	for (int i = 0; i < encodedPassword.length; i++){
		if ((encodedPassword[i] & 0xff) < 0x10){
			buf.append("0");
		}
		buf.append(Long.toString(encodedPassword[i] & 0xff, 16));
	}
	return buf.toString();
 }
  
void SendEmail(HashMap hm){
    try{
    	String mailbcc=EbeeConstantsF.get("mail_ebee_bcc","bala@eventbee.org");
    	EmailTemplate emailtemplate=new EmailTemplate("13579","BEEIDSIGNUP");
        EmailObj obj=EventbeeMail.getEmailObj();
        Map mp=new HashMap();
        mp.put(TemplateConstants.TO_FIRST_NAME,(String)hm.get("firstname"));
        mp.put(TemplateConstants.TO_LAST_NAME,(String)hm.get("lastname"));
        mp.put(TemplateConstants.USERID,(String)hm.get("loginname"));
        mp.put(TemplateConstants.PASSWORD,(String)hm.get("password"));
        String formatmessage=TemplateConverter.getMessage(mp,emailtemplate.getTextFormat());
        obj.setTo((String)hm.get("email"));
        obj.setFrom(emailtemplate.getFromMail());
	    //obj.setBcc("bala@beeport.com,newsignup@eventbee.com");
	    obj.setBcc(mailbcc);
        obj.setSubject(TemplateConverter.getMessage(mp,emailtemplate.getSubjectFormat()));
        obj.setTextMessage(formatmessage);
        obj.setSendMailStatus(new SendMailStatus((String)hm.get("unitid"),"BeeID_SignUp",(String)hm.get("userid"),"1"));
        EventbeeMail.sendTextMail(obj);
    }
    catch(Exception e){
       EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"SendMail()","ERROR in SendMail method",e);
    }
       EventbeeLogger.log("com.eventbee.main",EventbeeLogger.INFO,FILE_NAME, "fillData()", "End of SendEmail:",null);
}

public void sendEmailToOwner(String groupid){
	HashMap MessageMap=fillData(groupid);
	EmailTemplate emailtemplate=new EmailTemplate("13579","MEMBER_JOINED_ALERT_TO_MGR");
	String HTMLcontent=TemplateConverter.getMessage(MessageMap,emailtemplate.getHtmlFormat());
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "sendmail(groupid) for New Hub Member Joined ", " enetered the SendMail ", null);
		try{
              		 EmailObj obj=EventbeeMail.getEmailObj();			 
			 
		 	 String purpose="MEMBER_JOINED_ALERT_TO_MGR";
			 obj.setTo(GenUtil.getHMvalue(MessageMap,"db_own_email"));
			 obj.setFrom(emailtemplate.getFromMail());
			 obj.setReplyTo(emailtemplate.getReplyToMail());
			 obj.setSubject(emailtemplate.getSubjectFormat());
			 obj.setHtmlMessage(HTMLcontent);
			 obj.setSendMailStatus(new SendMailStatus("13579",purpose,groupid,"1"));
			 EventbeeMail.sendHtmlMail(obj);
			 
		}catch(Exception e){
			 System.out.println(" There is an error in send mail:"+ e.getMessage());
			 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "sendmail(groupid) for New Hub Member Joined ", " Exception Occured ", new Object[]{e});
		}
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "sendmail(groupid) for New Hub Member Joined ", " ENDED the SendMail ", null);	
 }
public HashMap fillData(String groupid){
  	HashMap messageMap=new HashMap();
	DBManager dbmanager=new DBManager();
	StatusObj stobj=dbmanager.executeSelectQuery("select clubname,email,first_name from user_profile,clubinfo where clubid=? and mgr_id=user_id;",new String[]{groupid});
	if(stobj.getCount()>0){
		messageMap.put("#**TO_FIRST_NAME**#",dbmanager.getValue(0,"first_name",""));
		messageMap.put("#**HUB_NAME**#",dbmanager.getValue(0,"clubname",""));
		messageMap.put("db_own_email",dbmanager.getValue(0,"email",""));
	}
	return messageMap;
}
 %>


<%
com.eventbee.util.RequestSaver rMap=new com.eventbee.util.RequestSaver(pageContext,"USER_SIGN_HASH","session",false);
StatusObj stob=null;
boolean flag=false;

String attendeekey=(String)session.getAttribute("attendeekey");
String unitid="13579";
String groupid=request.getParameter("GROUPID");
HashMap hm=(HashMap)session.getAttribute("USER_SIGN_HASH");

//for privacy settings
String privacy=null;
HashMap prefmap=new HashMap();
//EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"signupprocess.jsp",null,"USER_SIGN_HASH hashmap value is------"+hm,null);



if(hm!=null){		
	privacy=(String)hm.get("privacylevel");
	hm.put("acctstatus","1");
	hm.put("loginname",(String)hm.get("name"));
	hm.put("password",(String)hm.get("profileKey"));
	hm.put("firstname",(String)hm.get("firstname"));
	hm.put("lastname",(String)hm.get("lastname"));
	hm.put("email",(String)hm.get("email"));
	hm.put("phone",(String)hm.get("phone"));
	hm.put("category",(String)hm.get("category"));
	hm.put("scrname",(String)hm.get("name"));

	ProfileValidator validator=new ProfileValidator();
	hm=validator.validateAttendeeSignUp(hm);
	
	if(hm.get("generalError")!=null){
		session.setAttribute("USER_SIGN_HASH", hm);
		
		response.sendRedirect("/portal/guesttasks/checkevtauth.jsp?showerr=y&GROUPID="+groupid);
	}  
	else{
		AccountDB accDB=new AccountDB();
		HashMap seqHm=accDB.getSequenceID(unitid);
		
		if(seqHm!=null){
			hm.put("orgid",(String)seqHm.get("orgid"));
			hm.put("unitid",(String)seqHm.get("unitid"));
			hm.put("roleid",(String)seqHm.get("roleid"));
			hm.put("userid",(String)seqHm.get("userid"));
			hm.put("transactionid",(String)seqHm.get("transactionid"));
		}//if seqHm

		
		stob=accDB.insertAttendeeData(hm);
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"signupprocess.jsp",null,"status of accDB.insertAttendeeData(hm) is------"+stob.getStatus(),null);

		if (stob.getStatus()){
		
			String themecode=EbeeConstantsF.get("accounts.basic.deftheme","movablemanila");
			
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"signupprocess.jsp",null,"themecode is------"+themecode,null);
			StatusObj statobj=new StatusObj(false,"",null);
			String USERTHEMES_QUERY="insert into user_roller_themes (userid,module,themecode) values(?,?,?)";
			DBQueryObj [] dbquery=new DBQueryObj [3];
			dbquery[0]=new DBQueryObj();
			dbquery[0].setQuery(USERTHEMES_QUERY);
			dbquery[0].setQueryInputs(new String[] {(String)hm.get("userid"),"eventspage","basic"});
			dbquery[1]=new DBQueryObj();
			dbquery[1].setQuery(USERTHEMES_QUERY);
			dbquery[1].setQueryInputs(new String[] {(String)hm.get("userid"),"Photos",themecode});
			dbquery[2]=new DBQueryObj();
			dbquery[2].setQuery(USERTHEMES_QUERY);
			dbquery[2].setQueryInputs(new String[] {(String)hm.get("userid"),"Snapshot",themecode});
			statobj=DbUtil.executeUpdateQueries(dbquery);
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"signupprocess.jsp",null,"status of Inserting default themes for signup user: is------"+statobj.getStatus(),null);
			
			String category=(String)hm.get("category");
			HashMap signupHubMap=new HashMap();
			signupHubMap.put("firstname",hm.get("firstname"));
			signupHubMap.put("userid",hm.get("userid"));
			signupHubMap.put("category",category);
			signupHubMap.put("loginname",(String)hm.get("name"));
			
			String groupid1=hubDB.addSignUpHub(signupHubMap);
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"signupprocess.jsp",null,"hub id for this user is------"+groupid1,null);

			if(statobj.getStatus()){

				//************start of roller signup***************
				try {
					String serverport=(80==request.getServerPort())?"":(":"+request.getServerPort()) ;
					EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,request.getServerName()+":Before sending request to roller","sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
					String serverurl=request.getScheme()+"://localhost"+serverport;
					String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
					String fullname=(GenUtil.getHMvalue(hm,"firstname","").trim()+" "+ GenUtil.getHMvalue(hm,"lastname","").trim() ).trim();
					HashMap parammap=new HashMap();
					CoreConnector cc1=new CoreConnector(serverurl+rollercontext+"/portaluser/createportaluser.jsp");
					cc1.setTimeout(30000);
					String eventbeerollerpass=encodePassword(encodePassword(ROLLERPASSWORD, "SHA"),"SHA" );
					parammap=new HashMap();
					parammap.put("portaluser",(String)hm.get("loginname") );
					EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"signupprocess.jsp",null,"loginname is------"+(String)hm.get("loginname"),null);

					parammap.put("fullName",fullname);
					String email=(String)hm.get("email");
					email=("".equals(email) )?"dummy@hh.com":email;
					parammap.put("emailAddress", email );
					EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"signupprocess.jsp",null,"email is------"+email,null);

					parammap.put("locale","en_US");
					parammap.put("timezone","PDT");
					parammap.put("theme", themecode );
					cc1.setArguments(parammap);
					cc1.MPost() ;
					// the follwing used as roller password while form submiting:    06f2ea14bb6b113d44611ff33bf337b06a837cb0   and roller dbentry will be 590ea037cbde9658f4b828ddc8b964e4405843fb
				}catch (Exception ex){
					System.out.println("EXP:"+ex);
					EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.DEBUG,CLASS_NAME,"Blog user creation","Exception while creating blog user",ex);
				}


			}//************end of roller signup***************
//Partner Signup
%>
			
<%@ include file="/signup/signuppartner.jsp" %>
			
<%
//end of Partner Signup

//Alerts Starting			
			
			
	if("low".equals(privacy)){
	
		String ebeecategory[]=EventbeeStrings.getCategoryNames();
		String catg=GenUtil.stringArrayToStr(ebeecategory,",");
		HashMap typesmap=ClassifiedDB.getClassifiedTypes(new String[]{"13579","classified"});
		String types[]=(String [])typesmap.get("codes");
		String type=GenUtil.stringArrayToStr(types,",");

		prefmap.put("classifieds.alert","Yes");
		prefmap.put("alert.classifieds.type",type);
		prefmap.put("alert.eventlisting.pref","Yes");
		prefmap.put("f2f.alertevent","Yes");
		prefmap.put("messages.alert","Yes");
		prefmap.put("network.alertrequests","Yes");
		prefmap.put("guestbook.alertmessage","Yes");
		prefmap.put("forums.alert","Yes");		
		prefmap.put("network.alertfriends","Yes");
		prefmap.put("alert.eventlisting.cat",catg);
	}
	else {
		prefmap.put("forums.alert","No");	
		prefmap.put("classifieds.alert","No");
		prefmap.put("alert.eventlisting.pref","No");
		prefmap.put("f2f.alertevent","No");
		prefmap.put("messages.alert","No");
		prefmap.put("network.alertrequests","No");
		prefmap.put("guestbook.alertmessage","No");
		prefmap.put("network.alertfriends","No");	
	}
	PreferencesDB.updatePreferences((String)hm.get("userid"),prefmap,new HashMap());

//Alerts ending

			flag=true;
			AuthDB adb=new AuthDB();
			Authenticate au=adb.authenticateMember((String)hm.get("loginname"),(String)hm.get("password"),"13579");
			session.setAttribute("authData",au);
			AuthInfo auth=new AuthInfo();
			auth.setUserName((String)hm.get("loginname"));
			auth.setSignUpPwd((String)hm.get("password"));
			session.setAttribute("signupAuth",auth);
			session.setAttribute("loginAfterSignUp","Y");
			SendEmail(hm);

			HashMap hmnew=new HashMap(hm);
			hmnew.remove("password");
			hmnew.remove("profileKey");
			hmnew.remove("retypeProfileKey");
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "New user details are"+hmnew, "", null);			

			

		}//if  stob.getStatus()
		session.setAttribute("USER_SIGN_HASH", null);
		String link="",message="",continuelink="";
		if(flag){
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"Signup successful","sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
			message=EbeeConstantsF.get("attendee.signup.done","Thank you for signing up.");
			
			link=EbeeConstantsF.get("link.enterhome.page","Go to My Home");
			continuelink=EbeeConstantsF.get("link.taskcontinue.page","Continue");
			%>
			<tr><td class="inform" align="center"><table width="100%" align="center"><tr>
			<%
			session.removeAttribute("USER_SIGN_HASH");
			String BACK_PAGE=(String)session.getAttribute("BACK_PAGE");
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"Signup successful","BACK_PAGE value is--===============--------"+BACK_PAGE,null);
			if(("".equals(BACK_PAGE))||(BACK_PAGE==null)) {
				%>
					<jsp:forward page='/createnew' />

				<%
			}else{
				response.sendRedirect("/portal/networking/redirectnetwork.jsp");
				return;
			}

		}else{
			message=EbeeConstantsF.get("attendee.signup.failure","Sorry, this request cannot be processed at this time.");
			link=EbeeConstantsF.get("link.contexthome.page","Back to My home Page");
			%>
			<tr><td class="inform" align="center"><%=message%></td></tr>

			<%
			}

		}//else
}//if
else{
%>
<tr><td>Session expired</td></tr>
<%
}
%>
</table>
<%@ include file="/stylesheets/bottomlnf.jsp" %>









