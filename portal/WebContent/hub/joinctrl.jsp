<%@ page import="com.eventbee.hub.*" %>
<%@ page import="com.eventbee.customconfig.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.*" %>
<%@ page import="java.util.*" %>

<%!
	final String INSERT_MEMBER="insert into member_profile(manager_id,member_id,m_email,userid,created_at)	values (?,?,?,?,now())";
	final String INSERT_LIST_MEMBER="insert into mail_list_members(member_id,list_id,status,created_at) values(?,?,'available',now())";
%>

<%
	request.setAttribute("tasktitle","Join Hub");

%>
<jsp:include page='/stylesheets/CoreRequestMap.jsp' />

<%

//"joinctrl.jsp"
String userid="";
Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate)session.getAttribute(ContextConstants.AUTH_DATA_OBJ);
	if (authData!=null){
		userid=authData.getUserID();
	}
String groupid=request.getParameter("GROUPID");
String unitid=request.getParameter("UNITID");
String statement=request.getParameter("statement");

String clubapprovaltype=request.getParameter("clubapprovaltype");
//System.out.println("clubapprovaltype==========="+clubapprovaltype);
String status=("Public".equalsIgnoreCase(clubapprovaltype) )?"ACTIVE":"PENDING";

			Map profilemap=new HashMap();
			profilemap.put("clubid",groupid);
			profilemap.put("userid",userid);
			profilemap.put("isMgr","false");
			profilemap.put("status",status) ;
			profilemap.put("statement",statement);
			//profilemap.put("surveyresponseid");
			//profilemap.put("membership_id");
			profilemap.put("created_by","Manual");
			profilemap.put("updated_by","Manual");
			String email=DbUtil.getVal("select email from user_profile where user_id=?",new String[]{userid} );
			String ismem=DbUtil.getVal("select userid from club_member where clubid=? and userid=?",new String[]{groupid,userid} );
			String mgrid=DbUtil.getVal("select mgr_id from clubinfo where clubid=?",new String[]{groupid} );
			if(ismem ==null){
				profilemap.put("mgr_id",mgrid);
				HubMaster.addMember( profilemap,null);
				String MEMBER_SEQ_ID="select nextval('seq_maillist') as memberid" ;
				String memberid=DbUtil.getVal(MEMBER_SEQ_ID,new String[]{});
				String listid=DbUtil.getVal("select list_id from mail_list where list_name like 'Active Members%' and unit_id=? and manager_id=?",new String[]{groupid,mgrid} );
				StatusObj stob=DbUtil.executeUpdateQuery(INSERT_MEMBER,new String [] {mgrid,memberid,email,userid});
				stob=DbUtil.executeUpdateQuery(INSERT_LIST_MEMBER,new String [] {memberid,listid});
				sendEmail(groupid);
			}	
	
	String custommessge=("Public".equalsIgnoreCase(clubapprovaltype) )?"publichubmember.join.done":"moderatedhubmember.join.done";
	//System.out.println("custommessge==========="+custommessge);
	response.sendRedirect(PageUtil.appendLinkWithGroup("/portal/mytasks/hubdone.jsp?message="+custommessge+"&title=Join Hub",(HashMap)request.getAttribute("REQMAP")) );
%>



<%!
 final String CLASS_NAME="hub/joinctrl.jsp";
public void sendEmail(String groupid){
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
			// obj.setTextMessage(content);
			 obj.setHtmlMessage(HTMLcontent);
			 obj.setSendMailStatus(new SendMailStatus("13579",purpose,groupid,"1"));
			 EventbeeMail.sendHtmlMail(obj);
			 
		}catch(Exception e){
			 
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
