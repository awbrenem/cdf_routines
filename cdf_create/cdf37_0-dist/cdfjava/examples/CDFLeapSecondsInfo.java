/******************************************************************************
* Copyright 1996-2013 United States Government as represented by the
* Administrator of the National Aeronautics and Space Administration.
* All Rights Reserved.
******************************************************************************/

import gsfc.nssdc.cdf.*;
import gsfc.nssdc.cdf.util.*;
import java.io.*;
import java.util.*;

public class CDFLeapSecondsInfo implements CDFConstants {
   public static void main (String[] args) {
     boolean dump = false;
     String table = null;
     double[][] lt;
     int fileStatus;
     long year, month, day;
     int ix, rows;
     if (args.length == 1) {
       String option = args[0];
       if (option.toLowerCase().equals("dump")) dump = true;
     }
     String os = System.getProperty("os.name");
     boolean nonVMS = true;
     if (os.toLowerCase().indexOf("vms") != -1) nonVMS = false;   
     System.out.println ("Info for CDF leap second table...");
     table = CDFTT2000.getLeapSecondsTableEnvVar();
     fileStatus = CDFTT2000.CDFgetLeapSecondsTableStatus();
     if (table == null) {
       if (nonVMS)
         System.out.println ("Environment Variable: CDF_LEAPSECONDSTABLE is NOT defined....");
       else
         System.out.println ("Environment Variable: CDF$LEAPSECONDSTABLE is NOT defined....");
       System.out.println ("Thus, the hard-coded table is used.");
     } else {
       if (fileStatus == 0) {
         if (nonVMS) {
           System.out.println ("Environment Variable: CDF_LEAPSECONDSTABLE is defined as: "+table);
         } else {
           System.out.println ("Environment Variable: CDF$LEAPSECONDSTABLE is defined as: "+table);
         }
         System.out.println ("                      but the file is invalid...."); 
         System.out.println ("Thus, the hard-coded table is used.");
       } else
         System.out.println ("CDF's leap seconds table is based on the file: "+table);
     }
     long[] ymd = CDFTT2000.CDFgetLastDateinLeapSecondsTable ();
     System.out.println ("The last date a leap second was added to the table is: "+ymd[0]+"-"+((ymd[1]<10)?"0":"")+ymd[1]+"-"+((ymd[2]<10)?"0":"")+ymd[2]);
     if (dump) {
       lt = (double [][]) CDFTT2000.CDFgetLeapSecondsTable();
       rows = CDFTT2000.CDFgetRowsinLeapSecondsTable();
       System.out.print ("    \t     \t     \t  Leap \t\t  Drift\t\t  Drift\n");
       System.out.print ("Year\tMonth\t  Day\tSeconds\t\t     1 \t\t     2\n");
       for (ix = 0; ix < rows; ++ix) {
         if (ix < 5) 
           System.out.println (""+lt[ix][0]+"\t  "+lt[ix][1]+"\t  "+lt[ix][2]+"\t"+lt[ix][3]+"\t "+lt[ix][4]+"\t "+lt[ix][5]);
         else if (ix < 14)
           System.out.println (""+lt[ix][0]+"\t  "+lt[ix][1]+"\t  "+lt[ix][2]+"\t"+lt[ix][3]+"\t\t "+lt[ix][4]+"\t "+lt[ix][5]);
         else
           System.out.println (""+lt[ix][0]+"\t  "+lt[ix][1]+"\t  "+lt[ix][2]+"\t"+lt[ix][3]+"\t\t "+lt[ix][4]+"\t\t "+lt[ix][5]);

       }
     }
   }
}

