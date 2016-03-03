package com.eventbee.general;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class DbUtilExtesion {
	
	public static StatusObj executeUpdateBatchQueries(DBQueryObj [] dbqueries){
		/*only one query can be taken*/
		Connection con=null;		
		StatusObj stob=new StatusObj(false,"",null);		
		int resultCount=0;
		PreparedStatement pstmt=null;
		
		if(dbqueries!=null&&dbqueries.length>0 && dbqueries.length<1000){
			try{
				con=EventbeeConnection.getConnection();
				con.setAutoCommit(false);
				String query=dbqueries[0].getQuery();
				if(query!=null)
					pstmt=con.prepareStatement(query);				 
				for(int i=0;i<dbqueries.length;i++){
					DBQueryObj dbquery=dbqueries[i];
					
					if(pstmt!=null){
						String [] inputparams=dbquery.getQueryInputs();
						if(con==null)
							con=EventbeeConnection.getConnection();
						
						for(int j=0;inputparams!=null && j<inputparams.length;j++)
							pstmt.setString(j+1,inputparams[j]);
						
				     	pstmt.addBatch();		
					}
				}		
				try{
					int results[]=pstmt.executeBatch();
					resultCount=results.length;
					stob.setCount(results.length);
					stob.setStatus(true);
				}catch(Exception e){ System.out.println("Exception while proseesing batch"+e.getMessage());
					stob.setCount(0);
					stob.setStatus(false);
				}
				if(!stob.getStatus()){
					con.rollback();
					stob=new StatusObj(false, "rollback",null);
				}else{
					con.commit();
					stob=new StatusObj(true, "success","");
					stob.setCount(resultCount);
				}
				con.close();
				con=null;
				pstmt.close();
				pstmt=null;
			
			 }catch(Exception e){
				System.out.println("Exception occured at executeUpdateQueries():" +e.getMessage());
			}
	        finally{
			try{
				if(con!=null){
				      if(!stob.getStatus())
					  con.rollback();
				      
				      con.close();
				}				
			}catch(Exception e){System.out.println("Exception while processing llast level "+e.getMessage());}
		  }
		}
		return stob;
	}

}
