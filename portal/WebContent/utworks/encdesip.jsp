<%@ page import="java.util.*,java.sql.*,com.eventbee.general.*" %>


<%
String UPDQUERY="update authentication set password=? where user_id=?";
%>



<%
	DBManager dbmanager=new DBManager();
	StatusObj statobj=dbmanager.executeSelectQuery("select user_id,password from authentication",null );
	Connection con=null;
	PreparedStatement pstmt=null;
	
	try{
		con=EventbeeConnection.getConnection();
		
		StringEncrypter strenc=new StringEncrypter(StringEncrypter.DES_ENCRYPTION_SCHEME) ;
		
		int reccount=statobj.getCount();
		
		if(statobj !=null && statobj.getStatus()  && reccount>0    ){
			
			for(int i=0;i<reccount;i++){
				String userid=dbmanager.getValue(i,"user_id",null);
				
				String userip=dbmanager.getValue(i,"password",null);
				
				DbUtil.executeUpdateQuery( "update authentication set password=? where user_id=?",new String[]{strenc.encrypt(userip),userid  } , con);
				
				out.println( (i+1)+".&nbsp;&nbsp;"+userid+"*****"+strenc.encrypt(userip)+"<br />");
			}
			out.println("Total Record Count****==="+reccount);	
		
		
		}
		
		
		con.close();
		con=null;
	}catch(Exception e){
		EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "encdesip.jsp", "service(), e", e.getMessage(), e ) ;
	
	}finally{
		try{
		if(con !=null){
			con.close();
			}
		}catch(Exception exp1){
		
			EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR, "encdesip.jsp", "service(),exp1", exp1.getMessage(), exp1 ) ;
		}
	}
%>


