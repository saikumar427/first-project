
<%@page import="com.eventbee.noticeboard.*"%>
<%@page import="com.eventbee.general.*,com.eventbee.emailschedule.*, com.eventbee.listmanagement.*"%>
<%@ page import="com.eventbee.emailschedule.*, com.eventbee.listmanagement.*,com.eventbee.authentication.*" %>
<%@ page import="java.io.*, java.util.*,com.eventbee.general.EventbeeConnection,com.eventbee.listmanagement.*,com.eventbee.general.*" %>

<jsp:include page='/auth/checkpermission.jsp'>
	<jsp:param name='authtype' value='<%=request.getParameter("PS")%>' />
<jsp:param name='Dummy_ph' value='' /></jsp:include>
<%


String groupid=request.getParameter("GROUPID");

String sendmail=request.getParameter("sendmail");

String combo=request.getParameter("noticetype");



if("on".equalsIgnoreCase(sendmail))
{
	
		
		EmailObj emailobj=new EmailObj();
		String Htmlcont=request.getParameter("notice");
		String mailtotest = DbUtil.getVal("select email from eventinfo where eventid=?",new String[]{groupid});
		
		try{
				emailobj.setFrom(mailtotest);
				emailobj.setHtmlMessage(Htmlcont);
				emailobj.setReplyTo(mailtotest);
				emailobj.setSubject("Type_"+combo);
				//emailobj.setTextMessage(txtcontent);
		
		
				DBManager dbmanager=new DBManager();
				String colName = null;
				String Query1="select email from eventattendee where eventid=?";
				StatusObj statobj1=dbmanager.executeSelectQuery(Query1,new String[]{groupid});
				String [] emailids = new String[]{};
		
					if(statobj1.getStatus())
					{
						int count=statobj1.getCount();
						emailids=new String [count];
		
						for(int i=0;i<count;i++)
						{
							emailids[i]=dbmanager.getValue(i,"email","");
							
						}
					}
					
					
					if(emailids!=null)
					{
	  					for(int i=0;i<emailids.length ;i++)
	  					{
		  					emailobj.setTo(emailids[i]);
		  					EventbeeMail.sendHtmlMail(emailobj);
		  				}
	  				}
	  			/*	
				
				if(Htmlcont!=null&&!"".equals(Htmlcont.trim()))
				{
					
					emailobj.setTo(emailids);
					EventbeeMail.sendHtmlMail(emailobj);
					//EventbeeMail.sendHtmlMailPlain(emailobj);
				}
				
				*/
			}
			
			
			catch(Exception e)
			{
  				System.out.println(" There is an error in send mail:"+ e.getMessage());
  			}
				
			
}




EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"insertnotice.jsp","Authdata is not null. Authid: "+((AuthUtil.getAuthData(pageContext)!=null)?AuthUtil.getAuthData(pageContext).getUserID():"Auth data is null"),"sessionid: "+session.getId()+", time: "+(new java.util.Date()).toString(),null);
    String appname=("/manager".equalsIgnoreCase(request.getContextPath()))?"/manager":"/portal";	
    String mode=null,grouptype=null,message="";
    boolean errorflag=false;
    HashMap localParams=new HashMap();
    
    	errorflag=validateData(pageContext,localParams);
	if(errorflag){
		response.sendRedirect(PageUtil.appendLinkWithGroup(appname+"/noticeboard/enternoticeinfo.jsp",localParams));
	}else{
		session.removeAttribute("noticehash");
		session.removeAttribute("noticeerrorvector");	
	      int rcount=NoticeboardDB.insertNotice(localParams);
	      if(rcount>0){
		 
		 message=EbeeConstantsF.get("hub.notice.posted.message","Notice posted successfully");
		 //message="Notice posted successfully";
		}
		response.sendRedirect(PageUtil.appendLinkWithGroup(appname+"/noticeboard/notice.jsp?message="+message,localParams));
	}
%>	
<%!
    public boolean validateData(PageContext pctx,HashMap noticehash){
    	HttpServletRequest req=(HttpServletRequest) pctx.getRequest();
	HttpSession session=pctx.getSession();
	boolean  flag=false;
	String notice=null,noticetype=null;
	String noticeempty=EbeeConstantsF.get("hub.notice.empty.message","Notice is empty");
	String noticeexceed=EbeeConstantsF.get("hub.notice.exceed.message","Notice exceeds 1000 characters");
	
    	Vector errorvector=new Vector();
	if(noticehash==null) noticehash=new HashMap();

		  notice=req.getParameter("notice").trim();
		  noticetype=req.getParameter("noticetype");
	
	  	  noticehash.put("notice", req.getParameter("notice"));
          noticehash.put("noticetype", req.getParameter("noticetype"));
          noticehash.put("groupid", req.getParameter("GROUPID"));
          noticehash.put("grouptype", req.getParameter("GROUPTYPE"));
          noticehash.put("owner", req.getParameter("owner"));
	      noticehash.put("GROUPID", req.getParameter("GROUPID"));
          noticehash.put("GROUPTYPE", req.getParameter("GROUPTYPE"));
	  //noticehash.put("UNITID", req.getParameter("UNITID"));
	  noticehash.put("PS", req.getParameter("PS"));
	  //noticehash.put("checkbox",req.getParameter("checkbox"));
	  	
	  	
	  	if(notice.length()==0){
			flag=true;
			errorvector.add(noticeempty);
		}else if(notice.length()>1000){
			flag=true;
			errorvector.add(noticeexceed);
		}

		session.setAttribute("noticehash",noticehash);
		session.setAttribute("noticeerrorvector",errorvector);

        return flag;
	}





%>



