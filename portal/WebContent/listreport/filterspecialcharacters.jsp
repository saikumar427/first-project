<%!
	int asciistart = 32;
	int asciiend = 125;
	int excludeascii = 94;
	public String filterSpecialCharacters(String data){
		String result_data = "";
		try{
			for(int i=0;i<data.length();i++){
				int sciicode = (int)data.charAt(i);
				if(sciicode >= asciistart && sciicode <=asciiend && sciicode != excludeascii)	
					result_data += data.charAt(i);
				else{
				data=data.replace(data.charAt(i) ,' ');
				result_data +=data.charAt(i);
				}
				}
				
		}catch(Exception e){
			
		}
	return result_data;
	}
%>
