package com.eventregister;

import java.util.ArrayList;
import java.util.HashMap;
import org.json.JSONArray;
import org.json.JSONObject;
import com.event.dbhelpers.BDisplayAttribsDB;
import com.eventbee.general.DBManager;
import com.eventbee.general.DbUtil;
import com.eventbee.general.GenUtil;
import com.eventbee.general.StatusObj;
import com.eventbee.general.formatting.CurrencyFormat;

public class CCTicketsJson {
	
	public JSONObject getTicketsJSON(String eid,HashMap<String, String> params){
		CTicketsInfo ticketInfo=new CTicketsInfo();
		JSONObject ticketsJSON=new JSONObject();
		JSONArray tickets=new JSONArray();
		HashMap<String, String> lockedQuantity=new HashMap<String, String>();
		try{
			long startTime = System.currentTimeMillis();
			ticketInfo.intialize(eid,params);
		}catch(Exception e){
			System.out.println("Exception in getTicketsJSON : "+e);
		}
		return ticketsJSON;
	}
}
