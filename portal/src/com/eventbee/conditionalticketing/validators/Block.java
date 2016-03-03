package com.eventbee.conditionalticketing.validators;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class Block implements ConditionalTicketing {

	@Override
	public ArrayList<String> validateCondition(JSONObject condition, JSONObject selectedTickets) {
		ArrayList<String> warningsList= new ArrayList<String>();
		try {
			JSONArray targets= (JSONArray) condition.get("trg");
			
				if(selectedTickets.has(condition.getJSONObject("src").getString("id"))){
					for(int i=0; i<targets.length();i++){
						if(selectedTickets.has((String)targets.getJSONObject(i).getString("id"))){
							StringBuffer buffer=new StringBuffer();
							for(int j=0;j<targets.length();j++){									
								if(j != targets.length()-1)
									buffer.append(targets.getJSONObject(j).getString("id")+", ");
								else
									buffer.append(targets.getJSONObject(j).getString("id")+"");
							}
							if(targets.length() > 1 )
								warningsList.add("If "+condition.getJSONObject("src").getString("id")+" is selected, you can't buy any of the tickets - "+buffer.toString() +".");
							else
								warningsList.add("If "+condition.getJSONObject("src").getString("id")+" is selected, you can't buy "+buffer.toString() +".");
							return warningsList;
						}
					}
				}
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return warningsList;
	}

	
}
