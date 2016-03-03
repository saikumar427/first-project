package com.eventbee.general;
import java.util.*;
import java.sql.*;

public class  MasterDB{
	public static final String  CLASS_NAME="MasterDB";

	public static final String INT="INT";
	public static final String STR="STR";
	public static final String DT="DT";
    public   String dsnname=null;

	public static final String COLUMN_NAMES="COLUMN_NAMES";
	public static final String COLUMN_MAPPING="COLUMN_MAPPING";
	public static final String RECORDS="RECORDS";

   public MasterDB(String name){

	 dsnname=name;


   }
public MasterDB(){}
	public HashMap getRecords(String query,Object[] inputparams,String[] inputpramtypes){
			java.sql.Connection con=null;
			java.sql.PreparedStatement pstmt=null;
			java.sql.ResultSet rs=null;
			Map columnMap=new HashMap();
			List records=null;
			HashMap resultMap=null;
			dsnname="PostgresDS";
			try{
				if(dsnname==null)
				con=EventbeeConnection.getConnection();
				else con=EventbeeConnection.getConnection(dsnname);
				//con=EventbeeConnection.getConnection(dsnname);

				pstmt=con.prepareStatement(query);
				if(inputparams != null){
					boolean fortypes=false;
					if(inputpramtypes!=null && inputparams.length== inputpramtypes.length)fortypes=true;
					for(int i=0;i<inputparams.length;i++){

						if(fortypes){
							if(INT.equals(inputpramtypes[i]) )pstmt.setInt( i+1, ( (Integer)inputparams[i] ).intValue()  );
							if(STR.equals(inputpramtypes[i]) )pstmt.setString(i+1,(String)inputparams[i]);
							if(DT.equals(inputpramtypes[i]) )pstmt.setDate(i+1,(java.sql.Date)inputparams[i]);
						}else{

							pstmt.setString(i+1,(String)inputparams[i]);
						}
					}
				}

				rs=pstmt.executeQuery();

				if(rs.next()){

					records=new ArrayList();
					resultMap=new HashMap();
					ResultSetMetaData rsmd=rs.getMetaData();
					int colcount=rsmd.getColumnCount();
					String colnames[]=new String[colcount];
					for(int i=0;i<colcount;i++){
						colnames[i]=rsmd.getColumnName(i+1);
						columnMap.put( rsmd.getColumnName(i+1),new Integer( rsmd.getColumnType(i+1)) );
					 }

					resultMap.put(COLUMN_NAMES,colnames);//adding coulmn names[] to reqult
					resultMap.put(COLUMN_MAPPING,columnMap);//adding mappin to sql
					 //Set keyset=columnMap.keySet() ;
					 do{

						String key=null;
						Object[] record=new Object[colnames.length];
						for(int i=0;i<colnames.length;i++){
							 key=colnames[i];
							 int coltype=((Integer)columnMap.get(key)).intValue();
							 Object val=null;
							/* if(coltype==93 ||coltype==91 )	val=rs.getDate(key,Calendar.getInstance());
							 else val=rs.getString(key);
							 */
							 if(coltype==93 ||coltype==91 )	val=rs.getObject(key);
							 else val=rs.getString(key);
							record[i]=val;
						}
						records.add(record);

					 }while(rs.next());
					 resultMap.put(RECORDS,records);
				}
				rs.close();
				pstmt.close();

				con.close();
			}catch(Exception e){
				System.out.println("Error in MasterDB getrecords(): "+e.getMessage()+query+"\n params: "+Arrays.toString(inputparams));
				
				
				if(resultMap !=null)resultMap=null;
				EventbeeLogger.log(EventbeeLogger.LOGGER_MAIN,EventbeeLogger.DEBUG,CLASS_NAME,"getRecords()","query===="+query,null);

				EventbeeLogger.logException(EventbeeLogger.LOGGER_EXCEPTION,EventbeeLogger.ERROR,CLASS_NAME, "getRecords()", e.getMessage(), e);
			}finally{
				try{
					if(pstmt!=null)pstmt.close();
					if(con!=null)con.close();
				}catch(Exception ex){}
			}

			return resultMap;
	}






}