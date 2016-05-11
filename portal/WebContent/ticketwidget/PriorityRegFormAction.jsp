<%@page import="com.eventbee.cachemanage.CacheManager"%>
<%@page import="java.util.HashMap"%>
<%@page import="com.eventbee.general.GenUtil"%>
<%@page import="com.eventbee.general.DateUtil"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="org.json.JSONObject"%>
<%@page import="com.eventbee.general.EncodeNum"%>
<%@page import="com.eventbee.general.DBManager"%>
<%@page import="com.eventbee.general.StatusObj"%>
<%@ include file='/globalprops.jsp' %>
<%!
JSONObject getPriorityRegToken(String eventId,String listId,String prioKey1, String prioKey2,String eventdate){
	JSONObject resData = new JSONObject();
	try{
		String priority_reg_seq=DbUtil.getVal("select nextval('seq_priority_reg')", new String[] {});
		String priRegToken = "PR"+EncodeNum.encodeNum(priority_reg_seq).toUpperCase();
		//String refkey_update_qry="update priority_list_records set priority_token=? where eventid=CAST(? as BIGINT) and list_id=? and lower(id)=? and lower(password)=?";
		//DbUtil.executeUpdateQuery(refkey_update_qry,new String[] {priRegToken,eventId,listId,prioKey1.trim().toLowerCase(),prioKey2.trim().toLowerCase()});
		HashMap configMap=(HashMap)CacheManager.getData(eventId, "eventinfo").get("configmap");
		String timeout=GenUtil.getHMvalue(configMap,"priority.reg.timeout","30");
		System.out.println("priority.reg.timeout: "+timeout);
		String insertQry="insert into priority_reg_transactions(eventid,list_id,field1,field2,pri_token,eventdate,status,expires_at,created_at) values(CAST(? AS BIGINT),?,?,?,?,?,'Pending',to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS')+ interval '"+timeout+" minutes',to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'))";
		DbUtil.executeUpdateQuery(insertQry,new String[] {eventId,listId,prioKey1.trim().toLowerCase(),prioKey2.trim().toLowerCase(),priRegToken,eventdate,DateUtil.getCurrDBFormatDate(),DateUtil.getCurrDBFormatDate()});
		resData.put("status", "success");
		resData.put("prireg_token", priRegToken);
		resData.put("pri_list_id", listId);
	}catch(Exception e){
		
	}
	return resData;
}

%>
<%
	String eventId = request.getParameter("eid");
	String listId = request.getParameter("listId");
	String prioKey1 = request.getParameter("prioritykey1");
	String prioKey2 = request.getParameter("prioritykey2");
	String noofflds = request.getParameter("noofflds");
	String eventdate=request.getParameter("evtdate");
	JSONObject resData = new JSONObject();
	System.out.println("!!! prioKey1: "+prioKey1+" prioKey2: "+prioKey2+" noofflds: "+noofflds+" eventdate: "+eventdate+" eventId: "+eventId+" listId: "+listId);
	try {
		//String query = "insert into priority_reg_track(eventid,listid,field1,field2,created_at) values (?, ?, ?, ?, now())";
		//DbUtil.executeUpdateQuery(query,new String[] {eventId,listId,prioKey1.trim().toLowerCase(),prioKey2.trim().toLowerCase()});
		String limitTypeQry ="select limit_type from priority_list where eventid=CAST(? as BIGINT) and list_id=?";
		String limit_type=DbUtil.getVal(limitTypeQry, new String[]{eventId,listId});
		if(limit_type==null || "".equals(limit_type)) limit_type="UNLIMIT";
		if(!"UNLIMIT".equals(limit_type))//deleting only limited list pending transactions if expires. limit varies for each list.
			DbUtil.executeUpdateQuery("delete from priority_reg_transactions where expires_at < (select now()) and status='Pending' and eventid=? and list_id=?",new String[]{eventId,listId});
		
		if(prioKey1==null) prioKey1="";
		if(prioKey2==null) prioKey2="";
		if("1".equals(noofflds)) prioKey2="undefined";
		String key1=prioKey1.trim().toLowerCase();
		String key2=prioKey2.trim().toLowerCase();
		
		//String statusQry="select 'yes' from priority_list_records where eventid=CAST(? as BIGINT) and list_id=? and lower(id)='"+key1+"'";
		
		//if("2".equals(noofflds))
		String statusQry="select 'yes' from priority_list_records where eventid=CAST(? as BIGINT) and list_id=? and lower(id)='"+key1+"' and lower(password)='"+key2+"'";
		
		String status=DbUtil.getVal(statusQry, new String[] {eventId,listId});
		
		
		if("".equals(status) || status==null){
			resData.put("status", "fail");
			resData.put("reason", getPropValue("pri.reg.invalid.errmsg",eventId));
		}else{
			if("UNLIMIT".equals(limit_type)){
				resData=getPriorityRegToken(eventId,listId,prioKey1,prioKey2,eventdate);
				resData.put("limit_type", limit_type);
			}else{
				String checkStatusQry="";
				if(!"".equals(eventdate) && eventdate!=null)
					checkStatusQry="select count(*) from priority_reg_transactions where eventid=CAST(? as BIGINT) and list_id=? and lower(field1)='"+key1+"' and lower(field2)='"+key2+"' and eventdate='"+eventdate+"' and status in('Pending','Completed')";
				else
					checkStatusQry="select count(*) from priority_reg_transactions where eventid=CAST(? as BIGINT) and list_id=? and lower(field1)='"+key1+"' and lower(field2)='"+key2+"' and status in('Pending','Completed')";
				String checkStatusCount=DbUtil.getVal(checkStatusQry, new String[] {eventId,listId});
				try{
					if(Integer.parseInt(limit_type)==1 && Integer.parseInt(checkStatusCount)==1){
						resData.put("status", "fail");	
						resData.put("reason", getPropValue("pri.reg.limit.reg.single.errmsg",eventId));
					}else if(Integer.parseInt(limit_type)==Integer.parseInt(checkStatusCount)){
						resData.put("status", "fail");	
						resData.put("reason", getPropValue("pri.reg.limit.reg.mul.errmsg",eventId));
					}else if(Integer.parseInt(limit_type)>Integer.parseInt(checkStatusCount)){
						resData=getPriorityRegToken(eventId,listId,prioKey1,prioKey2,eventdate);
						resData.put("limit_type", limit_type);
					}else{
						resData.put("status", "fail");	
						resData.put("reason", getPropValue("pri.reg.limit.reg.mul.errmsg",eventId));
					}
				}catch(Exception e){
					System.out.println("Exception in PriorityRegFormAction.jsp ERROR: "+e.getMessage());
					resData.put("status", "fail");	
					resData.put("reason", getPropValue("pri.reg.limit.reg.mul.errmsg",eventId));
				}
			}
		}
	}catch (Exception e) {
		resData.put("status", "fail");
		resData.put("reason", getPropValue("pri.reg.invalid.errmsg",eventId));
	}
	System.out.println(resData.toString(2));
	out.println(resData.toString(2));
%>