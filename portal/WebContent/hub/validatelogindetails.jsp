<%@ page import="com.eventbee.editprofiles.*,java.util.*,com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.general.*,com.eventbee.util.CoreConnector"%>
<%@ page import="com.eventbee.customconfig.*,com.eventbee.profiles.ProfileDB" %>
<%@ page import='java.net.*,java.io.*' %>

<%!
 final String ROLLERPASSWORD="desihubeventbeebeeport";
 String CLASS_NAME="hub/validatelogindetails.jsp";

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
    
    

 String AUTHENTICATION_UPDATE="update authentication set login_name=?,"
				   +"password=?,updated_by='HUBMEMBER',updated_at=now(),acct_status=1 where user_id=?";
 String MEM_PREFERENCE_INSERT =" insert into member_preference( "
				    +" user_id, pref_name, pref_value) values (?,?,?) ";

 String UPDATE_CLUB_MEMBER_STATUS="update club_member set status='ACTIVE' where userid=?";


%>

<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"Validation after change login details","", null);

String uname="";
// EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"User ID: "+uname,"", null);
String groupid=request.getParameter("GROUPID");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"Club ID: "+groupid,"", null);
String password=request.getParameter("password");
String cpassword=request.getParameter("cpassword");
HashMap hm=new HashMap();
ProfileValidator validator=new ProfileValidator();
// hm=validator.validateUserName("",uname,"Bee ID already exists","loginnameExist",hm,"signup","Bee ID","13579");
hm=validator.validateEquals(password,cpassword,"Passwords should match","pwdMatch",hm);
// hm=validator.validateString(uname,"Bee ID","loginLength",40,1,hm);
hm=validator.validateString(password,"Password","pwdLength",40,1,hm);
/* if(uname!=null&& !"".equals( (uname).trim() )){
	if(!validator.checkNameValidity(uname,true) ){
		hm.put("invalid_id","Invalid Bee ID. Use alphanumeric characters only");
	}
 }*/
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"Error HashMap after validation: "+hm,"", null);
if(hm!=null&&hm.size()>0){
       	StringBuffer sb=new StringBuffer();
       /*	if(!"".equals(GenUtil.getHMvalue(hm,"loginnameExist",""))){
		sb.append(GenUtil.getHMvalue(hm,"loginnameExist",""));
		
	}*/
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
	/*if(!"".equals(GenUtil.getHMvalue(hm,"invalid_id",""))){
		sb.append("<br/>");
		sb.append(GenUtil.getHMvalue(hm,"invalid_id",""));
	}*/
			

	out.println(sb.toString());
}
else{
Authenticate au=(Authenticate)session.getAttribute("authData");
if(au!=null){
        uname=DbUtil.getVal("select login_name from authentication where user_id=? ",new String[]{au.getUserID()});
	cpassword=password;
	password=(new StringEncrypter(StringEncrypter.DES_ENCRYPTION_SCHEME) ).encrypt(password);
	StatusObj sbj=DbUtil.executeUpdateQuery(AUTHENTICATION_UPDATE,new String[]{uname,password,au.getUserID()});
        sbj=DbUtil.executeUpdateQuery(UPDATE_CLUB_MEMBER_STATUS,new String[]{au.getUserID()});
	String themecode=EbeeConstantsF.get("accounts.basic.deftheme","movablemanila");
	StatusObj statobjn= DbUtil.executeUpdateQuery("insert into user_roller_themes (userid,module,themecode) values(?,?,?)", new String[]{au.getUserID(),"Snapshot",themecode    } );
	statobjn= DbUtil.executeUpdateQuery("insert into user_roller_themes (userid,module,themecode) values(?,?,?)", new String[]{au.getUserID(),"Photos",themecode    } );
	statobjn= DbUtil.executeUpdateQuery(MEM_PREFERENCE_INSERT, new String[]{au.getUserID(),"pref:myurl",uname} );
        String membertype=DbUtil.getVal("select value from community_config_settings where key='MEMBER_ACCOUNT_TYPE' and clubid=? ",new String [] {groupid});
	if("EXCLUSIVE".equals(membertype)){
	String statusid=au.getAcctStatusID();
	String acct_status=statusid;
	if("6".equals(statusid)) acct_status="3";
	if("9".equals(statusid)) acct_status="8";
	StatusObj sobj1=DbUtil.executeUpdateQuery("update authentication set acct_status=?,updated_by='CLUB_UNITMEMBER' where user_id=?", new String []{acct_status,au.getUserID()});
	} 
if(statobjn.getStatus()){
AuthDB authDB=new AuthDB();
au=authDB.authenticatePortalUser(uname,cpassword,"13579");
if(au !=null){
session.setAttribute("13579_authData",au);
String authid=au.getUserID();
Cookie cookie1 = new Cookie("SESSION_TRACKID",authid+"~"+session.getId()+"~"+(InetAddress.getLocalHost() ).getHostName()+"~"+(new java.util.Date()).toString());
response.addCookie(cookie1);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"hub.validatelogindetails.jsp","SESSION_TRACKID for Authid: "+authid+" is: "+authid+"~"+session.getId()+"~"+(InetAddress.getLocalHost() ).getHostName()+"~"+(new java.util.Date()).toString(),"sessionid: "+session.getId()+",login time: "+(new java.util.Date()).toString(),null);
if(((String)session.getAttribute(authid+"PROFILEINSERT"))==null){
HashMap hm1=new HashMap();
hm1.put("userid",authid);	
hm1.put("sid",session.getId());
int logincount=ProfileDB.insertLoginDetails(hm1);
session.setAttribute(authid+"PROFILEINSERT","Y");
}
session.setAttribute("authData",au);	
}

//************start of roller signup***************
try {
			String serverport=(80==request.getServerPort())?"":(":"+request.getServerPort()) ;
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"serverport  is: "+serverport,"",null);

			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,request.getServerName()+":Before sending request to roller","sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
			String serverurl=request.getScheme()+"://localhost"+serverport;
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"serverurl  is: "+serverurl,"",null);

			String rollercontext=(application.getInitParameter("rollercontext")!=null)?application.getInitParameter("rollercontext"):"/roller";
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"rollercontext  is: "+rollercontext,"",null);
			String fullname=(au.getFirstName()+" "+au.getLastName());

			HashMap parammap=new HashMap();
			CoreConnector cc1=new CoreConnector(serverurl+rollercontext+"/portaluser/createportaluser.jsp");
			cc1.setTimeout(30000);
			String eventbeerollerpass=encodePassword(encodePassword(ROLLERPASSWORD, "SHA"),"SHA" );
			parammap=new HashMap();
			parammap.put("portaluser",uname);

			parammap.put("fullName",fullname);
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"fullname  is: "+fullname,"",null);
			String emailn=au.getEmail();
			EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"email  is: "+emailn,"",null);

			emailn=("".equals(emailn) )?"dummy@hh.com":emailn;
			parammap.put("emailAddress", emailn );
			parammap.put("locale","en_US");
			parammap.put("timezone","PDT");
			parammap.put("theme", themecode );
			cc1.setArguments(parammap);
			cc1.MPost() ;
			// the follwing used as roller password while form submiting:    06f2ea14bb6b113d44611ff33bf337b06a837cb0   and roller dbentry will be 590ea037cbde9658f4b828ddc8b964e4405843fb
		}catch (Exception ex){
			EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, CLASS_NAME, "", ex.getMessage(), ex ) ;
		}

 	      

	}
	//************end of roller signup***************






}
	out.println("Success");		


}

%>