package com.eventregister;
import java.util.ArrayList;
import java.util.HashMap;
import com.eventbee.general.formatting.*;
import com.eventbee.general.*;

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
String query="select price_id,ticket_type,ticket_price,isdonation from price where evt_id=cast(? as numeric) ";
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
hm.put("haveDiscount","yes");
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
else hm.put("haveDiscount","no");
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

public HashMap getDiscountInfo(String discountcode, String eid, String tid,HashMap DiscountLabels){
     String  discountfalg="true";

	String discountMsg="";
	String discountcodeapplied="";
	HashMap discountinfomap = new HashMap();
	String discount="0";
	String discounttype="ABSOLUTE";
	int remcnt=0;
	if(discountcode!=null){discountcode=discountcode.trim();}
	HashMap discountsMap=getDiscountDetails(discountcode,eid);
	if(discountsMap!=null&&discountsMap.size()>0){
	discount=(String)discountsMap.get("discount");
	discounttype=(String)discountsMap.get("discounttype");
	String copid=DbUtil.getVal("select a.couponid from coupon_master a,coupon_codes b where a.couponid=b.couponid and a.groupid=? and b.couponcode=?",new String[]{eid,discountcode} );
	String dicountcount=DbUtil.getVal("select maxcount from coupon_codes where  couponcode=? and couponid=? ",new String[]{discountcode,copid});
	String ecachcode_limit=DbUtil.getVal("select eachcode_limit from coupon_master where couponid=? and groupid=?",new String[]{copid,eid} );
	if(ecachcode_limit==null)ecachcode_limit="N";
	String totcurrentcouponcounthold=null;
	String couponcount="0";
	
	if(copid!=null && "N".equals(ecachcode_limit))
	{ //couponcount=DbUtil.getVal("select sum(ticketqty) from transaction_tickets tt,event_reg_transactions et where et.eventid=tt.eventid and et.eventid=? and et.discountcode in(select couponcode from coupon_codes where couponid=?) and tt.discount>0 and et.tid=tt.tid",new String[]{eid,copid});
		
	  couponcount=DbUtil.getVal("select sum(ticketqty) from transaction_tickets tt,event_reg_transactions et where et.tid=tt.tid and tt.eventid=? and et.discountcode in(select couponcode from coupon_codes where couponid=?) and tt.discount>0", new String[]{eid,copid});
	  totcurrentcouponcounthold=DbUtil.getVal("select sum(totticketsqty) from event_reg_details_temp where tid in(select tid from event_reg_locked_tickets where eventid=?) and discountcode in(select couponcode from coupon_codes where couponid=?) ",new String[]{eid,copid});
	}
	else
	{ 
	  //couponcount=DbUtil.getVal("select sum(ticketqty) from transaction_tickets tt,event_reg_transactions et where et.eventid=tt.eventid and et.eventid=? and et.discountcode=? and tt.discount>0 and et.tid=tt.tid",new String[]{eid,discountcode});
	  couponcount=DbUtil.getVal("select sum(ticketqty) from transaction_tickets tt,event_reg_transactions et where et.tid=tt.tid and tt.eventid=? and et.discountcode=? and tt.discount>0",new String[]{eid,discountcode});
	  totcurrentcouponcounthold=DbUtil.getVal("select sum(totticketsqty) from event_reg_details_temp where tid in(select tid from event_reg_locked_tickets where eventid=?) and discountcode=?",new String[]{eid,discountcode});
	}
	
	String nototcurrentcouponcounthold=DbUtil.getVal("select sum(case when locked_qty=0 then 1 else locked_qty end) from event_reg_locked_tickets where eventid=? and ticketid  not in(select price_id from coupon_ticket a,coupon_codes b where a.couponid=b.couponid  and couponcode=?)",new String[]{eid,discountcode});
	//System.out.println("***st*****");
	//System.out.println("couponcount::"+couponcount);
	//System.out.println("totcurrentcouponcounthold::"+totcurrentcouponcounthold);
	//System.out.println("nototcurrentcouponcounthold::"+nototcurrentcouponcounthold);
	    
	if(totcurrentcouponcounthold==null)totcurrentcouponcounthold="0";
	if(nototcurrentcouponcounthold==null)nototcurrentcouponcounthold="0";
	int completedDiscountsCount=0;
	int currentholddiscountCount=0;
	int availableDiscounts=0;
	
	try{
		
	String currentcouponcount=""+(Integer.parseInt(totcurrentcouponcounthold)-Integer.parseInt(nototcurrentcouponcounthold));
	if(currentcouponcount==null)currentcouponcount="0";
	if(couponcount==null)couponcount="0";
	if(dicountcount==null)dicountcount="0";
	
	System.out.println("current_hold:"+currentcouponcount+" sale_count:"+couponcount+" dicountlimitcount:"+dicountcount);
	availableDiscounts=Integer.parseInt(dicountcount);
	completedDiscountsCount=Integer.parseInt(couponcount);
	currentholddiscountCount=Integer.parseInt(currentcouponcount);
	
	//System.out.println("currentholddiscountCount"+currentholddiscountCount);
	//System.out.println("****end****");
	remcnt=availableDiscounts-(completedDiscountsCount+currentholddiscountCount);
	if(remcnt<0){remcnt=0;}

	}
	catch(Exception e){
	completedDiscountsCount=0;
	currentholddiscountCount=0;
	System.out.println("error in discount manager"+e.getMessage());
	}
	//System.out.println("TotalCount"+(completedDiscountsCount+currentholddiscountCount));
	if(!"NO".equals(tid)){
		
		String timeexp="no"; 
    	if("Y".equalsIgnoreCase((String)discountsMap.get("exptype")))
    		timeexp=checkTimeDiffrence(discountsMap);
    	 
    	if("yes".equals(timeexp)){
    		 discountfalg="false";
    		 discountMsg=GenUtil.getHMvalue(DiscountLabels,"event.reg.discount.time.exp.msg","Applied code is Unavailable");
    	}else if(availableDiscounts<(completedDiscountsCount+currentholddiscountCount)){
		   discountfalg="false";
		   discountMsg=GenUtil.getHMvalue(DiscountLabels,"event.reg.discount.not.available.msg","Applied code is Unavailable");
	   }else{
			ArrayList eventTickets=getTickets(discountcode, eid,discount,discounttype);
			if(eventTickets!=null&&eventTickets.size()>0){
			discountcodeapplied=discountcode;
			discountMsg=GenUtil.getHMvalue(DiscountLabels,"event.reg.discount.applied.msg","Applied");
			discountinfomap.put("discountedtickets", eventTickets);
	    }
	   }
    }else{
    	
    	String timeexp="no"; 
    	if("Y".equalsIgnoreCase((String)discountsMap.get("exptype")))
    		timeexp=checkTimeDiffrence(discountsMap);
    	
    	if("yes".equals(timeexp)){
    		 discountfalg="false";
    		 discountMsg=GenUtil.getHMvalue(DiscountLabels,"event.reg.discount.time.exp.msg","Applied code is Unavailable");
    	}else if(availableDiscounts<=(completedDiscountsCount+currentholddiscountCount)){
		 discountfalg="false";
		 discountMsg=GenUtil.getHMvalue(DiscountLabels,"event.reg.discount.not.available.msg","Applied code is Unavailable");
		 }else{
			ArrayList eventTickets=getTickets(discountcode, eid,discount,discounttype);
			if(eventTickets!=null&&eventTickets.size()>0){
			discountcodeapplied=discountcode;
			discountMsg=GenUtil.getHMvalue(DiscountLabels,"event.reg.discount.applied.msg","Applied");
			discountinfomap.put("discountedtickets", eventTickets);
			}
		 }
     }
	
 }else{
	    discountfalg="false";
		discountMsg=GenUtil.getHMvalue(DiscountLabels,"event.reg.discount.invalid.msg","Invalid Discount code");
	}
	
	if("false".equals(discountfalg))
	
	discountinfomap.put("discountfalg", discountfalg);
	if("".equals(discountcode)) discountMsg="";
	discountinfomap.put("message", discountMsg);
	discountinfomap.put("remcnt", remcnt+"");
	return discountinfomap;
}


HashMap getDiscountDetails(String code,String groupid){
String query="select discount,discounttype,exp_date,exp_time,exp_type from coupon_master where couponid in (select couponid from coupon_codes where couponcode=?) and groupid=? ";
HashMap discountsMap=new HashMap();
DBManager db=new DBManager();
StatusObj sb=db.executeSelectQuery(query,new String[]{code,groupid});
if(sb.getStatus()){
discountsMap.put("discounttype",db.getValue(0,"discounttype",""));
discountsMap.put("discount",db.getValue(0,"discount",""));
discountsMap.put("exptype",db.getValue(0,"exp_type","N"));
discountsMap.put("expdate",db.getValue(0,"exp_date",""));
discountsMap.put("exptime",db.getValue(0,"exp_time",""));
}
return discountsMap;
}


String checkTimeDiffrence(HashMap disMap){
	String timeexp="no";
	String time=disMap.get("expdate")+" "+disMap.get("exptime");
	 String timequery="select '"+time+"'<now() ";
	 String val=DbUtil.getVal(timequery,null);
	 if("t".equals(val))
		 timeexp="yes";
return timeexp;
}

}