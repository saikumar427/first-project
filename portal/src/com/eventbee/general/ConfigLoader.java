package com.eventbee.general;

import com.eventbee.general.EventbeeConnection;
import com.eventbee.general.StatusObj;
import java.sql.*;
import java.util.*;
public class ConfigLoader {
    final static String FILE_NAME="ConfigLoader";
    public final static String UNITBASE="UNIT_BASE_CONFIG";
    public final static String ORGBASE="ORG_BASE_CONFIG";

    final static String CONFIG_ID_GET="select config_id from config_master where ref_id=? and purpose=?";
    final static String CONFIG_INFO_GET="select * from config where config_id=CAST(? AS INTEGER)";
    final static String CONFIG_INFO_DELETE="delete from config where config_id=?";
    final static String CONFIG_KEY_DELETE="delete from config where config_id=? and name=?";
    final static String CONFIG_INFO_INSERT="insert into config(config_id, name, value) values (?,?,?)";
    final static String CONFIG_MASTER_INSERT="insert into config_master(purpose,ref_id,config_id) values "
			+"(?,?,nextval('seq_configid'))";
    final static String CONFIG_MASTER_DELETE="delete from config_master where purpose=? and ref_id=?";
    final static String EVENT_INFO_QUERY="select config_id as configid from eventinfo where eventid=CAST(? AS INTEGER)";
    final static String CLUB_INFO_QUERY="select config_id as configid from clubinfo where clubid=CAST(? AS INTEGER)";


   public static int createConfig(String refid,String purpose,Connection con){
	int rcount=0;
	java.sql.PreparedStatement pstmt=null;
	try{
		pstmt=con.prepareStatement(CONFIG_MASTER_DELETE);
		pstmt.setString(1,purpose);
		pstmt.setString(2,refid);
	        rcount=pstmt.executeUpdate();
		pstmt.close();		

		pstmt=con.prepareStatement(CONFIG_MASTER_INSERT);
	 	pstmt.setString(1,purpose);
		pstmt.setString(2,refid);
		rcount=pstmt.executeUpdate();
		pstmt.close();
  		pstmt=null;
	}catch(Exception e){
		System.out.println("Error in createConfig:" +e.getMessage());
		return 0;
	}
        finally{
		try{
			if(pstmt!=null) pstmt.close();
		}catch(Exception e){}
	}
	return rcount;
    }

  public static Config getConfig(String refid,String purpose){
	StatusObj statusObj=null;
	String configid=null;
	Config cf=new Config();
	try{		 
		 cf.setRefID(refid);
		 cf.setPurpose(purpose);	
		 statusObj=getConfigID(refid,purpose);
		 if(statusObj.getStatus()){
			configid=(String)statusObj.getData();
			cf.setConfigID(configid);		
			cf.setConfigHash(getConfig(configid));
		 }
 	  }catch(Exception e){
		System.out.println("Error in getConfig():" +e.getMessage());
	  }
	 return cf;
    }

 /*   public static HashMap getConfig(String refid,String purpose){
	StatusObj statusObj=null;
	String configid=null;
	HashMap hm=null;
	try{
		 statusObj=getConfigID(refid,purpose);
		 if(statusObj.getStatus()){
			configid=(String)statusObj.getData();
			hm=getConfig(configid);
		 }
 	  }catch(Exception e){
		System.out.println("Error in getConfig:" +e.getMessage());
		hm=null;
	  }
	 return hm;
    }  */
    public static HashMap getConfig(String configid){
	    HashMap hm=null;
	    return getConfig(configid,hm);
    }
    public static HashMap getConfig(String configid,HashMap hm){
	StatusObj statusObj=null;
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	boolean flag=false;
	if(hm==null) hm=new HashMap();
	try{
			con=EventbeeConnection.getConnection();
			pstmt=con.prepareStatement(CONFIG_INFO_GET);
			pstmt.setString(1,configid);
			rs=pstmt.executeQuery();			
			while(rs.next()){
				hm.put(rs.getString("name"),rs.getString("value"));
			}
			//hm.put("configid",configid);
			rs.close();
			pstmt.close();
			pstmt=null;
			con.close();
 	     }catch(Exception e){
			System.out.println("Error in getConfig(configid):" +e.getMessage());
			hm=null;
	     }
	     finally{
			try{
				if(pstmt!=null) pstmt.close();
				if(con!=null) con.close();
			}catch(Exception e){}
		}
		return hm;
    }

    public static StatusObj getConfigID(String refid,String purpose){
	StatusObj statusObj=null;
	Connection con=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	String configid=null;
	boolean flag=false;
	try{
		con=EventbeeConnection.getConnection();
		pstmt=con.prepareStatement(CONFIG_ID_GET);
		pstmt.setString(1,refid);
		pstmt.setString(2,purpose);
		rs=pstmt.executeQuery();
		if(rs.next()){
			configid=rs.getString("config_id");
			flag=true;			
		}
		rs.close();
		pstmt.close();
		pstmt=null;		
		if(flag){
			statusObj=new StatusObj(true, "success", configid);
		}else{
			statusObj=new StatusObj(false, "No matching record for configid",null);
		}
	}catch(Exception e){
		System.out.println("Error in getConfigId:" +e.getMessage());
		statusObj=new StatusObj(false,e.getMessage(),null);
	}
        finally{
		try{
			if(pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}
	return statusObj;
    }

    public static StatusObj getConfigID(String refid,String purpose,Connection con){
	StatusObj statusObj=null;
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	String configid=null;
	boolean flag=false;
	try{
		pstmt=con.prepareStatement(CONFIG_ID_GET);
		pstmt.setString(1,refid);
		pstmt.setString(2,purpose);
		rs=pstmt.executeQuery();
		if(rs.next()){
			configid=rs.getString("config_id");
			flag=true;			
		}
		rs.close();
		pstmt.close();
		pstmt=null;		
		if(flag){
			statusObj=new StatusObj(true, "success", configid);
		}else{
			statusObj=new StatusObj(false, "No matching record for configid",null);
		}
	}catch(Exception e){
		System.out.println("Error in getConfigId:" +e.getMessage());
		statusObj=new StatusObj(false,e.getMessage(),null);
	}
        finally{
		try{
			if(pstmt!=null) pstmt.close();
		}catch(Exception e){}
	}
	return statusObj;
    }

    public static int insertConfigInfo(String configid,HashMap hm,Connection con){
	int rcount=0;
	java.sql.PreparedStatement pstmt=null;
	try{
		if(configid!=null){
			pstmt=con.prepareStatement(CONFIG_INFO_DELETE);
			pstmt.setString(1,configid);
		        rcount=pstmt.executeUpdate();
			pstmt.close();
	
			Set e =hm.entrySet();

      			for (Iterator i = e.iterator(); i.hasNext();){
        	                  Map.Entry entry =(Map.Entry)i.next();
				  pstmt=con.prepareStatement(CONFIG_INFO_INSERT);
			 	  pstmt.setString(1,configid);
				  pstmt.setString(2,(String)entry.getKey());
				  pstmt.setString(3,(String)entry.getValue());
				  rcount=pstmt.executeUpdate();
				  pstmt.close();
  				  pstmt=null;
		         }
		}
	}catch(Exception e){
		System.out.println("Error in insertConfigInfo:" +e.getMessage());
		return 0;
	}
        finally{
		try{
			if(pstmt!=null) pstmt.close();
		}catch(Exception e){}
	}
	return rcount;
    }

    public static int setConfig(String configid,HashMap hm){
	    Connection con=null;
	    return updateConfigInfo(configid,hm,con);
    }
    public static int updateConfigInfo(String configid,HashMap hm,Connection con){
	int rcount=0;
	java.sql.PreparedStatement pstmt=null;
	boolean conclose=false;
	
	try{
		if(con==null){
			con=EventbeeConnection.getConnection();
			conclose=true;
		}
			con.setAutoCommit(false);
			Set e =hm.entrySet();
      			for (Iterator i = e.iterator(); i.hasNext();){
        	                  Map.Entry entry =(Map.Entry)i.next();

				  pstmt=con.prepareStatement(CONFIG_KEY_DELETE);
				  pstmt.setString(1,configid);
				  pstmt.setString(2,(String)entry.getKey());
				  int count=pstmt.executeUpdate();
				  pstmt.close();

				  pstmt=con.prepareStatement(CONFIG_INFO_INSERT);
				  pstmt.setString(1,configid);
				  pstmt.setString(2,(String)entry.getKey());
				  pstmt.setString(3,(String)entry.getValue());
				  rcount+=pstmt.executeUpdate();
				  pstmt.close();
  				  pstmt=null;
		         }
		con.commit();
	}catch(Exception e){
		System.out.println("Exception in ConfigLoader/updateConfigInfo:" +e.getMessage());
		try{
			con.rollback();
		}catch(Exception e12){}
		rcount=0;
	}
        finally{
		try{
			if(pstmt!=null) pstmt.close();
			if(conclose){
				if(con!=null){con.close();con=null;}
			}
		}catch(Exception e){}
	}
	return rcount;
    }
    public static int setConfig(String configid,HashMap hm,boolean replaceFlag,Connection con){
		int rcount=0;
		HashMap existhm=null;
		boolean conclose=false;
		try{
			if(con==null){
				con=EventbeeConnection.getConnection();
				conclose=true;
			}
			con.setAutoCommit(false);
			if(replaceFlag){
			      existhm=getConfig(configid);

			      if(existhm==null)
					existhm=new HashMap();
			      Set e =hm.entrySet();
			      for (Iterator i = e.iterator(); i.hasNext();){
                        	  Map.Entry entry =(Map.Entry)i.next();
				  existhm.put((String)entry.getKey(),(String)entry.getValue());
			     }
			     rcount=insertConfigInfo(configid,existhm,con);			      
			 }else{
			     rcount=insertConfigInfo(configid,hm,con);			      
			}
			con.commit();
		}catch(Exception e1){
			System.out.println("Exception at setConfig(configid,hm,flag,con)");
			try{
				con.rollback();
			}catch(Exception e2){}
		}finally{
			try{	
				if(conclose){
					if(con!=null){con.close();con=null;}
				}
			}catch(Exception efin){}	
		}
		return rcount;
        }

    public static int setConfig(String configid,HashMap hm,boolean replaceFlag){
	Connection con=null;
	int rcount=0;
	try{
	        con=EventbeeConnection.getConnection();
		con.setAutoCommit(false);	
		rcount=setConfig(configid,hm,replaceFlag,con);		
		con.close();	
	}catch(SQLException e){
		rcount=0;		
	}catch(Exception e1){
		rcount=0;		
	}finally{
		try{
			con.setAutoCommit(true);
			if(con!=null)con.close();
		}catch(Exception e){
			rcount=0;		
		}
	}	
	return rcount;
   }

  public static int setConfig(String refid,String purpose,HashMap hm,boolean replaceFlag){
	StatusObj statusObj=null;
	Connection con=null;
	PreparedStatement pstmt=null;
	int rcount=0;
	try{
	        con=EventbeeConnection.getConnection();
		con.setAutoCommit(false);
		rcount=setConfig(refid,purpose,hm,replaceFlag,con);
	}catch(SQLException e){
		rcount=0;		
	}catch(Exception e1){
		rcount=0;		
	}finally{
		try{
			con.setAutoCommit(true);
			if(con!=null)con.close();
		}catch(Exception e){
			rcount=0;		
		}
	}
	return rcount;
   }    

  public static int setConfig(String refid,String purpose,HashMap hm,boolean replaceFlag,Connection con){
	StatusObj statusObj=null;
	PreparedStatement pstmt=null;
	int rcount=0;
	String configid=null;
	try{
		statusObj=getConfigID(refid,purpose);
		if(statusObj.getStatus()){
			configid=(String)statusObj.getData();
			rcount=setConfig(configid,hm,replaceFlag,con);
		}	
	}catch(Exception e1){
		rcount=0;		
	}
	return rcount;
   }    

  public static int setConfig(String refid,String purpose,HashMap hm,boolean replaceFlag,boolean forceCreate,Connection con){
	StatusObj statusObj=new StatusObj(false,"","");
	StatusObj statusObj1=new StatusObj(false,"","");
	PreparedStatement pstmt=null;
	int rcount=0;
	int mastercount=0;
	String configid=null;
	try{
		statusObj=getConfigID(refid,purpose);
		if(statusObj.getStatus()){
			configid=(String)statusObj.getData();
			rcount=ConfigLoader.setConfig(configid,hm,replaceFlag,con);
		}else{

			if(forceCreate){
				mastercount=ConfigLoader.createConfig(refid,purpose,con);

				if(mastercount>0){
					statusObj1=ConfigLoader.getConfigID(refid,purpose,con);
					if(statusObj1.getStatus()){
						configid=(String)statusObj1.getData();
						rcount=ConfigLoader.setConfig(configid,hm,replaceFlag,con);
					}
				}
			}
		}

	}catch(Exception e1){
		rcount=0;
	}
	return rcount;
   }

   public static int setConfigKey(String configid,String key,String value,Connection con){
	int rcount=0;
	java.sql.PreparedStatement pstmt=null;
	try{
		pstmt=con.prepareStatement(CONFIG_KEY_DELETE);
		pstmt.setString(1,configid);
		pstmt.setString(2,key);
	        rcount=pstmt.executeUpdate();
		pstmt.close();

		pstmt=con.prepareStatement(CONFIG_INFO_INSERT);
		pstmt.setString(1,configid);
		pstmt.setString(2,key);
		pstmt.setString(3,value);
	        rcount=pstmt.executeUpdate();
		pstmt.close();
  		pstmt=null;
	}catch(Exception e){
		System.out.println("Error in setConfigKey():" +e.getMessage());
		return 0;
	}
        finally{
		try{
			if(pstmt!=null) pstmt.close();
		}catch(Exception e){}
	}
	return rcount;
    }

  public static int setConfig(Config config,boolean replaceFlag,boolean forceCreate){
	StatusObj statusObj=null;
	Connection con=null;
	PreparedStatement pstmt=null;
	int rcount=0;
	try{
	        con=EventbeeConnection.getConnection();
		con.setAutoCommit(false);
		rcount=setConfig(config.getRefID(),config.getPurpose(),config.getConfigHash(),replaceFlag,forceCreate,con);
	}catch(SQLException e){
		rcount=0;		
	}catch(Exception e1){
		rcount=0;		
	}finally{
		try{
			con.setAutoCommit(true);
			if(con!=null)con.close();
		}catch(Exception e){
			rcount=0;		
		}
	}
	return rcount;
   }
   
   public static Config getGroupConfig(HashMap hm) {
	PreparedStatement pstmt=null;
	ResultSet rs=null;
	Connection con=null;
	Config cf=new Config();
	String groupid=(String)hm.get("groupid");
	try{
		if(groupid!=null){ 
			con=EventbeeConnection.getConnection();
		if("Club".equalsIgnoreCase((String)hm.get("grouptype"))){
	                pstmt=con.prepareStatement(CLUB_INFO_QUERY);
 		}else{
                        pstmt=con.prepareStatement(EVENT_INFO_QUERY);
                }
			pstmt.setString(1,groupid);
			rs=pstmt.executeQuery();
                if(rs.next()){
			cf.setConfigID(rs.getString("configid"));
		}
		rs.close();
		pstmt.close();
	 }	
	        
	}catch(Exception e1){
		EventbeeLogger.logException("com.eventbee.exception",EventbeeLogger.INFO,FILE_NAME,"setGroupConfig()","ERROR in setGroupConfig() method",e1);
	}finally{
		try{
			if(pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){
			
		}
	}	
	
	return cf;
   }

}

