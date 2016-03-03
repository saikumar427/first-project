package com.eventbee.general;
import java.util.*;
import java.text.*;
import java.io.*;

public class  VCal{

public static final String ID="ID";
public static final String PURPOSE="PURPOSE";
public static final String SUMMARY="SUMMARY";

public static final String STARTTIME="STARTTIME";
public static final String ENDTIME="ENDTIME";
public static final String DESCRIPTION="DESCRIPTION";

public static final String NAME="NAME";
public static final String LOCATION="LOCATION";

/*
generalprps to be set are

vcal.path=/opt/jboss-3.2.1/server/default/deploy/home.war/vcal
vcal.webpath=http://localhost:18080/home/vcal

*/

public static void createFile(HashMap hm){


/*
BEGIN:VCALENDAR
VERSION:1.0
BEGIN:VEVENT
DTSTART:20030901T073000Z
DTEND:20030901T083000Z
SUMMARY:raja
DESCRIPTION:summary
END:VEVENT
END:VCALENDAR

*/
try{

String fileName=EbeeConstantsF.get("vcal.path","/opt/jboss-3.2.1/server/default/deploy/home.war/vcal")+"/"+"vcal_"+(String)hm.get(PURPOSE)+"_"+(String)hm.get(ID)+".ics";
 File file=new File(fileName);
Calendar currentDate = Calendar.getInstance();

String groupid=(String)hm.get(ID);
SimpleDateFormat formatter=  new SimpleDateFormat("yyyyMMdd'T'HHmm'00'");

String dateNow = formatter.format(currentDate.getTime());

String mgrlogin=DbUtil.getVal("select login_name from authentication where user_id=(select mgr_id::varchar from eventinfo where eventid=CAST(? AS INTEGER))",new String[]{(String)hm.get(ID)});
String eventurl=ShortUrlPattern.get(mgrlogin)+"/event?eventid="+groupid;


if(file.exists() )file.delete();
RandomAccessFile raf=new RandomAccessFile(file ,"rw");


	raf.writeBytes("BEGIN:VCALENDAR\n") ;
	raf.writeBytes("METHOD:PUBLISH\n") ;
	raf.writeBytes("CALSCALE:GREGORIAN\n") ;
	raf.writeBytes("Content-Type:text/calendar\n") ;
	raf.writeBytes("PRODID:-//www.eventbee.com//EN\n");
	raf.writeBytes("VERSION:2.0\n") ;
	raf.writeBytes("BEGIN:VEVENT\n") ;
	raf.writeBytes("DTSTART:"+(String)hm.get(STARTTIME)+"\n" ) ;
	raf.writeBytes("DTEND:"+(String)hm.get(ENDTIME)+"\n" ) ;
	raf.writeBytes("LOCATION:"+(String)hm.get(LOCATION)+"\n" ) ;
	raf.writeBytes("UID:"+dateNow+"@eventbee.com\n");

	//raf.writeBytes("DESCRIPTION:"+(String)hm.get(DESCRIPTION)+"\n" ) ;

	raf.writeBytes("SUMMARY:"+(String)hm.get(NAME)+"\n" ) ;
	raf.writeBytes("URL:"+eventurl+"\n") ;

	raf.writeBytes("END:VEVENT\n") ;
	raf.writeBytes("END:VCALENDAR\n") ;


}catch(Exception ex){
System.out.println("Error in VCal in createfile()"+ex.getMessage());
}


}




}



