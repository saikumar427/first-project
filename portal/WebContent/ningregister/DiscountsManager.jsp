<%@ page import="java.util.HashMap,java.util.ArrayList"%>
<%@ page import="com.eventbee.general.formatting.*"%>
<%@ page import="com.eventbee.general.*"%>
<%!
public class DiscountsManager{
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
ArrayList getTickets(String discountcode, String eventid,String discount,String discounttype){
double newprice=0;
double discountamount=0;
String query="select price_id,ticket_type,ticket_price,isdonation from price where evt_id=? and  now() between start_date+cast(cast(starttime as text) as time ) and (end_date+cast(cast(endtime as text) as time )) and max_ticket>sold_qty ";
ArrayList Discountpriceids=getDiscountPriceIds(eventid,discountcode);
ArrayList ticketList=new ArrayList();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(query,new String []{eventid});
if(sb.getStatus() && sb.getCount()>0){
for(int i=0;i<sb.getCount();i++)
{
HashMap  hm=new HashMap();
String price=db.getValue(i,"ticket_price","");
String finalprice=price;
String ticketdiscount=discount;
String ticketid=db.getValue(i,"price_id","");
if(Discountpriceids.contains(ticketid)){
if("PERCENTAGE".equals(discounttype))
discountamount=Double.parseDouble(price)*Double.parseDouble(discount)/100;
else
discountamount=Double.parseDouble(discount);
newprice=Double.parseDouble(price)-discountamount;
if(newprice<0){
newprice=0.00;
discountamount=Double.parseDouble(price);
}
finalprice=Double.toString(newprice);
}
hm.put("ticketid",db.getValue(i,"price_id",""));
hm.put("price",CurrencyFormat.getCurrencyFormat("",price,true));
hm.put("discount",CurrencyFormat.getCurrencyFormat("",discountamount+"",true));
hm.put("final_price",CurrencyFormat.getCurrencyFormat("",finalprice,true));
hm.put("isdonation",db.getValue(i,"isdonation",""));

ticketList.add(hm);
}
}
return ticketList;
}

public HashMap getDiscountInfo(String discountcode, String eid, String tid){

	String discountMsg="";
	String discountcodeapplied="";
	HashMap discountinfomap = new HashMap();
	String discount="0";
	String discounttype="ABSOLUTE";
	HashMap discountsMap=getDiscountDetails(discountcode,eid);
	
	if(discountsMap!=null&&discountsMap.size()>0){
	discount=(String)discountsMap.get("discount");
	discounttype=(String)discountsMap.get("discounttype");
	String couponcount=DbUtil.getVal("select sum(ticketqty) from transaction_tickets tt,event_reg_transactions et where et.eventid=tt.eventid and et.eventid=? and et.discountcode=? and tt.discount>0 and et.tid=tt.tid",new String[]{eid,discountcode});
	String dicountcount=DbUtil.getVal("select maxcount from coupon_codes where  couponcode=? and couponid in(select couponid from coupon_master where groupid=?) ",new String[]{discountcode,eid});
	int completedDiscountsCount=0;
	int availableDiscounts=0;
	try{
	completedDiscountsCount=Integer.parseInt(couponcount);
	availableDiscounts=Integer.parseInt(dicountcount);
	}
	catch(Exception e){
	completedDiscountsCount=0;
	}
	if(completedDiscountsCount>availableDiscounts){
	discountMsg="Applied code is Unavailable";
	}else{
		ArrayList eventTickets=getTickets(discountcode, eid,discount,discounttype);
		if(eventTickets!=null&&eventTickets.size()>0){
		discountcodeapplied=discountcode;
		discountMsg="Applied";
		discountinfomap.put("discountedtickets", eventTickets);
	}
	}
	}else{
		discountMsg="Invalid Discount code";
	}
	DbUtil.executeUpdateQuery("update event_reg_details set discountcode=? where tid=? and eventid=?",new String[]{discountcodeapplied,tid,eid});
	discountinfomap.put("message", discountMsg);
	return discountinfomap;
}


HashMap getDiscountDetails(String code,String groupid){
String query="select discount,discounttype from coupon_master where couponid in (select couponid from coupon_codes where couponcode=?) and groupid=?";
HashMap discountsMap=new HashMap();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(query,new String[]{code,groupid});
if(sb.getStatus()){
discountsMap.put("discounttype",db.getValue(0,"discounttype",""));
discountsMap.put("discount",db.getValue(0,"discount",""));

}
return discountsMap;
}


}
%>