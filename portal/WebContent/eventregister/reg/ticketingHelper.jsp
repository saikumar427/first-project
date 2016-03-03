<%@ page import="com.eventbee.event.*,com.eventbee.event.ticketinfo.*"%>
<%@ page import="com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.general.GenUtil"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.survey.*"%>
<%@ page import="com.eventbee.creditcard.*"%>
<%@ page import="com.eventbee.useraccount.*" %>


<%!


String showRegiteredTickets(EventRegisterBean jBean){

StringBuffer sb=new StringBuffer();
HashMap oldtransdetails=jBean.getTransactionInfo();
Vector Tickets=null;
if(oldtransdetails!=null)
{
Tickets=(Vector)oldtransdetails.get("Tickets");
}

if(Tickets!=null&&Tickets.size()>0){
sb.append("<table width='95%' ><tr><td><table width='100%'><tr height='15'><td></td></tr>");
for(int i=0;i<Tickets.size();i++){
HashMap ticketMap=(HashMap)Tickets.elementAt(i);
String base="evenbase";

if(i%2==0)
base="evenbase";
else
base="oddbase";

String tprice=(String)ticketMap.get("ticketprice");
String qty=(String)ticketMap.get("ticketqty");
double total=Double.parseDouble(tprice)*Integer.parseInt(qty);
sb.append("<tr><td  class='"+base+"'><span class='inform'><table><tr><td><strong>"+ticketMap.get("ticketname")+"</strong></td></tr></table></span></td><td class='"+base+"'><table><tr><td width='10%'><span class='inform'>"+ticketMap.get("ticketqty")+"</span></td><td class='"+base+"' ><span class='inform'>"+CurrencyFormat.getCurrencyFormat("$",""+total,true)+" (Paid)</span></td><td wodth='10%'></td></tr></table></td></tr>");


}

sb.append("</table></td></tr></table>");

}

return sb.toString();

}

HashMap getEventCustomMessages(String eventid){

String query="select loginmsg,signupmsg,description from event_ticket_communities where eventid=?";

DBManager db=new DBManager();

StatusObj sb=db.executeSelectQuery(query,new String[]{eventid});
HashMap hm=new HashMap();
if(sb.getStatus()){
hm.put("loginmsg",db.getValue(0,"loginmsg",""));
hm.put("signupmsg",db.getValue(0,"signupmsg",""));
hm.put("description",db.getValue(0,"description",""));
}
return hm;

}


HashMap getUserCustomMessages(String eventid){

String query="select loginmsg,signupmsg,description from user_communities where userid=(select mgr_id from eventinfo where eventid=?)";

DBManager db=new DBManager();

StatusObj sb=db.executeSelectQuery(query,new String[]{eventid});
HashMap hm=new HashMap();
if(sb.getStatus()){
hm.put("loginmsg",db.getValue(0,"loginmsg",""));
hm.put("signupmsg",db.getValue(0,"signupmsg",""));
hm.put("description",db.getValue(0,"description",""));
}
return hm;

}






HashMap getHubDetails(String eventid){
	DBManager dbmanager=new DBManager();
	HashMap hm=new HashMap();
	StatusObj stob=dbmanager.executeSelectQuery("select c.clubid,clubname from event_communities e,clubinfo c where eventid=? and c.clubid=e.clubid", new String []{eventid});
	if(stob.getStatus()){
		for(int k=0;k<stob.getCount();k++){
			hm.put("clubid",dbmanager.getValue(k,"clubid",""));
			hm.put("clubname",dbmanager.getValue(k,"clubname",""));
		}
	}
	return hm;
}
	
HashMap getMemberTicketIds(String eventid){
	HashMap hm=new HashMap();
	DBManager dbmanager=new DBManager();
	StatusObj st=dbmanager.executeSelectQuery("select price_id from event_communities ec where eventid=?", new String []{eventid});
	if(st.getStatus()){
		for(int k=0;k<st.getCount();k++){
			hm.put(dbmanager.getValue(k,"price_id",""),"Y");
		}
	}
	return hm;
}
HashMap getDonationTicketIds(String eventid){
	HashMap hm=new HashMap();
	DBManager dbmanager=new DBManager();
	StatusObj st=dbmanager.executeSelectQuery("select price_id from price where evt_id=? and isdonation='Yes' ", new String []{eventid});
	if(st.getStatus()){
		for(int k=0;k<st.getCount();k++){
			String price_id=dbmanager.getValue(k,"price_id","");
			hm.put(price_id,price_id);
		}
	}
	return hm;
}

EventTicket[] orderTickets(EventTicket[] tickets,Vector v){	    	
	 EventTicket[] evttkt=new EventTicket[tickets.length];
	EventTicket[] evt=new EventTicket[tickets.length];
	int m=0;
	HashMap hm1=new HashMap();
	if(v.isEmpty()||v==null){
		return tickets;
	}else{	    	
		for(int j=0;j<v.size();j++){
			HashMap  hm=(HashMap)v.elementAt(j);
			String price=(String)hm.get("ticketid");
			String position=(String)hm.get(price);
			//if(hm1.get(price)!=null)
			hm1.put(price,position);
		}	    	
	}	    	
	for(int i=0;i<tickets.length;i++){
		String ticketid=tickets[i].getTicketId();	    	
		if(hm1.containsKey(ticketid)){
			int pos=Integer.parseInt((String)hm1.get(ticketid));
			evttkt[pos-1]=tickets[i];
		}else{
			evt[m]=tickets[i];
			m++;
		}
	}
	for(int q=0;q<m;q++){
		int l=tickets.length-m+q;
		evttkt[l]=evt[q];
	}
	return evttkt;	    	
}

Vector getReqGroupDetails(String evtid,EventTicket[] evt1,String tickettype){
	Vector vec=new Vector();
	HashMap pm=new HashMap();
	for(int p=0;p<evt1.length;p++){
		pm.put(evt1[p].getTicketId(),"");
	}
	DBManager dbmanager=new DBManager();
	StatusObj st=dbmanager.executeSelectQuery("select groupname,description,price_id,g.position from group_tickets g,event_ticket_groups e where e.ticket_groupid=g.ticket_groupid and e.eventid=? and e.tickettype=? order by e.position,g.position ",new String []{evtid,tickettype});
	if(st.getStatus()){
		int a=0;
		for(int k=0;k<st.getCount();k++){
			if(pm.containsKey(dbmanager.getValue(k,"price_id",""))){
				HashMap hm=new HashMap ();
				hm.put("ticketid",dbmanager.getValue(k,"price_id",""));
				hm.put("name",dbmanager.getValue(k,"groupname",""));
				hm.put("description",dbmanager.getValue(k,"description",""));
				a++;
				hm.put(dbmanager.getValue(k,"price_id",""),String.valueOf(a));
				vec.add(hm);
			}
		}
	}
	return vec;
}
%>

