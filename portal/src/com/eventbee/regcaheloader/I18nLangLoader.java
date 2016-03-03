package com.eventbee.regcaheloader;

import java.util.HashMap;
import java.util.Map;

import com.eventbee.cachemanage.CacheLoader;
import com.eventbee.general.DbUtil;

public class I18nLangLoader implements CacheLoader{
	long refreshInterval=60*60*1000;
	long maxIdleTime=60*60*1000;
	Map <String,String> cMap;
	public long getRefreshInterval(){return refreshInterval;}
	public void setRefreshInterval(long ri){refreshInterval=ri;}
	public long getMaxIdleTime(){return maxIdleTime;}
	public void setMaxIdleTime(long mtime){maxIdleTime=mtime;}
	public void setConfigMap(Map<String,String> cMap){this.cMap=cMap;}
	public Map <String,String> getConfigMap(){return cMap;}
	   
	public Map load(String groupid){
		Map<String,String> i18nLangMap=new HashMap<String,String>();	
		String lang=DbUtil.getVal("select value from config where config_id=(select config_id from eventinfo where eventid=?::bigint) and name='event.i18n.lang'",new String[]{groupid});
		if("".equals(lang) || lang==null) lang="en_US";
		i18nLangMap.put("i18n_lang",lang);	
		System.out.println("I18nLangLoader eventid: "+groupid+" lang: "+lang);
		return i18nLangMap;
	}
}
