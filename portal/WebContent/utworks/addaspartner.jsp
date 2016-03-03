<%@ page import="java.util.*,com.eventbee.general.*" %>
<%@ page import="com.eventbee.eventpartner.PartnerDB" %>

<%!

/*

This is the utility provided for exisitng user join as Eventbee Partner

*/

String INSERTQ="insert into group_partner (partnerid,title,message,userid,url,status,created_at) values (nextval('group_partnerid'),?,?,?,?,'Active',now())";
%>

<%
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery("select user_id from authentication where acct_status=1 and role_id=-100",null );
	String title="";
	String message="";
	String url="";
	List partnerlist=DbUtil.getValues("select userid from group_partner",null);
	
	try{
		int reccount=statobj.getCount();
		
		if(statobj !=null && statobj.getStatus()  && reccount>0    ){
			
			for(int i=0;i<reccount;i++){
				String userid=dbmanager.getValue(i,"user_id",null);
				
				if(!"".equals(userid)){
					if(!partnerlist.contains(userid) ){
						StatusObj stobjt=DbUtil.executeUpdateQuery(INSERTQ,new String [] {title,message,userid,url});

						
					}
				} 	 		 
			}
			
			out.println("Total Record Count****==="+reccount);	
		
		
		}
		
		
		
	}catch(Exception e){
		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "addaspartner.jsp", "service(), e", e.getMessage(), e ) ;
	
	}
%>


