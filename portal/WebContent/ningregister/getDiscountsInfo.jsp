<%!
ArrayList getDiscountPriceIds(String eid,String discountcode){
String query="select price_id from coupon_ticket  where couponid in(select couponid from coupon_master where couponid in (select couponid from coupon_codes where couponcode=?) and groupid=?)";
ArrayList priceIdsList=new ArrayList();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(query,new String []{discountcode,eid});
if(sb.getStatus()){
for(int i=0;i<sb.getCount();i++){
priceIdsList.add(db.getValue(i,"price_id",""));
}
}
return priceIdsList;
}
ArrayList getTickets(String eventid){
String query="select price_id,ticket_type,ticket_price from price where evt_id=? and  now() between start_date+cast(cast(starttime as text) as time ) and (end_date+cast(cast(endtime as text) as time )) and max_ticket>sold_qty ";
ArrayList ticketList=new ArrayList();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(query,new String []{eventid});
if(sb.getStatus()){
for(int i=0;i<sb.getCount();i++)
{
HashMap  hm=new HashMap();
hm.put("ticketid",db.getValue(i,"price_id",""));
hm.put("price",db.getValue(i,"ticket_price",""));
ticketList.add(hm);
}
}
return ticketList;
}
%>