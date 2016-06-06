
<%@ page import="com.event.dbhelpers.*,com.eventregister.*,com.eventbee.general.*"%>
<%@ page import="java.util.*,java.util.ArrayList,org.json.*"%>
<%!
public HashMap eventLevelCheck(String eid,String tid,String eventdate){
	HashMap result=new HashMap();
	 String limitcount=DbUtil.getVal("select value from config where config_id=(select config_id from eventinfo where eventid=?::integer) and name='event.reg.eventlevelcheck.count'",new String[]{eid});
	 limitcount=limitcount==null?"":limitcount.trim();
	System.out.println("eid::"+eid);
	System.out.println("tid::"+tid);
	System.out.println("eventdate::"+eventdate);
	System.out.println(eid+"limitcount::"+limitcount);
	if("".equals(limitcount))
	 return result;
     
	try{Integer.parseInt(limitcount);
	}catch(Exception e){return result;}
	
	 String query="";
	String params[]=null;	
	
	if("".equals(eventdate))
	    {     query="select  (?::integer -((select COALESCE(sum(locked_qty),0) from         event_reg_locked_tickets where eventid=? and locked_time <=(select locked_time from event_reg_locked_tickets where  tid=? order by locked_time desc limit 1))+(select COALESCE(sum(sold_qty),0) from price where evt_id=?::integer and isdonation='No'))) as re_qty";
		 	   params=new String[]{limitcount,eid,tid,eid};
	   }
	   else
	    {	    query="select  (?::integer -((select COALESCE(sum(locked_qty),0) from event_reg_locked_tickets where eventid=? and eventdate=? and locked_time <=(select locked_time from event_reg_locked_tickets where  tid=? order by locked_time desc limit 1))+(select COALESCE (sum (soldqty),0) from  reccurringevent_ticketdetails where eventid=?::integer and eventdate=? and isdonation='No' ))) as re_qty";			
	         params=new String[]{limitcount,eid,eventdate,tid,eid,eventdate};
       }	
	
	if("".equals(query))	
	return result;
	String reqty=DbUtil.getVal(query,params);
	System.out.println("reqty:::::::"+reqty+"  params::"+ params);
	try{
	if(Integer.parseInt(reqty)<0)
	  { int selqty=0;
	    try{selqty=Integer.parseInt(DbUtil.getVal("select sum(locked_qty) from event_reg_locked_tickets where tid=?",new String[]{tid}));
		       reqty=selqty+Integer.parseInt(reqty)+"";
	     }catch(Exception e){selqty=0;}
	    result.put("remaining_"+eid,reqty);
	    result.put("sel_"+eid,selqty);
	    result.put("Name",DbUtil.getVal("select eventname from eventinfo where eventid=?::integer",new String[]{eid}));
		DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid=?",new String[]{tid});
	  }
	 }catch(Exception e ){System.out.println("Error While calculating the event level check:::"+tid+"::"+e.getMessage());
	}
	System.out.println("result:::::::"+result);
return result;	
}


public HashMap getregularticketsAvailibility(HashMap hm,JSONObject jobj){
	HashMap hmap=new HashMap();
	HashMap remainingcounthm=new HashMap();
	try{
		String eventid=(String) hm.get("eid");
		String tid=(String)hm.get("tid");
		String[] allticketid=(String[])hm.get("allticketids");
		//System.out.println("allticket array:"+allticketid);
		DBManager Db=new DBManager();
		StatusObj sb=null,price_sb=null,curr_lsb=null;

		String soldlquery="select sold_qty,max_ticket,price_id from price where evt_id=cast(? as numeric)";
		String current_locked_qry="select locked_qty,ticketid from event_reg_locked_tickets  where tid=? ";
		
		hmap=eventLevelCheck(eventid, tid,"");
	    if(!hmap.isEmpty())
            return hmap;

		price_sb=Db.executeSelectQuery(soldlquery,new String[]{eventid});
			if(price_sb.getStatus()&&price_sb.getCount()>0){
			for(int i=0;i<price_sb.getCount();i++){
			remainingcounthm.put("p_"+Db.getValue(i,"price_id",""),Db.getValue(i,"max_ticket","0"));
			remainingcounthm.put("s_"+Db.getValue(i,"price_id",""),Db.getValue(i,"sold_qty","0"));
			  }
		   }
		
					
			curr_lsb=Db.executeSelectQuery(current_locked_qry,new String[]{tid});
			if(curr_lsb.getStatus()&&curr_lsb.getCount()>0){
			
			for(int i=0;i<curr_lsb.getCount();i++){
			System.out.println(Db.getValue(i,"ticketid","")+"  lockedqty "+Db.getValue(i,"locked_qty","0"));
			remainingcounthm.put("cl_"+Db.getValue(i,"ticketid",""),Db.getValue(i,"locked_qty","0"));
			}
		}
		curr_lsb=null;
		String lquery2="select ticketid,sum(locked_qty)as lock from event_reg_locked_tickets where eventid=? and locked_time <=(select locked_time from event_reg_locked_tickets where  tid=? order by locked_time desc limit 1) group by ticketid";
       curr_lsb=Db.executeSelectQuery(lquery2,new String[]{eventid,tid});
	
     	if(curr_lsb.getStatus()&&curr_lsb.getCount()>0){
			
			for(int i=0;i<curr_lsb.getCount();i++){
			System.out.println(Db.getValue(i,"ticketid","")+" lock "+Db.getValue(i,"lock","0"));
		remainingcounthm.put("lk_"+Db.getValue(i,"ticketid",""),Db.getValue(i,"lock","0"));
			}
		}
		
		
		for(int i=0;i<allticketid.length;i++){
			String tktid=allticketid[i];
			
						
		int max_ticket=0;
		int sold=0;
		int currentlock=0;
		int lock=0;
					try{
						if(remainingcounthm.get("p_"+tktid)!=null)
							max_ticket=Integer.parseInt((String)remainingcounthm.get("p_"+tktid));
						}catch(Exception e){max_ticket=0;}
					try{
						if(remainingcounthm.get("s_"+tktid)!=null)
							sold=Integer.parseInt((String)remainingcounthm.get("s_"+tktid));
						}catch(Exception e){sold=0;}
							
					try{
					if(remainingcounthm.get("cl_"+tktid)!=null)
						currentlock=Integer.parseInt((String)remainingcounthm.get("cl_"+tktid));
					}catch(Exception e){currentlock=0;}
			
				    try{	
					   if(remainingcounthm.get("cl_"+tktid)!=null)
					lock=Integer.parseInt((String)remainingcounthm.get("lk_"+tktid));
					System.out.println("lock:"+lock+"tktid:"+tktid);
						
						}catch(Exception e){lock=0;}
			
			
                  
            System.out.println("max "+max_ticket+" sold "+sold+" lock "+lock+" currentlock "+currentlock);
			if(max_ticket<(sold+lock))
			{       int remainingqty=max_ticket-(sold+lock-currentlock);
		            System.out.println("2max "+max_ticket+" sold "+sold+" lock "+lock+" currentlock "+currentlock+"remainingqty"+remainingqty);
		            String res=DbUtil.getVal("select array_agg( 'eventid='||eventid ||' ticketid='||ticketid||' tid='||tid||' qty='||locked_qty||' eventdate='||eventdate||' time='||locked_time) ::text"+
							 " as response from event_reg_locked_tickets where eventid=? and tid=?", new String[]{eventid,tid});
					System.out.println("quantity exceeded at profile level::"+res);
		            hmap.put("sel_"+tktid,currentlock);
					hmap.put("remaining_"+tktid,remainingqty);	
                    hmap.put("hold_"+tktid,(lock-currentlock));					
					DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid=? and ticketid=CAST(? AS INTEGER)",new String[]{tid,tktid});
					DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where   transactionid=?", new String[]{tid});
					
			}
    }
		}catch(Exception e){
		System.out.println("exception in regular profile ticketstatus method is: "+e.getMessage());
	}
	
	return hmap;


}


public HashMap getrecurringticketsAvailibility(HashMap hm,JSONObject jobj){
System.out.println("recurrni check....");
	HashMap hmap=new HashMap();
	HashMap remainingcounthm=new HashMap();
	try{
	StatusObj price_sb=null,rec_sb=null,locked_sb=null,curr_lsb=null;
	String eventid=(String) hm.get("eid");
	String tid=(String)hm.get("tid");
	String eventdate=(String)hm.get("eventdate");
	DBManager Db=new DBManager();
	hmap=eventLevelCheck(eventid, tid,eventdate);
	    if(!hmap.isEmpty())
            return hmap;
			
	String price_qry="select price_id,max_ticket,min_qty,max_qty from price where evt_id=cast(? as numeric)";
	price_sb=Db.executeSelectQuery(price_qry,new String[]{eventid});
	String rec_sold_qty_qry="select ticketid,soldqty from reccurringevent_ticketdetails where eventid=cast(?as numeric) and eventdate=?";
	
	String current_locked_qry="select locked_qty ,ticketid from event_reg_locked_tickets where  tid=?";

		if(price_sb.getStatus()&&price_sb.getCount()>0){
			for(int i=0;i<price_sb.getCount();i++){
			remainingcounthm.put("p_"+Db.getValue(i,"price_id",""),Db.getValue(i,"max_ticket","0"));
			remainingcounthm.put("min_"+Db.getValue(i,"price_id",""),Db.getValue(i,"min_qty","0"));
			remainingcounthm.put("max_"+Db.getValue(i,"price_id",""),Db.getValue(i,"max_qty","0"));
			}
		}
		
		
		rec_sb=Db.executeSelectQuery(rec_sold_qty_qry,new String[]{eventid,eventdate});
		if(rec_sb.getStatus()&&rec_sb.getCount()>0){
		for(int i=0;i<rec_sb.getCount();i++){
			remainingcounthm.put("r_"+Db.getValue(i,"ticketid",""),Db.getValue(i,"soldqty","0"));
			}
			}
			
			curr_lsb=Db.executeSelectQuery(current_locked_qry,new String[]{tid});
			if(curr_lsb.getStatus()&&curr_lsb.getCount()>0){
			
			for(int i=0;i<curr_lsb.getCount();i++){
			System.out.println(Db.getValue(i,"ticketid","")+" curentlock "+Db.getValue(i,"locked_qty","0"));
			remainingcounthm.put("cl_"+Db.getValue(i,"ticketid",""),Db.getValue(i,"locked_qty","0"));
			}
		}
		
		
		String locked_qry="select ticketid,sum(locked_qty) as locked_qty from event_reg_locked_tickets where eventid=? and eventdate=? and  locked_time <=(select locked_time from event_reg_locked_tickets  where  tid=? order by locked_time desc limit 1)group by ticketid";
		
		locked_sb=Db.executeSelectQuery(locked_qry,new String[]{eventid,eventdate,tid});
		if(locked_sb.getStatus()&&locked_sb.getCount()>0){
			
			for(int i=0;i<locked_sb.getCount();i++){
		System.out.println(Db.getValue(i,"ticketid","")+" reclock  "+Db.getValue(i,"locked_qty","0"));
			remainingcounthm.put("lk_"+Db.getValue(i,"ticketid",""),Db.getValue(i,"locked_qty","0"));
			}
		}
		
		String[] allticketid=(String[])hm.get("allticketids");
		for(int i=0;i<allticketid.length;i++){
		String tktid=allticketid[i];
		int lockcount=0;
		int max=0;
		int sold=0;
		int curenthold=0;
		int minqty=0;
		int maxqty=0;
					try{
							if(remainingcounthm.get("p_"+tktid)!=null)
								max=Integer.parseInt((String)remainingcounthm.get("p_"+tktid));
							}catch(Exception e){max=0;}
					try{
							if(remainingcounthm.get("r_"+tktid)!=null)
								sold=Integer.parseInt((String)remainingcounthm.get("r_"+tktid));
							}catch(Exception e){sold=0;}
							
							try{
							if(remainingcounthm.get("cl_"+tktid)!=null)
								curenthold=Integer.parseInt((String)remainingcounthm.get("cl_"+tktid));
							}catch(Exception e){curenthold=0;}
							
							try{
							if(remainingcounthm.get("lk_"+tktid)!=null)
								lockcount=Integer.parseInt((String)remainingcounthm.get("lk_"+tktid));
							}catch(Exception e){lockcount=0;}
							try{
								if(remainingcounthm.get("min_"+tktid)!=null)
									minqty=Integer.parseInt((String)remainingcounthm.get("min_"+tktid));
							}catch(Exception e){minqty=0;}
							try{
								if(remainingcounthm.get("max_"+tktid)!=null)
									maxqty=Integer.parseInt((String)remainingcounthm.get("max_"+tktid));
							}catch(Exception e){maxqty=0;}
							
							
			System.out.println("2max "+max+" sold "+sold+" lock "+lockcount+" currentlock "+curenthold+" minqty "+minqty+" maxqty "+maxqty+" tktid "+tktid+" tid "+tid);
			
					if((max<(sold+lockcount)) || (curenthold<minqty) || (curenthold>maxqty))
			{       int remainingqty=max-(sold+lockcount-curenthold);
		            int hh=(lockcount-curenthold);
			        hmap.put("sel_"+tktid,curenthold);
				    hmap.put("remaining_"+tktid,remainingqty);
					hmap.put("hold_"+tktid,hh);
					String res=DbUtil.getVal("select array_agg( 'eventid='||eventid ||' ticketid='||ticketid||' tid='||tid||' qty='||locked_qty||' eventdate='||eventdate||' time='||locked_time) ::text"+
							 " as response from event_reg_locked_tickets where eventid=? and tid=?", new String[]{eventid,tid});
					System.out.println("quantity exceeded at profile level::"+res);
					DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid=? and ticketid=CAST(? AS INTEGER)",new String[]{tid,tktid});
					DbUtil.executeUpdateQuery("delete from event_reg_block_seats_temp where   transactionid=?", new String[]{tid});
			}
		
			
		}
	}catch(Exception e){System.out.println("Exception in  recurring event hold at profile level:"+e.getMessage());	}
	
	System.out.println("hmap:"+hmap);
	return hmap;
	
	
}





%>
<%
System.out.println("ticket checking profile.....");
String eid=request.getParameter("eid");
String tid=request.getParameter("tid");
String seltktids=request.getParameter("seltktids");
String eventdate=request.getParameter("eventdate");
String selectedtickets=request.getParameter("selected_tickets");
if(selectedtickets==null){selectedtickets="";}
System.out.println("selectedtickets"+selectedtickets+"seltktids"+seltktids);
String ticketids=request.getParameter("all_ticket_ids");
if(ticketids==null){ticketids="";}
String[] allticketids=ticketids.split("_");
String[] allseltktids=seltktids.split("_");
RegistrationTiketingManager regtktmgr=new RegistrationTiketingManager();
regtktmgr.autoLocksAndBlockDelete(eid, tid, "profilpageelevel");


/* DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid in (select tid from event_reg_details_temp where  eventid=?  and current_action in ('','profile page','tickets page','payment section','confirmation page'))and locked_time <(select now()- interval '20 minutes') and tid not in (?)",new String[]{eid,tid});
DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid in (select tid from event_reg_details_temp where  eventid=?  and current_action in ('paypal','google','eventbee','other','ebeecredits'))and locked_time <(select now()-interval '1 hours') and tid not in (?)",new String[]{eid,tid});
DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid in (select tid from event_reg_details_temp where eventid=? and current_action is null ) and locked_time < (select now()- interval '20 minutes')and tid not in (?)",new String[]{eid,tid});
DbUtil.executeUpdateQuery("delete from event_reg_locked_tickets where tid in (select tid from event_reg_transactions where eventid=? and paymentstatus ='Completed')",new String[]{eid});

 */
JSONObject obj=new JSONObject();
try{
obj=(JSONObject)new JSONTokener(selectedtickets).nextValue();
}catch(Exception e){System.out.println("Error while processing profile hold checking:eid:"+eid+"tid::"+tid+""+e.getMessage());}

HashMap hm= new HashMap();
hm.put("eid",eid);
hm.put("tid",tid);
hm.put("allticketids",allseltktids);
HashMap notavailabletktids=new HashMap();
if(!"".equals(eventdate)){
hm.put("eventdate",eventdate);
notavailabletktids=getrecurringticketsAvailibility(hm,obj);
}
else{
notavailabletktids=getregularticketsAvailibility(hm,obj);
}
if(notavailabletktids.isEmpty()){ notavailabletktids.put("status","success");
}
else{notavailabletktids.put("status","failure");}
JSONObject jobj=new JSONObject();
jobj.put("responsemap",notavailabletktids);
jobj.put("tid",tid);
out.println(jobj.toString());
%>