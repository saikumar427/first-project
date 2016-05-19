package com.eventbee.layout;

import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject; 

import com.eventbee.cachemanage.CacheLoader;
import com.eventbee.cachemanage.CacheManager;

import com.eventbee.general.DBManager;
import com.eventbee.general.DbUtil;
import com.eventbee.general.StatusObj;
import com.eventbee.regcaheloader.I18nLangLoader;

public class DBHelper {
	
	public static String getLanguageFromDB(String eventid){
		/*HashMap<String, String> configMap=(HashMap)(CacheManager.getData(eventid, "eventinfo").get("configmap"));
		String lang=GenUtil.getHMvalue(configMap,"event.i18n.lang","en_US");*/
		String lang="en_US";
		try{
			if(!CacheManager.getInstanceMap().containsKey("i18nlang")){
				CacheLoader i18nLang=new I18nLangLoader();
				i18nLang.setRefreshInterval(60*60*1000);
				i18nLang.setMaxIdleTime(60*60*1000);
				CacheManager.getInstanceMap().put("i18nlang",i18nLang);		
			}
			Map i18nLangMap=CacheManager.getData(eventid, "i18nlang");
			int i=0;
			while(i18nLangMap==null && i<10){
				try {
				    i18nLangMap=CacheManager.getData(eventid, "i18nlang");
				    i++;
				} catch(Exception ex) {
					System.out.println("Exception in DBHelper getLanguageFromDB: eventid: "+eventid+" iteration: "+i+" ERROR: "+ex.getMessage());
				}
			}
			if(i18nLangMap!=null && i18nLangMap.get("i18n_lang")!=null && !"".equals(i18nLangMap.get("i18n_lang"))) 
				lang=(String)i18nLangMap.get("i18n_lang");
		}catch(Exception e){
			System.out.println("Exception in DBHelper getLanguageFromDB: eventid: "+eventid+" ERROR: "+e.getMessage());
		}
		return lang;
	}
	  
	public static String getLayout(String eventid,String ref,String stage) throws Exception {
		try{
		DBManager dbm = new DBManager();
		StatusObj statobj;
		System.out.println("stage:::::"+stage);
		HashMap<String, String> widgettitles=getTitles(eventid,stage) ;
		String query = "select * from event_layout where eventid = ?::bigint and stage = 'draft';";
		if("final".equals(stage))
			query = "select * from event_layout where eventid = ?::bigint and stage = 'final';";
		
		statobj = dbm.executeSelectQuery(query, new String[]{eventid});
		
		
		JSONObject result = null;
		
		if(statobj.getStatus() && statobj.getCount()>0 ) {
			result=fillLayout(eventid,ref,dbm,widgettitles);
			
		}else{
			//for final and draft(preview), default event_layout is same 
			String	defaultQuery = "select * from event_layout where eventid = '1'::bigint and stage = 'final';";
			
			statobj = dbm.executeSelectQuery(defaultQuery, null);
			
			result=fillLayout(eventid,ref,dbm,widgettitles);
		}
		
		//result.put("allThemes", getThemeDetails());
		
		 return result.toString();
		}catch(Exception e){System.out.println("exception while getlayout"+e.getMessage());e.printStackTrace();}
		return "";
	}
	
	public static JSONObject fillLayout(String eventid,String ref, DBManager dbm, HashMap<String, String> widgettitles){
		JSONObject result = new JSONObject();
		try{
		
		String[]widgets;
		JSONObject hidewidgets = new JSONObject();	
		JSONArray hidewidgetsarr = new JSONArray();	
		
		widgets = dbm.getValue(0, "hide_widgets", "").split(",");			
		for(int i=0;i<widgets.length;i++) {	
			if("".equals(widgets[i]))
				continue;
		    hidewidgets.put(widgets[i],i);
		    hidewidgetsarr.put(widgets[i]);
		}
		
		result.put("hide-widgets", hidewidgetsarr);
		result.put("sync",  dbm.getValue(0, "sync", "yes"));
		
		widgets = dbm.getValue(0, "wide_widgets", "").split(",");
		JSONArray wide = new JSONArray();
		for(int i=0;i<widgets.length;i++) {				
			if("".equals(widgets[i]))continue;
			String tle=widgettitles.get(widgets[i]+ref);
			tle=tle==null?"":tle;
			tle=URLDecoder.decode(tle,"UTF-8");
			tle=tle==null?"":tle;
			if(checkHideStatus(widgets[i],ref,hidewidgets))
				continue;
			wide.put(new JSONObject().put(widgets[i],tle));
			
		}
		result.put("column-wide", wide);
		
		widgets = dbm.getValue(0, "narrow_widgets", "").split(",");
		JSONArray narrow = new JSONArray();
		for(int i=0;i<widgets.length;i++) {
			if("".equals(widgets[i]))continue;
			String tle=widgettitles.get(widgets[i]+ref);
			tle=tle==null?"":tle;
			tle=URLDecoder.decode(tle,"UTF-8");
			tle=tle==null?"":tle;
			if(checkHideStatus(widgets[i],ref,hidewidgets))
				continue;
			narrow.put(new JSONObject().put(widgets[i],tle));
		}
		result.put("column-narrow", narrow);			
		widgets = dbm.getValue(0, "single_widgets", "").split(",");
	
		JSONArray single = new JSONArray();
		for(int i=0;i<widgets.length;i++) {
			if("".equals(widgets[i]))continue;
			String tle=widgettitles.get(widgets[i]+ref);
			tle=tle==null?"":tle;
			 tle=URLDecoder.decode(tle,"UTF-8");
			tle=tle==null?"":tle;
			if(checkHideStatus(widgets[i],ref,hidewidgets))
				continue;
			single.put(new JSONObject().put(widgets[i],tle));
		}
		result.put("column-single", single);
		
		widgets = dbm.getValue(0, "single_bottom_widgets", "").split(",");
		JSONArray single_bottom = new JSONArray();
		for(int i=0;i<widgets.length;i++) {
			if("".equals(widgets[i]))continue;
			String tle=widgettitles.get(widgets[i]+ref);
			tle=tle==null?"":tle;
		    tle=URLDecoder.decode(tle,"UTF-8");
			tle=tle==null?"":tle;
			if(checkHideStatus(widgets[i],ref,hidewidgets))
				continue;
			single_bottom.put(new JSONObject().put(widgets[i],tle));
		}
		result.put("column-single-bottom", single_bottom);			
		
		result.put("eventid", dbm.getValue(0, "eventid", ""));
		
		result.put("global_style", new JSONObject(dbm.getValue(0, "global_style", "")));
		
		result.put("themeCodeName", dbm.getValue(0, "themecode", ""));
		
		if(!"".equals(dbm.getValue(0, "header_theme", "").trim())) {
			result.put("header_theme", dbm.getValue(0, "header_theme", ""));
		} else {
			result.put("header_theme",InitHeaderTheme(eventid));
		}
		
		JSONObject added = LayoutManager.concatArrays(single,wide,narrow,single_bottom);
		result.put("added",added);
		
		}catch(Exception e){
			System.out.println("Exception in DBHelper.java fillLayout() ERROR:: "+e.getMessage());
		}
		return result;
	}
	
	public static JSONArray getThemeDetails(){
		DBManager dbm =new DBManager();
		String ThemQuery = "select * from event_page_themes where eventid= 0";
		StatusObj statusTheme = dbm.executeSelectQuery(ThemQuery,null);
		JSONArray themeData = new JSONArray();
		if(statusTheme.getStatus() && statusTheme.getCount()>0){
			for(int i=0;i<statusTheme.getCount();i++) {
				try{
					JSONObject themeKey = new JSONObject();
					themeKey.put("themeKey",dbm.getValue(i, "themecode", ""));
					themeKey.put("themeValue",dbm.getValue(i, "themename", ""));
					themeData.put(themeKey);
				}catch(Exception e){
					System.out.println("Exception in select thems"+e);
				}
			}
		}
		return themeData;
		
	}
	/*public static String chenageThemJson(String eid, String themecode){
		try{
			String updateTheme = "update event_layout set global_style=(select themejson from event_page_themes where eventid=0 and themecode=?), themecode=? where eventid=? ::bigint and stage='draft'";
			StatusObj successObj = DbUtil.executeUpdateQuery(updateTheme, new String[]{themecode,themecode,eid});
		}catch(Exception e){
			System.out.println("Exception while update theme");
			return "fail";
		}
		return "success";
	}*/ //commented on 13th Nov 2015 while i18n changes
	
	/*public static Boolean resetLastFinal(String eventid){
		String query = "update event_layout set wide_widgets=aa.wide_widgets,narrow_widgets=aa.narrow_widgets,single_widgets=aa.single_widgets,single_bottom_widgets=aa.single_bottom_widgets,hide_widgets=aa.hide_widgets,updated_at='now()' from (select wide_widgets,narrow_widgets,single_widgets,single_bottom_widgets,hide_widgets from event_layout  where stage='final' and eventid=?::bigint) aa where stage='draft' and eventid=?::bigint ";
		StatusObj statobj = DbUtil.executeUpdateQuery(query, new String[]{eventid,eventid});
		 if(statobj.getStatus() && statobj.getCount()>0)			
		 { updateSync(eventid, "yes");
		    query = "delete from  widget_options where widgetid not in(select widgetid from widget_options where  stage='final' and eventid=?::bigint) and stage='draft' and eventid=?::bigint ";
		   statobj = DbUtil.executeUpdateQuery(query, new String[]{eventid,eventid});
			 
			 
		   query = "update widget_options w set widgetid=aa.widgetid,config_data=aa.config_data,widget_title=aa.widget_title,widget_ref_title=aa.widget_ref_title,updated_at='now()' from (select widgetid,config_data,widget_title,widget_ref_title from widget_options  where stage='final' and eventid=?::bigint) aa where stage='draft' and w.widgetid=aa.widgetid and eventid=?::bigint ";
		   statobj = DbUtil.executeUpdateQuery(query, new String[]{eventid,eventid});
		   
		   query="update widget_styles ws set widgetid=aa.widgetid,styles=aa.styles from(select widgetid,styles from widget_styles where stage='final' and eventid=?::bigint) aa where stage='draft' and ws.widgetid=aa.widgetid and eventid=?::bigint ";
		   statobj = DbUtil.executeUpdateQuery(query, new String[]{eventid,eventid});
		   
		   if(statobj.getStatus() ){
		   return true;
		   }
		   else				 
		   return false;
		 }		 
		 else
		 return false;		
		
	}*/ //commented on 13th Nov 2015 while i18n changes
	public static Boolean checkHideStatus(String widgetid,String ref,JSONObject hides){
		if("".equals(ref))
		{  if( hides.has(widgetid))
			return true;
		  else
			return false;
		}
		else
		return false;
	}
	
	/*public static Boolean saveHide(String eventid,String data){
		try{		  	 
			data=data==null?data="":data;
			data=data.replace("[", "").replace("]", "").replace("\"", "");
			
			String query   = "update event_layout set hide_widgets=? where eventid=?::bigint and stage='draft'";
			StatusObj statobj = DbUtil.executeUpdateQuery(query, new String[]{data,eventid});
				if(statobj.getStatus() && statobj.getCount()>0)
					{updateSync(eventid, "no");
					return true;					
					}
					else						 
					return false;							
		}catch(Exception e){System.out.println(" exception in saveHide  ");return false;}					

		
	}*/ //commented on 13th Nov 2015 while i18n changes
	/*public static Boolean saveLayout(String jsonData) throws Exception {
		//System.out.println("the final json data is::"+jsonData);
		JSONObject data = new JSONObject(jsonData);
		JSONObject titlesjson;
		String wideWidgets="",narrowWidgets="",singleWidgets="",next,singlBottomWidgets="";
		if(data.has("titles"))
		{	titlesjson=data.getJSONObject("titles");
		     saveTitle(data.getString("eventid"), titlesjson);
		}


	try{
		JSONArray wide = data.getJSONArray("column-wide");
		for(int i=0;i<wide.length();i++) {
			Iterator<?> iterator = wide.getJSONObject(i).keys();
			while(iterator.hasNext()) {
				next = (String)iterator.next();
				wideWidgets += next + ",";
				}
		}
		}catch(Exception e){System.out.println(" wide coulmn parsing"+e.getMessage());}
	
	  try{
		JSONArray narrow = data.getJSONArray("column-narrow");
		for(int i=0;i<narrow.length();i++) {
			Iterator<?> iterator = narrow.getJSONObject(i).keys();
			while(iterator.hasNext()) {
			next = (String)iterator.next();
			narrowWidgets += next + ",";
			}
		}
	  }catch(Exception e){System.out.println(" narrow coulmn parsing"+e.getMessage());}
		
	 try{	
		JSONArray single = data.getJSONArray("column-single");
		
		for(int i=0;i<single.length();i++) {
			Iterator<?> iterator = single.getJSONObject(i).keys();
			while(iterator.hasNext()) {
				next = (String)iterator.next();
				singleWidgets += next + ",";
			   }
		     }
        }catch(Exception e){System.out.println(" single coulmn parsing"+e.getMessage());}
		
	 try{
			JSONArray single_bottom = data.getJSONArray("column-single-bottom");	
	    	for(int i=0;i<single_bottom.length();i++) {
			Iterator<?> iterator = single_bottom.getJSONObject(i).keys();
			while(iterator.hasNext()) {
				next = (String)iterator.next();
				singlBottomWidgets += next + ",";
			}
		}
	   }catch(Exception e){System.out.println(" single-bottom coulmn parsing"+e.getMessage());}
	 
		
		if(!"".equals(wideWidgets))wideWidgets = wideWidgets.substring(0, wideWidgets.length()-1);
		if(!"".equals(narrowWidgets))narrowWidgets = narrowWidgets.substring(0, narrowWidgets.length()-1);
		if(!"".equals(singleWidgets))singleWidgets = singleWidgets.substring(0, singleWidgets.length()-1);
		if(!"".equals(singlBottomWidgets))singlBottomWidgets = singlBottomWidgets.substring(0, singlBottomWidgets.length()-1);
			
		String query = "update event_layout set wide_widgets=?,narrow_widgets=?,single_widgets=?,single_bottom_widgets=?,updated_at='now()' where stage=? and eventid=?::bigint ";
		StatusObj statobj = DbUtil.executeUpdateQuery(query, new String[]{wideWidgets,narrowWidgets,singleWidgets,singlBottomWidgets,"draft",data.getString("eventid")});
		updateSync(data.getString("eventid"), "no");
		if(statobj.getStatus() && statobj.getCount()>0 && "draft".equals(data.getString("stage")))
			return true;

		else if(statobj.getStatus() && statobj.getCount()>0 && "final".equals(data.getString("stage"))){
			
			query = "update event_layout set wide_widgets=aa.wide_widgets,narrow_widgets=aa.narrow_widgets,single_widgets=aa.single_widgets,single_bottom_widgets=aa.single_bottom_widgets,hide_widgets=aa.hide_widgets,updated_at='now()',global_style=aa.global_style,themecode=aa.themecode from (select wide_widgets,narrow_widgets,single_widgets,single_bottom_widgets,hide_widgets,global_style,themecode from event_layout  where stage='draft' and eventid=?::bigint) aa where stage='final' and eventid=?::bigint ";
			System.out.println(query); 
			statobj = DbUtil.executeUpdateQuery(query, new String[]{data.getString("eventid"),data.getString("eventid")});
			 if(statobj.getStatus() && statobj.getCount()>0)			
			 { updateSync(data.getString("eventid"), "yes");
			    query = "delete from  widget_options where widgetid not in(select widgetid from widget_options where  stage='draft' and eventid=?::bigint) and stage='final' and eventid=?::bigint ";
			   statobj = DbUtil.executeUpdateQuery(query, new String[]{data.getString("eventid"),data.getString("eventid")});
				 
				 
			   query = "update widget_options w set widgetid=aa.widgetid,config_data=aa.config_data,widget_title=aa.widget_title,widget_ref_title=aa.widget_ref_title,updated_at='now()' from (select widgetid,config_data,widget_title,widget_ref_title from widget_options  where stage='draft' and eventid=?::bigint) aa where stage='final' and w.widgetid=aa.widgetid and eventid=?::bigint ";
			   statobj = DbUtil.executeUpdateQuery(query, new String[]{data.getString("eventid"),data.getString("eventid")});
			   
			   query = "delete from  widget_styles where widgetid not in(select widgetid from widget_styles where  stage='draft' and eventid=?::bigint) and stage='final' and eventid=?::bigint ";
			   statobj = DbUtil.executeUpdateQuery(query, new String[]{data.getString("eventid"),data.getString("eventid")});
			   
			   query = "update widget_styles w set widgetid=aa.widgetid,styles=aa.styles from (select widgetid,styles from widget_styles  where stage='draft' and eventid=?::bigint) aa where stage='final' and w.widgetid=aa.widgetid and eventid=?::bigint ";
			   statobj = DbUtil.executeUpdateQuery(query, new String[]{data.getString("eventid"),data.getString("eventid")});
			   if(statobj.getStatus() ){
			   return true;
			   }
			   else				 
			   return false;
			   
			   
			 }
			 
			 else
			 return false;			 
		 }
		  else
		 return false;		

		

	}*/ //commented on 13th Nov 2015 while i18n changes
	
	public static String getGlobalStyles(String eventid) {
		DBManager dbm = new DBManager();
		StatusObj statobj;
		String query = "select global_style from event_layout where eventid = ?::bigint and stage='draft'";
		statobj = dbm.executeSelectQuery(query, new String[]{eventid});
		if(statobj.getStatus())
			return dbm.getValue(0, "global_Style", "");
		return "";
		
	}
	
	
	
	/*public static Boolean saveGlobalStyles(String current_styles,String eventid) {
		
		System.out.println("in header setting method");
		String db_styles=DbUtil.getVal("select global_style from event_layout where eventid=?::bigint and stage='draft'", new String[]{eventid});
		if(db_styles==null && "".equals(db_styles))
			return false;
		try{
		JSONObject dbjson=new JSONObject(db_styles);
		JSONObject currjson=new JSONObject(current_styles);
		currjson.put("details",dbjson.has("details")?dbjson.getString("details"):"");
		currjson.put("coverPhoto",dbjson.has("coverPhoto")?dbjson.getString("coverPhoto"):"");
		currjson.put("logourl",dbjson.has("logourl")?dbjson.getString("logourl"):"");
		currjson.put("logomsg",dbjson.has("logomsg")?dbjson.getString("logomsg"):"");
		currjson.put("title",dbjson.has("title")?dbjson.getString("title"):"");
		
		String query = "update event_layout set global_style=? where eventid=?::bigint and stage='draft'";
		StatusObj statobj = DbUtil.executeUpdateQuery(query, new String[]{currjson.toString(),eventid});
		updateSync(eventid, "no");
		if(statobj.getStatus())
			return true;
		else
			return false;
		
		}catch(Exception e){
			return false;
		}
		String query = "update event_layout set global_style=? where eventid=?::bigint";
		StatusObj statobj = DbUtil.executeUpdateQuery(query, new String[]{global_style,eventid});
		if(statobj.getStatus())
			return true;
		else
			return false;
	}*/ 
	
	
	/*public static Boolean saveHeaderSettings(String headersettings,String eventid){
		System.out.println("in header setting method");
		String global_style=DbUtil.getVal("select global_style from event_layout where eventid=?::bigint and stage='draft'", new String[]{eventid});
		if(global_style==null && "".equals(global_style))
			return false;
		try{
		JSONObject dbjson=new JSONObject(global_style);
		JSONObject currjson=new JSONObject(headersettings);
		dbjson.put("details",currjson.getString("details"));
		dbjson.put("coverPhoto",currjson.getString("coverPhoto"));
		dbjson.put("logourl",currjson.getString("logourl"));
		dbjson.put("logomsg",currjson.getString("logomsg"));
		dbjson.put("title",currjson.getString("title"));
		
		String query = "update event_layout set global_style=? where eventid=?::bigint and stage='draft'";
		StatusObj statobj = DbUtil.executeUpdateQuery(query, new String[]{dbjson.toString(),eventid});
		if(statobj.getStatus())
			return true;
		else
			return false;
		
		}catch(Exception e){
			return false;
		}
		
	}*/ //commented on 13th Nov 2015 while i18n changes
	
	public static JSONObject getWidgetStyles(String eventid,String widgetid,String stage)throws JSONException {
		String query = "select * from widget_styles where eventid=?::bigint and widgetid=? and stage=?";
		DBManager dbm = new DBManager();
		StatusObj statobj = dbm.executeSelectQuery(query, new String[]{eventid,widgetid,stage});
		String result = "";
		if(statobj.getStatus()) {
			result = dbm.getValue(0, "styles", "");
		}
		return new JSONObject(result);
	}
	public static JSONObject getWidgetStyles(String eventid,String stage)throws JSONException {
		String query="";
		if("draft".equalsIgnoreCase(stage))
		    query = "select * from widget_styles where eventid=?::bigint and stage='draft'";
		else
			query = "select * from widget_styles where eventid=?::bigint and stage='final'";
		DBManager dbm = new DBManager();
		StatusObj statobj = dbm.executeSelectQuery(query, new String[]{eventid});
		JSONObject result = new JSONObject();
		if(statobj.getStatus()) {
			for(int i=0;i<statobj.getCount();i++) {
				result.put(dbm.getValue(i, "widgetid", ""), new JSONObject( dbm.getValue(i, "styles", "")));
			}
		}
		return result;
	}
	/*public static Boolean saveWidgetStyles(String data,String eventid,String widgetid)throws JSONException {
		String query = "update widget_styles set styles=? where eventid=?::bigint and widgetid=? and stage='draft'";
		StatusObj statobj = DbUtil.executeUpdateQuery(query, new String[]{data,eventid,widgetid});
		updateSync(eventid, "no");
		if(statobj.getStatus())
			return true;
		else
			return false;
	}*/ //commented on 13th Nov 2015 while i18n changes
	
	//call this for newly added widget from layout manager
	public static JSONObject InitWidgetStyle(String eventid, String widgetid) throws JSONException {
		String query = "select global_style from event_layout where eventid=?::bigint and stage='draft'";
		DBManager dbm = new DBManager();
		StatusObj statobj = dbm.executeSelectQuery(query, new String[]{eventid});
		if(statobj.getStatus()) {
			JSONObject result = new JSONObject(dbm.getValue(0, "global_style", ""));
			result.remove("bodyBackgroundColor");
			result.remove("contentBackground");
			result.remove("bodyBackgroundImage");
			result.remove("backgroundPosition");
			result.remove("coverPhoto");
			result.remove("details");
			result.remove("title");
			result.put("global", true);
			result.put("hideHeader", false);
			StatusObj s;
			query = "insert into widget_styles(eventid,widgetid,styles,stage) values(?::bigint,?,?,'draft')";
			s = DbUtil.executeUpdateQuery(query, new String[]{eventid,widgetid,result.toString()});
			query="insert into widget_styles(eventid,widgetid,styles,stage) values(?::bigint,?,?,'final')";
			s = DbUtil.executeUpdateQuery(query, new String[]{eventid,widgetid,result.toString()});
			if(s.getStatus())
				return result;
		}
		return new JSONObject();
	}
	public static JSONObject getAllWidgetOptions(String eventid,String stage, JSONObject addedWidgets) throws JSONException {
		String query = "select * from custom_widget_options where eventid=?::bigint and stage=?";
		DBManager dbm = new DBManager();
		StatusObj statobj = dbm.executeSelectQuery(query, new String[]{eventid,stage});
		JSONObject result = new JSONObject();
		if(statobj.getStatus()) {
			for(int i=0;i<statobj.getCount();i++) {
				result.put(dbm.getValue(i, "widgetid", ""), dbm.getValueFromRecord(i, "config_data", ""));
				addedWidgets.remove(dbm.getValue(i, "widgetid", ""));
				//System.out.println("test ::::::"+dbm.getValueFromRecord(i, "config_data", "").toString());
				//result.put(dbm.getValue(i, "widgetid", ""), new JSONObject( dbm.getValueFromRecord(i, "config_data", "").toString()));
			}
		}
		
		Iterator<String> keys = addedWidgets.keys();
		HashMap<String, String> defaultWidgetOptions=EventGlobalTemplates.getWidgetOptions(getLanguageFromDB(eventid));
	    while(keys.hasNext()){
	        String key = keys.next();
	        String val = null;
	        try{
	             //result.put(key, EventGlobalTemplates.getWidgetOptions(key, ""));
	             result.put(key, defaultWidgetOptions.get(key)==null?"":defaultWidgetOptions.get(key));
	        }catch(Exception e){
	        	System.out.println("Exception in DBHelper.java getAllWidgetOptions() ERROR: "+e.getMessage());
	        }

	    }
		
		
		/*String query2 = "select latitude, longitude from eventinfo where eventid = ?::bigint";
		statobj = dbm.executeSelectQuery(query2, new String[]{eventid});
		if(statobj.getStatus() && statobj.getCount()>0){
			try{
				result.put("latitude",dbm.getValue(0, "latitude", ""));
				result.put("longitude", dbm.getValue(0, "longitude", ""));
			}catch(Exception e){
				System.out.println("Exception in MapLonLat");
			}
		}
		*/
		if(result.has("organizer")){
			//String orgName = DbUtil.getVal("select value from config where config_id in(select config_id from eventinfo where eventid=?::bigint) and name='event.hostname'", new String[]{eventid});
			String orgName="";
			try{
				orgName=(String)((HashMap)(CacheManager.getData(eventid, "eventinfo").get("configmap"))).get("event.hostname");
			}catch(Exception e){
				orgName = DbUtil.getVal("select value from config where config_id in(select config_id from eventinfo where eventid=?::bigint) and name='event.hostname'", new String[]{eventid});
				System.out.println("Exception while getting event.hostname in getAllWidgetOptions for eventid: "+eventid+" ERROR: "+e.getMessage());
			}
			if(orgName==null) orgName="";
			if(new JSONObject(result.getString("organizer")).has("hostbydata"))
				if("".equals(new JSONObject(result.getString("organizer")).get("hostbydata")))
					result.put("organizer",new JSONObject(result.getString("organizer")).put("hostbydata",orgName).toString());
		}
		
		
		return result;
	}
	
	

	/*public static String getWidgetOptions(String eventid,String widgetid) throws JSONException {
		return getWidgetOptions(eventid,widgetid,"draft");
	}
	public static String getWidgetOptions(String eventid,String widgetid,String stage) throws JSONException {
		String query = "select * from widget_options where eventid=?::bigint and widgetid=? and stage=?";
		DBManager dbm = new DBManager();
		StatusObj statobj = dbm.executeSelectQuery(query, new String[]{eventid,widgetid,stage});
		String result = "";
		if(statobj.getCount()>0) {
			if(statobj.getStatus()) {
				result = dbm.getValue(0, "config_data", "");
			}
			if("organizer".equals(widgetid)){
				String orgName = DbUtil.getVal("select value from config where config_id in(select config_id from eventinfo where eventid=?::bigint) and name='event.hostname'", new String[]{eventid});
				JSONObject resultJson = new JSONObject(result);
				String hostbydata = resultJson.getString("hostbydata");
				if(hostbydata == null || "".equals(hostbydata))
					hostbydata = orgName;
				resultJson.put("hostbydata", hostbydata);
				result = resultJson.toString();
			}
			return result;
		} else {
			String defaultwidgetid = widgetid;
			if(defaultwidgetid.contains("_"))
				defaultwidgetid = defaultwidgetid.split("_")[0];
			DbUtil.executeUpdateQuery("delete from widget_options where eventid=?::bigint and widgetid=? and stage='draft'", new String[]{eventid,widgetid});
			query = "insert into widget_options(eventid,widgetid,config_data,widget_title,widget_ref_title,stage) (select ?::bigint,?, config_data,widget_title,widget_ref_title,'draft' from widget_options where eventid='0'::bigint and widgetid=?)";
			statobj = DbUtil.executeUpdateQuery(query, new String[]{eventid,widgetid,defaultwidgetid});
			String yes=DbUtil.getVal("select 'yes' from widget_options where eventid=?::bigint and widgetid=? and stage='final'", new String[]{eventid,widgetid});
			query = "insert into widget_options(eventid,widgetid,config_data,widget_title,widget_ref_title,stage) (select ?::bigint,?, config_data,widget_title,widget_ref_title,'final' from widget_options where eventid='0'::bigint and widgetid=?)";
			if(!"yes".equals(yes))
			statobj = DbUtil.executeUpdateQuery(query, new String[]{eventid,widgetid,defaultwidgetid});
			if(statobj.getStatus() && statobj.getCount()>0) {
				return getWidgetOptions(eventid, widgetid);
			}
			return "";
		}
	}*/
/*public static Boolean deteWidgetOption(String widgetid,String eventid){
	//System.out.println("widgetid"+widgetid);
	//System.out.println("eventid"+eventid);
	String query = "delete from  widget_options where eventid=?::bigint and widgetid=? and stage='draft'";
	StatusObj statobj = DbUtil.executeUpdateQuery(query, new String[]{eventid,widgetid});
	if(statobj.getStatus())
		return true;
	else
		return false; 
	
}*/ //commented on 13th Nov 2015 while i18n changes
	
	
	public static String InitHeaderTheme(String eventid) {
		String query = "select themedata from event_header_themes where themeid=0";
		String themedata = DbUtil.getVal(query, new String[]{});
		query = "update event_layout set header_theme = ? where eventid=?::bigint";
		StatusObj statobj = DbUtil.executeUpdateQuery(query, new String[]{themedata,eventid});
		if(statobj.getStatus()) {
			return themedata;
		}
		return "";
	} 
	/*public static String getMyHeaderTheme(String eventid) {
		String query = "select header_theme from event_layout where eventid=?::bigint";
		if("".equals(DbUtil.getVal(query, new String[]{eventid}).trim())) {
			return InitHeaderTheme(eventid);
		} else {
			return DbUtil.getVal(query, new String[]{eventid});
		}
	}
	public static Boolean saveHeaderTheme(String themedata,String eventid) {
		String query = "update event_layout set header_theme=? where eventid=?::bigint";
		StatusObj statobj = DbUtil.executeUpdateQuery(query, new String[]{themedata,eventid});
		if(statobj.getStatus())
			return true;
		else
			return false;
	} 
	public static Boolean ApplyHeaderTheme(String themeid,String eventid){
		String query = "update event_layout set header_theme=(select themedata from event_header_themes where themeid=?::bigint) where eventid=?::bigint";
		StatusObj statobj = DbUtil.executeUpdateQuery(query, new String[]{themeid,eventid});
		if(statobj.getStatus())
			return true;
		else
			return false;
	}
	
	public static JSONObject BrowseThemes() throws JSONException {
		//String query = "select thumbnail,description,name,categories,date_created,themeid,ownerid from event_header_themes where themeid!=0 and status='approved'";
		String query = "select thumbnail,description,name,categories,date_created,themeid,ownerid from event_header_themes where status='approved' order by themeid";
		DBManager dbm = new DBManager();
		StatusObj s = dbm.executeSelectQuery(query, new String[]{});
		JSONArray themesarray = new JSONArray();
		JSONObject theme, result = new JSONObject();
		if(s.getStatus()) {
			result.put("total", s.getCount());
			for(int i=0;i<s.getCount();i++) {
				theme = new JSONObject();
				theme.put("name", dbm.getValue(i, "name", ""));
				theme.put("description", dbm.getValue(i, "description", ""));
				theme.put("themeid", dbm.getValue(i, "themeid", ""));
				theme.put("thumbnail", dbm.getValue(i, "thumbnail", ""));
				themesarray.put(theme);
			}
			result.put("themes", themesarray);
		}
		return result;
	}
	
	public static String currentThemeName(String eventid){
		String curTheme = DbUtil.getVal("select a.name from event_header_themes a, event_layout b where a.themedata=b.header_theme and b.stage='draft' and b.eventid=?::bigint", new String[]{eventid});
		return curTheme;
	}
		public static HashMap<String, String> getEventinfo(String eventid){
		DBManager dbmanager=new DBManager();
		
		HashMap <String,String>hmap=new HashMap<String,String>();
		String query="select trim(to_char(('0001-01-01'||' '|| starttime):: timestamp, 'HH12:MI')) as startTime,trim(to_char(('0001-01-01'||' '|| starttime):: timestamp, 'AM')) as startAMPM,trim(to_char(('0001-01-01'||' '|| endtime):: timestamp, 'AM')) as endAMPM,trim(to_char(a.start_date, 'Dy'))as startDay, trim(to_char(a.start_date, 'Mon')) as startMon,trim(to_char(a.start_date, 'DD')) as startDate, trim(to_char(a.start_date, 'YYYY')) as startYear ," +
				" trim(to_char(('0001-01-01'||' '|| endtime):: timestamp, 'HH12:MI')) as endTime,trim(to_char(a.end_date, 'Dy'))as endDay, trim(to_char(a.end_date, 'Mon')) as endMon,trim(to_char(a.end_date, 'DD')) as endDate, trim(to_char(a.end_date, 'YYYY')) as endYear  " +
				" ,*  from eventinfo a where eventid=?::bigint";
		StatusObj statobj=dbmanager.executeSelectQuery(query,new String[]{eventid});
		try{
			if(statobj.getStatus()){
				String [] columnnames=dbmanager.getColumnNames();
				for(int j=0;j<columnnames.length;j++){
					hmap.put(columnnames[j],dbmanager.getValue(0,columnnames[j],""));
				}
			}
		}
		catch(Exception e){
			System.out.println("Exception in getRegistrationData"+e.getMessage());
		}
		//System.out.println("hmap::"+hmap);
		return hmap;
		
		
	}*/ //commented on 13th Nov 2015 while i18n changes
		

	

		public static String getFBAppId(String name){
			String fbappid=DbUtil.getVal("select value from config where config_id='0' and name=?",new String[]{name});
			return fbappid;
		}
		

		
		

public static HashMap<String, String> getTitles(String eventid,String stage) {
		/* HashMap< String ,String> titles=new HashMap<String, String>();
	     String query = "select widget_ref_title,widget_title,widgetid from widget_options where (eventid=?::bigint or eventid='0'::bigint) and (stage='draft' or  stage='init') order by eventid";
		if("final".equals(stage))
			   query = "select widget_ref_title,widget_title,widgetid from widget_options where (eventid=?::bigint or eventid='0'::bigint) and (stage='final' or  stage='init') order by eventid";
*/		
	 	HashMap<String,String> defWidTitMap=getDefWidgetTitles(getLanguageFromDB(eventid));
	 	String cusQry="select widget_ref_title,widget_title,widgetid from custom_widget_options where eventid=?::bigint and stage=?";
	     DBManager db=new DBManager();
			StatusObj stb=db.executeSelectQuery(cusQry, new String[]{eventid,stage});
			if(stb.getStatus()){
				for(int i=0;i<stb.getCount();i++){
					
					String widgetid=db.getValue(i, "widgetid", "");
					if(defWidTitMap.containsKey(widgetid)){
						defWidTitMap.remove(widgetid);
						defWidTitMap.remove(widgetid+"_ref");
					}
					defWidTitMap.put(db.getValue(i, "widgetid", ""), db.getValue(i, "widget_title", ""));
					defWidTitMap.put(db.getValue(i, "widgetid", "")+"_ref", db.getValue(i, "widget_ref_title", ""));
					
			/*titles.put(db.getValue(i, "widgetid", ""), db.getValue(i, "widget_title", ""));
			titles.put(db.getValue(i, "widgetid", "")+"_ref", db.getValue(i, "widget_ref_title", ""));*/
				}
		  }
			return defWidTitMap;
		}

public static HashMap<String,String> getDefWidgetTitles(String lang){
	HashMap<String,String> defWidgetTitMap=new HashMap<String,String>();
	String defWidgetTitQry="select widget_ref_title,widget_title,widgetid from default_widget_options where lang=? and stage='init'";
	DBManager db=new DBManager();
	StatusObj statobj=null;
	statobj=db.executeSelectQuery(defWidgetTitQry,new String []{lang});
	int count=statobj.getCount();
	if(statobj.getStatus() && count>0){
		for(int i=0;i<count;i++){
		    defWidgetTitMap.put(db.getValue(i, "widgetid", ""), db.getValue(i, "widget_title", ""));
		    defWidgetTitMap.put(db.getValue(i, "widgetid", "")+"_ref", db.getValue(i, "widget_ref_title", ""));
		}
	}
	return defWidgetTitMap;
}

/*public static String getTitle(String eventid,String widgetid) {
	 String query = "select widget_title,widgetid,eventid from widget_options where   widgetid=?  and (eventid=?::bigint or eventid='0'::bigint) and (stage='draft' or  stage='init') order by eventid desc ";
	 String title =DbUtil.getVal(query, new String[]{widgetid,eventid});
	 title=title==null?"":title;
		return title;
	}



 public static void saveTitle(String eventid,JSONObject titles) {
    try{					
		 Iterator keys=titles.keys();
	     while(keys.hasNext()){
	  
		 String widget=(String)keys.next();
	     String title=(String)titles.get(widget);
	     
	     saveRefTitle(eventid,title,widget);
		 }				
      }catch(Exception e){System.out.println("default saving  titles");	}			  
}
 
 public  static boolean saveRefTitle(String eventid,String title,String widgetid) {
		try{
		  	 
	String query   = "update widget_options set widget_ref_title=?,updated_at='now()' where eventid=?::bigint and widgetid=? and stage='draft'";
	StatusObj statobj = DbUtil.executeUpdateQuery(query, new String[]{title,eventid,widgetid});
		if(statobj.getStatus() && statobj.getCount()>0)
			return true;
			else{
				 query= "insert into widget_options(eventid,widgetid,widget_ref_title,config_data,stage) values(?::bigint,?,?,?,'draft')";
				statobj = DbUtil.executeUpdateQuery(query, new String[]{eventid,widgetid,title,""});
				String yes=DbUtil.getVal("select 'yes' from widget_options where eventid=?::bigint and widgetid=? and stage='final'", new String[]{eventid,widgetid});
				if(!"yes".equals(yes)){
				query= "insert into widget_options(eventid,widgetid,widget_ref_title,config_data,stage) values(?::bigint,?,?,?,'final')";
				statobj = DbUtil.executeUpdateQuery(query, new String[]{eventid,widgetid,title,""});
				}
				if(statobj.getStatus())
					return true;
				else
					return false;
			}
						
		}catch(Exception e){System.out.println(" exception while savingsaving  titles");return false;}					
	 }

 
public static String getRefTitle(String eventid,String widgetid) {
	 String query = "select widget_ref_title,widgetid,eventid from widget_options where   widgetid=?  and (eventid=?::bigint or eventid='0'::bigint) and (stage='draft' or  stage='init') order by eventid desc ";
	 String title =DbUtil.getVal(query, new String[]{widgetid,eventid});
	 title=title==null?"":title;
		return title;
	}*/ //commented on 13th Nov 2015 while i18n changes
 
 /*public  static boolean saveTitle(String eventid,String title,String widgetid) {
		try{
		  	
	String query   = "update widget_options set widget_title=?,updated_at='now()' where eventid=?::bigint and widgetid=? and stage='draft'";
	StatusObj statobj = DbUtil.executeUpdateQuery(query, new String[]{title,eventid,widgetid});
	updateSync(eventid, "no");
		if(statobj.getStatus() && statobj.getCount()>0)
			return true;
			else{
				 query= "insert into widget_options(eventid,widgetid,widget_title,config_data,stage) values(?::bigint,?,?,?,'draft')";
				statobj = DbUtil.executeUpdateQuery(query, new String[]{eventid,widgetid,title,""});
				String yes=DbUtil.getVal("select 'yes' from widget_options where eventid=?::bigint and widgetid=? and stage='final'", new String[]{eventid,widgetid});
				if(!"yes".equals(yes)){				
				 query= "insert into widget_options(eventid,widgetid,widget_title,config_data,stage) values(?::bigint,?,?,?,'final')";
				 statobj = DbUtil.executeUpdateQuery(query, new String[]{eventid,widgetid,title,""});
				}
				if(statobj.getStatus())
					return true;
				else
					return false;
			}
						
		}catch(Exception e){System.out.println(" exception while savingsaving  titles");return false;}					
	 }







		public static HashMap<String,String> getConfigValuesFromDb(String eventid){
			String ConfigQuery="select * from config where config_id=(select config_id from eventinfo where eventid=CAST(? as INTEGER))";
			DBManager db=new DBManager();
			HashMap<String,String> confighm=new HashMap<String,String>();
			StatusObj sb=db.executeSelectQuery(ConfigQuery,new String[]{eventid});
			if(sb.getStatus()){
				for(int i=0;i<sb.getCount();i++){
					confighm.put(db.getValue(i,"name",""),db.getValue(i,"value",""));
				}
			}
			return confighm;
		}
		
		public static HashMap<String,String> getVenueCssMsgMap(String venueid){
			HashMap<String,String> venuecssmap=new HashMap<String,String>();
			String venuecss="",notavail="",notavailmsg="",unassign="",unassignmsg="";
			if(!"".equals(venueid) && venueid!=null)
			venuecss=DbUtil.getVal("select layout_css from venue_sections where venue_id=CAST(? AS INTEGER)",new String[]{venueid});
			venuecssmap.put("venuecss", venuecss);
			DBManager dbm=new DBManager();
			StatusObj statobj=null;
			String venuecssqry="select * from venue_seating_images where venue_id=CAST(? AS BIGINT) and context in('notavailable','unassign')";
			if(!"".equals(venueid) && venueid!=null)
			statobj=dbm.executeSelectQuery(venuecssqry, new String[]{venueid});
			if(statobj.getStatus() && statobj.getCount()>0){
				for(int i=0;i<statobj.getCount();i++){
					if("notavailable".equals(dbm.getValue(i,"context",""))){
						venuecssmap.put("notavailimg", dbm.getValue(i,"image",""));
						venuecssmap.put("notavailmsg", dbm.getValue(i,"message",""));
					}
					if("unassign".equals(dbm.getValue(i,"context",""))){
						venuecssmap.put("unassignimg", dbm.getValue(i,"image",""));
						venuecssmap.put("unassignmsg", dbm.getValue(i,"message",""));
					}
				}
			}
			
			return venuecssmap;
		}
		
		public static String getRecurringEventDates(String eventid,String purpose){
			String query="select  to_char(zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ),'Dy, Mon DD, YYYY HH12:MI AM') as evt_start_date"
		      +",to_char(zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ),'Dy, Mon DD, YYYY') as evt_start_date1 from event_dates where eventid=cast(? as numeric) and (zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ))>=current_date order by (zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ))";
			  String showTimePart=DbUtil.getVal("select value from mgr_config c,eventinfo e where e.eventid=?::BIGINT and c.name='mgr.recurring.showtime' and e.mgr_id=c.userid",new String[]{eventid});		  
				if(showTimePart==null || "".equals(showTimePart)) showTimePart="Y";
				ArrayList al=new ArrayList();
				DBManager db=new DBManager();
				String str=null;
				StatusObj stob=db.executeSelectQuery(query,new String[]{eventid} );
				if(stob.getStatus()){
					for(int i=0;i<stob.getCount();i++){
					HashMap<String,String> hm=new HashMap<String,String>();
						if("N".equals(showTimePart))
						hm.put("display",db.getValue(i,"evt_start_date1",""));
						//al.add(db.getValue(i,"evt_start_date1",""));
						else
						hm.put("display",db.getValue(i,"evt_start_date",""));
						//al.add(db.getValue(i,"evt_start_date",""));
						hm.put("value",db.getValue(i,"evt_start_date",""));
						al.add(hm);
					}
				}
				return getRecurringDatesForEventTickets(al,purpose,eventid);
			}
		
		static String getRecurringDatesForEventTickets(ArrayList al,String purpose,String eventid){
			String str=null;
			String checkrsvp=null;
			if(al!=null&&al.size()>0){
				if("tickets".equals(purpose))
					str="<select name='eventdate' id='eventdate'  onchange=getTicketsJsonBefore('"+eventid+"');>";
					
				else{
					checkrsvp=DbUtil.getVal("Select value from config where name='event.rsvp.enabled' and config_id in (select config_id from eventinfo where eventid=?::bigint)",new String[]{eventid});
					if("yes".equals(checkrsvp)){
						String get_key=null,get_value=null;
						//String Rsvp_RECURRING_EVEBT_DATES = "select distinct eventdate as date_display from event_reg_transactions where eventid=? and eventdate!='' and tid in (select tid from rsvp_transactions where eventid=? and responsetype='Y') order by date_display";
						String Rsvp_RECURRING_EVEBT_DATES  = "select date_display from event_dates where eventid=CAST(? AS BIGINT) and (zone_startdate+cast(cast(to_timestamp(COALESCE(zone_start_time,'00'),'HH24:MI:SS') as text) as time ))>=current_date order by date_key";

						DBManager dbmanager = new DBManager();
						StatusObj statobj = dbmanager.executeSelectQuery(Rsvp_RECURRING_EVEBT_DATES, new String[]{eventid});
						int rsvpcount = statobj.getCount();
						str="<select name='event_date' id='event_date' onchange=showRSVPAttendeesList('"+eventid+"');>";
						str=str+"<option value='Select Date'>--Select Date--</option>";
						if (statobj.getStatus() && rsvpcount > 0) {
						str="<select name='event_date' id='event_date' onchange=showRSVPAttendeesList('"+eventid+"');>";
						str=str+"<option value='Select Date'>--Select Date--</option>";
							for (int k = 0; k < rsvpcount; k++) {
								get_value = dbmanager.getValue(k, "date_display", "");
								
								str=str+"<option value='"+get_value+"'>"+get_value+"</option>";
							}
						}	
					}
					else{
						str="<select name='event_date' id='event_date' onchange=showAttendeesList('"+eventid+"');>";
					}
				}
				if(!"yes".equals(checkrsvp)){
					//HashMap hm=recurring_display(eventid);
					for(int i=0;i<al.size();i++){
						HashMap<String,String> hm1=(HashMap<String,String>)al.get(i);
						str=str+"<option value='"+hm1.get("value")+"'>"+hm1.get("display")+"</option>";
						//str=str+"<option value='"+(String)al.get(i)+"'>"+(String)al.get(i)+"</option>";
						//str=str+"<option value='"+(String)al.get(i)+"'>"+(String)hm.get(i)+"</option>";
					}
				}
				str=str+"</select>";

			}
			return str;

		}
		
		public static String getRecurringDatesLabel(String eid){
			String recurdateslabel="";
			if(!"".equals(eid) && eid!=null){
				recurdateslabel=DbUtil.getVal("select attrib_value from event_display_attribs where  module='RegFlowWordings' and attrib_name='event.reg.recurringdates.label' and eventid=CAST(? as BIGINT)", new String[]{eid});
				if(recurdateslabel==null || "".equals(recurdateslabel))
					recurdateslabel=DbUtil.getVal("select attribdefaultvalue from event_display_defaultattribs where  module='RegFlowWordings' and attribname='event.reg.recurringdates.label'",null);
				}
			if(recurdateslabel==null || "".equals(recurdateslabel))
				recurdateslabel="Select a date and time to attend";
			return recurdateslabel;
		}*/ //commented on 13th Nov 2015 while i18n changes
		
		/*public static String getCustomCSS(String eid){
			String customcss="";
			DBManager dbm=new DBManager();
			StatusObj statobj=null;
			String customcssqry="select themetype,themecode from user_roller_themes where upper(module)='EVENT' and refid=?";
			statobj=dbm.executeSelectQuery(customcssqry, new String[]{eid});
			String themeType=dbm.getValue(0, "themetype", "");
			String themeCode=dbm.getValue(0, "themecode", "");
			String query="";
			String[] params=null;
			if("CUSTOM".equalsIgnoreCase(themeType))
				customcss=DbUtil.getVal("select cssurl  from user_custom_roller_themes where refid=? ", new String[]{eid});
			else if("DEFAULT".equalsIgnoreCase(themeType))
				customcss=DbUtil.getVal("select cssurl from ebee_roller_def_themes where upper(module)='EVENT'" +
						"and themecode=?", new String[]{themeCode});
			else if("PERSONAL".equalsIgnoreCase(themeType))
			   customcss=DbUtil.getVal("select cssurl from user_customized_themes where upper(module)='EVENT'" +
				"and themeid=?", new String[]{themeCode});
			else
				customcss=DbUtil.getVal("select cssurl  from ebee_roller_def_themes where upper(module)='EVENT'" +
					"and themecode=?", new String[]{"basic"});
			
		   return customcss;
		}*/ //commented on 13th Nov 2015 while i18n changes
		
		public static HashMap<String,String> getTrackUrlDetails(String trackcode,String eid){
			HashMap<String,String> detailsMap=new HashMap<String,String>();
			String query="select photo,message from trackurls where trackingcode=? and eventid=?";
			DBManager dbm=new DBManager();
			StatusObj sbj=null;
			sbj=dbm.executeSelectQuery(query,new String[]{trackcode,eid});
			if(sbj.getStatus() && sbj.getCount()>0){
				detailsMap.put("photo",dbm.getValue(0,"photo",""));
				detailsMap.put("message",dbm.getValue(0,"message",""));
			}
		return detailsMap;
		}
		
		public static String getWidgetType(String widgetid,HashMap<String,String> configMap) throws Exception{
			ArrayList<String> arrlist=new ArrayList<String>(Arrays.asList("single","wide","narrow","singlebottom"));
			String widgetData=configMap.get("widgets");
				if(widgetData==null)
					return "none";
		JSONObject widgetjson=new JSONObject(widgetData);      
		System.out.println("the widget json is::"+widgetjson);
		for(int i=0;i<widgetjson.length();i++){
			JSONArray jsonarr=(JSONArray)widgetjson.get(arrlist.get(i));
			if(jsonarr.length()==0)continue;
			for(int j=0;j<jsonarr.length();j++){
				JSONObject jsonObj=jsonarr.getJSONObject(j);
				if(jsonObj.has(widgetid))
				return arrlist.get(i);
			}
		}
			return "none";
		}
		
		
		public static HashMap<String, String> getDefaultWidgetTemplates(String lang){
			System.out.println("In DBHelpers.java getDefaultWidgetTemplates");
			HashMap<String, String> hm = new HashMap<String, String>();
			String query="select template_key,template_value from layout_templates where lang=?";
			DBManager dbm=new DBManager();
			StatusObj statobj=null;
			statobj=dbm.executeSelectQuery(query, new String[]{lang});
			if (statobj.getStatus() && statobj.getCount() > 0) {
				for(int i=0;i<statobj.getCount();i++){
					String key=dbm.getValue(i, "template_key", "");
					String value=dbm.getValue(i, "template_value", "");
					hm.put(key, value);
				}
			}
			return hm;
		}
		public static HashMap<String,HashMap<String, String>> getAllLanguageDefaultGlobalTemplates(){
			System.out.println("In DBHelpers.java getAllLanguageDefaultGlobalTemplates");
			
			HashMap<String,HashMap<String, String>> langWidgetTemplates=new HashMap<String,HashMap<String, String>>();
			HashMap<String, String> widgetTemplates = null;
			String query="select template_key,template_value,lang from layout_templates";
			DBManager dbm=new DBManager();
			StatusObj statobj=null;
			statobj=dbm.executeSelectQuery(query, null);
			if (statobj.getStatus() && statobj.getCount() > 0) {
				for(int i=0;i<statobj.getCount();i++){
					String lang=dbm.getValue(i, "lang", "en_US");
					String key=dbm.getValue(i, "template_key", "");
					String value=dbm.getValue(i, "template_value", "");
					if(langWidgetTemplates.containsKey(lang)){
						widgetTemplates=langWidgetTemplates.get(lang);
						widgetTemplates.put(key, value);
					}else{
						widgetTemplates=new HashMap<String, String>();
						widgetTemplates.put(key, value);
						langWidgetTemplates.put(lang, widgetTemplates);
					}
				}
			}
			return langWidgetTemplates;
		}
		
		/*private static void updateSync(String eventid,String sync){
			String query = "update event_layout set sync=? where eventid=?::bigint and stage='draft'";
			StatusObj statobj = DbUtil.executeUpdateQuery(query, new String[]{sync,eventid});
		}
		
		
		public static HashMap<String, String> getGlobalWidgetOptions(){
			System.out.println("In DBHelpers.java getGlobalWidgetOptions");
			HashMap<String, String> hm = new HashMap<String, String>();
			
			String query="select widgetid,config_data from widget_options where eventid='0'::bigint and stage='init'";
			DBManager dbm=new DBManager();
			StatusObj statobj=null;
			statobj=dbm.executeSelectQuery(query, null);
			if (statobj.getStatus() && statobj.getCount() > 0) {
				for(int i=0;i<statobj.getCount();i++){
					String key=dbm.getValue(i, "widgetid", "");
					String value=dbm.getValue(i, "config_data", "");
					hm.put(key, value);
				}
			}
			return hm;
		}*/ //commented on 13th Nov 2015 while i18n changes
		
		public static HashMap<String,HashMap<String, String>> getAllLanguageDefaultWidgetOptions(){
			System.out.println("In DBHelpers.java getAllLanguageDefaultWidgetOptions");
			HashMap<String,HashMap<String, String>> langWidgetOptions=new HashMap<String,HashMap<String, String>>();
			HashMap<String, String> widgetOptions = null;
			String query="select widgetid,config_data,lang from default_widget_options where stage='init'";
			DBManager dbm=new DBManager();
			StatusObj statobj=null;
			statobj=dbm.executeSelectQuery(query, null);
			if (statobj.getStatus() && statobj.getCount() > 0) {
				for(int i=0;i<statobj.getCount();i++){
					String lang=dbm.getValue(i, "lang", "en");
					String key=dbm.getValue(i, "widgetid", "");
					String value=dbm.getValue(i, "config_data", "");
					if(langWidgetOptions.containsKey(lang)){
						widgetOptions=langWidgetOptions.get(lang);
						widgetOptions.put(key, value);
					}else{
						widgetOptions=new HashMap<String, String>();
						widgetOptions.put(key, value);
						langWidgetOptions.put(lang, widgetOptions);
					}
				}
			}
			return langWidgetOptions;
		}
		
		public static HashMap<String, String> getDefaultWidgetOptions(String lang){
			System.out.println("In DBHelpers.java getDefaultWidgetOptions");
			HashMap<String, String> hm = new HashMap<String, String>();
			//String lang=getLanguageFromDB(eventid);
			String query="select widgetid,config_data from default_widget_options where lang=? and stage='init'";
			DBManager dbm=new DBManager();
			StatusObj statobj=null;
			statobj=dbm.executeSelectQuery(query, new String[]{lang});
			if (statobj.getStatus() && statobj.getCount() > 0) {
				for(int i=0;i<statobj.getCount();i++){
					String key=dbm.getValue(i, "widgetid", "");
					String value=dbm.getValue(i, "config_data", "");
					hm.put(key, value);
				}
			}
			return hm;
		}
		
		
		
		public static void getDataHash(HashMap eventInfo,HashMap<String, String> dataHash){
			
			dataHash.put("eventposition", (String) eventInfo.get("eventposition"));
			dataHash.put("cancel_by", (String) eventInfo.get("cancel_by"));
			dataHash.put("feature_type", (String) eventInfo.get("feature_type"));
			dataHash.put("phone", (String) eventInfo.get("phone"));
			dataHash.put("event_type", (String) eventInfo.get("event_type"));
			dataHash.put("address1", (String) eventInfo.get("address1"));
			dataHash.put("address2", (String) eventInfo.get("address2"));
			dataHash.put("type", (String) eventInfo.get("type"));
			dataHash.put("description", (String) eventInfo.get("description"));
			//here lm=LayoutManage
			dataHash.put("startday", (String) eventInfo.get("lm_startDay"));
			dataHash.put("city", (String) eventInfo.get("city"));
			dataHash.put("current_level", (String) eventInfo.get("current_level"));
			dataHash.put("showlogin", (String) eventInfo.get("showlogin"));
			dataHash.put("role", (String) eventInfo.get("role"));
			dataHash.put("longitude", (String) eventInfo.get("longitude"));
			dataHash.put("showinhomepage", (String) eventInfo.get("showinhomepage"));
			dataHash.put("startmon", (String) eventInfo.get("lm_startMon"));
			dataHash.put("created_by", (String) eventInfo.get("created_by"));
			dataHash.put("starttime", (String) eventInfo.get("lm_startTime"));
			dataHash.put("status", (String) eventInfo.get("status"));
			dataHash.put("startampm", (String) eventInfo.get("lm_startAMPM"));
			dataHash.put("code", (String) eventInfo.get("code"));
			dataHash.put("country", (String) eventInfo.get("country"));
			dataHash.put("category", (String) eventInfo.get("category"));
			dataHash.put("startdate", (String) eventInfo.get("_startDay"));
			dataHash.put("updated_at", (String) eventInfo.get("updated_at"));
			dataHash.put("ebee_st_desc", (String) eventInfo.get("ebee_st_desc"));
			dataHash.put("email", (String) eventInfo.get("email"));
			dataHash.put("latitude", (String) eventInfo.get("latitude"));
			dataHash.put("enddate", (String) eventInfo.get("_endDay"));
			dataHash.put("region", (String) eventInfo.get("region"));
			dataHash.put("endtime", (String) eventInfo.get("lm_endTime"));
			dataHash.put("config_id", (String) eventInfo.get("config_id"));
			dataHash.put("currency_update_date", (String) eventInfo.get("currency_update_date"));
			dataHash.put("mgr_id", (String) eventInfo.get("mgr_id"));
			dataHash.put("photourl", (String) eventInfo.get("photourl"));
			dataHash.put("state", (String) eventInfo.get("state"));
			dataHash.put("endyear", (String) eventInfo.get("_endYear"));
			dataHash.put("nts_enable", (String) eventInfo.get("nts_enable"));
			dataHash.put("eventid", (String) eventInfo.get("eventid"));
			dataHash.put("mgr_st_desc", (String) eventInfo.get("mgr_st_desc"));
			dataHash.put("current_fee", (String) eventInfo.get("current_fee"));
			dataHash.put("nts_commission", (String) eventInfo.get("nts_commission"));
			dataHash.put("attendeepagephoto", (String) eventInfo.get("attendeepagephoto"));
			dataHash.put("end_date", (String) eventInfo.get("end_date"));
			dataHash.put("unitid", (String) eventInfo.get("unitid"));
			dataHash.put("startyear", (String) eventInfo.get("_startYear"));
			dataHash.put("created_at", (String) eventInfo.get("created_at"));
			dataHash.put("updated_by", (String) eventInfo.get("updated_by"));
			dataHash.put("endday", (String) eventInfo.get("lm_endDay"));
			dataHash.put("internalcomments", (String) eventInfo.get("internalcomments"));
			dataHash.put("tags", (String) eventInfo.get("tags"));
			dataHash.put("enddate_est", (String) eventInfo.get("enddate_est"));
			dataHash.put("listebee", (String) eventInfo.get("listebee"));
			dataHash.put("update_desc", (String) eventInfo.get("update_desc"));
			dataHash.put("venue", (String) eventInfo.get("venue"));
			dataHash.put("endmon", (String) eventInfo.get("lm_endMon"));
			dataHash.put("pblview_ok", (String) eventInfo.get("pblview_ok"));
			dataHash.put("endampm", (String) eventInfo.get("lm_endAMPM"));
			dataHash.put("price_id", (String) eventInfo.get("price_id"));
			dataHash.put("start_date", (String) eventInfo.get("start_date"));
			dataHash.put("listtype", (String) eventInfo.get("listtype"));
			dataHash.put("comments", (String) eventInfo.get("comments"));
			dataHash.put("eventname", (String) eventInfo.get("eventname"));
			dataHash.put("evt_level", (String) eventInfo.get("evt_level"));
		}
		
		public static HashMap<String, String> prepareHashMapFromJSON(JSONObject jsonData){
			//System.out.println("prepareHashMapFromJSON jsonData: "+jsonData);
			HashMap<String, String> hashmap=new HashMap<String, String>();
			Iterator<String> keysItr = jsonData.keys();
		    while(keysItr.hasNext()) {
		        String key = keysItr.next();
		        String value="";
				try {
					value = jsonData.getString(key);
				} catch (JSONException e) {
					e.printStackTrace();
				}
		        hashmap.put(key, value);
		    }
		    return hashmap;
		}
		
}

