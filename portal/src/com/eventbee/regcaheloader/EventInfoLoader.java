package com.eventbee.regcaheloader;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;

import org.json.JSONException;
import org.json.JSONObject;

import com.eventbee.cachemanage.CacheLoader;
import com.eventbee.cachemanage.CacheManager;
import com.eventbee.event.EventsContent;
import com.eventbee.general.DBManager;
import com.eventbee.general.DbUtil;
import com.eventbee.general.EbeeConstantsF;
import com.eventbee.general.GenUtil;
import com.eventbee.general.StatusObj;
import com.eventbee.util.CoreConnector;
import com.eventpageloader.EventPageContentLoader;
import com.themes.ThemeController;
public class EventInfoLoader implements CacheLoader {
	long refreshInterval=30*1000;
	long maxIdleTime=60*1000;
	Map <String,String> cMap;
   public long getRefreshInterval(){return refreshInterval;}
   public void setRefreshInterval(long ri){refreshInterval=ri;}
   public long getMaxIdleTime(){return maxIdleTime;}
   public void setMaxIdleTime(long mtime){maxIdleTime=mtime;}
   public void setConfigMap(Map<String,String> cMap){this.cMap=cMap;}
   public Map <String,String> getConfigMap(){return cMap;}
   public Map load(String groupid){
	   
	   CacheManager.getData("0", "globalstatic");	   
	   
	  
	   HashMap info=EventPageContentLoader.getEventDetailsFromDbLoad(groupid);
	   HashMap configmap=EventPageContentLoader.getConfigValuesFromDb((String)info.get("config_id"));
	   
	   HashMap infomap=new HashMap();
	   infomap.put("customCssMap",getCSSHTMLMap(groupid,info));
	   infomap.put("event_mapString",getMapString(info));	   
	   infomap.put("event_metaEndDate", metaEndDate(info));
	   infomap.put("event_metaStartDate", metaStartDate(info));
	   infomap.put("event_fullAddress",getFullAddress(info));
	   
	   getNTSGen(info,configmap,groupid);
	   getCalanderMap(groupid, info);
	   if(isRecurring(configmap))
	   getRecuring(groupid);
	   if("YES".equals(GenUtil.getHMvalue(configmap,"event.seating.enabled","NO")))
	   getSetaing(configmap, groupid);	   
	   infomap.put("event_hostedBy",getHostedBy(info,configmap));
	   if("YES".equals(GenUtil.getHMvalue(configmap,"event.loading.quick","NO"))){}
	   else{
		   /*String userid=DbUtil.getVal("select userid from user_groupevents where event_groupid =?" ,new String[]{groupid});
		   infomap.put("userid_group",userid);
		   String password=DbUtil.getVal("select password from view_security where eventid=?",new String[]{groupid});
		   infomap.put("event_password",password);*/
		   Vector notices=EventsContent.getAllNotices(groupid);
		   infomap.put("event_notices",notices);
	   }
	   
	   String eventurl=DbUtil.getVal("select url from event_custom_urls where eventid=?",new String[]{groupid});
	   infomap.put("eventcustomurl",eventurl);
	   
	   infomap.put("event_header_footer",getCustomHeaderFooterFromDb(groupid));	   
	   info.putAll(infomap);
	   info.put("configmap", configmap);
	 return  info;
	   
    	
    }
   public boolean isRecurring(Map configmap){
		return ("Y".equalsIgnoreCase(GenUtil.getHMvalue(configmap,"event.recurring","N")));
	}
   
   public static HashMap getCustomHeaderFooterFromDb(String groupid){
	   
		String header="";
		String footer=null;
		HashMap hm=new HashMap();
		DBManager dbmanager=new DBManager();
		StatusObj statobj=dbmanager.executeSelectQuery("select * from configure_looknfeel where refid=? and idtype=? ",new String []{groupid,"eventdetails"});
		if(statobj.getStatus()){
			header=dbmanager.getValue(0,"headerhtml","");
			footer=dbmanager.getValue(0,"footerhtml","");
			if("Default".equals(header))header="";
			if("Default".equals(footer) || "".equals(footer))footer=null;
		}
		hm.put("header",header);
		hm.put("footer",footer);
		return hm;
		
	}
   
   
   public String getHostedBy(Map info, Map configmap){		
		String hostedby=(String)configmap.get("event.hostname");
		if(hostedby==null||"".equals(hostedby)){
			String company=(String)info.get("company");
			if(company!=null&&!"".equals(company))
				hostedby=company;
			else
				hostedby=(String)info.get("first_name")+" "+(String)info.get("last_name");
			}		
		return hostedby;
	}
   
   public String [] getFullAddress(Map info){
		String [] address_arr=null;
		List addressList=new ArrayList();
		String venue="";
		venue=(String)info.get("venue");
		String city=(String)info.get("city");
		String state=(String)info.get("state");
		String country=(String)info.get("country");
		String address2=GenUtil.getHMvalue(info,"address2",null);
		String address1=GenUtil.getHMvalue(info,"address1",null);
		String address=GenUtil.getCSVData(new String[]{city,state,country});
		if(venue!=null&&(venue.trim()).length()>0)
			addressList.add(venue);
		if(address1!=null&&(address1.trim()).length()>0)
			addressList.add(address1);
		if(address2!=null&&(address2.trim()).length()>0)
			addressList.add(address2);
		if(address!=null&&(address.trim()).length()>0)
			addressList.add(address);
		address_arr=(String [])addressList.toArray(new String [0]);		
		return address_arr;
		
	}
   
   
   public String getMapString(Map info){
		
		String mstr="";
		String city=(String)info.get("city");
		String state=(String)info.get("state");
		String country=(String)info.get("country");
		String address2=GenUtil.getHMvalue(info,"address2",null);
		String address1=GenUtil.getHMvalue(info,"address1",null);	
			if(address2.equals("")){
				mstr=address1+"+"+city+"+"+state+"+"+country;
			}else{
				mstr=address1+"+"+address2+"+"+city+"+"+state+"+"+country;
			}
			mstr=URLEncoder.encode(mstr);		
		return mstr;
	}
   
   public  String getStartDate(Map info){
		return (String)info.get("evt_start_date")+", "+(String)info.get("starttime");
	}

	public  String getEndDate(Map info){
		return (String)info.get("evt_end_date")+", "+(String)info.get("endtime");
	}
	public String metaStartDate(Map info){
		String desc_start_date=getStartDate(info);
		try{
			String[] st_temp=desc_start_date.split(",");
			String[] st_dd_format  =st_temp[1].split(" ");
			return st_dd_format[2]+" "+st_dd_format[1]+""+st_temp[2]+","+st_temp[3];
			
			}catch(Exception e){
		}
		return "";
	}

	public String metaEndDate(Map info){
		String desc_end_date=getEndDate(info);
		try{
		String[] end_temp=desc_end_date.split(",");
		String[] end_dd_format  =end_temp[1].split(" ");
		return end_dd_format[2]+" "+end_dd_format[1]+""+end_temp[2]+","+end_temp[3];
		}catch(Exception e){
		}
		return "";
	}
	
	
	public HashMap getCSSHTMLMap(String groupid,Map info){		
		HashMap hm=new HashMap();
		String templatedata="";
		String themetype=null;
		String deftheme=null;
		String [] themedata=null;
		String thememodule=null;
		String customcss="";
		String [] themeNameandType=ThemeController.getThemeCodeAndType("event%",groupid,"basic");
		themetype=themeNameandType[0];
		deftheme=themeNameandType[1];
		thememodule=themeNameandType[3];
		if(thememodule==null) thememodule="event";
		
		themedata=ThemeController.getSelectedThemeData((String)info.get("mgr_id"),thememodule,deftheme,"event",groupid,themetype);
		customcss=themedata[0];
		templatedata=themedata[1];
		hm.put("customcss",customcss);
		hm.put("templatedata",templatedata);
		return hm;
		
	}
	
	public void getSetaing(Map configmp,String groupid){
		Map<String, String> params=new HashMap<String, String>(); 
		params.put("venueid",GenUtil.getHMvalue(configmp,"event.seating.venueid","0"));
		params.put("groupid",groupid);		   
	    CoreConnector cn=new CoreConnector("http://localhost/customevents/loadseatingcontent.jsp");
	    cn.setArguments(params);
	    cn.setTimeout(500000);try{
	    cn.MPost();
	    }catch(Exception e){System.out.println("Exception getSetaing "+e.getMessage());}		
		
		
	}
	public void getRecuring(String groupid){
	    CoreConnector cn=new CoreConnector("http://localhost/customevents/loadrecurringcontent.jsp");
	    Map<String, String> params=new HashMap<String, String>(); 
		params.put("groupid",groupid);	
	    cn.setArguments(params);
	    cn.setTimeout(500000);try{
	    cn.MPost();
	    }catch(Exception e){System.out.println("Exception getRecuring "+e.getMessage());}		
		
		
	}
	
	public void  getNTSGen(Map info,Map configmp,String groupid){		
		
		String nts_enable=(String)info.get("nts_enable");
		nts_enable=nts_enable==null?"N":nts_enable;
		String nts_commission=(String)info.get("nts_commission");
		nts_commission=nts_commission==null?"0":nts_commission;
		String venueid=GenUtil.getHMvalue(configmp,"event.seating.venueid","0");
		String fbsharepopup=GenUtil.getHMvalue(configmp,"event.confirmationpage.fbsharepopup.show","Y");
		String eventstatus=GenUtil.getHMvalue(info,"status","ACTIVE");
		String fbappid=DbUtil.getVal("select value from config where config_id='0' and name='ebee.fbconnect.appid'",null); 

		String isseatingevent=GenUtil.getHMvalue(configmp,"event.seating.enabled","NO");
		
		if("".equals(nts_enable) || "N".equals(nts_enable)){
			nts_enable="N";
			nts_commission="0";	
		}
		try{
		if(Double.parseDouble(nts_commission)<0){
			nts_commission="0";
		}
		}catch(Exception e){	nts_commission="0";}

	
		String domain=EbeeConstantsF.get("serveraddress","www.eventbee.com");
		String event_photo_src=GenUtil.getHMvalue(configmp,"event.eventphotoURL",GenUtil.getHMvalue(configmp,"eventpage.logo.url","http://"+domain+"/home/images/social_fb.png"));
		
		Map<String, String> params=new HashMap<String, String>(); 
		params.put("nts_enable",nts_enable );
		params.put("nts_commission",nts_commission );
		params.put("venueid",venueid );
		params.put("fbsharepopup",fbsharepopup);
		params.put("eventstatus",eventstatus );
		params.put("fbappid",fbappid);
		params.put("event_photo_src",event_photo_src);
		params.put("isseatingevent",isseatingevent);
		params.put("content","nts");
		params.put("groupid",groupid);
		params.put("fbloginpopup",GenUtil.getHMvalue(configmp,"event.reg.loginpopup.show","Y"));
		
		   
	    CoreConnector cn=new CoreConnector("http://localhost/customevents/loadntscontent.jsp");
	    cn.setArguments(params);
	    cn.setTimeout(500000);try{
	    cn.MPost();
	    }catch(Exception e){System.out.println("Exception getNTSGen "+e.getMessage());}		
		
		
	}
	

public  void  getCalanderMap(String groupid,Map info){
	
	StringBuffer sb = new StringBuffer();
	SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyyMMdd'T'HHmm'00'");
	SimpleDateFormat DATE_FORMATT = new SimpleDateFormat("HHmm");
	String sdate="",edate="", textdesc="", durationstr="";
	String eventname=(String)info.get("eventname");
	String location=(String)info.get("city");
	location=java.net.URLEncoder.encode(location);
	
	String sd=(String)info.get("_startDay");
	String ed=(String)info.get("_endDay");
	String sm=(String)info.get("_startMonth");
	String em=(String)info.get("_endMonth");
	String eh=(String)info.get("_endHour");
	String sh=(String)info.get("_startHour");
	String ey=(String)info.get("_endYear");
	String sy=(String)info.get("_startYear");
	String emin=(String)info.get("_endMinute");
	String smin=(String)info.get("_startMinute");
	
	Calendar calendar = new GregorianCalendar(Integer.parseInt(sy),
			Integer.parseInt(sm)-1,
			Integer.parseInt(sd),
			Integer.parseInt(sh),
			Integer.parseInt(smin));

	Calendar calendar1 = new GregorianCalendar(Integer.parseInt(ey),
				Integer.parseInt(em)-1,
				Integer.parseInt(ed),
				Integer.parseInt(eh),
				Integer.parseInt(emin));
	sdate=DATE_FORMAT.format(calendar.getTime());
	edate=DATE_FORMAT.format(calendar1.getTime());
	long differenceInMillis = calendar1.getTimeInMillis() - calendar.getTimeInMillis();
	long differenceInDays = differenceInMillis /(24*60*60*1000);
	long diffHours = differenceInMillis/(60*60*1000);
	long diffMins = differenceInMillis/(60*1000);
	diffMins=diffMins-diffHours*60;
	String hoursstr=""+diffHours;
	if(hoursstr.length()==1)hoursstr="0"+hoursstr;
	String minsstr=""+diffMins;
	if(minsstr.length()==1) minsstr="0"+minsstr;
	if(hoursstr.length()>2) hoursstr="99";
	durationstr=hoursstr+minsstr;
	
	if("text".equals(info.get("descriptiontype")))
		textdesc=(String)info.get("description");
	if(textdesc==null)
		textdesc="";
	

	Map<String, String> params=new HashMap<String, String>(); 
	params.put("sdate",sdate);
	params.put("edate",edate );
	params.put("durationstr",durationstr );
	params.put("textdesc",textdesc);
	params.put("groupid",groupid);
	params.put("location",location);  
	params.put("eventname",eventname); 
    CoreConnector cn=new CoreConnector("http://localhost/customevents/loadcalendercontent.jsp");
    cn.setArguments(params);
    cn.setTimeout(500000);try{
    cn.MPost();
    }catch(Exception e){System.out.println("Exception getCalanderMap "+e.getMessage());}		
	
	

}






}