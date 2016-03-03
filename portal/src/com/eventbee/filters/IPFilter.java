package com.eventbee.filters;

import java.io.IOException;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.eventbee.general.DBManager;
import com.eventbee.general.DateUtil;
import com.eventbee.general.DbUtil;
import com.eventbee.general.StatusObj;

public class IPFilter implements Filter {


	public void destroy() {
		// TODO Auto-generated method stub

	}
	public static ArrayList<String> blockedIpsList=new ArrayList<String>();
	public static ArrayList<String> allowedIpsList=new ArrayList<String>();
	public static  HashMap <String,Integer> EmailBlockIps=new HashMap<String,Integer>();
	public static  HashMap <String,Integer> GlobalIpsCounts=new HashMap<String,Integer>();
	public static  String  Globalcleardate="";
	public static  int  Globalblockcount=5000;
	public static  int  GlobalminitLimit=60;
	public static  boolean  blockflag=true;
	
	static{initLoad();}
	public static void initLoad(){
		blockedIpsList.clear();
		allowedIpsList.clear();
		DBManager dm=new DBManager();
		StatusObj sob= dm.executeSelectQuery("select * from iptable",null);
			if(sob.getStatus() && sob.getCount()>0 ){
				for (int i=0;i<sob.getCount();i++){
				String val=dm.getValue(i,"ip","");
				String stas=dm.getValue(i,"status","");
			    if(!"".equals(val)&& !allowedIpsList.contains(val) && "allow".equals(stas))
			   	allowedIpsList.add(val);
			    else if(!"".equals(val)&& !blockedIpsList.contains(val) && "block".equals(stas) &&!allowedIpsList.contains(val))
				blockedIpsList.add(val);
				  
		     }
		 }
	}
	public static void removeAllowLoad(String id){
		IPFilter.allowedIpsList.remove(id);
	DbUtil.executeUpdateQuery("delete  from iptable where status='allow' and ip=?",new String[]{id});
	}
	public static void removeAllowLoad(){   IPFilter.allowedIpsList.clear();DbUtil.executeUpdateQuery("delete  from iptable where status='allow'",new String[]{});}
	public static void addBlock(String id){ 
		System.out.println("addddd::"+id);
		removeBlockLoad(id);
		IPFilter.blockedIpsList.add(id);DbUtil.executeUpdateQuery("insert into iptable (ip,status,created_at)values(?,?,now())",new String[]{id,"block"});}
	public static void addAllow(String id){removeAllowLoad(id); IPFilter.allowedIpsList.add(id);DbUtil.executeUpdateQuery("insert into iptable (ip,status,created_at)values(?,?,now())",new String[]{id,"allow"});}
	public static void removeBlockLoad(){IPFilter.blockedIpsList.clear();DbUtil.executeUpdateQuery("delete  from iptable where status='block'",new String[]{});}
	public static void removeBlockLoad(String id){IPFilter.blockedIpsList.remove(id);DbUtil.executeUpdateQuery("delete  from iptable where status='block' and ip=?",new String[]{id});}
	

	public void doFilter(ServletRequest request, ServletResponse response,
			FilterChain filterChain) throws IOException, ServletException {
		// TODO Auto-generated method stub
		 HttpServletRequest req=(HttpServletRequest)request;
	     HttpServletResponse resp=(HttpServletResponse)response;
	     String uri=req.getRequestURI();
	     
	     if((uri.startsWith("/home") || uri.startsWith("/portal/home")) && uri.endsWith(".jsp")){
	    	 resp.sendRedirect("/main/");
	    	 return;
	     }
	     String ipd=req.getHeader("x-forwarded-for");
	     if(ipd==null)
	     ipd=req.getRemoteAddr();
	     
	    if("".equals(Globalcleardate))
	    Globalcleardate=DateUtil.getFormatedDate(new Date(), "MM/dd/yyyy HH:mm:ss", new Date().toGMTString());
		      
	    long time=getDateDiffer(Globalcleardate,DateUtil.getFormatedDate(new Date(), "MM/dd/yyyy HH:mm:ss", new Date().toGMTString()));	    
	    if(time>=GlobalminitLimit)
	    {GlobalIpsCounts.clear();
	     Globalcleardate=DateUtil.getFormatedDate(new Date(), "MM/dd/yyyy HH:mm:ss", new Date().toGMTString());
	    }
	     
	     int prevcount=IPFilter.GlobalIpsCounts.get(ipd)==null || "".equals(IPFilter.GlobalIpsCounts.get(ipd))?0:IPFilter.GlobalIpsCounts.get(ipd);
	    if(blockflag)	    
	     IPFilter.GlobalIpsCounts.put(ipd,prevcount+1);	
	     
	     if(prevcount>Globalblockcount && blockflag)
		   {if(!blockedIpsList.contains(ipd) && !allowedIpsList.contains(ipd)){ 
			  blockedIpsList.add(ipd);
			  addBlock(ipd);
			  System.out.println("maximum ipcount reached : "+ipd);
		      
		    }
		   }
		
	     
	  if(blockedIpsList.contains(req.getHeader("x-forwarded-for")) || blockedIpsList.contains(req.getRemoteAddr()) ){
      PrintWriter out=resp.getWriter();
      out.print("Sorry");
       return;
     }
		filterChain.doFilter(request, response);
		
	}


	public void init(FilterConfig arg0) throws ServletException {
		// TODO Auto-generated method stub

	}
	public long getDateDiffer(String dateStart,String dateStop){
		long result=0;
       try{ SimpleDateFormat format = new SimpleDateFormat("MM/dd/yyyy HH:mm:ss");	     
		Date d1 = null;
		Date d2 = null;
		d1 = format.parse(dateStart);
		d2 = format.parse(dateStop);

		//in milliseconds
		long diff = d2.getTime() - d1.getTime();
	    //in hours
	//	result = diff / (60 * 60 * 1000) % 24;
	//in minutes
		result = diff / (60 * 1000);
       }catch(Exception e){}
		return result;
	}

}
