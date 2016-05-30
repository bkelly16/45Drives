
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Iterator;
import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Brett
 */
public class ParseJSON {
    public static void readJSON(String file1, DataSet set1) throws IOException, ParseException{
        //System.out.println("test");
        
        //ParseLog.sortHeaderLog(file2);
        //Craete Parser Object

        //Read JSON in Object
        JSONParser parser = new JSONParser();
        Object raw = parser.parse(new FileReader(file1));
        //Get Log Object ("log", [header, threashold, values]
        JSONObject logObject = (JSONObject) raw;
        JSONArray logArray = (JSONArray) logObject.get("log");
        
        //ArrayList<JSONArray> listofItems = new ArrayList<>(logArray.size());
        JSONObject headerObject = (JSONObject) logArray.get(0);
        JSONArray headerArray = (JSONArray) headerObject.get("header");
        //Get Header object ( "header", [data])
        
        //Get threshold object ( "threshold", [data] )
        JSONObject thresholdObject = (JSONObject) logArray.get(1);
        JSONArray thresholdArray = (JSONArray) thresholdObject.get("threshold");
        
        //Get Values object ( "values, [data] )
        JSONObject valuesObject = (JSONObject) logArray.get(2);
        JSONArray valuesArray = (JSONArray) valuesObject.get("values");
        
        // Initial list of measurements
        ArrayList<JSONArray> listofMeasurements = new ArrayList<>(valuesArray.size());
        
        //Loop through valuesArray, get measureObject[i] enter into MeasuremntList
        for (int i=0; i<valuesArray.size();i++){
            JSONObject measureObject = (JSONObject) valuesArray.get(i);
            JSONArray measureArray = (JSONArray) measureObject.get("m");
            listofMeasurements.add(measureArray);
        }
        
        //importSet(headerArray,thresholdArray,listofMeasuremnts);
        //System.out.println(listofMeasuremnts.toString());

        //Import Header Values
        JSONObject header = (JSONObject) headerArray.get(0);
        printJSONObject(header);
        set1.dateStamp = (long) header.get("date");
        set1.machineID = (String) header.get("id");
        set1.totalCPU = (double) header.get("totalcpu");
        set1.totalRAM = (long) header.get("totalram");
        
        
        //Import Threshold Values
        JSONObject thresholds = (JSONObject) thresholdArray.get(0);
        printJSONObject(thresholds);
        set1.iniTimeStamp = (long) thresholds.get("timestamp");
        set1.thresholdcpu = (long) thresholds.get("thresholdcpu");
        set1.thresholdram = (long) thresholds.get("thresholdram");
        set1.thresholdDataBus = (long) thresholds.get("thresholddatabus");
        set1.thresholdNetwork = (long) thresholds.get("thresholdnetwork");
         
        //Import Meausrment values
        for (int n = 0;n<listofMeasurements.size(); n++) { // Loop through the List of measurements
            JSONArray valueArray = (JSONArray) listofMeasurements.get(n); // create JSONArray out of current line
            printJSONArray(valueArray);
            JSONObject valueObject = (JSONObject) valueArray.get(0); // grab first entry in Array
            printJSONObject(valueObject);
            
            //store values
            //set1.initializeSet(listofMeasurements.size());
            //System.out.println(listofMeasurements.size());
            
            set1.timeStamp.add((long) valueObject.get("t"));
            set1.cpuLoad.add((double) valueObject.get("c"));
            set1.memLoad.add((long) valueObject.get("r"));
            set1.dataBus.add((long) valueObject.get("d"));
            set1.networkBus.add((long) valueObject.get("n"));
            //set1.timeStamp[n] = (long) valueObject.get("t");
            //set1.cpuLoad[n] = (double) valueObject.get("c");
            //set1.memLoad[n] = (long) valueObject.get("r");
            //set1.dataBus[n] =  (long) valueObject.get("d");
            //set1.networkBus[n] = (long) valueObject.get("n");
        }
        
        
    }  
        
    public static void printJSONArray(JSONArray ja){
        Iterator itr = ja.iterator();
        //Iterator itr2 = logObject.iterator();
        while(itr.hasNext()){    
            System.out.println(itr.next());
        }
    }
    
    public static void printJSONObject(JSONObject ja){
        //Iterator itr = jr.iterator();
        String test = ja.toString();
        //Iterator itr2 = logObject.iterator();
            
        System.out.println(test);  
    }   
}
