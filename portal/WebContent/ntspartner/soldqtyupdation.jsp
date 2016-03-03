<%!
static String SOLDQTY_UPDATE="update price set sold_qty=sold_qty+? where price_id=? and evt_id=?";
public void updateSoldQty(String tid,String eventid,String factor){
DBManager dbmanager=new DBManager();
StatusObj statobj=null;
String TRN_TICKETS_SELECT_QUERY="select ticketid,sum(ticketqty) as qty from transaction_tickets where tid=? and eventid=? group by ticketid";
statobj=dbmanager.executeSelectQuery(TRN_TICKETS_SELECT_QUERY,new String []{tid,eventid});
int count=statobj.getCount();
if(statobj.getStatus()){
for(int k=0;k<count;k++){
	String ticketid=(String)dbmanager.getValue(k,"ticketid","");	
	String qty=(String)dbmanager.getValue(k,"qty","");	
	int qtytemp=Integer.parseInt(qty)*Integer.parseInt(factor);
	String temp =Integer.toString(qtytemp);
	DbUtil.executeUpdateQuery(SOLDQTY_UPDATE,new String[]{temp,ticketid,eventid});
	} //end for()
	} //end if()
} //end method()
%>