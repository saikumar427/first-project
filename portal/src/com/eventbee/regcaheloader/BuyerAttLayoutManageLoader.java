package com.eventbee.regcaheloader;

import java.util.HashMap;
import java.util.Map;

import org.json.JSONObject;

import com.eventbee.cachemanage.CacheLoader;
import com.eventbee.layout.BuyerAttDBHelper;
import com.eventbee.layout.DBHelper;

public class BuyerAttLayoutManageLoader implements CacheLoader{
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
		Map layoutManageMap=new HashMap();	
		try {
			//layoutManageMap.put("eventinfomap", DBHelper.getEventinfo(groupid));
			String layout=BuyerAttDBHelper.getLayout(groupid,"","final","buyer");
			JSONObject layoutJsonData = new JSONObject(layout);
			layoutManageMap.put("layout", layout);
			layoutManageMap.put("widgetstyles",DBHelper.getWidgetStyles(groupid,"final"));
			layoutManageMap.put("widgetoptions",BuyerAttDBHelper.getAllWidgetOptions(groupid,"final","buyer",layoutJsonData.getJSONObject("added")).toString());
		} catch (Exception e) {
			e.printStackTrace();
		} 
		return  layoutManageMap;
    }
	
}