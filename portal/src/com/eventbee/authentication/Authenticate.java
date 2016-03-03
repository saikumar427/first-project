 /*
 * Authenticate.java
 *
 * Created on March 27, 2003, 6:49 PM
 */

package com.eventbee.authentication;

import com.eventbee.general.EventbeeConnection;
import java.sql.*;

/**
 *
 * @author  rajanikanth
*/
import java.util.Map;
import java.util.HashMap;
import java.util.Vector;
public class Authenticate {

    private UserAccount mUserAccount=null;


    private Organization mOrganization=null;


    private OrgUnit mOrgUnit=null;


    private UserRole mUserRole=null;

    private AccessStore mAccessStore=null;

    public HashMap UserInfo=new HashMap();

    public HashMap UnitInfo=new HashMap(); 	
    
    
    private Map customData=new HashMap(); 

    public boolean islogged=false;


	final String IS_PROXY = " select * from proxyconfig Where unitid=?";

      public String getFirstName(){
          if(mUserAccount==null) return null;
          return mUserAccount.getFirstName();}
	 
      public String getLastName(){
          if(mUserAccount==null) return null;
          return mUserAccount.getLastName();}
	  
	 public String getEmail(){
          if(mUserAccount==null) return null;
          return mUserAccount.getEmail();}
	  
	  public String getUserName(){
          if(mUserAccount==null) return null;
          return mUserAccount.getUserName();}
		  
      public String getAuthID(){
          if(mUserAccount==null) return null;
          return mUserAccount.getAuthID();}

      public String getUserID(){
          if(mUserAccount==null) return null;
          return mUserAccount.getUserID();
      }
      public String getLoginName(){
          if(mUserAccount==null) return null;
          return mUserAccount.getLoginName();
      }
      public String getAcctStatusID(){
          if(mUserAccount==null) return null;
          return mUserAccount.getAcctStatusID();
      }
      public String getAcctStatusCode(){
          if(mUserAccount==null) return null;
          return mUserAccount.getAcctStatusCode();
      }

      public String getOrgID(){
          if(mOrganization==null) return null;
          return mOrganization.getOrgID();
      }
      public String getOrgName(){
          if(mOrganization==null) return null;
          return mOrganization.getOrgName();
      }
      public String getOrgTypeCode(){
          if(mOrganization==null) return null;
          return mOrganization.getOrgTypeCode();
      }

      public String getOrgPkgType(){
          if(mOrganization==null) return null;
          return mOrganization.getOrgPkgType();
      }

      public String getUnitID(){
          if(mOrgUnit==null) return null;
          return mOrgUnit.getUnitID();
      }
      public String getUnitName(){
          if(mOrgUnit==null) return null;
          return mOrgUnit.getUnitName();
      }
      public String getUnitCode(){
          if(mOrgUnit==null) return null;
          return mOrgUnit.getUnitCode();
      }
      public String getUnitTypeCode(){
          if(mOrgUnit==null) return null;
          return mOrgUnit.getUnitTypeCode();
      }

      public String getUnitPkgType(){
          if(mOrgUnit==null) return null;
          return mOrgUnit.getUnitPkgType();
      }

      public String getRoleID(){
          if(mUserRole==null) return null;
          return mUserRole.getRoleID();
      }
      public String getRoleCode(){
          if(mUserRole==null) return null;
          return mUserRole.getRoleCode();
      }
      public String getRoleName(){
          if(mUserRole==null) return null;
          return mUserRole.getRoleName();
      }
      public String getRoleTypeCode(){
          if(mUserRole==null) return null;
          return mUserRole.getRoleTypeCode();
      }

      public String getOrgAcctStatus(){
          if(mOrganization==null) return null;
          return mOrganization.getOrgAcctStatus();
      }

      public String getUnitAcctStatus(){
		  if(mOrgUnit==null) return null;
          return mOrgUnit.getUnitAcctStatus();
      }

      public String getOrgAcctDescription(){
          if(mOrganization==null) return null;
          return mOrganization.getOrgAcctDescription();
      }

      public String getUnitAcctDescription(){
		  if(mOrgUnit==null) return null;
          return mOrgUnit.getUnitAcctDescription();
      }

      public String getAcctDescription(){
          if(mUserAccount==null) return null;
          return mUserAccount.getAcctDescription();
      }

	 public String getAccountType(){
         	 if(mUserAccount==null) return null;
         	 return mUserAccount.getAccountType();
      	}



	  public boolean hasPermission(String beelet_id,String feature){

		  if(mAccessStore==null) return false;
		  return mAccessStore.hasPermission(beelet_id,feature);
	  }

	  public boolean isActiveAccount(){
		  boolean flag=false;
		  if("Manager".equals(getRoleName())){
				if(("1".equals(getAcctStatusID()))&&("1".equals(getOrgAcctStatus()))&&("1".equals(getUnitAcctStatus()))){
					flag=true;
				}else	if(("1".equals(getAcctStatusID()))&&("1".equals(getOrgAcctStatus()))&&("4".equals(getUnitAcctStatus()))){
					flag=true;
				}else	if(("1".equals(getAcctStatusID()))&&("4".equals(getOrgAcctStatus()))&&("1".equals(getUnitAcctStatus()))){
					flag=true;
				}else{
					flag=false;
				}
		  }else if("Member".equals(getRoleName())){
			  	if(("1".equals(getUnitAcctStatus()))&&("1".equals(getAcctStatusID()))&&("1".equals(getOrgAcctStatus()))){
					flag=true;
				}else	if(("1".equals(getAcctStatusID()))&&("1".equals(getOrgAcctStatus()))&&("4".equals(getUnitAcctStatus()))){
					flag=true;
				}else	if(("1".equals(getAcctStatusID()))&&("4".equals(getOrgAcctStatus()))&&("1".equals(getUnitAcctStatus()))){
					flag=true;
				}else{
					flag=false;
				}
		  }
		  return flag;
	  }

	  public Vector inActiveDescription(){
		  Vector v=new Vector();
		  HashMap hm=new HashMap();
		  String status=null;
		  String description=null;

		  hm.put("2","Suspended");
		  hm.put("3","Inactivated");
		  hm.put("6","Need to set password");
		  hm.put("7","Pending");
		  hm.put("8","Renewal Due");

		  if("Manager".equals(getRoleName())){
			  	if("6".equals(getAcctStatusID())){
					v.add((String)hm.get(getAcctStatusID()));
				}else{
					description=getAcctDescription();
					status=(String)hm.get(getAcctStatusID());

					if(status!=null){
						if(description!=null){
							status=status+".\n Reason :"+description;
						}
						v.add("Your account is "+status);
					}
				}

				description=getUnitAcctDescription();
				status=(String)hm.get(getUnitAcctStatus());


				if(status!=null){
					if(description!=null){
						status=status+".\n Reason :"+description;
					}
					v.add("Your unit is "+status);
				}

				description=getOrgAcctDescription();
				status=(String)hm.get(getOrgAcctStatus());


				if(status!=null){
					if(description!=null){
						status=status+".\n Reason :"+description;
					}
					v.add("Your organization is "+status);
				}

		  }else if("Member".equals(getRoleName())){

				status=(String)hm.get(getOrgAcctStatus());
				if(status!=null){
					v.add("Sorry this service is currently not available. ");
				}


				status=(String)hm.get(getUnitAcctStatus());
				if(status!=null){
					if((v.size()==0)){
						v.add("Sorry this service is currently not available. ");
					}
				}

				if("6".equals(getAcctStatusID())){
						v.add((String)hm.get(getAcctStatusID()));
				}else{

				description=getAcctDescription();
				status=(String)hm.get(getAcctStatusID());

					if(status!=null){
						if(description!=null){
								status=status+".\n Reason :"+description;
						}
						v.add("Your account is "+status);
					}

				}

		  }
		  if(v.size()==0){
			v=null;
		  }
		  return v;
	  }



    public UserAccount getUserAccount(){return mUserAccount;}

    public Organization getOrganization(){return mOrganization;}

    public OrgUnit getOrgUnit(){return mOrgUnit;}

    public UserRole getUserRole(){return mUserRole;}
    
    
    public Map getCustomData(){return customData;}

    public void setRolePermission(AccessStore pAccessStore) {mAccessStore=pAccessStore;}

    public void setUserAccount(UserAccount pUserAccount) {mUserAccount=pUserAccount;}

    public void setOrganization(Organization pOrganization) {mOrganization=pOrganization;}

    public void setOrgUnit(OrgUnit pOrgUnit) {mOrgUnit=pOrgUnit;}

    public void setUserRole(UserRole pUserRole) {mUserRole=pUserRole;}


   public boolean isProxy(){
	//Connection con=null;
	//boolean exists=false;
	/*java.sql.PreparedStatement pstmt=null;
	boolean flag=false;
	String unitid=getUnitID();
	try{
		con=EventbeeConnection.getConnection();
		pstmt=con.prepareStatement(IS_PROXY);
		pstmt.setString(1,unitid);
		ResultSet rs=pstmt.executeQuery();
		if(rs.next()){
			flag=true;
		}else{
			flag=false;
		}
		rs.close();
		pstmt.close();
		pstmt=null;
		con.close();
		con=null;
	}catch(Exception e){
		System.out.println("Error in isProxy()"+e.getMessage());
	}
	finally{
		try{
			if (pstmt!=null) pstmt.close();
			if(con!=null) con.close();
		}catch(Exception e){}
	}*/
	return false;
   }



}
