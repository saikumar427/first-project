package com.boxoffice.classes;

import java.util.HashMap;

import com.eventbee.general.EbeeConstantsF;

public class BSendEmailThread implements Runnable{
	String serveraddress="http://"+EbeeConstantsF.get("serveraddress","");
	HashMap<String,String> paramMap=new HashMap<String,String>();
	public BSendEmailThread(HashMap<String,String> hm) {  
		paramMap = hm;  
    }
	public void run() {
		try{
			com.eventbee.util.CoreConnector cc1=new com.eventbee.util.CoreConnector(com.eventbee.general.EbeeConstantsF.get("CONNECTING_PDF_URL",serveraddress+"/attendee/utiltools/sendPdfMail.jsp"));
			cc1.setArguments(paramMap);
		    cc1.setTimeout(30000);
		    cc1.MGet();
		}catch(Exception e){
			System.out.println("Error in GetTicketsThread: "+e.getMessage());
		}
	}

}