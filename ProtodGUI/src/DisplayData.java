
import static java.lang.reflect.Array.set;
import java.util.ArrayList;

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Brett
 */
public class DisplayData {
    
    //public static void cpuPlot(double[] set, long[] timeset){
        //lineGraph graph = new lineGraph("Resource Usage", "CPU Load", "Utiliztaion (%)", set , timeset);
        //graph.showChart();
    //}


    public static void ramPlot(ArrayList<Long> ramSet, ArrayList<Long> timeSet){
        long[] time = new long[ramSet.size()];
        long[] mem  = new long[ramSet.size()];
        
        for (int i =0;i<ramSet.size();i++){
            time[i] = (long) timeSet.get(i);
            mem[i] = (long) ramSet.get(i);
        }
        lineGraph graph = new lineGraph("Resource Usage", "RAM Load", "RAM (Bytes)", mem , time);
        graph.showChart();
    }
    public static void dataPlot(ArrayList<Long> dataSet, ArrayList<Long> timeSet){
        long[] time = new long[timeSet.size()];
        long[] data  = new long[dataSet.size()];
        
        for (int i =0;i<dataSet.size();i++){
            time[i] = (long) timeSet.get(i);
            data[i] = (long) dataSet.get(i);
        }
        lineGraph graph = new lineGraph("Resource Usage", "Data Transfer", "Data IO (Bytes)", data , time);
        graph.showChart();
    }
    public static void networkPlot(ArrayList<Long> networkSet, ArrayList<Long> timeSet){
        long[] time = new long[timeSet.size()];
        long[] mem  = new long[networkSet.size()];
        
        for (int i =0;i<networkSet.size();i++){
            time[i] = (long) timeSet.get(i);
            mem[i] = (long) networkSet.get(i);
        }
        lineGraph graph = new lineGraph("Resource Usage", "Network Transfer", "Data IO (Octets)", mem , time);
        graph.showChart();
    }    
}
