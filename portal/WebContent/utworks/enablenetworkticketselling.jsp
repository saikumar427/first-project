<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.f2f.F2FEventDB" %>

<%!

/*

This is the utility provided for Enabling Network Ticketselling for Active Events

*/

String INSERT_GROUP_AGENT_SETTINGS="insert into group_agent_settings (settingid,groupid,commtype,salecommission,saleslimit,created_dt,showagents,enableparticipant,approvaltype,purpose,enablenetworkticketing) values (nextval('group_agent_settingid'),?,'$',0.5,5000,now(),'No','No','Yes','event','Yes')";

%>

<%
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery("select eventid from eventinfo where status='ACTIVE'",null );
	String title="";
	String message="";
	String url="";
	List enabledlist=DbUtil.getValues("select groupid from group_agent_settings",null);
	
	try{
		
		int reccount=statobj.getCount();
		if(statobj !=null && statobj.getStatus()  && reccount>0    ){
			
			for(int i=0;i<reccount;i++){
				String groupid=dbmanager.getValue(i,"eventid",null);
				
				if(!"".equals(groupid)){
					if(!enabledlist.contains(groupid) ){
						StatusObj stobjt=DbUtil.executeUpdateQuery(INSERT_GROUP_AGENT_SETTINGS,new String [] {groupid});
					} 	 		 
				}
			}
			out.println("Total Record Count****==="+reccount);	
		}
			
		
	}catch(Exception e){
		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.DEBUG, "enbalenetworkticketselling.jsp", "service(), e", e.getMessage(), e ) ;
	
	}
%>


