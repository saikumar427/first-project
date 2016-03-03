<%@ page import="java.util.*,java.sql.*,java.io.*" %>
<%@ page import="com.eventbee.editprofiles.ProfileValidator"%>
<%@ page import="com.eventbee.useraccount.*"%>
<%@ page import="com.eventbee.general.EbeeConstantsF" %>
<%@ page import="com.eventbee.general.EventbeeLogger"%>
<%@ page import="com.eventbee.nuser.*" %>
<%@ page import="com.eventbee.hub.*" %>
<%@ page import="com.eventbee.classifieds.*"%>
<%!
	final String ROLLERPASSWORD="desihubeventbeebeeport";	
    String FILE_NAME="/portal/webintegration/validatesignup.jsp";     
	public  String encodePassword(String password, String algorithm)
	{
		byte[] unencodedPassword = password.getBytes();
		java.security.MessageDigest md = null;
		try 
			{
		    // first create an instance, given the provider
		    md = java.security.MessageDigest.getInstance(algorithm);
			} 
		catch (Exception e) 
		{
		    return password;
		}
		md.reset();
		// call the update method one or more times
		// (useful when you don't know the size of your data, eg. stream)
		md.update(unencodedPassword);
		// now calculate the hash
		byte[] encodedPassword = md.digest();
		StringBuffer buf = new StringBuffer();
		for (int i = 0; i < encodedPassword.length; i++) 
		{
		    if ((encodedPassword[i] & 0xff) < 0x10) 
		    {
			buf.append("0");
		    }
		    buf.append(Long.toString(encodedPassword[i] & 0xff, 16));
		}
		return buf.toString();
    	}   
void SendEmail(HashMap hm)
	{
    try{
    	    String mailbcc=EbeeConstantsF.get("mail_ebee_bcc","bala@eventbee.org");
    	    EmailTemplate emailtemplate=new EmailTemplate("13579","BEEIDSIGNUP");
			EmailObj obj=EventbeeMail.getEmailObj();
			Map mp=new HashMap();
			mp.put(TemplateConstants.TO_FIRST_NAME,(String)hm.get("firstname"));
			mp.put(TemplateConstants.TO_LAST_NAME,(String)hm.get("lastname"));
			mp.put(TemplateConstants.USERID,(String)hm.get("loginname"));
			mp.put(TemplateConstants.PASSWORD,(String)hm.get("password"));
			//String formatmessage=TemplateConverter.getMessage(mp,TemplateConverter.BeeID_SignUp);
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

 final String CLASS_NAME="/portal/webintegration/validatesignup.jsp";
 public void sendEmailToOwner(String groupid){
	HashMap MessageMap=fillData(groupid);
	EmailTemplate emailtemplate=new EmailTemplate("13579","MEMBER_JOINED_ALERT_TO_MGR");
	//String content=TemplateConverter.getMessage(MessageMap,emailtemplate.getTextFormat());
	String HTMLcontent=TemplateConverter.getMessage(MessageMap,emailtemplate.getHtmlFormat());
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "sendmail(groupid) for New Hub Member Joined ", " enetered the SendMail ", null);
		try{
			EmailObj obj=EventbeeMail.getEmailObj();				 
		 	 String purpose="MEMBER_JOINED_ALERT_TO_MGR";
			 obj.setTo(GenUtil.getHMvalue(MessageMap,"db_own_email"));
			 obj.setFrom(emailtemplate.getFromMail());
			 obj.setReplyTo(emailtemplate.getReplyToMail());
			 obj.setSubject(emailtemplate.getSubjectFormat());
			 //obj.setTextMessage(content);
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
String groupid=request.getParameter("groupid");	
String from=request.getParameter("from");
String attendeekey=(String)session.getAttribute("attendeekey");
String unitid="13579";


HashMap hm=(HashMap)session.getAttribute("USER_SIGN_HASH");
//for privacy settings
String privacy=null;

HashMap prefmap=new HashMap();
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"/portal/webintegration/validatesignup.jsp",null,"USER_SIGN_HASH hashmap value is------"+hm,null);

//System.out.println("hashmap ::::::::"+hm);

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
	try{
	ProfileValidator validator=new ProfileValidator();
	hm=validator.validateAttendeeSignUp(hm);
	}catch(Exception e)
	{
		System.out.println("exception");
		//e.printStackTrace();
	}	
	if(hm.get("generalError")!=null){
		session.setAttribute("USER_SIGN_HASH", hm);
		
		out.println("error");
		
	}  
	else
	{
		

		AccountDB accDB=new AccountDB();
		HashMap seqHm=accDB.getSequenceID(unitid);
		
		if(seqHm!=null){
			hm.put("orgid",(String)seqHm.get("orgid"));
			hm.put("unitid",(String)seqHm.get("unitid"));
			hm.put("roleid",(String)seqHm.get("roleid"));
			hm.put("userid",(String)seqHm.get("userid"));
			hm.put("transactionid",(String)seqHm.get("transactionid"));
		}		
		stob=accDB.insertAttendeeData(hm);
		if (stob.getStatus()){
		//System.out.println("status is::::::::::::::::"+stob.getStatus());
			String themecode=EbeeConstantsF.get("accounts.basic.deftheme","movablemanila");			
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
					if(statobj.getStatus()){}
					else
					{
					EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"/portal/webintegration/validatesignup.jsp","error in inserting the values into the database ","",null);
					}
			//Insert the themes of a signup user:
					
			HashMap signupHubMap=new HashMap();
			String category=(String)hm.get("category");			
			signupHubMap.put("firstname",hm.get("firstname"));
			signupHubMap.put("userid",hm.get("userid"));
			signupHubMap.put("category",category);
			signupHubMap.put("loginname",(String)hm.get("name"));
			String groupid1=hubDB.addSignUpHub(signupHubMap);			
//Partner Signup
%>
			
<%@ include file="signuppartner.jsp" %>
			
<%
//end of Partner Signup

			
//Alerts Starting			
			
if("checkauth".equals(from)){}
else{

	if("low".equals(privacy))
	{

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
		//prefmap.put("alert.eventlisting.state",region);
		prefmap.put("alert.eventlisting.cat",catg);
		//prefmap.put("alert.eventlisting.country",country);

	}
	else {
		
//System.out.println("ggggggggg");
		prefmap.put("forums.alert","Yes");	
		prefmap.put("classifieds.alert","No");
		prefmap.put("alert.eventlisting.pref","No");
		prefmap.put("f2f.alertevent","No");
		prefmap.put("messages.alert","No");
		prefmap.put("network.alertrequests","No");
		prefmap.put("guestbook.alertmessage","No");
		prefmap.put("network.alertfriends","No");	
	}
	PreferencesDB.updatePreferences((String)hm.get("userid"),prefmap,new HashMap());
}


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

		}
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
						//if("Eventbee".equals(EbeeConstantsF.get("application.name","Eventbee"))){
						%>							
						<%--}else if("Desihub".equals(EbeeConstantsF.get("application.name","Eventbee"))){%>	
						<%}--%>
						<%
					}			
			%>
			
			
		<%out.println("success");
		}	

}
		
}

%>












