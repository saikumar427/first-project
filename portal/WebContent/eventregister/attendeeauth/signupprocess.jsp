<%@ page import="com.eventbee.classifieds.*,com.eventbee.general.*"%>
<%@ page import="com.eventbee.event.*"%>

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
HashMap userhm=(HashMap)session.getAttribute("USER_SIGN_HASH");

//for privacy settings
String privacy=null;
HashMap prefmap=new HashMap();
HashMap hm=new HashMap();

if(userhm!=null){	
	
	privacy=(String)hm.get("privacylevel");
	ProfileValidator validator=new ProfileValidator();
	hm=validator.validateUserName("",(String)userhm.get("name"),"Bee ID already exist","loginnameExist",hm,"signup","Bee ID","13579");
	hm=validator.validateEquals((String)userhm.get("profileKey"),(String)userhm.get("retypeProfileKey"),"Passwords should match","pwdMatch",hm);
	hm=validator.validateString((String)userhm.get("name"),"Bee ID","loginLength",40,1,hm);
	hm=validator.validateString((String)userhm.get("profileKey"),"Password","pwdLength",40,1,hm);
	hm=validator.validateString((String)userhm.get("firstname"),"FirstName","fnameLength",40,1,hm);
	hm=validator.validateString((String)userhm.get("lastname"),"LastName","lnameLength",40,1,hm);
	hm=validator.validateString((String)userhm.get("email"),"Email","emailerror",40,1,hm);
	hm=validator.validateString((String)userhm.get("gender"),"Gender","gendererror",40,1,hm);
	hm=validator.validateString((String)userhm.get("phone"),"Phone","phoneerror",40,1,hm);
	hm=validator.validateString((String)userhm.get("category"),"Category","categoryerror",40,1,hm);
	 if((String)userhm.get("name")!=null&& !"".equals( ((String)userhm.get("name")).trim() )){
		if(!validator.checkNameValidity((String)userhm.get("name"),true) ){
			hm.put("invalid_id","Invalid Bee ID. Use alphanumeric characters only");
		}
  	}
  	if(hm!=null&&hm.size()>0){
	
	       	StringBuffer sb=new StringBuffer();
	       	if(!"".equals(GenUtil.getHMvalue(hm,"loginnameExist",""))){
			sb.append(GenUtil.getHMvalue(hm,"loginnameExist",""));
		}
		if(!"".equals(GenUtil.getHMvalue(hm,"pwdMatch",""))){
			sb.append("<br/>");
			sb.append(GenUtil.getHMvalue(hm,"pwdMatch",""));
		}
		if(!"".equals(GenUtil.getHMvalue(hm,"loginLength",""))){
			sb.append("<br/>");
			sb.append(GenUtil.getHMvalue(hm,"loginLength",""));
		}
		if(!"".equals(GenUtil.getHMvalue(hm,"pwdLength",""))){
			sb.append("<br/>");
			sb.append(GenUtil.getHMvalue(hm,"pwdLength",""));
		}
		if(!"".equals(GenUtil.getHMvalue(hm,"invalid_id",""))){
			sb.append("<br/>");
			sb.append(GenUtil.getHMvalue(hm,"invalid_id",""));
		}
		if(!"".equals(GenUtil.getHMvalue(hm,"fnameLength",""))){
			sb.append("<br/>");
			sb.append(GenUtil.getHMvalue(hm,"fnameLength",""));
		}
		if(!"".equals(GenUtil.getHMvalue(hm,"lnameLength",""))){
			sb.append("<br/>");
			sb.append(GenUtil.getHMvalue(hm,"lnameLength",""));
		}
		if(!"".equals(GenUtil.getHMvalue(hm,"emailerror",""))){
			sb.append("<br/>");
			sb.append(GenUtil.getHMvalue(hm,"emailerror",""));
		}
		if(!"".equals(GenUtil.getHMvalue(hm,"gendererror",""))){
			sb.append("<br/>");
			sb.append(GenUtil.getHMvalue(hm,"gendererror",""));
		}
		
		if(!"".equals(GenUtil.getHMvalue(hm,"phoneerror",""))){
			sb.append("<br/>");
			sb.append(GenUtil.getHMvalue(hm,"phoneerror",""));
		}
		if(!"".equals(GenUtil.getHMvalue(hm,"categoryerror",""))){
			sb.append("<br/>");
			sb.append(GenUtil.getHMvalue(hm,"categoryerror",""));
		}
		out.println(sb.toString());
	}

	else{
		AccountDB accDB=new AccountDB();
		HashMap seqHm=accDB.getSequenceID(unitid);
		hm.put("acctstatus","1");
		hm.put("loginname",(String)userhm.get("name"));
		hm.put("scrname",(String)userhm.get("name"));
		hm.put("password",(String)userhm.get("profileKey"));
		hm.put("firstname",(String)userhm.get("firstname"));
		hm.put("lastname",(String)userhm.get("lastname"));
		hm.put("email",(String)userhm.get("email"));
		hm.put("gender",(String)userhm.get("gender"));
		hm.put("phone",(String)userhm.get("phone"));
		hm.put("shareprofile",request.getParameter("shareprofile"));
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
			String USERTHEMES_QUERY="insert into user_roller_themes (userid,module,themecode,cssurl) values(?,?,?,?)";
			String name=(String)hm.get("loginname");
			String ethemecode=null;
			String pthemecode=null;
			String nthemecode=null;
			String hthemecode=null;

			if(name.toLowerCase().startsWith("a")){
				ethemecode="baby-one";
				pthemecode="starry-one";
				nthemecode="surfaces-one";
				hthemecode="x-mas_winter-one";
			}else if(name.toLowerCase().startsWith("b")){
				ethemecode="birthday-one";
				pthemecode="embossed-one";
				nthemecode="ice-one";
				hthemecode="lines-one";
			}else if(name.toLowerCase().startsWith("c")){
				ethemecode="music-one";
				pthemecode="nature-one";
				nthemecode="rainbow-one";
				hthemecode="sports-baseball";
			}else if(name.toLowerCase().startsWith("d")){
				ethemecode="starry-two";
				pthemecode="water-world-two";
				nthemecode="wood-two";
				hthemecode="x-mas_winter-two";
		       }else if(name.toLowerCase().startsWith("e")){
				ethemecode="baby-two";
				pthemecode="birthday-two";
				nthemecode="bricks-two";
				hthemecode="clouds-two";
			}else if(name.toLowerCase().startsWith("f")){
				ethemecode="embossed-two";
				pthemecode="holloween-two";
				nthemecode="ice-two";
				hthemecode="lines-two";
			}else if(name.toLowerCase().startsWith("g")){
				ethemecode="music-two";
				pthemecode="nature-two";
				nthemecode="rainbow-two";
				hthemecode="space-two";
			}else if(name.toLowerCase().startsWith("h")){
				ethemecode="sports-archory";
				pthemecode="starry-three";
				nthemecode="surfaces-two";
				hthemecode="water-world-three";
			}else if(name.toLowerCase().startsWith("i")){
				ethemecode="wood-three";
				pthemecode="x-mas_winter-three";
				nthemecode="baby-three";
				hthemecode="birthday-three";
			}else if(name.toLowerCase().startsWith("j")){
				ethemecode="bricks-three";
				pthemecode="clouds-three";
				nthemecode="embossed-three";
				hthemecode="holloween-three";
			}else if(name.toLowerCase().startsWith("k")){
				ethemecode="ice-three";
				pthemecode="lines-three";
				nthemecode="music-three";
				hthemecode="nature-three";
			}else if(name.toLowerCase().startsWith("l")){
				ethemecode="rainbow-three";
				pthemecode="space-three";
				nthemecode="sports-asianbowling";
				hthemecode="starry-four";
			}else if(name.toLowerCase().startsWith("m")){
				ethemecode="surfaces-three";
				pthemecode="water-world-four";
				nthemecode="wood-three";
				hthemecode="x-mas_winter-four";
			}else if(name.toLowerCase().startsWith("n")){
				ethemecode="baby-four";
				pthemecode="birthday-four";
				nthemecode="bricks-four";
				hthemecode="clouds-one";
			}else if(name.toLowerCase().startsWith("o")){
				ethemecode="embossed-four";
				pthemecode="holloween-four";
				nthemecode="ice-four";
				hthemecode="lines-four";
			}else if(name.toLowerCase().startsWith("p")){
				ethemecode="music-four";
				pthemecode="nature-four";
				nthemecode="rainbow-four";
				hthemecode="space-four";
			}else if(name.toLowerCase().startsWith("q")){
				ethemecode="sports- Basketball";
				pthemecode="starry-four";
				nthemecode="surfaces-four";
				hthemecode="water-world-five";
                        }else if(name.toLowerCase().startsWith("r")){
				ethemecode="wood-four";
				pthemecode="x-mas_winter-five";
				nthemecode="baby-five";
				hthemecode="birthday-five";
		        }else if(name.toLowerCase().startsWith("s")){
				ethemecode="bricks-five";
				pthemecode="clouds-five";
				nthemecode="lines-five";
				hthemecode="ice-five";
    		        }else if(name.toLowerCase().startsWith("t")){
				ethemecode="embossed-five";
				pthemecode="music-five";
				nthemecode="space-five";
				hthemecode="sports-cycling";
		        }else if(name.toLowerCase().startsWith("u")){
				ethemecode="starry-five"; 
				pthemecode="surfaces-five";
				nthemecode="water-world-five";
				hthemecode="x-mas_winter-five";
			}else if(name.toLowerCase().startsWith("v")){
				ethemecode="baby-six"; 
				pthemecode="birthday-six";
				nthemecode="bricks-five";
				hthemecode="clouds-six";
 			}else if(name.toLowerCase().startsWith("w")){
				ethemecode="embossed-six"; 
				pthemecode="ice-six";
				nthemecode="lines-six";
				hthemecode="music-six";
			}else if(name.toLowerCase().startsWith("x")){
				ethemecode="space-six"; 
				pthemecode="sports-horseride";
				nthemecode="starry-six";
				hthemecode="surfaces-five";
			}else if(name.toLowerCase().startsWith("y")){
				ethemecode="x-mas_winter-six"; 
				pthemecode="baby-seven";
				nthemecode="birthday-seven";
				hthemecode="bricks-seven";
			}else if(name.toLowerCase().startsWith("z")){
				ethemecode="clouds-seven"; 
				pthemecode="embossed-seven";
				nthemecode="line-seven";
				hthemecode="music-seven";
			}else{
				ethemecode="clouds-eight"; 
				pthemecode="embossed-eight";
				nthemecode="lines-eight";
				hthemecode="x-mas_winter-seven";

			}
			
			DBQueryObj [] dbquery=new DBQueryObj [3];
			dbquery[0]=new DBQueryObj();
			dbquery[0].setQuery(USERTHEMES_QUERY);
			dbquery[0].setQueryInputs(new String[] {(String)hm.get("userid"),"eventspage",ethemecode,ethemecode+".css"});
			dbquery[1]=new DBQueryObj();
			dbquery[1].setQuery(USERTHEMES_QUERY);
			dbquery[1].setQueryInputs(new String[] {(String)hm.get("userid"),"photo",pthemecode,pthemecode+".css"});
			dbquery[2]=new DBQueryObj();
			dbquery[2].setQuery(USERTHEMES_QUERY);
			dbquery[2].setQueryInputs(new String[] {(String)hm.get("userid"),"network",nthemecode,nthemecode+".css"});
					
			statobj=DbUtil.executeUpdateQueries(dbquery);
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"signupprocess.jsp",null,"status of Inserting default themes for signup user: is------"+statobj.getStatus(),null);
			
			String category=(String)userhm.get("category");
			HashMap signupHubMap=new HashMap();
			signupHubMap.put("firstname",userhm.get("firstname"));
			signupHubMap.put("userid",hm.get("userid"));
			signupHubMap.put("category",category);
			signupHubMap.put("loginname",(String)userhm.get("name"));
			String groupid1=hubDB.addSignUpHub(signupHubMap);
			StatusObj stobj= DbUtil.executeUpdateQuery("update user_roller_themes set themecode=? ,cssurl=? where userid=? and refid=? and module=?", new String[]{hthemecode,hthemecode+".css",(String)hm.get("userid"),groupid1,"hubpage"} );
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
					String email=(String)userhm.get("email");
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
			
<%@ include file="/../signup/signuppartner.jsp" %>
			
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
		SendEmail(userhm);

		
		}//if  stob.getStatus()
		session.setAttribute("USER_SIGN_HASH", null);
		String link="",message="",continuelink="";
		if(flag){
		EventRegisterBean jBean= (EventRegisterBean)session.getAttribute("regEventBean");
		
		if(jBean!=null){
			
			jBean.setSelectedLogin("");
			jBean.getEbeeLoginData().setLoginName((String)hm.get("loginname"));
			jBean.getEbeeLoginData().setPassword((String)hm.get("password"));
			String uid=(String)hm.get("userid");
			StatusObj sobj=jBean.validateEbeeLogin(session);
			session.setAttribute("regerrors",null);
			session.removeAttribute("USER_SIGN_HASH");
				%>
			<tr><td class="inform" align="center"><table width="100%" align="center"><tr>
			<%
					
			if(!sobj.getStatus())
				out.print("Success");
			else
				out.print("Failure");
			}

		}else{
			out.print("Failure");
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










