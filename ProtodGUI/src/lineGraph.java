
import java.awt.List;
import java.util.Arrays;
import javax.swing.JFrame;
import org.jfree.chart.ChartFactory;
import org.jfree.chart.ChartPanel;
import org.jfree.chart.JFreeChart;
import org.jfree.chart.plot.PlotOrientation;
import org.jfree.data.category.DefaultCategoryDataset;
import org.jfree.ui.RefineryUtilities;

public class lineGraph extends JFrame {

    public lineGraph(String applicationTitle, String chartTitle,String yAxisLabel, long[] set, long[] timeset) {
        super(applicationTitle);
        //this.setDefaultCloseOperation(DISPOSE_ON_CLOSE);
        JFreeChart lineChart = ChartFactory.createLineChart(
                chartTitle,
                "Time (# of Samples)", yAxisLabel,
                createDataset(chartTitle,set,timeset),
                PlotOrientation.VERTICAL,
                true, true, false);

        ChartPanel chartPanel = new ChartPanel(lineChart);
        chartPanel.setPreferredSize(new java.awt.Dimension(560, 367));
        setContentPane(chartPanel);
    }

    public void showChart() {
        pack();
        RefineryUtilities.centerFrameOnScreen(this);
        setVisible(true);
    }

    private static DefaultCategoryDataset createDataset(String label, long[] set, long[] timeset) {
        DefaultCategoryDataset dataset = new DefaultCategoryDataset();
        for (int i = 0; i < timeset.length; i++){
            dataset.addValue(set[i], label, Long.toString(timeset[i]));
            
        } 
        return dataset;

    }

}
