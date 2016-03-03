<%@ page import="com.eventbee.general.*,java.util.*"%>
<%@ page import="java.io.*,java.sql.*,com.eventbee.general.EventbeeConnection"%>
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.hub.*"%>
<%@ page import="com.eventbee.passivemember.*"%>

<%!
String CLASS_NAME="/hub/sendmails.jsp";
String [] getValidEmailid(String [] emails){
List strlst=new ArrayList();
	for(int i=0;i<emails.length;i++)
	{
		String st=emails[i];
		int s1=st.indexOf('@');
		int s2=st.indexOf('.');
		if ((s1==-1)||(s2==-1)){
		}
		else
		strlst.add(st);
	}
	String [] str = (String [])strlst.toArray(new String[strlst.size()]);
	return str;
}
%>

<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
String userid="",fname="",lname="",hubname="",sendemail="", huburl="",hubslink="";
String httpserveraddress="http://"+EbeeConstantsF.get("serveraddress","www.eventbee.com");
String groupid=request.getParameter("GROUPID");
Authenticate au=AuthUtil.getAuthData(pageContext);
        if(au!=null){
               userid=au.getUserID();
	       fname=(String)au.UserInfo.get("FirstName");
	       lname=(String)au.UserInfo.get("LastName");
	       hubname=DbUtil.getVal("select clubname from clubinfo where clubid=?",new String [] {request.getParameter("GROUPID")});
	       sendemail=au.getEmail();
	       huburl=httpserveraddress+"/hub/clubview.jsp?GROUPID="+request.getParameter("GROUPID");
	       hubslink=httpserveraddress+"/hub/clubsview.jsp?UNITID=13579";
	}
	String toid=request.getParameter("emailsString");
	String memberbenefits=request.getParameter("memberbenefit");
	HashMap groupinfo=new HashMap();
	groupinfo.put("groupid",groupid);
	groupinfo.put("grouptype","Club");
	Config conf1=ConfigLoader.getGroupConfig(groupinfo); 
	HashMap conghm=ConfigLoader.getConfig(conf1.getConfigID());
	conf1.setConfigHash(conghm);
	String clubapprovaltype=conf1.getKeyValue("club.memberapproval.type","Public");

	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "toid isssssss", " toid issssssss= "+toid, null);
	String invid=request.getParameter("invid");
		
	if(toid==null) toid="";
	String url="";
	String appname="/portal";
	
	EmailTemplate emailtemplate=new EmailTemplate("13579","ADDMEMBERS");
	String HTMLcontent="";
	int result=0;
	String res="";
	if(invid==null){
		toid=GenUtil.traverseString(toid.trim()," ","");
		toid=GenUtil.traverseString(toid,",,",",");
	}
	String emails[]=GenUtil.strToArrayStr(toid,",");
	emails=getValidEmailid(emails);
	
	if(emails!=null){
		for(int i=0;i<emails.length;i++){
			HashMap userhash=null;
			StatusObj stobj=PassiveMemDB.AddPassiveMember(emails[i],groupid,clubapprovaltype);
			if(stobj.getStatus()){
				EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"Manual user creation status is: "+stobj.getStatus(),"",null);
				userhash=(HashMap)stobj.getData();
				String refid=(String)userhash.get("encodedid");
				String manualuserid=(String)userhash.get("userid");
				String loginurl=httpserveraddress+"/portal/guesttasks/loginurl.jsp?refid="+refid+"&GROUPID="+groupid;
				String unsubscribeurl=httpserveraddress+"/portal/guesttasks/passiveunsubscribe.jsp?UNITID=13579&refid="+refid+"&GROUPID="+groupid;
				HashMap MessageMap=PassiveMemDB.fillData(fname,lname,hubname,sendemail,huburl,loginurl,memberbenefits,unsubscribeurl,hubslink);
				String subject="You have been added to "+hubname;
				HTMLcontent=TemplateConverter.getMessage(MessageMap,PassiveMemDB.htmlMessage);
				result+=PassiveMemDB.SendEmail(emails[i],sendemail,userid,subject,HTMLcontent);			
			}
		}
	}
	EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, CLASS_NAME, "jspservice(..", " toid= "+toid, null);
	response.sendRedirect(appname+"/hub/EmailDone.jsp?ntype=Add Member"+"&count="+result+"&type=club&GROUPID="+request.getParameter("GROUPID"));
	
%>
