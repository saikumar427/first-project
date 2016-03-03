package com.eventbee.general;


import java.security.MessageDigest;
 //SHA-2 hash function implementation adapted from http://www.mkyong.com/java/java-sha-hashing-example/
import java.util.Random;


public class GenerateOTP{
    public static void main(String[] args)throws Exception{
	
    }	


    public static String genHash()throws Exception {
    	MessageDigest md = MessageDigest.getInstance("SHA-256");
       	md.update(Integer.toString(new Random().nextInt()).getBytes());
       	byte byteData[] = md.digest();
        	//convert the byte to hex format method 1
        StringBuffer sb = new StringBuffer();
    	for (int i = 0; i < byteData.length; i++) {
     		sb.append(Integer.toString((byteData[i] & 0xff) + 0x100, 16).substring(1));
    	}
 		//This generates a single hash 
		return sb.toString();
	}
	
	public static  String genPassword() {
	//now we need to generate numbers based on the SHA hash output. so take last 12 chars of sb string, 		convert in pairs to integer values (usually ends up being only first few hex values used to make 6-int long number string) 
		String Password = "",hash="";
		try {
			hash=genHash();
		} catch (Exception e) {
			e.printStackTrace();
		}
		char[] hashArray = hash.toCharArray();
		char[] shortHashArray;
		shortHashArray = new char[12];
		char[] tempChar = new char[6];
		for(int i = 0; i < 12; i++) {
			shortHashArray[i] = hashArray[52+i]; //shortHashArray is last 12 digits of entire hash
		}
		
		int hexNum;
		for (int i = 0; i < 6; i++) {
			tempChar[0] = shortHashArray[2*i];
			tempChar[1] = shortHashArray[2*i+1];
			String temp = new String(tempChar); //section off blocks of 2 (hex numbers)
			temp = temp.trim();
			hexNum = Integer.parseInt(temp, 16); //convert hex num string to decimal;
			String hexNumString = Integer.toString(hexNum);
				
			if (Password.length() == 5) { //just add first char of hex num

				Password += hexNumString.charAt(0);
				
			}
			else if (Password.length() == 4) {              
				if(hexNum<10) {  // if hex num is only 1 char long, add just that 
					//(and continue in loop to add first char of next hex num)
					Password += hexNumString.charAt(0);
				}
				else {					//add first two chars of hex num ()) 
					Password += hexNumString.charAt(0);
					Password += hexNumString.charAt(1);
				}
			}
			else if (Password.length() >= 6) { //password too large, quit
				break;
			}
			else {
				Password += hexNumString; //put converted decimal into password string
			}


		}

		return Password;
	}

}