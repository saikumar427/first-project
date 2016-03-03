<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.f2f.F2FEventDB"%> 
<%
String userid="";
String groupid=request.getParameter("GROUPID");
String unitid=request.getParameter("UNITID");
%>

<%
Authenticate authData=AuthUtil.getAuthData(pageContext);
if(authData !=null){
userid=authData.getUserID();
}
%>

<%

StatusObj sobj=null;
String settingid=request.getParameter("setid");
String title=request.getParameter("title");
String message=request.getParameter("message");
String showsales=request.getParameter("showsales");
String goalamount=request.getParameter("goalamount");

String UPDATEQ="update group_agent set  title=?,message=?,goalamount=?,showsales=? where settingid=?";
%>
<%
String statusq="select approvaltype from group_agent_settings where settingid=?";
String statusv=F2FEventDB.getVal(F2FEventDB.getStatusVal_Query,settingid);

if("No".equals(statusv))
statusv="Pending";
else
statusv="Active";
%>
<%
String agentid=request.getParameter("agentid");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"confirmSettings.jsp","null","agentid :"+agentid,null);
request.setAttribute("agentid",agentid);
String foroperation=request.getParameter("foroperation");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"confirmSettings.jsp","null","foroperation value is :"+foroperation,null);
com.eventbee.util.RequestSaver rMap=new com.eventbee.util.RequestSaver(pageContext,request.getParameter("agentid")+"_agent_map","session",true);
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"confirmSettings.jsp","null","agent_map value is :"+(HashMap)session.getAttribute("0_agent_map"),null);

%>
<%
Vector v=new Vector();
StatusObj status=null;
String submit=request.getParameter("submit");
boolean flag=true;
%>
<%
if ("submit".equalsIgnoreCase(submit)){
if("".equals(goalamount)){}else{
status=EventBeeValidations.isValidNumber(request.getParameter("goalamount"),"GoalAmount","Integer");
	if (!(status.getStatus())){
		 v.add(status.getErrorMsg());
		 flag=false;
	}
	}


%>
<%
if(v!=null&&v.size()>0){
		session.setAttribute("CREATE_TASK_DATA_ERROR_DATA",v);
		response.sendRedirect(PageUtil.appendLinkWithGroup("/portal/eventbeeticket/agentcomm.jsp?error=yes&agentid="+request.getParameter("agentid")+"&setid="+request.getParameter("setid"),(HashMap)request.getAttribute("REQMAP")));
		return;
	}else{
	         if("add".equals(request.getParameter("foroperation"))){
		 	HashMap hm=new HashMap();
		 	hm.put("title",title);
			hm.put("message",message);
			hm.put("userid",userid);
			hm.put("settingid",settingid);
			hm.put("showsales",showsales);
			hm.put("goalamount",goalamount);
			hm.put("statusv",statusv);
			
		 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"confirmsettings.jsp","null","agent details are :"+hm,null);
		 sobj=F2FEventDB.insertAgentDetails(hm);
		 
		 
		 //sobj=DbUtil.executeUpdateQuery(INSERTQ,new String [] {title,message,userid,settingid,showsales,goalamount,statusv});
		 }else if ("edit".equals(request.getParameter("foroperation"))){
		 	HashMap hm=new HashMap();
		 	hm.put("title",title);
			hm.put("message",message);
			hm.put("goalamount",goalamount);
			hm.put("showsales",showsales);
			hm.put("setid",request.getParameter("setid"));
			
		 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"confirmsettings.jsp","null","agent details are :"+hm,null);
		 sobj=F2FEventDB.updateAgentDetails(hm); 	
		 	 
			//sobj=DbUtil.executeUpdateQuery(UPDATEQ,new String [] {title,message,goalamount,showsales,request.getParameter("setid")});
                        }
        }
	
	
	}                    
%>
<%
String response1=request.getParameter("response1");
if("yes".equalsIgnoreCase(response1)){
response.sendRedirect("/portal/eventbeeticket/updatesettings.jsp?PS="+request.getParameter("PS")+"&GROUPID="+groupid+"&UNITID="+unitid);
}
else
{
response.sendRedirect("/portal/eventbeeticket/addagent.jsp?PS="+request.getParameter("PS")+"&GROUPID="+groupid+"&UNITID="+unitid);
}
%>


