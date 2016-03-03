package com.eventregister;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import com.eventbee.general.DBQueryObj;
import com.eventbee.general.DateUtil;
import com.eventbee.general.DbUtilExtesion;
import com.eventbee.general.EventbeeBatch;
import com.eventbee.general.EventbeeBatchMemActions;
import com.eventbee.general.StatusObj;

public class BatchEventHitTrack implements EventbeeBatch {

	  String Hit_Query="insert into Hit_Track(source,resource,sessionid,access_at,id,userid)"
				+" values(?,?,?,to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),?,?) ";
	@Override
	public void userBatchActions(String mode, String key) {
		/*if("timeout".equals(mode))
		{}
		else if("exceed".equals(mode))
		{}*/
		//System.out.println("com.eventregister.BatchEventHitTrack clear mode "+mode);
		ArrayList<String[]> eventHitTrackData=(ArrayList<String[]>)EventbeeBatchMemActions.get("com.eventregister.BatchEventHitTrack"+EventbeeBatchMemActions.checkKey);
		EventbeeBatchMemActions.ebeeBatchCache.remove("com.eventregister.BatchEventHitTrack"+EventbeeBatchMemActions.checkKey);
		if(eventHitTrackData==null)
			return ;
		DBQueryObj[] dbqueries = new DBQueryObj[eventHitTrackData.size()];
		int i=0;
		for(String[] temParms:eventHitTrackData)
		dbqueries[i++] = new DBQueryObj(Hit_Query,temParms);
		
		StatusObj s = DbUtilExtesion.executeUpdateBatchQueries(dbqueries);
		
		
	}
	
	public static void  setHitBatchBatch(String array[]){
		ArrayList<String[]> temp=(ArrayList<String[]>)EventbeeBatchMemActions.ebeeBatchCache.get("com.eventregister.BatchEventHitTrack"+EventbeeBatchMemActions.checkKey);
		//	System.out.println("check key::::"+	EventbeeBatchMemActions.ebeeBatchCache.get("com.eventregister.BatchEventHitTrack"+EventbeeBatchMemActions.checkKey));
	     if(temp==null)
	     { temp=new ArrayList<String[]>();
	       EventbeeBatchMemActions.ebeeBatchCache.put("com.eventregister.BatchEventHitTrack"+EventbeeBatchMemActions.timeKey,DateUtil.getFormatedDate(new Date(), "MM/dd/yyyy HH:mm:ss", new Date().toGMTString()));
	     }
	   //  System.out.println("checkintemp::"+temp);
	     temp.add(array);
	     EventbeeBatchMemActions.ebeeBatchCache.put("com.eventregister.BatchEventHitTrack"+EventbeeBatchMemActions.checkKey,temp);
	     EventbeeBatchMemActions.ebeeBatchCache.put("com.eventregister.BatchEventHitTrack"+EventbeeBatchMemActions.countKey,temp.size());
	     
	    // System.out.println("checkintemp1::"+EventbeeBatchMemActions.ebeeBatchCache);
	 	
		
	}

}
