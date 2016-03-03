package com.eventbee.conditionalticketing.validators;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class RequireOR implements ConditionalTicketing{

	@Override
	public ArrayList<String> validateCondition(JSONObject condition, JSONObject selectedTickets) {
		ArrayList<String> warningsList= new ArrayList<String>();
		ArrayList<String> list = new ArrayList<String>();
		try {
			JSONArray targets= (JSONArray) condition.get("trg");
			boolean flag=false;
			StringBuffer sb = new StringBuffer();
			for(int i=0; i<targets.length();i++){
				if(selectedTickets.has((String)targets.getJSONObject(i).getString("id")))
					flag=true;
				/*else
					list.add(targets.getString(i));*/
				if(i!=targets.length()-1)
					sb.append(targets.getJSONObject(i).getString("id")+", ");
				else 
					sb.append(targets.getJSONObject(i).getString("id")+" ");
			}
			if(!flag){
				/*if(list.size()>1){
					StringBuffer sb = new StringBuffer();
					for(int i=0;i<list.size();i++){
						if(i!=list.size()-1)
							sb.append(list.get(i)+", ");
						else 
							sb.append(list.get(i)+" ");
					}
					warningslist.add("Any of "+sb+"are Required");
				}else warningslist.add(list.get(0)+" is Required");*/
				if(targets.length()>1)
					warningsList.add("Any of the "+sb+" are required");
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
