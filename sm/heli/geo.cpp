/*
Copyright (c) 2012, Zubair Khan (governer@gmail.com) 
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
    *     * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
    *
    *     THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/


// This is to geo tag FAA charts not already get tagged.

// compile using: c++ geo.cpp -lgdal -Wall -o geo
// or c++ geo.cpp -lgdal1.7.0 -Wall -o geo

#include <gdal_priv.h>
#include <ogr_api.h>
#include <ogrsf_frmts.h>

#include <stdio.h>

int main(int argc, char *argv[]) 
{
    OGRSpatialReference lccSRS, wgsSRS;
    GDALDataset  *datsetSrc_ptr, *datsetDst_ptr;
    GDALDriver *gdalDrv_ptr;
    char *wktSrc_ptr = NULL;
    FILE *input_ptr;
    
    double firstlatParallel;
    double secondlatParallel;
    double latCenter;
    double lonCenter;
    double latTopLeft;
    double lonTopLeft;
    double latBottomRight;
    double lonBottomRight;
    char inputConfig_ptr[256];
    char outputName_ptr[256];
    char inputName_ptr[256];

    strcpy(inputConfig_ptr, argv[1]);
    strcat(inputConfig_ptr, ".txt");
    strcpy(inputName_ptr, argv[1]);
    strcat(inputName_ptr, ".tif");
    sprintf(outputName_ptr, "geo_%s", inputName_ptr); 

    input_ptr = fopen(inputConfig_ptr, "r");

    fscanf(input_ptr,"%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf",
            &firstlatParallel,
            &secondlatParallel,
            &latCenter,
            &lonCenter,
            &latTopLeft,
            &lonTopLeft,
            &latBottomRight,
            &lonBottomRight);
    fclose(input_ptr);

    printf("%lf,%lf,%lf,%lf,%lf,%lf,%lf,%lf,%s,%s,%s\n",
            firstlatParallel,
            secondlatParallel,
            latCenter,
            lonCenter,
            latTopLeft,
            lonTopLeft,
            latBottomRight,
            lonBottomRight,
            inputName_ptr,
            inputConfig_ptr,
            outputName_ptr);
   
    OGRRegisterAll();
    GDALAllRegister(); 
    
    // LCC, projection of chart
    lccSRS.SetProjCS("Avare");
    lccSRS.SetWellKnownGeogCS("NAD83");
    lccSRS.SetLCC(firstlatParallel, secondlatParallel, latCenter, lonCenter, 0, 0);
    lccSRS.exportToWkt(&wktSrc_ptr);
    
    // WGS this is for converting GPS coordinates we enter to LCC coordinates
    wgsSRS.SetWellKnownGeogCS("EPSG:4326");
   
    // input file
    datsetSrc_ptr = (GDALDataset *)GDALOpen(inputName_ptr, GA_ReadOnly);

    // projection find
    OGRCoordinateTransformation *oct_ptr;
    oct_ptr = OGRCreateCoordinateTransformation(&wgsSRS, &lccSRS);
    double px;
    double py;
    
    double x = datsetSrc_ptr->GetRasterXSize();
    double y = datsetSrc_ptr->GetRasterYSize();

    double latTopLeft_p = latTopLeft;
    double lonTopLeft_p = lonTopLeft;
    double latBottomRight_p = latBottomRight;
    double lonBottomRight_p = lonBottomRight;
    oct_ptr->Transform(1, &lonTopLeft_p, &latTopLeft_p);
    oct_ptr->Transform(1, &lonBottomRight_p, &latBottomRight_p);

    px = (lonBottomRight_p - lonTopLeft_p) / x;
    py = (latBottomRight_p - latTopLeft_p) / y;
  
    double transform[6] = {lonTopLeft_p, px, 0, latTopLeft_p, 0, py}; 

    //output
    gdalDrv_ptr = GetGDALDriverManager()->GetDriverByName("GTiff");
    datsetDst_ptr = gdalDrv_ptr->CreateCopy(outputName_ptr, datsetSrc_ptr, FALSE, 
                                NULL, NULL, NULL );
    datsetDst_ptr->SetProjection(wktSrc_ptr);
    datsetDst_ptr->SetGeoTransform(transform);

    GDALClose((GDALDatasetH)datsetSrc_ptr);
    GDALClose((GDALDatasetH)datsetDst_ptr);

    CPLFree(wktSrc_ptr);
}
