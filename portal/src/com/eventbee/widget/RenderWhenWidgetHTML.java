package com.eventbee.widget;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.GregorianCalendar;
import java.util.HashMap;

import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.VelocityEngine;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.eventbee.cachemanage.CacheManager;
import com.eventbee.general.EbeeConstantsF;
import com.eventbee.general.GenUtil;
import com.eventbee.layout.EventGlobalTemplates;

public class RenderWhenWidgetHTML implements RenderWidgetHTML {

	@Override
	public String getHTML(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash)
			throws Exception {		
		 String result="";
		JSONObject config_options = new JSONObject(configHash.get("config_options"));
		 String when=config_options.getString("when");
		try{ JSONObject json=new JSONObject(when);
		 String whenc=json.has("whenc")?json.getString("whenc"):"";
		 String addcn=json.has("addcn")?json.getString("addcn"):"";
		 JSONArray keyw=json.getJSONArray("keyw");
		 VelocityContext vc = new VelocityContext();
		 String template=configHash.get("global_template_whenwidget");
		 if(template==null || "".equals(template.trim()))
		 template=EventGlobalTemplates.getTemplateOfLanguage(refHash.get("i18nlang"),"global_template_whenwidget");
		 vc.put("eid",dataHash.get("eventid"));
		 if(whenc!=null && !"".equals(whenc)){
			 vc.put("replacekeywords",replaceKeyWords(keyw,dataHash,whenc));
			 if(addcn.indexOf("addTocalnder")>-1){				      
				 vc.put("calenderdata","");
				 HashMap dataMap=getCalenerData(dataHash,addcn,json);
				 vc.put("linktitle",dataMap.get("linktitle"));
				 	if(dataMap.containsKey("ical")){
				 		vc.put("ical",dataMap.get("ical"));
				 		vc.put("file","vcal_event_"+dataMap.get("eid")+".ics");
				 	}
				 	if(dataMap.containsKey("google")){
				 		vc.put("google","google");
				 		vc.put("eventname",dataMap.get("eventname"));
				 		vc.put("sdate",dataMap.get("sdate"));
				 		vc.put("edate",dataMap.get("edate"));
				 		vc.put("textdesc",dataMap.get("textdesc"));
				 		vc.put("city",dataMap.get("city"));
				 	}
				 	if(dataMap.containsKey("yahoo")){
				 		vc.put("yahoo","yahoo");
				 		vc.put("durationstr",dataMap.get("durationstr"));
				 		vc.put("eventname",dataMap.get("eventname"));
				 		vc.put("sdate",dataMap.get("sdate"));
				 		vc.put("edate",dataMap.get("edate"));
				 		vc.put("city",dataMap.get("city"));
				 		vc.put("textdesc",dataMap.get("textdesc"));
		}
       }
    }
    		result=getVelocityOutPut(vc,template);
		}catch(Exception e){System.out.println(" when parsing error "+e.getMessage()); }
      
		return result;
	}

	private static String getVelocityOutPut(VelocityContext vc,String Template){
		
		StringBuffer str=new StringBuffer();
		java.io.StringWriter out1=new java.io.StringWriter();
		VelocityEngine ve= new VelocityEngine();
		try{
			ve.init();
			boolean abletopares=ve.evaluate(vc,out1,"ebeetemplate",Template );
			str=out1.getBuffer();
		}catch(Exception e){
			System.out.println("whosattending exception: "+e.getMessage());
		}
			return str.toString();
	}
	
	public Boolean IsRenderable(HashMap<String, String> refHash,
			HashMap<String, String> dataHash, HashMap<String, String> configHash)
			throws Exception {
		 String groupid=refHash.get("eventid");
		 boolean isRecurring=false;
		 HashMap eventinfoMap=(HashMap)CacheManager.getData(groupid, "eventinfo");
		 HashMap configMap=((HashMap)(eventinfoMap.get("configmap")));//DBHelper.getConfigValuesFromDb(groupid);
		 isRecurring=("Y".equalsIgnoreCase(GenUtil.getHMvalue(configMap,"event.recurring","N")));
		 if(isRecurring)
			 return false;
		 JSONObject config_options = new JSONObject(configHash.get("config_options"));
		try{		
			 String when=config_options.getString("when");
			 JSONObject json=new JSONObject(when);
		     String whenc=json.getString("whenc");
		   if(whenc==null || "".equals(whenc)){
		   return false;
		   }
	}catch(Exception e){System.out.println(" when IsRenderable  parsing error "+e.getMessage());}
		return true;
	}
	
	private static  HashMap getCalenerData(HashMap<String, String> dataHash, String addcndata,JSONObject json){	
		String durationstr="";
		String sdate="";
		String edate="";
		  HashMap dataMap=new HashMap();
		try{
			SimpleDateFormat DATE_FORMAT = new SimpleDateFormat("yyyyMMdd'T'HHmm'00'");
			
			Calendar cal = Calendar.getInstance();
			cal.setTime(new SimpleDateFormat("MMM").parse(dataHash.get("startmon")));
			int startMonthInt = cal.get(Calendar.MONTH)+1 ; 
			cal.setTime(new SimpleDateFormat("MMM").parse(dataHash.get("endmon")));
			int endMonthInt = cal.get(Calendar.MONTH)+1 ;
			String stampm=dataHash.get("startampm");
			String endampm=dataHash.get("endampm");
			Calendar calendar = new GregorianCalendar(
					Integer.parseInt(dataHash.get("startyear")),	
					startMonthInt-1,
					Integer.parseInt(dataHash.get("startdate")),
					Integer.parseInt(dataHash.get("starttime").split(":")[0]),
					Integer.parseInt(dataHash.get("starttime").split(":")[1]));
			if("PM".equals(stampm))
				calendar.set(Calendar.AM_PM, Calendar.PM);
			else
				calendar.set(Calendar.AM_PM, Calendar.AM);
	        Calendar calendar1 = new GregorianCalendar(
	        		Integer.parseInt(dataHash.get("endyear")),
	        		endMonthInt-1,
					Integer.parseInt(dataHash.get("enddate")),
					Integer.parseInt(dataHash.get("endtime").split(":")[0]),
					Integer.parseInt(dataHash.get("endtime").split(":")[1]));
	        if("PM".equals(endampm))
	        	calendar1.set(Calendar.AM_PM, Calendar.PM);
	        else
	        	calendar1.set(Calendar.AM_PM, Calendar.AM);
					long differenceInMillis = calendar1.getTimeInMillis() - calendar.getTimeInMillis();
					
					long diffHours = differenceInMillis/(60*60*1000);
					long diffMins = differenceInMillis/(60*1000);
					diffMins=diffMins-diffHours*60;
					String hoursstr=""+diffHours;
			
					if(hoursstr.length()==1)hoursstr="0"+hoursstr;
					String minsstr=""+diffMins;
					if(minsstr.length()==1) minsstr="0"+minsstr;
					if(hoursstr.length()>2) hoursstr="99";
					
					 sdate=DATE_FORMAT.format(calendar.getTime());
					 edate=DATE_FORMAT.format(calendar1.getTime());
					 durationstr=hoursstr+minsstr;
	
		}catch(Exception e){
			System.out.println("add caln date cal execepton"+e.getMessage());}

			String textdesc="";
			
			if("text".equals(dataHash.get("descriptiontype")))
			textdesc=dataHash.get("description");
			
			if(textdesc==null)
			 textdesc="";
      
			try{
        if(json.has("addcntxt") && !"".equals(json.getString("addcntxt")))
        	dataMap.put("linktitle",json.getString("addcntxt"));
        else
        	dataMap.put("linktitle","Add to my calendar");
			}catch(Exception e){}
			
        if(addcndata.indexOf("ical")>-1){
        	dataMap.put("ical",EbeeConstantsF.get("vcal.webpath","/jboss32/server/default/deploy/home.war/vcal"));
            dataMap.put("eid",dataHash.get("eventid"));
            //System.out.println("the eventid is::"+dataHash.get("eventid"));
        }
        
        if(addcndata.indexOf("google")>-1){
        	dataMap.put("google","google");
        	dataMap.put("eventname",dataHash.get("eventname"));
        	dataMap.put("sdate",sdate);
        	dataMap.put("edate",edate);
        	dataMap.put("textdesc",textdesc);
        	dataMap.put("city",dataHash.get("city"));
        }
        if(addcndata.indexOf("yahoo")>-1){
        	dataMap.put("yahoo","yahoo");
        	dataMap.put("durationstr",durationstr);
        	dataMap.put("eventname",dataHash.get("eventname"));
        	dataMap.put("sdate",sdate);
        	dataMap.put("edate",edate);
        	dataMap.put("textdesc",textdesc);
        	dataMap.put("city",dataHash.get("city"));
        }
	return dataMap;
		
	}
	
	private static String replaceKeyWords(JSONArray keywords,HashMap<String, String> datahash, String content){
		try {
		for(int i=0;i<keywords.length();i++){			
				String key = keywords.getString(i);			
			    String value=datahash.get(key.replace("$", "").toLowerCase());	
			         while(content.contains(key))
			    	 content=content.replace(key, value);
		     }
		} catch (JSONException e) {
			System.out.println("exception while replacing key words"+e.getMessage());	
			}
		//System.out.println("content"+content);
		return content;
	}


}
