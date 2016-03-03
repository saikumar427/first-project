package com.eventbee.general;
import java.sql.*;



public class SendMailStatus  {
	private String unitid=null;
	private String purpose=null;
	private String refid=null;
	private String mailCount=null;
       public SendMailStatus(String unitid,String purpose,String refid,String mailCount){
	       this.unitid=unitid;
	       this.purpose=purpose;
	       this.refid=refid;
	       this.mailCount=mailCount;
	       
       }
       public String getUnitId(){
	       return (unitid==null)?"0":unitid;
       }
      
      public String getPurpose(){
	       return (purpose==null)?"":purpose;
       }

       public String getRefId(){
	        return (refid==null)?"":refid;
       }


       public String getMailCount(){
	        return (mailCount==null)?"0":mailCount;
       }

      public void insertStatus(){
			String query="insert into sent_mail_status (unit_id  ,purpose  ,sent_date  ,mail_count  ,ref_id )"
			+"  values (CAST(? AS INTEGER),CAST(? AS DATE),to_timestamp(?,'YYYY-MM-DD HH24:MI:SS.MS'),CAST(? AS INTEGER),?)";
			DbUtil.executeUpdateQuery(query, new String[]{unitid,purpose,DateUtil.getCurrDBFormatDate(), mailCount,refid});
			
     }
       
}

