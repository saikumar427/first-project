<%@ page import="com.eventbee.general.*" %>
<%@ page import="com.eventbee.forum.ForumDB" %>
<%@ page import="com.eventbee.authentication.*,com.eventbee.util.*" %>
<%@ page import="java.util.*" %>

<%! public static final	String FILE_NAME="discussionforums/logic/insertDiscForum.jsp";
public void setDataToDb(HashMap localParams){
try{
String domain=EbeeConstantsF.get("support.email","support@beeport.com");
domain=domain.replaceAll("support","");
String server=EbeeConstantsF.get("email.server.url","http://demo.eventbee.com:9090/testing/adduser.jsp");
if(((String)localParams.get("loginname"))!=null&&(((String)localParams.get("loginname")).trim()).length()>0){
CoreConnector cc1=new CoreConnector(server);
cc1.setQuery("loginname="+(String)localParams.get("loginname")+domain+"&password="+(String)localParams.get("a_UNITID")+"_"+(String)localParams.get("forumid"));
cc1.setTimeout(30000);
String st=cc1.MGet();
System.out.println(st);
StatusObj sobj=DbUtil.executeUpdateQuery("insert into custom_mail_box(unitid,groupid,purpose,refid,servername,password,loginname,status) values(?,?,?,?,?,?,?,?)",new String[]{(String)localParams.get("a_UNITID"),(String)localParams.get("GROUPID"),"FORUM",(String)localParams.get("forumid"),EbeeConstantsF.get("email_server","webmail.beeport.com"),(String)localParams.get("a_UNITID")+"_"+(String)localParams.get("forumid"),(String)localParams.get("loginname")+domain,"ACTIVE"});

}}catch(Exception e)
{
System.out.println("Exception in insertDiscForum.jsp setDatatoDb"+e.getMessage());
}
	}
%>
<jsp:include page='/auth/checkpermission.jsp'>
	<jsp:param name='authtype' value='<%=request.getParameter("PS")%>' />
<jsp:param name='Dummy_ph' value='' /></jsp:include>
<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"insertDiscForum.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
	   int res=0;
	   String message="";
	   HashMap localParams=new HashMap();
	    String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";
	 String submit=request.getParameter("submit");
	 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,FILE_NAME,"FORUM - PURPOSE: "+submit, EventbeeLogger.LOG_START_PAGE, null);

          if("Delete".equals(submit)){
		  String mode=request.getParameter("mode");	                  
		  if("multiple".equals(mode)){
		  	String id[]=request.getParameterValues("forumid");
			if(id!=null && id.length>0){
				res=ForumDB.deleteDiscForum(id,mode,"No");
			if(res>0)			
				message=EbeeConstantsF.get("hub.forum.deleted","Forum deleted");
				
			else
			message=EbeeConstantsF.get("hub.forum.not.deleted","Forum not deleted");
				
			}
		}else if("single".equals(mode)){
			String id[]=request.getParameterValues("msgid");
			if(id!=null && id.length>0)
			res=ForumDB.deleteDiscForum(id,mode,"No");
			message=EbeeConstantsF.get("hub.forum.message.deleted","count Forum Message(s) Deleted");
			if(message.indexOf("count")!=-1)
                        message=message.replaceAll("count",res+"");
			
		}
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,FILE_NAME,"FORUM - PURPOSE: "+submit,EventbeeLogger.LOG_END_PAGE, null);
		fillGroupData(request,localParams);
		response.sendRedirect(PageUtil.appendLinkWithGroup(appname+"/discussionforums/logic/dffinalinfo.jsp?type=Community&message="+message,localParams));
		
	}else if(validateData(pageContext,localParams)){
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG, FILE_NAME,"FORUM - PURPOSE: "+submit, "Exited in ValidateData function", null);
		if("Add".equals(submit)){
			response.sendRedirect(PageUtil.appendLinkWithGroup(appname+"/discussionforums/logic/enterforuminfo.jsp",localParams));
		}else if("Update".equals(submit)){
			response.sendRedirect(PageUtil.appendLinkWithGroup(appname+"/discussionforums/logic/editforuminfo.jsp",localParams));
		}
	}else{
	  	Authenticate authData=AuthUtil.getAuthData(pageContext);//(Authenticate) session.getAttribute("authData");
		localParams.put("owner",authData.getUserID());
		if("Add".equals(submit)){
	  		res=ForumDB.insertDiscForum(localParams);

			if(res>0){
				localParams.put("forumid",res+"");
				if("yes".equals(request.getParameter("enableposting")))
				{
					localParams.put("a_UNITID",authData.getUnitID());
					setDataToDb(localParams);
				}
				message=EbeeConstantsF.get("hub.forum.created.message","Forum created successfully");
							}
		}else if("Update".equals(submit)){
			res=ForumDB.updatetDiscForum(localParams);
			StatusObj sobj=null;
			String templateexists=DbUtil.getVal("select 'yes' from email_templates where purpose='FORUMS' and unitid=?  ",new String []{authData.getUnitID()});
			if("yes".equals(templateexists)&&(!"MEM".equals(authData.getRoleCode()))){
			sobj=DbUtil.executeUpdateQuery("update email_templates set header=?, footer=?, headertype=?, footertype=? where unitid=? and purpose='FORUMS'  ",new String [] {(String)localParams.get("header1"),(String)localParams.get("footer1"),(String)localParams.get("headertype"),(String)localParams.get("footertype"),authData.getUnitID()});
			}

			if(res>0){

				if("yes".equals(request.getParameter("enableposting"))){
				localParams.put("a_UNITID",authData.getUnitID());
				System.out.println(request.getParameter("isedit"));
				if(!"yes".equals(request.getParameter("isedit")))
				setDataToDb(localParams);
				else
				 sobj=DbUtil.executeUpdateQuery("update custom_mail_box set status='ACTIVE' where loginname=? ",new String [] {(String)localParams.get("loginname")});
				}else{
				localParams.put("a_UNITID",authData.getUnitID());
				 sobj=DbUtil.executeUpdateQuery("update custom_mail_box set status='PENDING' where loginname=? ",new String [] {(String)localParams.get("loginname")});
				}
				message=EbeeConstantsF.get("hub.forum.updated.message","Forum updated");
				
			}
		}
		 session.removeAttribute("forumhash");
		 session.removeAttribute("errorvector");
		EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,FILE_NAME,"FORUM - PURPOSE: "+submit,EventbeeLogger.LOG_END_PAGE, null);
		response.sendRedirect(PageUtil.appendLinkWithGroup(appname+"/discussionforums/logic/dffinalinfo.jsp?type=Community&message="+message,localParams));
	 }	

%>
<%!
   public boolean validateData(PageContext pctx,HashMap localParams){
     	HttpServletRequest req=(HttpServletRequest) pctx.getRequest();
	HttpSession session=pctx.getSession();
	boolean  flag=false;
	String name=null,description=null,status=null,loginname=null;

    	java.util.Vector errorvector=new java.util.Vector();

	name=req.getParameter("name").trim();
        description=req.getParameter("description").trim();
        status=req.getParameter("status").trim();
	loginname=req.getParameter("loginname");
	if(loginname!=null)
	loginname=loginname.trim();
	else loginname="";
	if(name.length()==0){
		flag=true;
		errorvector.add("Name should not be empty");
	}
	 if(description.length()>5000){
		flag=true;
		errorvector.add("Description should not exceed 5000 characters");
	}if("yes".equals(req.getParameter("enableposting"))){

	if(loginname.length()>0){
	String emailid=loginname;
		if(!"yes".equals(req.getParameter("isedit")))
		emailid=loginname.toLowerCase()+EbeeConstantsF.get("email_domain","@beeport.com");
		String refid=DbUtil.getVal("select refid from custom_mail_box where lower(loginname)=?",new String [] {emailid});
		System.out.println("refid: "+refid);
		System.out.println("refid: "+loginname);
		if(refid==null){
		flag=EventBeeValidations.isStringValidForEmail(loginname,"Email Id");
			if(!flag){
				errorvector.add("Invalid emailid");
				flag=true;
			}else flag=false;
		}else if(!refid.equals(req.getParameter("forumid"))){

			flag=true;
			errorvector.add("Emailid already exists ");
		}
		}else{
		flag=true;
			errorvector.add("Invalid emailid ");
		}

	}
          localParams.put("description",req.getParameter("description"));
          localParams.put("name", req.getParameter("name"));
	  localParams.put("forumname", req.getParameter("name"));
	  localParams.put("forumid", req.getParameter("forumid"));
          localParams.put("status",req.getParameter("status"));
	  localParams.put("loginname",req.getParameter("loginname"));
	  localParams.put("enableposting",req.getParameter("enableposting"));
	  fillGroupData(req,localParams);
	  localParams.put("groupid", req.getParameter("GROUPID"));
          localParams.put("grouptype", req.getParameter("GROUPTYPE"));
	  localParams.put("createdby", FILE_NAME);
          localParams.put("updatedby", FILE_NAME);
	  localParams.put("headertype", req.getParameter("headertype"));
	  localParams.put("footertype", req.getParameter("footertype"));
	  localParams.put("header1", req.getParameter("header1"));
          localParams.put("footer1",req.getParameter("footer1"));
	  
	 session.setAttribute("forumhash",localParams);
	 session.setAttribute("errorvector",errorvector);
	 return flag;
   }
   public void fillGroupData(HttpServletRequest req,HashMap localParams){
   	localParams.put("GROUPID", req.getParameter("GROUPID"));
          localParams.put("GROUPTYPE", req.getParameter("GROUPTYPE"));
	  localParams.put("UNITID","13579");
	  localParams.put("PS",req.getParameter("PS"));
   }	 
%>
