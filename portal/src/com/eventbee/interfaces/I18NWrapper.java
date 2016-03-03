package com.eventbee.interfaces;

import java.util.HashMap;

public interface I18NWrapper {
	public HashMap<String, Object> getData(HashMap<String, String> hm, String lang, String eid);
}
