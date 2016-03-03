package com.eventbee.conditionalticketing.validators;

import java.util.ArrayList;

import org.json.JSONObject;

public interface ConditionalTicketing {
	public ArrayList<String> validateCondition(JSONObject condition, JSONObject selectedTickets);

}
