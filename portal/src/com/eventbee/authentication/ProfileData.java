package com.eventbee.authentication;
import com.eventbee.general.StatusObj;
import com.eventbee.general.EventBeeValidations;
import java.util.*;

public class ProfileData{
 private String m_FirstName="";
 private String m_LastName="";
 private String m_Email="";

 private String m_City="";
 private String m_State="";
 private String m_Zip="";
 private String m_Gender="";
 private String m_Street1="";
 private String m_Street2="";
 private String m_Phone="";
 private String m_Title="";
 private String m_Country="";
 private String m_Company="";
 private String m_pitch="";
 private String m_shareprofile="Yes";
 public Vector errorvector=null;
 private String comments="";


 public String getComments(){ return comments; }
 public void setComments(String comments1) { comments = comments1; }



 public String getFirstName(){ return m_FirstName; }
 public void setFirstName(String p_FirstName) { m_FirstName = p_FirstName; }

 public String getLastName(){ return m_LastName; }
 public void setLastName(String p_LastName) { m_LastName = p_LastName; }

 public String getEmail(){ return m_Email; }
 public void setEmail(String p_Email) { m_Email = p_Email; }

 public String getCity(){ return m_City; }
 public void setCity(String p_City) { m_City = p_City; }

 public String getState(){ return m_State; }
 public void setState(String p_State) { m_State = p_State; }

 public String getZip(){ return m_Zip; }
 public void setZip(String p_Zip) { m_Zip = p_Zip; }

 public String getGender(){ return m_Gender; }
 public void setGender(String p_Gender) { m_Gender = p_Gender; }

 public String getShareProfile(){ return m_shareprofile; }
 public void setShareProfile(String p_shareprofile) { m_shareprofile = p_shareprofile; }

 public String getStreet1(){ return m_Street1; }
 public void setStreet1(String p_Street1) {
                   m_Street1 = p_Street1; }

 public String getStreet2(){ return m_Street2; }
 public void setStreet2(String p_Street2) { m_Street2 = p_Street2; }

 public String getPhone(){ return m_Phone; }
 public void setPhone(String p_Phone) { m_Phone = p_Phone; }

 public String getCompany(){ return m_Company; }
 public void setCompany(String p_Company) { m_Company = p_Company; }

 public String getCountry(){ return m_Country; }
 public void setCountry(String p_Country) { m_Country = p_Country; }

 public String getTitle(){ return m_Title; }
 public void setTitle(String p_Title) { m_Title = p_Title; }

 public String getPitch(){ return m_pitch; }
 public void setPitch(String p_pitch) { m_pitch = p_pitch; }

 public Vector validateProfile(){

	errorvector=new Vector();
	if(m_FirstName.length()==0 || m_FirstName.trim().equals("First Name")){
		errorvector.add("First name should not be empty");
		return errorvector;
	}

	if(m_LastName.length()==0 || m_LastName.trim().equals("Last Name")){
		errorvector.add("Last name should not be empty");
		return errorvector;
	}

/*	if(m_Email.length()==0){
		errorvector.add("Email should not be empty");
	}else{
		StatusObj sobj=EventBeeValidations.isValidEmail(m_Email,"Email");
		if(!sobj.getStatus()){
			errorvector.add(sobj.getErrorMsg());
		}
	}*/


	if(m_Street1.length()==0){
		errorvector.add("Address should not be empty");
		return errorvector;
	}
	if(m_City.length()==0){
		errorvector.add("City should not be empty");
		return errorvector;
	}
	if(m_State.length()==0){
		errorvector.add("Select State");
	}

	if(m_Zip.length()==0){
		errorvector.add("Zip should not be empty");
		return errorvector;
	}






	/*if(m_Phone.length()==0){
		errorvector.add("Phone should not be empty");
	}*/
	/*else if(!EventBeeValidations.checkValidZip(m_Phone)){
		errorvector.add("Invalid Phone format");
	}*/
	/*else if(m_Phone.length()<7){
		errorvector.add("Phone enter minimum 7 digits");
	}*/




	if(errorvector.size()==0){
		errorvector=null;
	}

	return errorvector;

 }



 public StatusObj validate(){
     return new StatusObj(true, "", "");
 }

}
