package com.eventbee.conditionalticketing.validators;

import java.util.ArrayList;
import java.util.HashMap;

import org.json.JSONArray;
import org.json.JSONObject;

public class MustByAND implements ConditionalTicketing {

	@Override
	public ArrayList<String> validateCondition(JSONObject condition, JSONObject selectedTickets) {

		ArrayList<String> warningsList= new ArrayList<String>();
		try {
			System.out.println("MustByAND selectedTickets: "+selectedTickets);
			HashMap<String,Integer> targetAllowMap=new HashMap<String, Integer>();
			String srcTicket=condition.getJSONObject("src").getString("id");
			if(selectedTickets.has(srcTicket)){
				JSONArray trgArray=condition.getJSONArray("trg");
				Boolean containStatus=true; 
				StringBuffer dependantTickets=new StringBuffer();
				StringBuffer selTickets=new StringBuffer();
				for(int i=0;i<trgArray.length();i++){
					String trgId=trgArray.getJSONObject(i).getString("id");
					if(!selectedTickets.has(trgId)){
						if(containStatus)
							containStatus=false;	
					}	
					if(selectedTickets.has(trgId)){
						if(!"NOLIMIT".equalsIgnoreCase(trgArray.getJSONObject(i).getString("type")) && selectedTickets.getInt(trgId)<trgArray.getJSONObject(i).getInt("qty")){
							warningsList.add(" To buy "+srcTicket+", you have to buy at least "+trgArray.getJSONObject(i).getInt("qty")+"  "+trgId+".");
							//warningsList.add(" your are not allowed to buy "+srcTicket+" until an  unless  "+trgArray.getJSONObject(i).getInt("qty")+"  "+trgId+"  ticket(s) ");
							return warningsList;
						}
						if(!targetAllowMap.containsKey(srcTicket+"_min")){
							if("NOLIMIT".equalsIgnoreCase(trgArray.getJSONObject(i).getString("type"))){}
							else if(trgArray.getJSONObject(i).getInt("qty")==0)//if src qty is none(or =0) //we should not allow ratio
								targetAllowMap.put(srcTicket+"_min", trgArray.getJSONObject(i).getInt("min"));
							else
								targetAllowMap.put(srcTicket+"_min", (selectedTickets.getInt(trgId)*Math.round(trgArray.getJSONObject(i).getInt("min"))/trgArray.getJSONObject(i).getInt("qty")));
						}
						else{
							if("NOLIMIT".equalsIgnoreCase(trgArray.getJSONObject(i).getString("type"))){}
							else if(trgArray.getJSONObject(i).getInt("qty")==0)//if src qty is none(or =0) //we should not allow ratio
								targetAllowMap.put(srcTicket+"_min", targetAllowMap.get(srcTicket+"_min")+trgArray.getJSONObject(i).getInt("min"));
							else
								targetAllowMap.put(srcTicket+"_min",targetAllowMap.get(srcTicket+"_min")+((selectedTickets.getInt(trgId)*Math.round(trgArray.getJSONObject(i).getInt("min"))/trgArray.getJSONObject(i).getInt("qty"))));
						}
						if(!targetAllowMap.containsKey(srcTicket+"_max")){
							if("NOLIMIT".equalsIgnoreCase(trgArray.getJSONObject(i).getString("type"))){}
							else if(trgArray.getJSONObject(i).getInt("qty")==0){//if src qty is none(or =0) //we should not allow ratio
								if(trgArray.getJSONObject(i).getInt("max")==0)//no limit on max
									targetAllowMap.put(srcTicket+"_max", 1000000);
								else
									targetAllowMap.put(srcTicket+"_max", trgArray.getJSONObject(i).getInt("max"));
							}
							else{
								targetAllowMap.put(srcTicket+"_max", (selectedTickets.getInt(trgId)*Math.round(trgArray.getJSONObject(i).getInt("max"))/trgArray.getJSONObject(i).getInt("qty")));
							}
						}
						else{
							if("NOLIMIT".equalsIgnoreCase(trgArray.getJSONObject(i).getString("type"))){}
							else if(trgArray.getJSONObject(i).getInt("qty")==0){//if src qty is none(or =0) //we should not allow ratio
								if(trgArray.getJSONObject(i).getInt("max")==0)//no limit on max									
									targetAllowMap.put(srcTicket+"_max", targetAllowMap.get(srcTicket+"_max")+1000000);
								else								
									targetAllowMap.put(srcTicket+"_max", targetAllowMap.get(srcTicket+"_max")+trgArray.getJSONObject(i).getInt("max"));
							}
							else{
								targetAllowMap.put(srcTicket+"_max",targetAllowMap.get(srcTicket+"_max")+ (selectedTickets.getInt(trgId)*Math.round(trgArray.getJSONObject(i).getInt("max"))/trgArray.getJSONObject(i).getInt("qty")));
							}
						}
					}
					if("".equals(dependantTickets.toString()))
						dependantTickets.append(trgId);					

					else 
						dependantTickets.append(", "+trgId);

					if("".equals(selTickets.toString())&&selectedTickets.has(trgId)){
						if(trgArray.getJSONObject(i).getInt("qty")!=0)// if qty=0 dont put selected qty in warning message
							selTickets.append(""+selectedTickets.getInt(trgId)+" "+trgId);
						else
							selTickets.append(" "+trgId);
					}

					else if(selectedTickets.has(trgId)){
						if(trgArray.getJSONObject(i).getInt("qty")!=0)// if qty=0 dont put selected qty in warning message
							selTickets.append(" and "+selectedTickets.getInt(trgId)+" "+trgId);
						else
							selTickets.append(" and "+trgId);
					}




				}
				//System.out.println(targetAllowMap.toString());
				if(!containStatus){
					if(trgArray.length() > 1 )
						warningsList.add(" If you want to buy "+srcTicket+",  you have to buy all of the tickets - "+dependantTickets.toString()+".");
					else
					warningsList.add(" If you want to buy "+srcTicket+",  you have to buy "+dependantTickets.toString()+".");
					return warningsList;
				}
				if(targetAllowMap.containsKey(srcTicket+"_min") && selectedTickets.getInt(srcTicket)<targetAllowMap.get(srcTicket+"_min")){
					//warningsList.add("You can't  buy "+srcTicket+" less than "+targetAllowMap.get(srcTicket+"_min") +" if you  select  "+selTickets.toString()+".");
					warningsList.add("For "+selTickets.toString()  +",  you  have to buy at least "+targetAllowMap.get(srcTicket+"_min") +" " +srcTicket+"." );
					return warningsList;
				}
				if(targetAllowMap.containsKey(srcTicket+"_max") && selectedTickets.getInt(srcTicket)>targetAllowMap.get(srcTicket+"_max")){
					warningsList.add("For "+selTickets.toString()  +",  you can buy upto "+targetAllowMap.get(srcTicket+"_max") +" " +srcTicket+"." );
					return warningsList;
				}


			}	


		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return warningsList;

	}


}

