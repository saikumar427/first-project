package com.eventbee.layout;

import java.net.URLDecoder;
import java.util.HashMap;
import java.util.Iterator;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import com.eventbee.cachemanage.CacheManager;
import com.eventbee.general.DBManager;
import com.eventbee.general.DbUtil;
import com.eventbee.general.StatusObj;

public class BuyerAttDBHelper {
	
	public static String getLayout(String eventid,String ref,String stage,String type) throws Exception {
		try{
		DBManager dbm = new DBManager();
		StatusObj statobj;
		System.out.println("stage:::::"+stage);
		HashMap<String, String> widgettitles=getTitles(eventid,stage,type) ;
		String query = "select * from buyer_att_page_layout where eventid = ?::bigint and stage = 'draft' and layout_type=?";
		if("final".equals(stage))
			query = "select * from buyer_att_page_layout where eventid = ?::bigint and stage = 'final' and layout_type=?";
		
		statobj = dbm.executeSelectQuery(query, new String[]{eventid,type});
		
		
		JSONObject result = null;
		
		if(statobj.getStatus() && statobj.getCount()>0 ) {
			result=fillLayout(eventid,ref,dbm,widgettitles);
			
		}else{
			//for final and draft(preview), default event_layout is same 
			String	defaultQuery = "select * from buyer_att_page_layout where eventid = '1'::bigint and stage = 'final' and layout_type=?";
			
			statobj = dbm.executeSelectQuery(defaultQuery, new String[]{type});
			
			result=fillLayout(eventid,ref,dbm,widgettitles);
		}
		
		//result.put("allThemes", getThemeDetails());
		
		 return result.toString();
		}catch(Exception e){System.out.println("exception while getlayout"+e.getMessage());e.printStackTrace();}
		return "";
	}
	
	public static HashMap<String, String> getTitles(String eventid,String stage,String type) {
	 	HashMap<String,String> defWidTitMap=getDefWidgetTitles(DBHelper.getLanguageFromDB(eventid));
	 	String cusQry="select widget_ref_title,widget_title,widgetid from buyer_att_custom_widget_options where eventid=?::bigint and stage=? and layout_type=?";
	     DBManager db=new DBManager();
			StatusObj stb=db.executeSelectQuery(cusQry, new String[]{eventid,stage,type});
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
			if(DBHelper.checkHideStatus(widgets[i],ref,hidewidgets))
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
			if(DBHelper.checkHideStatus(widgets[i],ref,hidewidgets))
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
			if(DBHelper.checkHideStatus(widgets[i],ref,hidewidgets))
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
			if(DBHelper.checkHideStatus(widgets[i],ref,hidewidgets))
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
			result.put("header_theme",DBHelper.InitHeaderTheme(eventid));
		}
		
		JSONObject added = LayoutManager.concatArrays(single,wide,narrow,single_bottom);
		/*System.out.println("!!! added: "+added);*/
		result.put("added",added);
		
		}catch(Exception e){
			System.out.println("Exception in DBHelper.java fillLayout() ERROR:: "+e.getMessage());
		}
		return result;
	}
	
	public static HashMap<String,String> getDefWidgetTitles(String lang){
		HashMap<String,String> defWidgetTitMap=new HashMap<String,String>();
		String defWidgetTitQry="select widget_ref_title,widget_title,widgetid from buyer_att_def_widget_options where lang=? and stage='init'";
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
	
	public static JSONObject getAllWidgetOptions(String eventid,String stage,String type, JSONObject addedWidgets) throws JSONException {
		String query = "select * from buyer_att_custom_widget_options where eventid=?::bigint and stage=? and layout_type=?";
		DBManager dbm = new DBManager();
		StatusObj statobj = dbm.executeSelectQuery(query, new String[]{eventid,stage,type});
		JSONObject result = new JSONObject();
		if(statobj.getStatus()) {
			
			for(int i=0;i<statobj.getCount();i++) {
				result.put(dbm.getValue(i, "widgetid", ""), dbm.getValueFromRecord(i, "config_data", ""));
				addedWidgets.remove(dbm.getValue(i, "widgetid", ""));
			}
		}
		
		Iterator<String> keys = addedWidgets.keys();
		HashMap<String, String> defaultWidgetOptions=EventGlobalTemplates.getBuyerWidgetOptions(DBHelper.getLanguageFromDB(eventid),type);
	    while(keys.hasNext()){
	        String key = keys.next();
	        String val = null;
	        try{
	             result.put(key, defaultWidgetOptions.get(key)==null?"":defaultWidgetOptions.get(key));
	        }catch(Exception e){
	        	System.out.println("Exception in DBHelper.java getAllWidgetOptions() ERROR: "+e.getMessage());
	        }

	    }
		if(result.has("organizer")){
			String orgName=(String)((HashMap)(CacheManager.getData(eventid, "eventinfo").get("configmap"))).get("event.hostname");
			if(new JSONObject(result.getString("organizer")).has("hostbydata"))
				if("".equals(new JSONObject(result.getString("organizer")).get("hostbydata")))
					result.put("organizer",new JSONObject(result.getString("organizer")).put("hostbydata",orgName).toString());
		}
		
		
		return result;
	}
	
	public static HashMap<String,HashMap<String, String>> getAllLanguageDefaultBuyerWidgetOptions(){
		System.out.println("In DBHelpers.java getAllLanguageDefaultWidgetOptions");
		HashMap<String,HashMap<String, String>> langWidgetOptions=new HashMap<String,HashMap<String, String>>();
		HashMap<String, String> widgetOptions = null;
		String query="select widgetid,config_data,lang from buyer_att_def_widget_options where stage='init' and layout_type='buyer'";
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
	
	public static HashMap<String, String> getDefaultBuyerWidgetOptions(String lang){
		System.out.println("In DBHelpers.java getDefaultWidgetOptions");
		HashMap<String, String> hm = new HashMap<String, String>();
		//String lang=getLanguageFromDB(eventid);
		String query="select widgetid,config_data from buyer_att_def_widget_options where lang=? and stage='init'";
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
	
	public static boolean isValidToken(String token, String tid, String eid){
		String status=DbUtil.getVal("select status from buyer_att_page_visits where token=? and tid=? and eventid=?", new String[]{token, tid, eid});
		if("Success".equalsIgnoreCase(status)) return true;
		else return false;
	}
}
