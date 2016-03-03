<?xml version="1.0" encoding="UTF-8"?>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>

<%!

Vector getTicketDetails(String groupid)
{

String query="select price_id,ticket_type,ticket_price,isdonation from price where evt_id=? and  now() between start_date+cast(cast(starttime as text) as time ) and (end_date+cast(cast(endtime as text) as time )) and max_ticket>sold_qty ";

Vector vec=new Vector();
HashMap hm=new HashMap();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(query,new String []{groupid});
if(sb.getStatus()){
for(int i=0;i<sb.getCount();i++)
{
hm=new HashMap();
hm.put("ticket",db.getValue(i,"price_id",""));
hm.put("price",db.getValue(i,"ticket_price",""));
hm.put("type",db.getValue(i,"ticket_type",""));
hm.put("donation",db.getValue(i,"isdonation","No"));

vec.add(hm);
}

}

return vec;
}


HashMap getTicketDiscounts(String groupid,String code)
{
String query="select price_id from coupon_ticket  where couponid in(select couponid from coupon_master where couponid in (select couponid from coupon_codes where couponcode=?) and groupid=?)";
HashMap hmp=new HashMap();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(query,new String []{code,groupid});
if(sb.getStatus()){
for(int i=0;i<sb.getCount();i++)
{
hmp.put(db.getValue(i,"price_id",""),"");
}

}
return hmp;
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

%>

<%
String groupid=request.getParameter("GROUPID");
String code=request.getParameter("code");
String isnew=request.getParameter("isnew");
if(code==null||"".equals(code)||"null".equals(code)){
code=(String)session.getAttribute("discountcode_"+groupid);
isnew="yes";
}

String tickettype="";
String price="";
double newprice=0.0;
String ticketid="";
String s="";
StringBuffer sb=null;
String newprice1="";
int count=0;
String discount="0";
String discountstype=null;
double discountamount=0;
HashMap discountsMap=getDiscountDetails(code,groupid);
String couponcount=DbUtil.getVal("select sum(ticketqty) from transaction_tickets tt,event_reg_transactions et where et.eventid=tt.eventid and et.eventid=? and et.discountcode=? and tt.discount>0 and tt.tid=et.tid",new String[]{groupid,code});
String dicountcount=DbUtil.getVal("select maxcount from coupon_codes where  couponcode=? and couponid in(select couponid from coupon_master where groupid=?) ",new String[]{code,groupid});

if(!"100000".equals(dicountcount)&&couponcount!=null&&dicountcount!=null){
if(Integer.parseInt(dicountcount)>Integer.parseInt(couponcount))
count=Integer.parseInt(dicountcount)-Integer.parseInt(couponcount);
else
count=0;
}
else
count=1;
 if(!"yes".equals(isnew)){

 s=(String)session.getAttribute("CouponContent_"+groupid);

 if(s!=null)
  sb=new StringBuffer(s);
  else
  sb=new StringBuffer("");
 
}



Vector v=getTicketDetails(groupid);

if(sb==null||"".equals(sb)){
sb=new StringBuffer();

if(discountsMap!=null&&discountsMap.size()>0&&count>0){
discount=(String)discountsMap.get("discount");
discountstype=(String)discountsMap.get("discounttype");
session.setAttribute("discountcode_"+groupid,code);

sb.append("<tickets codestatus='success'>");
}
else if(discountsMap!=null&&discountsMap.size()>0&&count==0){

sb.append("<tickets codestatus='Not Available'>");
}


else{
session.setAttribute("discountcode_"+groupid,code);
sb.append("<tickets codestatus='Invalid'>");
}
HashMap hmp1=getTicketDiscounts(groupid,code);
for(int i=0;i<v.size();i++){
HashMap hmp2=(HashMap)v.elementAt(i);
ticketid=(String)hmp2.get("ticket");
price=(String)hmp2.get("price");
tickettype=(String)hmp2.get("type");
String isdonation=(String)hmp2.get("donation");
if("Public".equals(tickettype))
tickettype="publicTickets";
else
tickettype="Optional";
sb.append("<ticket id='"+ticketid+"' type='"+tickettype+"' price='"+CurrencyFormat.getCurrencyFormat("",price,true)+"' isdonation='"+isdonation+"'");
if(hmp1.get(ticketid)!=null)
{
if("PERCENTAGE".equalsIgnoreCase(discountstype)){
discountamount=(Double.parseDouble(price)*Double.parseDouble(discount)/100);
}
else{
discountamount=Double.parseDouble(discount);
}

newprice=Double.parseDouble(price)-discountamount;

if(newprice<0)
newprice=0.0;
newprice1=Double.toString(newprice);
sb.append(" discount='"+discountamount+"' newprice='"+CurrencyFormat.getCurrencyFormat("",newprice1,true)+"'");

}
sb.append("/>");

}

sb.append("</tickets>");

}

session.setAttribute("CouponContent_"+groupid,sb.toString());
out.print(sb.toString());
%>
