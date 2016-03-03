<%@ page import="com.eventbee.event.*"%>
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.general.GenUtil"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*"%>
<%@ page import="org.eventbee.sitemap.util.Presentation" %>
<%     
	Authenticate au=null;
	EventRegisterBean jBean=new EventRegisterBean();
	session.removeAttribute("regerrors");
	String eventid=Presentation.GetRequestParam(request,  new String []{"eid","eventid", "id","GROUPID","groupid"});
	boolean ticketpagesession=(session.getAttribute("ticketingpagehit_"+eventid)==null);
	if(ticketpagesession){
		session.setAttribute("ticketingpagehit_"+eventid,"ticketingpagehit_"+eventid);
		String sessid=(String)session.getId();
		HitDB.insertHit(new String[]{"register.jsp","Ticketing Page",sessid,eventid,null});
		StatusObj updateStatusObj=DbUtil.executeUpdateQuery("update hits_summary set visit_count=visit_count+1 where id=? and resource ='Ticketing Page'",new String[]{eventid});
		if(updateStatusObj.getCount()==0){
			DbUtil.executeUpdateQuery("insert into hits_summary(visit_count, id, resource) values(1, ?,'Ticketing Page')",new String[]{eventid});
		}	
	}
	        
        String platform=request.getParameter("platform");
        if("ning".equals(platform)){
        String oid=request.getParameter("oid");
        String vid=request.getParameter("vid");
        String domain=request.getParameter("domain");
        
    
    if(request.getParameter("bgColor")!=null){
    String style= "body{"
                       +"background: "+request.getParameter("bgColor")+";"
		       +"text-align: center;"
			+"padding: 0;"
			+"font: 62.5% verdana, sans-serif;"
			+"color:"+request.getParameter("fontColor")+";"
			+"}"
			+"#container {"
			+"margin: 0 auto;"
			+"text-align: left;"
			+"width: 700px;"
			+"color: "+request.getParameter("fontColor")+";"
			+"background:"+request.getParameter("bgColor")+";"
			+"padding: 0px;"
			+"}"
			+"a {"
			+"color: "+request.getParameter("anchorColor")+";"
		          +"}"
			+".medium {"
			+"font: bold 20px veradana, sans-serif;"
			+"color:"+request.getParameter("fontColor")+";"
			+"}"
			+".large{"
			+"font: bold 26px veradana, sans-serif;"
			+"color:"+request.getParameter("fontColor")+";"
			+"}";

        session.setAttribute("ning_style_"+oid,style);
        }
	session.setAttribute("ningoid",oid);
	session.setAttribute("ningvid",vid);
	session.setAttribute("domain",domain);
	session.setAttribute("platform","ning");
        }
               
	String oldTranId=(String)session.getAttribute(eventid+"_OldTranId");
	if(oldTranId!=null){
	jBean.setTransactionInfo(oldTranId);
	jBean.setUpgradeRegStatus(true);
	jBean.setOldTransactionId(oldTranId);
		}
	if(eventid==null)eventid=request.getParameter("eventid");
	//String eunitid=request.getParameter("UNITID");
	String agentid=Presentation.GetRequestParam(request,  new String []{"pid","partnerid", "participantid","participant"});
	String discountcode=request.getParameter("code");
	
	String pfriendid=Presentation.GetRequestParam(request,  new String []{"fid","friendid"});
	String fromproxy=(String)session.getAttribute("fromproxy");
	String context=request.getParameter("context");
	//if(eunitid==null || "".equals(eunitid.trim()))		eunitid=(String)session.getAttribute("entryunitid");
	String userid=null;
		au=(Authenticate)session.getAttribute("13579_authData");
		//if(userid==null){
	Authenticate authData=AuthUtil.getAuthData(pageContext);
	if (authData!=null){
		userid=authData.getUserID();
	
	}
//}
		
		
		session.setAttribute("entryunitid","13579");
		if ("Yes".equals(fromproxy)){
             jBean.setProxy(1);
        }else{
              //if("13579".equals(eunitid))
		 jBean.setProxy(6);
	     //else
		 //jBean.setProxy(0);
        }
            

		session.setAttribute("regEventBean", jBean);
		request.setAttribute("regEventBean", jBean);
		
		if(!(jBean.initialize(eventid, au,"13579",agentid,pfriendid))){
			response.sendRedirect("/guesttasks/regerror.jsp");
			}
		/*if(!("ACTIVE".equals(jBean.getStatus())))
              		response.sendRedirect("/portal/guesttasks/regticketnotavailable.jsp?GROUPID="+eventid);*/
		
		if (( "ACTIVE".equals(jBean.getStatus()))&&(jBean.isTicketsAvailable()||jBean.getUpgradeRegStatus())){
			jBean.setUserId(userid);
			String trckcode=(String)session.getAttribute("trckcode");
			String trackcode=(String)session.getAttribute(eventid+"_"+trckcode);
			if(trackcode!=null){
			DbUtil.executeUpdateQuery("insert into trackURL_transaction(transactionid,trackingcode) values(?,?)",new String [] {jBean.getTransactionId(),trackcode});
			}
		
		
                   EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"REGISTER.jsp",null,"#####################Registration started for the Event eid#####################"+jBean.getEventId(),null);

                  EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.ERROR,"REGISTER.jsp",null,"#####################Registration started with Tid#####################"+jBean.getTransactionId(),null);

	
		 %>
			<jsp:forward page='../../guesttasks/regticket.jsp;jsessionid=<%=session.getId()%>'>
			<jsp:param name='code' value='<%=discountcode%>' />
			</jsp:forward>	
			<%
		}else{
			%>
			
			<jsp:forward page='../../guesttasks/regticketnotavailable.jsp'>
				<jsp:param name='eventstatus' value='<%=jBean.getStatus()%>' />
			</jsp:forward>	
			
	<%	}

	
	
%>
