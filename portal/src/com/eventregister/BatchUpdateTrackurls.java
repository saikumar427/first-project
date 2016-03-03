package com.eventregister;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

import com.eventbee.general.DBQueryObj;
import com.eventbee.general.DateUtil;
import com.eventbee.general.DbUtilExtesion;
import com.eventbee.general.EventbeeBatch;
import com.eventbee.general.EventbeeBatchMemActions;
import com.eventbee.general.StatusObj;

public class BatchUpdateTrackurls implements EventbeeBatch {
	
	String Update_Query="update trackurls set count=cast(coalesce(cast(count as numeric),0) as numeric)+? where trackingcode=? and eventid=?";
	
	public void userBatchActions(String mode, String key) {
		/*if("timeout".equals(mode))
		{}
		else if("exceed".equals(mode))
		{}*/
		//System.out.println("com.eventregister.BatchUpdateTrackurls clear mode: "+mode);
		HashMap<String, String> updateTrackurlsData=(HashMap<String, String>)EventbeeBatchMemActions.get("com.eventregister.BatchUpdateTrackurls"+EventbeeBatchMemActions.checkKey);
		EventbeeBatchMemActions.ebeeBatchCache.remove("com.eventregister.BatchUpdateTrackurls"+EventbeeBatchMemActions.checkKey);
		if(updateTrackurlsData==null)
			return ;
		DBQueryObj[] dbqueries = new DBQueryObj[updateTrackurlsData.size()];
		ArrayList<String[]> temp=new ArrayList<String[]>();
		for (Map.Entry<String, String> entry : updateTrackurlsData.entrySet()){
		    
			//System.out.println(entry.getKey() + "/" + entry.getValue());
		    
		    String count = entry.getValue();
		    String str = entry.getKey();
		    String eventid="";
		    String trackcode="";
		    String[] strtemp;
			String delimiter = "_";
			strtemp = str.split(delimiter);
			eventid=strtemp[0];
			trackcode=strtemp[1];
		    temp.add(new String[]{count,trackcode,eventid});
		}
		
		int i=0;
		for(String[] temParms:temp)
			dbqueries[i++] = new DBQueryObj(Update_Query,temParms);
		
		StatusObj s = DbUtilExtesion.executeUpdateBatchQueries(dbqueries);
		
	}
	
	public static void  setUpdateTrackUrlBatch(String eventid, String trackcode){
		
		HashMap hm = (HashMap)EventbeeBatchMemActions.ebeeBatchCache.get("com.eventregister.BatchUpdateTrackurls"+EventbeeBatchMemActions.checkKey);
		
		//System.out.println("check key::::"+	EventbeeBatchMemActions.ebeeBatchCache.get("com.eventregister.BatchUpdateTrackurls"+EventbeeBatchMemActions.checkKey));
	     if(hm==null)
	     { 
	    	 hm = new HashMap();
	    	 hm.put(eventid+"_"+trackcode, "1");
	    	 EventbeeBatchMemActions.ebeeBatchCache.put("com.eventregister.BatchUpdateTrackurls"+EventbeeBatchMemActions.timeKey,DateUtil.getFormatedDate(new Date(), "MM/dd/yyyy HH:mm:ss", new Date().toGMTString()));
	     }else{
	    	 int count=0;
	    	 if(hm.get(eventid+"_"+trackcode)!=null){ 
		    	 count = Integer.parseInt((String)hm.get(eventid+"_"+trackcode));
		    	 hm.put(eventid+"_"+trackcode, (count+1)+"");
	    	 }else{
	    		 hm.put(eventid+"_"+trackcode, "1");
	    	 }
	     }
	     
	     //System.out.println("checkintemp::"+hm);
	     EventbeeBatchMemActions.ebeeBatchCache.put("com.eventregister.BatchUpdateTrackurls"+EventbeeBatchMemActions.checkKey,hm);
	     EventbeeBatchMemActions.ebeeBatchCache.put("com.eventregister.BatchUpdateTrackurls"+EventbeeBatchMemActions.countKey,hm.size());
	     
	     //System.out.println("checkintemp1::"+EventbeeBatchMemActions.ebeeBatchCache);
	 	
		
	}

}
