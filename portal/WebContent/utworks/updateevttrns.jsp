<%@ page import="org.json.*,com.eventbee.general.*" %>
<%@ page import="java.util.*"%>

<%!
public String GET_TID_EID="select tid,eventid from event_reg_transactions order by tid,eventid";
public String GET_TRNRICKETS_INFO="select ticketid,ticket_groupid,ticketname,groupname,ticketqty,ticketprice,discount,ticketstotal from transaction_tickets where tid=? and eventid=? ";
public String EVT_REG_TRNS_UPDATE="update event_reg_transactions set current_tickets=? where tid=? and eventid =?";
DBManager dbmanager=new DBManager();


public  Vector getTidEventid(){
Vector v= new Vector();

StatusObj stobj=dbmanager.executeSelectQuery(GET_TID_EID,new String[]{});
	if(stobj.getStatus()){
		for(int i=0;i<stobj.getCount();i++){
			HashMap hm=new HashMap();
			String tid=dbmanager.getValue(i,"tid","");
			hm.put("tid",tid);
			String eventid=dbmanager.getValue(i,"eventid","");
			hm.put("eventid",eventid);
			v.addElement(hm);
			
		}
	}
	return v;
}

public Vector getTrnTicketsInfo(String tid,String eventid){
Vector v= new Vector();
DBManager dbmanager=new DBManager();
StatusObj stobj=dbmanager.executeSelectQuery(GET_TRNRICKETS_INFO,new String[]{tid,eventid});
	if(stobj.getStatus()){
		for(int i=0;i<stobj.getCount();i++){
			
			
			HashMap hm=new HashMap();
			String ticketid=dbmanager.getValue(i,"ticketid","");
			hm.put("ticketid",ticketid);
			String ticketname=(String)dbmanager.getValue(i,"ticketname","");
			hm.put("ticketname",ticketname);
			String price=dbmanager.getValue(i,"ticketprice","");
			hm.put("price",price);
			String qty=dbmanager.getValue(i,"ticketqty","");
			hm.put("qty",qty);
			String discount=dbmanager.getValue(i,"discount","");
			hm.put("discount",discount);
			String tktgroupid=dbmanager.getValue(i,"ticket_groupid","");
			hm.put("tktgroupid",tktgroupid);
			String groupname=dbmanager.getValue(i,"groupname","");
			hm.put("groupname",groupname);
			String ticketstotal=dbmanager.getValue(i,"ticketstotal","");
			hm.put("ticketstotal",ticketstotal);
			v.addElement(hm);
			

		}	

	}
	return v;
}
 
%>
<%

Vector tideiddetails=getTidEventid();


 for (int i=0;i<tideiddetails.size();i++){
 		JSONArray ticketsArray=new JSONArray();

  		HashMap hm=(HashMap)tideiddetails.elementAt(i);
		String tid=(String)hm.get("tid");	
	 	String eventid=(String)hm.get("eventid");	    
    		Vector trn_tkt_details=getTrnTicketsInfo(tid,eventid);
    		for(int j=0;j<trn_tkt_details.size();j++)
    		{
    		HashMap hm1=(HashMap)trn_tkt_details.elementAt(j);
    		JSONObject TicketObject=new JSONObject();

		String ticketid= (String)hm1.get("ticketid");
		String ticketname=(String)hm1.get("ticketname");
		String price=(String)hm1.get("price");
		String qty=(String)hm1.get("qty");
		String discount=(String)hm1.get("discount");
		String tktgroupid=(String)hm1.get("tktgroupid");
		String groupname=(String)hm1.get("groupname");
		String ticketstotal=(String)hm1.get("ticketstotal");
		TicketObject.put("gn",groupname);
		TicketObject.put("gid",tktgroupid);
		TicketObject.put("tn",ticketname);
		TicketObject.put("qty",qty);
		TicketObject.put("tid",ticketid);
		TicketObject.put("d",discount);
		TicketObject.put("p",price);
		TicketObject.put("ttotal",ticketstotal);
		ticketsArray.put(TicketObject);

		
    		}
    		String temp=ticketsArray.toString();
    		//if("[]".equals(temp))
    		//out.println(tid);

    		StatusObj statobj=DbUtil.executeUpdateQuery(EVT_REG_TRNS_UPDATE,new String[]{ticketsArray.toString(),tid,eventid});
		out.println(statobj.getStatus());

       }
     
%>