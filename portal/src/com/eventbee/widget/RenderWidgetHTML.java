package com.eventbee.widget;

import java.util.HashMap;

public interface RenderWidgetHTML {
	
	public String getHTML(HashMap<String, String> refHash, HashMap<String, String> dataHash, HashMap<String, String> configHash) throws Exception;
	
	public Boolean IsRenderable(HashMap<String, String> refHash, HashMap<String, String> dataHash, HashMap<String, String> configHash)throws Exception;

}