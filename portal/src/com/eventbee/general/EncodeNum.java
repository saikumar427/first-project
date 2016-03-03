package com.eventbee.general;
import java.util.*;


public class EncodeNum{

	static Random random = new Random();
	static String [] zero={"A","f","G","l","M" };
	static String [] one={"z","U" ,"t", "O" , "n"};
	static String [] two={ "D", "E","J","c","u"  };
	static String [] three={  "L", "R","W","j" ,"p" };
	static String [] four={"X","F","k","v","b"};
	static String [] five={"H" ,"Q", "q","r","i"};
	static String [] six={"C","P" ,"Y","d" , "x" ,"h"  };
	static String [] seven={ "a" ,"I","o","T","w"} ;
	static String [] eight={"B" , "g", "N","s" ,"V"};
	static String [] nine={ "y" ,"S","m" ,"K","e"  };
	
	
	
	
	static String [] zero_0={"A","Z"};
	static String [] one_1={"Y","B"};
	static String [] two_2={"C","X"};
	static String [] three_3={"V","D"};
	static String [] four_4={"E","U"};
	static String [] five_5={"T","F"};
	static String [] six_6={"G","S"};
	static String [] seven_7={"P","H"} ;
	static String [] eight_8={"J" ,"N"};
	static String [] nine_9={"M","L"};
	
	static List listarray_mod=new ArrayList();
	
	static List listarray=new ArrayList();
        static final List list=new ArrayList();
	static{
		list.add(zero);	list.add(one);	list.add(two);	list.add(three);list.add(four);	list.add(five);	list.add(six);
		list.add(seven);list.add(eight);list.add(nine);
		listarray.add( Arrays.asList(zero) );listarray.add( Arrays.asList(one) );
		listarray.add( Arrays.asList(two) );listarray.add( Arrays.asList(three) );
		listarray.add( Arrays.asList(four) );listarray.add( Arrays.asList(five) );
		listarray.add( Arrays.asList(six) );listarray.add( Arrays.asList(seven) );
		listarray.add( Arrays.asList(eight) );listarray.add( Arrays.asList(nine) );
		
		listarray_mod.add(zero_0);	listarray_mod.add(one_1);	listarray_mod.add(two_2);	listarray_mod.add(three_3); listarray_mod.add(four_4);	listarray_mod.add(five_5);	listarray_mod.add(six_6);
		listarray_mod.add(seven_7);listarray_mod.add(eight_8);listarray_mod.add(nine_9);
		
		
	}
	/*
	File Changed On 2013-05-03
	change encodeNum() logic
	Note:Need to write your own decodeNum() logic
	*/
	public static String encodeNum(String num){
		int leng=num.length();
		StringBuffer encoded=new StringBuffer();	
		String n=num.substring(num.length()-2,num.length()-1);
		encoded.append(n);
		while(num.length()>0){
			String tempstr=num.substring(0,1);
			int chr=(int)(random.nextFloat()*10);
			if(chr>=2)chr=chr/5;			
			String[]  temp=(String[] )listarray_mod.get( Integer.parseInt(tempstr)  );
			encoded.append(temp[chr]);			
			num=num.substring(1);
		}
		return encoded.toString();
		
	}
	

	/*public static String encodeNum(String num){
		int leng=num.length();
		if(leng>6)return num;
		//if(leng>7)return null;
		StringBuffer encoded=new StringBuffer();
		String[] temp=(String[] )list.get(leng);
		int chr=(int)(random.nextFloat()*10);
		if(chr>=5)chr=chr/2;
		encoded.append(temp[chr]);
		int chrtoapp=7-leng;		
		for(int i=0;i<chrtoapp;i++){
			num=num+"0";
		}
		while(num.length()>0){
			String tempstr=num.substring(0,1);
			chr=(int)(random.nextFloat()*10);
			if(chr>=5)chr=chr/2;			
			 temp=(String[] )list.get( Integer.parseInt(tempstr)  );
			encoded.append(temp[chr]);			
			num=num.substring(1);
		}
		return encoded.toString();
		
	}*/

	public static String decodeNum(String str){
		StringBuffer decoded=new StringBuffer();
		String len=str.substring(0,1);
		
		int lenofstr=0;
		for(int i=0;i<=9;i++){
		List templist=(List)listarray.get(i);
			if(templist.contains(len)){
				
				lenofstr=i;
			}
		}

		str=str.substring(1);
		str=str.substring(0,lenofstr);
		
		while(str.length()>0){
			
			String tempstr=str.substring(0,1);

			
			for(int i=0;i<=9;i++){
				List templist=(List)listarray.get(i);
				if(templist.contains(tempstr)){
					
					decoded.append(i+"");
				}
			}


			str=str.substring(1);
		}

		return decoded.toString();
	}

        public static void main(String arg[]){
        	String usern="";
        try{
        Scanner in = new Scanner(System.in);
        System.out.print("Please enter user num : ");
        usern= in.nextLine();  
        }catch(Exception e){System.out.println(e.getMessage());}
        String enc=encodeNum(usern);
		System.out.println("encoded string :="+enc);
		
        }
}
