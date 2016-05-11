<%@page import="java.util.List"%>
<%@page import="com.eventbee.general.DbUtil"%>
<%@page import="com.event.dbhelpers.DisplayAttribsDB"%>
<%@page import="com.eventbee.general.StatusObj"%>
<%@page import="com.eventbee.general.DBManager"%>
<%@ include file='/globalprops.jsp' %>
<%@ page import="org.json.JSONObject"%>
<%@page import="java.util.ArrayList"%>
<%
JSONObject fieldListObject=new JSONObject();
JSONObject priorityListData=new JSONObject();
ArrayList<JSONObject> list=new ArrayList<JSONObject>();
String eventId = request.getParameter("eid");
String listsQuery="select list_id,list_name,field1,field2,nooffields from priority_list where eventid=CAST(? AS BIGINT) order by list_id";
DBManager dbmanager=new DBManager();
StatusObj statobj=null;
statobj=dbmanager.executeSelectQuery(listsQuery,new String []{eventId});
int count=statobj.getCount();
if(statobj.getStatus() && count>0){
	for(int k=0;k<count;k++){
		 String list_id=dbmanager.getValue(k,"list_id","");
		 String list_name=dbmanager.getValue(k,"list_name","");
		 String nooffields=dbmanager.getValue(k,"nooffields","");
		 String field1=dbmanager.getValue(k,"field1","");
		 String field2=dbmanager.getValue(k,"field2","");
		 JSONObject listIdNmObject=new JSONObject();
		 listIdNmObject.put("list_id",list_id);
		 listIdNmObject.put("list_name",list_name);
		 listIdNmObject.put("no_of_flds",nooffields);
		 listIdNmObject.put("label1",field1);
		 listIdNmObject.put("label2",field2);
		 list.add(listIdNmObject);
		 JSONObject fieldsObject=new JSONObject();
		 fieldsObject.put("label1",field1);
		 fieldsObject.put("label2",field2);
		 fieldListObject.put(list_id,fieldsObject);
	}
}
String compareTicketsQry="select price_id from price where price_id::text not in (SELECT distinct(regexp_split_to_table(tickets, ',')) AS split_tickets FROM priority_list where eventid=?) and evt_id=CAST(? AS BIGINT)";
List tickets=DbUtil.getValues(compareTicketsQry,new String []{eventId,eventId});
if(tickets!=null && tickets.size()>0) priorityListData.put("skip_btn_req","Y");
else priorityListData.put("skip_btn_req","N");
priorityListData.put("list_labels",fieldListObject);
priorityListData.put("list_data",list);
priorityListData.put("PriorityRegWordings",DisplayAttribsDB.getAttribValues(eventId,"RegFlowWordings"));
//System.out.println("priorityListData: "+priorityListData);
out.println(priorityListData);
%>
