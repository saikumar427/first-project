package com.eventbee.conditionalticketing.validators;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class RequireAND implements ConditionalTicketing{

	@Override
	public ArrayList<String> validateCondition(JSONObject condition, JSONObject selectedTickets) {
		

		ArrayList<String> warningsList= new ArrayList<String>();
		ArrayList<String> list = new ArrayList<String>();
		try {
			JSONArray targets= (JSONArray) condition.get("trg");
			boolean flag=true;
			StringBuffer sb = new StringBuffer();
			for(int i=0; i<targets.length();i++){
				if(!selectedTickets.has(targets.getJSONObject(i).getString("id")))
					flag=false;
				if(i!=targets.length()-1)
					sb.append(targets.getJSONObject(i).getString("id")+", ");
				else 
					sb.append(targets.getJSONObject(i).getString("id")+" ");
			}
			if(!flag){
				if(targets.length()>1)
					warningsList.add(sb+" are required");
				else warningsList.add(sb+" is required");
				return warningsList;
			}
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return warningsList;
		
	}
}
