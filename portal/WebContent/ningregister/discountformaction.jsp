<%@ page import="org.json.*,java.util.*"%>
<%@ page import="com.eventbee.general.*,com.eventbee.general.formatting.*"%>
<%@ include file="getDiscountsInfo.jsp" %>

<%
String tid=request.getParameter("tid");
String discountcode=request.getParameter("discountcode");
String eid=request.getParameter("eid");
String discountMsg="";
String finalprice="0";
double newprice=0;
String discount=DbUtil.getVal("select discount from coupon_master where couponid in (select couponid from coupon_codes where couponcode=?) and groupid=?",new String[]{discountcode,eid});
JSONObject discountsObject=new JSONObject();
JSONObject discountsMsgObject=new JSONObject();
JSONArray discountsArray=new JSONArray();
if(discount!=null&&!"".equals(discount)){
String couponcount=DbUtil.getVal("select count(*) from attendeeticket where eventid=? and couponcode=? ",new String[]{eid,discountcode});
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
}
else{
ArrayList Discountpriceids=getDiscountPriceIds(eid,discountcode);
ArrayList eventTickets=getTickets(eid);
if(eventTickets!=null&&eventTickets.size()>0){
discountMsg="Applied";
DbUtil.executeUpdateQuery("update event_reg_details set discountcode=? where tid=? and eventid=?",new String[]{discountcode,tid,eid});
for(int i=0;i<eventTickets.size();i++){
JSONObject DiscounMap =new JSONObject();
HashMap hm=(HashMap)eventTickets.get(i);
String ticketid=(String)hm.get("ticketid");
String price=(String)hm.get("price");
String ticketdiscount=discount;
if(Discountpriceids.contains(ticketid)){
newprice=Double.parseDouble(price)-Double.parseDouble(discount);
if(newprice<0){
newprice=0.00;
ticketdiscount=price;
}
finalprice=Double.toString(newprice);
}
else
finalprice=price;
DiscounMap.put("ticketid",ticketid);
DiscounMap.put("final_price",CurrencyFormat.getCurrencyFormat("",finalprice,true));
DiscounMap.put("discount",CurrencyFormat.getCurrencyFormat("",ticketdiscount,true));
DiscounMap.put("price",CurrencyFormat.getCurrencyFormat("",price,true));
discountsArray.put(DiscounMap);
}
}
}
}
else
{
discountMsg="Invalid Discount code";
}
discountsMsgObject.put("IsCouponsExists","Y");
discountsMsgObject.put("discountapplied","Y");
discountsMsgObject.put("discountmsg",discountMsg);
discountsMsgObject.put("discountcode",discountcode);
discountsObject.put("discountedprices",discountsArray);
discountsObject.put("discounts",discountsMsgObject);
out.println(discountsObject.toString());

%>