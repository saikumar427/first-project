package com.eventbee.conditionalticketing.validators;

import java.util.ArrayList;
import java.util.Map;
import java.util.regex.Matcher;

import org.json.JSONArray;
import org.json.JSONObject;

import com.eventregister.TicketingInfo;

public class ConditionalTicketingValidator {

	public ArrayList<String> validateConditions(JSONArray conditions, JSONObject selectedTickets,String eventid){
		ArrayList<String> warnings=new ArrayList<String>();
		try{	
			for(int i=0; i<conditions.length() ;i++){
				JSONObject condition=conditions.getJSONObject(i);
				String rule=condition.getString("condition");
				ConditionalTicketing conditionInstance = (ConditionalTicketing)Class.forName("com.eventbee.conditionalticketing.validators."+Character.toUpperCase(rule.charAt(0))+rule.substring(1)).newInstance();
				warnings=conditionInstance.validateCondition(condition, selectedTickets);
				if(warnings!=null&&warnings.size()>0){
					Map<String, Map<String, String>> ticketIdsWithName=TicketingInfo.getTicketIdsWithName(eventid);					
					for (Map.Entry<String, Map<String, String>> entry : ticketIdsWithName.entrySet()){
					    for(int j=0;j<warnings.size();j++){
					    	String ticketNm=entry.getValue().get("tkt_name");
					    	ticketNm= Matcher.quoteReplacement(ticketNm);// to escape $ in the ticket name
					    	String message=warnings.get(j).replaceAll(entry.getKey(), ticketNm + ("".equals(entry.getValue().get("tkt_group_name")) ? "" : " ("+entry.getValue().get("tkt_group_name")+")") );
					    	 warnings.set(j, message);
						}
					}
					return warnings;
				}
			}
		}catch(Exception e){
			System.out.println("Exception in ConditionalTicketingValidator ERROR: "+e.getMessage());
		}
		System.out.println("returned");
		return warnings;
	}
}
