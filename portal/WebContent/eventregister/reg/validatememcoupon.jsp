<?xml version="1.0" encoding="UTF-8"?>
<%@ page import="com.eventbee.general.*"%>
<%@ page import="java.util.*,com.eventbee.authentication.*"%>
<%@ page import="com.eventbee.general.formatting.*"%>

<%!

Vector getTicketDetails(String groupid)
{

String query="select price_id,ticket_type,ticket_price from price where evt_id=? and  now() between start_date+cast(cast(starttime as text) as time ) and (end_date+cast(cast(endtime as text) as time )) ";

Vector vec=new Vector();
HashMap hm=new HashMap();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(query,new String []{groupid});
if(sb.getStatus()){
for(int i=0;i<sb.getCount();i++)
{
hm=new HashMap();
hm.put("ticket_"+i,db.getValue(i,"price_id",""));
hm.put("price_"+i,db.getValue(i,"ticket_price",""));
hm.put("type_"+i,db.getValue(i,"ticket_type",""));
vec.add(hm);
}

}

return vec;
}


HashMap getDiscounts(String couponid)
{
String query="select price_id from coupon_ticket  where couponid=?";
HashMap hmp=new HashMap();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(query,new String []{couponid});
if(sb.getStatus()){
for(int i=0;i<sb.getCount();i++)
{
hmp.put(db.getValue(i,"price_id",""),"");
}

}
return hmp;
}




%>
<%
String groupid=request.getParameter("GROUPID");
String username=request.getParameter("username");
String password=request.getParameter("password");

String userid="";
String validmem="";
String couponid=DbUtil.getVal("select couponid from coupon_master where groupid=? and coupontype='Member'",new String []{groupid});
String clubid="";
String discount="";
Vector v=null;
String newprice1="";
String tickettype="";
Authenticate au=null;
String price="";
double newprice=0.0;
String ticketid="";
StringBuffer sb=null; 
String s="";
 if(!"yes".equals(request.getParameter("isnew"))){
 s=(String)session.getAttribute("MemCouponContent_"+groupid);
 if(s!=null)
 sb=new StringBuffer(s);
 else
  sb=new StringBuffer("");
 
}
if(username!=null){  
        

	AuthDB authDB=new AuthDB();
	
	au=authDB.authenticatePortalUser(username,password,"13579");
	
	if(au !=null){
                
		
	userid=au.getUserID();
	
	}
	
	validmem=DbUtil.getVal("select 'yes' from club_member where userid=? and clubid in (select clubid from coupon_community where couponid=?)",new String[]{userid,couponid});
	
	discount=DbUtil.getVal("select discount from coupon_master where couponid=? and groupid=?",new String[]{couponid,groupid});
	
	if(sb==null||"".equals(sb)){
	sb=new StringBuffer();

	if("yes".equals(validmem)){
	sb.append("<tickets codestatus='success'>");
	}else{
	sb.append("<tickets codestatus='Invalid'>");
}
	v=getTicketDetails(groupid);
        HashMap hmp1=getDiscounts(couponid);
        for(int i=0;i<v.size();i++){
	 HashMap hmp2=(HashMap)v.elementAt(i);
	 ticketid=(String)hmp2.get("ticket_"+i);
	price=(String)hmp2.get("price_"+i);
	tickettype=(String)hmp2.get("type_"+i);
	if("Public".equals(tickettype))
         tickettype="publicTickets";
	 sb.append("<ticket id='"+ticketid+"' type='"+tickettype+"' price='"+CurrencyFormat.getCurrencyFormat("",price,true)+"'");
	 if(hmp1.get(ticketid)!=null)
	 {
	 newprice=Double.parseDouble(price)-Double.parseDouble(discount);
	 if(newprice<0)
	 newprice=0.0;
	 newprice1=Double.toString(newprice);
	sb.append(" discount='"+discount+"' newprice='"+CurrencyFormat.getCurrencyFormat("",newprice1,true)+"'");

	 }
	 sb.append("/>");
	 
	 }
	 
	 sb.append("</tickets>");
	 }
	
 
   session.setAttribute("MemCouponContent_"+groupid,sb.toString());
 
}

 out.print(sb.toString());

%>