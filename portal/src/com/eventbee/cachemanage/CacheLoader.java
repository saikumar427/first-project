package com.eventbee.cachemanage;

import java.util.Map;

public interface CacheLoader {
	    public  long getRefreshInterval();
	    public  void setRefreshInterval(long ri);
	    public  long getMaxIdleTime();
	    public  void setMaxIdleTime(long mtime);
	    public  void setConfigMap(Map<String,String> cMap);
	    public  Map <String,String> getConfigMap();
	    public  Map load(String token);
}
