<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.context.ContextConstants,com.eventbee.authentication.*,com.eventbee.general.formatting.*" %>
<%@ page import="com.eventbee.f2f.F2FEventDB"%>
<%@ page import="com.eventbee.eventpartner.PartnerDB"%>

<jsp:include page="/auth/checkpermission.jsp">
<jsp:param name='Dummy_ph' value='' /></jsp:include>

<%!
public Vector isValidStr(String str,String property,Vector v,String errormessage){
		if(str==null||"".equals(str.trim()))
			v.add(EbeeConstantsF.get(property,errormessage));
			return v;
		}
%>

<%@ include file="/stylesheets/CoreRequestMap.jsp" %>
<%
String userid=null;
String foroperation=request.getParameter("foroperation");
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"saveagentsettings.jsp","null","foroperation value is  :"+foroperation,null);
String taskid=request.getParameter("taskid");
com.eventbee.util.RequestSaver rMap=new com.eventbee.util.RequestSaver(pageContext,request.getParameter("setid")+"_task_map","session",true);
String groupid=request.getParameter("GROUPID");
String eveenable=request.getParameter("eveenable");
String  salecommission="";
String  saleslimit="";
String fixedamount=null;
StatusObj status=null;
boolean flag=true;
Vector v=new Vector();
String statusq="select approvaltype from group_agent_settings where settingid=?";
String statusv=DbUtil.getVal(statusq, new String[]{groupid});
if("No".equals(statusv))
statusv="Pending";
else
statusv="Active";

String tagline=request.getParameter("tagline");
String description=request.getParameter("description");
saleslimit=request.getParameter("saleslimit");
String approvaltype=request.getParameter("approvaltype");
String terms_conditions=request.getParameter("terms_conditions");
String showagents=request.getParameter("showagents");
String header=request.getParameter("header");
String commissiontype=request.getParameter("commissiontype");	

if("%".equals(commissiontype)){
salecommission=request.getParameter("salecommission");
if(salecommission!=null)
salecommission=salecommission.trim();
}
else
fixedamount=request.getParameter("fixedamount");

if( "yes".equalsIgnoreCase(eveenable)){
	v=isValidStr(request.getParameter("tagline"),"event.agent.settings.tagline.empty",v,"Tag line is empty");
	v=isValidStr(request.getParameter("description"),"event.agent.settings.description.empty",v,"description is empty");
	if("%".equals(commissiontype)){
		status=EventBeeValidations.isValidNumber(salecommission,"Sales Commision","Integer");
		if (!(status.getStatus())){
			 v.add(status.getErrorMsg());
			 flag=false;
		}
	}else{
	status=EventBeeValidations.isValidNumber(request.getParameter("fixedamount"),"Sales Commision","Float");
				if (!(status.getStatus())){
				 v.add(status.getErrorMsg());
				 flag=false;
			}
	}
	status=EventBeeValidations.isValidNumber(request.getParameter("saleslimit"),"sales limit","Integer");
	if (!(status.getStatus())){
		 v.add(status.getErrorMsg());
		 flag=false;
	}
	
	v=isValidStr(request.getParameter("terms_conditions"),"event.agent.settings.terms_conditions.empty",v,"terms and conditions is empty");
	
	if(v!=null&&v.size()>0){
		session.setAttribute("CREATE_TASK_DATA_ERROR_DATA",v);
		response.sendRedirect(PageUtil.appendLinkWithGroup("/portal/eventbeeticket/settask.jsp?error=yes&foroperation="+foroperation+"&setid="+request.getParameter("setid"),(HashMap)request.getAttribute("REQMAP")));
		return;
	}else{  
	         if("add".equals(request.getParameter("foroperation"))){
	         String group=DbUtil.getVal("select 'yes' from group_agent_settings where groupid=?",new String[]{groupid});
	         if("yes".equals(group))
	         {
	         
		 HashMap hm=new HashMap();
		 hm.put("tagline",tagline);
		 hm.put("description",description);
		 hm.put("commissiontype",commissiontype);
		 if("%".equals(commissiontype))
		 hm.put("salecommission",(Integer.parseInt(salecommission)*0.01)+"");
		 else
		 hm.put("salecommission",fixedamount);
		 hm.put("saleslimit",saleslimit);
		 hm.put("approvaltype",approvaltype);
		 hm.put("terms_conditions",terms_conditions);
		 hm.put("header",header);
		 hm.put("showagents",showagents);
		 hm.put("setid",request.getParameter("setid"));
		 hm.put("event","event");
		 
		 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"saveagentsettings.jsp","null","agent details are :"+hm,null);
	
		  
		  status=F2FEventDB.updateAgentSettings(hm);
		  }
		  else
		  {
		  HashMap hm=new HashMap();
			hm.put("tagline",tagline);
			hm.put("description",description);
			hm.put("commissiontype",commissiontype);
			if("%".equals(commissiontype))
			hm.put("salecommission",(Integer.parseInt(salecommission)*0.01)+"");
			else
			hm.put("salecommission",fixedamount);
			hm.put("saleslimit",saleslimit);
			hm.put("approvaltype",approvaltype);
			hm.put("terms_conditions",terms_conditions);
			hm.put("header",header);
			hm.put("showagents",showagents);
			hm.put("groupid",groupid);
			hm.put("event","event");
			status=F2FEventDB.insertAgentSettings(hm);}
		 
	     	
		 
		 }else if ("edit".equals(request.getParameter("foroperation"))){
		
		 HashMap hm=new HashMap();
		 	hm.put("tagline",tagline);
			hm.put("description",description);
			hm.put("commissiontype",commissiontype);
		        if("%".equals(commissiontype))
		        hm.put("salecommission",(Integer.parseInt(salecommission)*0.01)+"");
		        else
			hm.put("salecommission",fixedamount);
			hm.put("saleslimit",saleslimit);
			hm.put("approvaltype",approvaltype);
			hm.put("terms_conditions",terms_conditions);
			hm.put("header",header);
			hm.put("showagents",showagents);
			hm.put("setid",request.getParameter("setid"));
			hm.put("event","event");
		 EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"saveagentsettings.jsp","null","agent details are :"+hm,null);
		   status=F2FEventDB.updateAgentSettings(hm); 			
		 }
	}
}

String config_id=F2FEventDB.getVal(F2FEventDB.configIdVal_Query,request.getParameter("GROUPID"));
status=DbUtil.executeUpdateQuery("delete from config where config_id=? and name='event.enable.agent.settings'",new String [] {config_id});
status=DbUtil.executeUpdateQuery(F2FEventDB.Insert_Config_Query,new String [] {config_id,eveenable});
%>

<%
EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,"saveagentsettings.jsp","null","GROUPID value is  :"+groupid,null);
response.sendRedirect("/eventbeeticket/done.jsp?GROUPID="+groupid+"&isedit="+foroperation);
%>

