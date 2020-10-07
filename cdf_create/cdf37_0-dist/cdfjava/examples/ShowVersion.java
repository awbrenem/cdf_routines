
import gsfc.nssdc.cdf.CDF;
import gsfc.nssdc.cdf.CDFException;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

public class ShowVersion {
    
    public static void main(String[] args) throws Exception {

        System.err.println("CDF library version= " + CDF.getLibraryVersion());

    }

}
