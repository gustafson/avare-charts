// Avare - this code is not to be open sourced on request from the author (Faisal Bashir)


/////////////////////////////////////////////////////////////////////////////////
// PlateProcessor.cpp
/* Copyright 2013 Vision Tech Systems, Inc.
*/
//
// FILENAME : PlateProcessor.cpp
// AUTHORS  : Faisal Bashir.
//
// DATE     : April 17, 2013
/////////////////////////////////////////////////////////////////////////////////

//// Memory leak detection using CRT
//#define _CRTDBG_MAP_ALLOC
//#include <stdlib.h>
//#include <crtdbg.h>

#include "PlateProcessor.h"

using namespace cv;
using namespace std;

RNG rng(12345);

// Preprocesing Params
static bool g_Threshold = false; //true;
static int g_ThresholdVal = 127;
static const int g_ThresholdedImgMaxVal = 255;
static bool g_ThresholdAdaptive = false;
static int g_ThresholdAdaptiveBlockSize = 45;
static bool g_Negate = false;
static bool g_nopreproc = false;
static bool g_resizeImage = false;
static float g_smallFactor = 1.0f;

static const double g_bilatfiltSigmaColor = 25.0;
static const double g_bilatfiltSigmaSp = 12.0;

// Application params
static bool g_roiDetect = false;
static bool g_savefiximages = false;
static bool g_resizeImageForDisplay = false;
static float g_smallFactorForDisplay = 1.0f;
static bool g_ImageOut = false;
static bool g_cropOutFromOriginal = false;
static int g_outnum = 0;
static bool g_ImageShow = false;
static bool g_TxtOut = false;
static bool g_verbose = false;
static bool g_DisplayPoints = false;
static bool g_fixIsFixText = false;
// For level-2 (fix-text type) run, this is the offset of 
// ROI being processed from level-1 (fix) detection run.
static int g_inputROIX = 0;
static int g_inputROIY = 0;
static string g_imgFileName;
static string g_originalImgFileName;


// Chamfer matching params
static int g_MaxMatches = 20;
static float g_MinMatchDistance = 1.0f;
static const double g_CMorientationWeight = 0.75;
static float g_threshcost = 1000;

// Multi-results grouping params
static const int g_RectGroupThreshold = 1; // minneighbors for groupRectangles
static const float g_RectGroupEPS = 0.2;

static const float g_Rect2ROIExpX = 2.0f;
static const float g_Rect2ROIExpY = 2.0f;
static const float g_FixTextRect2ROIExpX = 0.5f;
static const float g_FixTextRect2ROIExpY = 1.5f;

static const int g_rectIntersectAreaTh = 1;

// Text detection using SWT params
static int g_DarkOnLight = false;
//////
// 0: Fix
// 1: Fix text
// 2: Text
static int g_AppMode = 0;

static bool g_ocr = false;
static std::string g_OCRLibPath = std::string("E:\\Dropbox\\work\\tesseract-build\\tesseract-ocr-302\\");

// TODO:
// Implement minNeighbors option.  Minimum this many should be detected
// in a neighborhood for valid detection.
// FIX1: 
// Not for now.  Controlling the minMatchDistance works.

// TODO:
// Implement prune_nonunique.  Return only unique detections.
// Implement groupRectangles (or groupRectangles_meanshift) to group
// similar detected rectangles.
//   For each vector<Point>, call cv::boundingRect to compute cv::Rect.
//   Call groupRectangles on vector<Rect>
// FIX1: For now, used parameters g_MinMatchDistance (tpl.size/3) and 
// g_MaxMatches (5 - 10).

// TODO:
// Implement sort_detections in measure of confidence.  Implement confidence measure
// as combination of cost + (neighbors ???)+ ???
// FIX 1:
// Currently just use chamfer matching cost for sorting.  Results from Chamfer matching
// are already sorted according to cost.

// TODO:
// Implement graphics overlay of confidence.  Draw detections with colors from
// blue to red in order of confidence.


void help()
{
	cout <<
			"\nThis program demonstrates Chamfer matching -- computing a distance between an \n"
			"edge template and a query edge image.\n"
			"Call:\n"
      "cpp-example-chamfer [<image>]\n"
      "[-tpl <template>]   -> Multiple templates specified with multiple -tpl <template> args\n"      
      "[-original <originalimagefilename>]   -> Original plate image to crop text candidates from\n"
      "[-thresh threshVal] \n"
      "[-threshcost threshVal] \n"      
      "[-negate] \n"
      "[-nopreproc] \n"      
      "[-inputroi x y] \n"      
      "[-roidetect] \n"
      "[-resize rszfactor] \n"
      "[-maxmatches maxmatches] \n"
      "[-minmatchdist minmatchdist] \n"
      "[-resizedisp rszfactordisp] \n"
      "[-showpts] \n"
      "[-imgout] \n"
      "[-outnum number] \n"
      "[-savefiximages] \n"
      "[-imgshow] \n"
      "[-txtout] \n"
      "[-v] \n"
      "[-mode 0|1|2] <- 0: Fix mode. 1: Fix text mode. 2: Text mode. \n"
      "[-dark] <- For txt detection, 1: dark text on light background.\n"
      "[-ocr] <- Perfrom ocr. Needs Tesseract lib.\n"
      "\n"
			"By default\n"
      "the inputs are \n"
      "./chamfer logo_in_clutter.png\n"
      "-tpl logo.png\n"
			"-thresh = " << g_Threshold << " threshVal = " << g_ThresholdVal << "\n"
      "-threshadaptive = " << g_ThresholdAdaptive << " ThresholdAdaptiveBlockSize = " << g_ThresholdAdaptiveBlockSize << "\n"      
      "-negate = " << g_Negate << "\n"
      "-inputroi " << g_inputROIX << " " << g_inputROIY <<"\n"
      "-resize = " << g_resizeImage << " rszfactor = " << g_smallFactor << "\n"
      "-maxmatches = " << g_MaxMatches << " \n"
      "-minmatchdist = " << g_MinMatchDistance << " \n"
      "-resizedisp = " << g_resizeImageForDisplay << " rszfactordisp = " << g_smallFactorForDisplay << "\n"
      "-showpts = " << g_DisplayPoints << "\n"
      "-imgout = " << g_ImageOut << "\n"
      "-imgshow = " << g_ImageShow << "\n"      
      "-txtout = " << g_TxtOut << "\n"
      "-v = " << g_verbose << "\n"
      "-v = " << g_verbose << "\n"
      "-mode = " << g_AppMode << "\n"
      "-dark = " << g_DarkOnLight << "\n"      
      "-ocr = " << g_ocr << "\n"
      << endl;
}

void PrintArgs( const string& imgFileName,
                const vector<string>& vecTplFileNames,
                const string& originalImgFileName,                
                const bool bThresh, const int threshVal,
                const bool ThresholdAdaptive, const int ThresholdAdaptiveBlockSize,
                const float threshcost,
                const bool bNegate,
                const bool nopreproc,
                const int inputROIX, const int inputROIY,                
                const bool roiDetect,
                const int maxmatches,
                const float minmatchdist,
                const bool bResz, const float smallFactor,
                const bool bReszDisp, const float smallFactorDisp,
                const bool bShowpts,
                const bool bImageOut,
                const int outnum,
                const bool savefiximages,
                const bool bImageShow,
                const bool bTxtOut,
                const bool bVerbose,
                const int appMode,
                const int darkOnLight,
                const bool ocr)
{
  if (bVerbose)
  {
	  cout <<
      " Img file name: " << imgFileName << "\n";
    for (int i = 0; i < vecTplFileNames.size(); i++)
      cout << " Tpl file name #: " << i << vecTplFileNames[i] << "\n";
    cout << " original: " << originalImgFileName << "\n";    
    cout <<
      " bThresh: " << bThresh << " threshVal: " << threshVal << "\n" <<
      " ThresholdAdaptive: " << ThresholdAdaptive << " ThresholdAdaptiveBlockSize: " << ThresholdAdaptiveBlockSize << "\n" <<
      " threshcost: " << threshcost << "\n" <<    
      " bNegate: " << bNegate << "\n" <<
      " nopreproc: " << nopreproc << "\n" <<    
      " inputroi " << inputROIX << " " << inputROIY <<"\n"
      " roidetect: " << roiDetect << "\n" <<    
      " maxmatches: " << maxmatches << "\n" <<
      " minmatchdist: " << minmatchdist << "\n" <<
      " bResz: " << bResz << " smallFactor: " << smallFactor << "\n" <<
      " bReszDisp: " << bReszDisp << " smallFactorDisp: " << smallFactorDisp << "\n" <<
      " bshowpts = " << bShowpts << "\n"
      " bImageOut: " << bImageOut << "\n" <<
      " outnum: " << outnum << "\n" <<
      " bsavefiximages: " << savefiximages << "\n" <<    
      " bImageShow: " << bImageShow << "\n" <<
      " bTxtOut: " << bTxtOut << "\n" <<
      " bVerbose: " << bVerbose << "\n" <<
      " mode = " << g_AppMode << "\n" <<
      " dark = " << darkOnLight << "\n" <<
      " ocr = " << ocr << "\n" <<      
      endl;
  }
}

void GenerateRects (const vector<vector<Point> >& results, 
                    vector<Rect>& resultRects,
                    const Rect& roi = Rect(0,0,0,0))
{
  resultRects.reserve(results.size());
  for (int i = 0; i < results.size(); i++)
  {
    Rect rect = boundingRect (results[i]);
    rect.x += roi.x;
    rect.y += roi.y;
    resultRects.push_back(rect);
  }
}

class DetectionResult
{
public:
  typedef vector<vector<Point> >  TypeDetResultsPts;

  DetectionResult ()
  {
    ClearAll();
  };

  ~DetectionResult ()
  {
    ClearAll();
  };

  void ClearAll                   ()
  {
    mResultsPts.clear();
    mResultRects.clear();
    mResultRectsGrouped.clear();
    mResultsCosts.clear();
    mBestResultIdx = -1;
    mResultsScoresNorlized.clear();
  };

  TypeDetResultsPts               mResultsPts;
  vector<Rect>                    mResultRects;
  vector<Rect>                    mResultRectsGrouped;
  vector<float>                   mResultsCosts;  
  int                             mBestResultIdx;
  vector<float>                   mResultsScoresNorlized;
};

void IntersectDetectionGroups (DetectionResult& detResult,
                               const vector<Rect>& vecMasterROIs)
{
  DetectionResult inputDetResults = detResult;
  detResult.ClearAll();
  if (inputDetResults.mResultRects.empty())
    return;  

  // Iterate over vecMasterROIs
  //    Iterate over mResultRects
  //      check if intersection between vecMasterROIs[i] with any mResultRects is > threshold
  //    If yes, add to results.
  int i(0);
  for( vector<Rect>::const_iterator r = vecMasterROIs.begin(); 
         r != vecMasterROIs.end(); 
         r++, i++)
  {
    // Intersect with all detected rects
    int j(0);
    int intersectFoundIndex (-1);
    for( vector<Rect>::const_iterator s = inputDetResults.mResultRects.begin(); 
         s != inputDetResults.mResultRects.end(); 
         s++, j++)
    {
      Rect rs = (*r) & (*s);
      if (rs.area() > g_rectIntersectAreaTh)
      {
        intersectFoundIndex = j;
        break;
      }
    }
    // If any of detected rects overlapped with any of the master ROI's,
    // add that detection to results
    if (intersectFoundIndex >= 0)
    {
      detResult.mResultsPts.push_back (inputDetResults.mResultsPts[intersectFoundIndex]);
      detResult.mResultRects.push_back (inputDetResults.mResultRects[intersectFoundIndex]);
      detResult.mResultsCosts.push_back (inputDetResults.mResultsCosts[intersectFoundIndex]);
      // TODO: This should be later updated
      detResult.mResultsScoresNorlized.push_back (inputDetResults.mResultsScoresNorlized[intersectFoundIndex]);
      
      // TODO: This should be later updated
      if (intersectFoundIndex == inputDetResults.mBestResultIdx)
        detResult.mBestResultIdx = intersectFoundIndex;
      
      // If any detection did intersect, there should be a grouped rect as well
      // Intersect with all grouped rects
      j = 0;
      intersectFoundIndex = -1;
      for( vector<Rect>::const_iterator s = inputDetResults.mResultRectsGrouped.begin(); 
           s != inputDetResults.mResultRectsGrouped.end(); 
           s++, j++)
      {
        Rect rs = (*r) & (*s);
        if (rs.area() > g_rectIntersectAreaTh)
        {
          intersectFoundIndex = j;
          break;
        }
      }
      // If any of grouped rects overlapped with any of the master ROI's,
      // add that detection to results
      if (intersectFoundIndex >= 0)
      {
        detResult.mResultRectsGrouped.push_back (inputDetResults.mResultRectsGrouped[intersectFoundIndex]);
      }
    }
  }
}

int DetectTemplateChamfer ( Mat& imgChamfer, 
                            Mat& tplChamfer, 
                            DetectionResult& detResultChamfer,
                            double& procTime,
                            const int maxMatches,
                            Rect roi = Rect(0,0,0,0))
{
  //double t = (double)getTickCount();
  double t = 0;
  
  Size sz; Point ofs;
  imgChamfer.locateROI(sz, ofs);
  if (g_verbose) cout << "   Chamfer: ROI(x,y,w,h): " << roi.x << "," << roi.y << "," << roi.width << "," << roi.height << "imgROIOfsX: " << ofs.x << endl;
  
    //CV_EXPORTS int chamerMatching( Mat& img, Mat& templ,
    //                               vector<vector<Point> >& results, vector<float>& cost,
    //                               double templScale=1, int maxMatches = 20,
    //                               double minMatchDistance = 1.0, int padX = 3,
    //                               int padY = 3, int scales = 5, double minScale = 0.6, double maxScale = 1.6,
    //                               double orientationWeight = 0.5, double truncate = 20);

  detResultChamfer.mResultsPts.clear();
  detResultChamfer.mResultsCosts.clear();
  std::vector<std::vector<Point> > results;
  std::vector<float> costs;
  int best = chamerMatching(imgChamfer, 
                              tplChamfer, 
                              results, 
                              costs,
                              1.0, //templScale
                              maxMatches,  //20, //maxMatches
                              g_MinMatchDistance, //1.0, //minMatchDistance                              
                              3, //padX
                              3, //padY
                              1, //scales
                              1.0, //minScale
                              1.0, //maxScale
                              g_CMorientationWeight,//0.5, //orientationWeight
                              20 //truncate
                              );
  
    float minCost (FLT_MAX);
    for (int i = 0; i < costs.size(); i++)
    {
      if (costs[i] <= g_threshcost)
      {
        detResultChamfer.mResultsPts.push_back(results[i]);
        detResultChamfer.mResultsCosts.push_back(costs[i]);
      }
      if (costs[i] < minCost)
      {
        minCost = costs[i];
        best = i;
      }
    }
    if (minCost > g_threshcost || detResultChamfer.mResultsCosts.empty())
    {
      best = -1;
      if (g_verbose) cout << "minCost: " << minCost << " above threshold cost: " << g_threshcost << " All rejected.\n";
      return -1;
    }
    
    if( best < 0 )
    {
        if (g_verbose) cout << "not found;\n";
        return -1;
    }
    
    // Generate rectangles from contour points ...
    GenerateRects (detResultChamfer.mResultsPts, detResultChamfer.mResultRects, roi);
    
    // Generate grouped rects from rects
    detResultChamfer.mResultRectsGrouped = detResultChamfer.mResultRects;
    groupRectangles (detResultChamfer.mResultRectsGrouped, g_RectGroupThreshold, g_RectGroupEPS);
    // Group rectangles above removes single detected rectangles
    // Regenerate any single non-overlapping detected rects
    for (int i = 0; i < detResultChamfer.mResultRects.size(); i++)
    {
      Rect curRect (detResultChamfer.mResultRects[i]);
      bool bFound (false);
      for (int j = 0; j < detResultChamfer.mResultRectsGrouped.size(); j++)
      {
        Rect intersect = curRect & detResultChamfer.mResultRectsGrouped[j];
        if (intersect.area() > 0)
        {
          bFound = true;
          break;
        }
      }
      if (!bFound)
        detResultChamfer.mResultRectsGrouped.push_back(curRect);
    }
    
    // Generate normalized scores
    float minval = 0;
    float maxval = 1;
    if (!detResultChamfer.mResultsCosts.empty())
    {
      minval = *(std::min_element(detResultChamfer.mResultsCosts.begin(), detResultChamfer.mResultsCosts.end()));
      maxval = *(std::max_element(detResultChamfer.mResultsCosts.begin(), detResultChamfer.mResultsCosts.end()));
    }
    for (int i = 0; i < detResultChamfer.mResultsCosts.size(); i++)
    {
       float normScore = 1 - // To generate score from cost ... larger is better.
                          (detResultChamfer.mResultsCosts[i] - minval) / ((maxval - minval)+0.0001); // To normalize in 0 - 1 range.
      detResultChamfer.mResultsScoresNorlized.push_back(normScore);
    }
    
    //t = (double)getTickCount() - t;
    //procTime = t*1000/getTickFrequency();
    //printf("Proc Time: %gms\n", procTime);

    return best;
}

void DrawResults (Mat& img,
                  const float scaleFactor,
                  const DetectionResult& detResult,
                  const Scalar color,
                  const int lineThickness)
{
  int t(0);
  try
  {
    for( vector<Rect>::const_iterator r = detResult.mResultRects.begin(); 
           r != detResult.mResultRects.end(); 
           r++, t++)
    {
        Point center;
        int radius;
        
        center.x = cvRound((r->x + r->width*0.5)*scaleFactor);
        center.y = cvRound((r->y + r->height*0.5)*scaleFactor);
        radius = cvRound((r->width + r->height)*0.25*scaleFactor);
        circle( img, center, radius, color, lineThickness, 8, 0 );

        if (g_verbose) cout << "Match: " << t << " of " << detResult.mResultsCosts.size() << "Display Centroid: " << center;
        if (detResult.mResultsCosts.size() > t)
          if (g_verbose) cout << " Cost: " << detResult.mResultsCosts[t] << " Score: " << detResult.mResultsScoresNorlized[t];
        if (g_verbose) cout << endl;
    }
    if (detResult.mBestResultIdx >= 0 && detResult.mBestResultIdx < detResult.mResultsCosts.size())
      if (g_verbose) cout << endl << "Best Match: " << detResult.mBestResultIdx << " of " << detResult.mResultsCosts.size() << " Cost: " << detResult.mResultsCosts[detResult.mBestResultIdx] << " Score: " << detResult.mResultsScoresNorlized[detResult.mBestResultIdx] << endl;
  }
  catch ( ... )
  {
    if (g_verbose) cout << "Exception caught in DrawResults" << endl;
  }

  if (g_verbose) cout << endl;
  t = 0;
  for( vector<Rect>::const_iterator r = detResult.mResultRectsGrouped.begin(); 
         r != detResult.mResultRectsGrouped.end(); 
         r++, t++)
  {
      Point center;
      center.x = cvRound((r->x + r->width*0.5)*scaleFactor);
      center.y = cvRound((r->y + r->height*0.5)*scaleFactor);
      rectangle( img, *r, color, lineThickness, 8, 0 );
      if (g_verbose) cout << "Grouped Rect: " << t << " of " << detResult.mResultRectsGrouped.size() << "Display Centroid: " << center << endl;
  }
}


int ProcessCLArgs ( int argc, char** argv, vector<string>& vecTemplateNames )
{
    
  // Process cmd line args
  for( int i = 1; i < argc; i++ )
  {
    if( strcmp(argv[i], "-negate") == 0 )
      g_Negate = true;
    if( strcmp(argv[i], "-nopreproc") == 0 )
      g_nopreproc = true;      
    if( strcmp(argv[i], "-roidetect") == 0 )
      g_roiDetect = true;
    else if( strcmp(argv[i], "-imgout") == 0 )
      g_ImageOut = true;
    else if( strcmp(argv[i], "-savefiximages") == 0 )
      g_savefiximages = true;
    else if( strcmp(argv[i], "-imgshow") == 0 )
      g_ImageShow = true;
    else if( strcmp(argv[i], "-txtout") == 0 )
      g_TxtOut = true;
    else if( strcmp(argv[i], "-v") == 0 )
      g_verbose = true;
    else if( strcmp(argv[i], "-dark") == 0 )
      g_DarkOnLight = true;
    else if( strcmp(argv[i], "-showpts") == 0 )
      g_DisplayPoints = true; 
    else if( strcmp(argv[i], "-ocr") == 0 )
      g_ocr = true;     
    else if( strcmp(argv[i], "-outnum") == 0 )
	  {        
	  	if(sscanf(argv[++i], "%d", &g_outnum) != 1)
	  	{
        cout << "Error reading in outnum param: " << g_outnum << endl;
	  		help ();
	  		return -1;
	  	}
	  }
    else if( strcmp(argv[i], "-thresh") == 0 )
	  {
      g_Threshold = true;
	  	if(sscanf(argv[++i], "%d", &g_ThresholdVal) != 1)
	  	{
        cout << "Error reading in thresh param: " << g_ThresholdVal << endl;
	  		help ();
	  		return -1;
	  	}
	  }
    else if( strcmp(argv[i], "-threshadaptive") == 0 )
	  {
      g_ThresholdAdaptive = true;
	  	if(sscanf(argv[++i], "%d", &g_ThresholdAdaptiveBlockSize) != 1)
	  	{
        cout << "Error reading in adaptive thresh param block size: " << g_ThresholdAdaptiveBlockSize << endl;
	  		help ();
	  		return -1;
	  	}
	  }
    else if( strcmp(argv[i], "-threshcost") == 0 )
	  {        
	  	if(sscanf(argv[++i], "%f", &g_threshcost) != 1)
	  	{
        cout << "Error reading in thresh param: " << g_threshcost << endl;
	  		help ();
	  		return -1;
	  	}
	  }      
    else if( strcmp(argv[i], "-resizedisp") == 0 )
	  {
      g_resizeImageForDisplay = true;
	  	if(sscanf(argv[++i], "%f", &g_smallFactorForDisplay) != 1)
	  	{
        cout << "Error reading in resize factor param for display: " << g_smallFactorForDisplay << endl;
	  		help ();
	  		return -1;
	  	}
	  }
    else if( strcmp(argv[i], "-resize") == 0 )
	  {
      g_resizeImage = true;
	  	if(sscanf(argv[++i], "%f", &g_smallFactor) != 1)
	  	{
        cout << "Error reading in resize factor param: " << g_smallFactor << endl;
	  		help ();
	  		return -1;
	  	}
	  }
    else if( strcmp(argv[i], "-maxmatches") == 0 )
	  {
	  	if(sscanf(argv[++i], "%d", &g_MaxMatches) != 1)
	  	{
        cout << "Error reading in maxmatches param: " << g_MaxMatches << endl;
	  		help ();
	  		return -1;
	  	}
	  }
    else if( strcmp(argv[i], "-minmatchdist") == 0 )
	  {
	  	if(sscanf(argv[++i], "%f", &g_MinMatchDistance) != 1)
	  	{
        cout << "Error reading in minmatchdist param: " << g_MinMatchDistance << endl;
	  		help ();
	  		return -1;
	  	}
	  }
    else if( strcmp(argv[i], "-tpl") == 0 )
	  {
      string tplName = string (argv[++i]);
	  	if(tplName.empty())
	  	{
        cout << "Error reading in template param: " << tplName << endl;
	  		help ();
	  		return -1;
	  	}
      vecTemplateNames.push_back(tplName);
	  }
    else if( strcmp(argv[i], "-original") == 0 )
	  {
      g_originalImgFileName = string (argv[++i]);
	  	if(g_originalImgFileName.empty())
	  	{
        cout << "Error reading in original image param: " << g_originalImgFileName << endl;
	  		help ();
	  		return -1;
	  	}      
	  }
    else if( strcmp(argv[i], "-inputroi") == 0 )
	  {
	  	if(sscanf(argv[++i], "%d", &g_inputROIX) != 1)
	  	{
        cout << "Error reading in input roi x param: " << g_inputROIX << endl;
	  		help ();
	  		return -1;
	  	}
      if(sscanf(argv[++i], "%d", &g_inputROIY) != 1)
	  	{
        cout << "Error reading in input roi y param: " << g_inputROIY << endl;
	  		help ();
	  		return -1;
	  	}
	  }    
    else if( strcmp(argv[i], "-mode") == 0 )
	  {        
	  	if(sscanf(argv[++i], "%d", &g_AppMode) != 1)
	  	{
        cout << "Error reading in mode param: " << g_AppMode << endl;
	  		help ();
	  		return -1;
	  	}
	  }
  }
  
  PrintArgs (g_imgFileName, 
             vecTemplateNames,
             g_originalImgFileName,
             g_Threshold, g_ThresholdVal,
             g_ThresholdAdaptive, g_ThresholdAdaptiveBlockSize,
             g_threshcost,
             g_Negate,
             g_nopreproc,
             g_inputROIX, g_inputROIY,
             g_roiDetect,
             g_MaxMatches,
             g_MinMatchDistance,
             g_resizeImage, g_smallFactor,
             g_resizeImageForDisplay, g_smallFactorForDisplay,
             g_DisplayPoints,
             g_ImageOut, g_outnum, g_savefiximages, g_ImageShow,
             g_TxtOut,
             g_verbose,
             g_AppMode, g_DarkOnLight, g_ocr);            

  return 0;
}

void ReadImage (Mat& img, const char* imgFileName, const int flags)
{
  img = imread(imgFileName, flags);
  if (img.rows <= 0 || img.cols <= 0)
  {
    throw std::exception ("imread failure");
  }
}

void ProcessTemplates (vector<string>& vecTemplateNames, 
                       vector<Mat>& vecTemplateMats)
{
    //////////////////
    // Template(s)
    // No processing on templates for now
    vecTemplateMats.reserve(vecTemplateNames.size());
    for (int i = 0; i < vecTemplateNames.size(); i++)
    {      
      Mat tpl;
      ReadImage (tpl, vecTemplateNames[i].c_str(), 0);
      vecTemplateMats.push_back(tpl.clone());
    }
    if (g_resizeImage)
    {
      for (int i = 0; i < vecTemplateMats.size(); i++)
      {
        cv::Size szSmall = cv::Size(vecTemplateMats[i].size());
        szSmall.width = szSmall.width*g_smallFactor;
        szSmall.height = szSmall.height*g_smallFactor;
        resize(vecTemplateMats[i], vecTemplateMats[i], szSmall);
      }
    }
    for (int i = 0; i < vecTemplateMats.size(); i++)
      Canny(vecTemplateMats[i], vecTemplateMats[i], 5, 50, 3);
}


void ReadAndProcessImage (string& imgOutFileName,
                          Mat& img,
                          Mat& imgSmall,
                          Mat& imgOrig)
{
            
    /////////////////
    // Input Image
    ///////        
    char imROIFNameBuff [1024];
    string extStr (".png");    
    sprintf(imROIFNameBuff,"%s_out_%d%s",g_imgFileName.c_str(), g_outnum, extStr.c_str());
    imgOutFileName = string(imROIFNameBuff);
        
    // Input image read in 
    ReadImage (img, g_imgFileName.c_str(), 0);
    imgOrig = img.clone();

    //if (!g_originalImgFileName.empty() &&
    //    0 != g_originalImgFileName.compare (""))
    //{
    //  // Load original image as well. This will be used to crop
    //  // final text candidate region(s)
    //  // Image read in gray-scale mode.
    //  // Output cropped images will be in gray-scale mode as well.
    //  imgOrig = imread(g_originalImgFileName.c_str(), 0);
    //}
    
    // Resizing should be done before thresholding
    if (g_resizeImage)
    {
      cv::Size szSmall = cv::Size(img.size());
      szSmall.width = szSmall.width*g_smallFactor;
      szSmall.height = szSmall.height*g_smallFactor;
      if (!g_nopreproc)
        resize(img, img, szSmall);
    }
    
    // Thresholding and negation only done on input image
    // Template is assumed to be already thresholded and negated.
    if (g_Threshold || g_ThresholdAdaptive)
    {
      int threshType (THRESH_BINARY_INV);
      if (!g_Negate)
        threshType = THRESH_BINARY;
      if (!g_nopreproc)
      {
        if (g_ThresholdAdaptive)
        {
          adaptiveThreshold (img, img, 
                           g_ThresholdedImgMaxVal,
                           ADAPTIVE_THRESH_GAUSSIAN_C,
                           threshType,
                           g_ThresholdAdaptiveBlockSize, //,45);
                           0);
        }
        else
          threshold (img, img, g_ThresholdVal, g_ThresholdedImgMaxVal, threshType);
      }
    }
    
    Mat cimg;
    //Mat cimgEdge;
    cvtColor(img, cimg, CV_GRAY2BGR);
    
    // Smoothing if needed ...
    //Mat imgSmooth, cimgSmooth;
    ////bilateralFilter (img, imgSmooth, 0, g_bilatfiltSigmaColor, g_bilatfiltSigmaSp); cvtColor(imgSmooth, cimgSmooth, CV_GRAY2BGR);
    ////Canny(imgSmooth, imgSmooth, 5, 50, 3); cvtColor(imgSmooth, cimgEdge, CV_GRAY2BGR);

    // Resizing for display only ...    
    if (g_resizeImageForDisplay)
    {
      cv::Size szSmall = cv::Size(img.size());
      szSmall.width = szSmall.width*g_smallFactorForDisplay;
      szSmall.height = szSmall.height*g_smallFactorForDisplay;
      
      resize(cimg, imgSmall, szSmall);
    }
    else
      imgSmall = cimg.clone();
    
    if (!g_nopreproc)
    {
      //double t = (double)getTickCount();
      Canny(img, img, 5, 50, 3); //cvtColor(img, cimgEdge, CV_GRAY2BGR);
    }
   
}

std::string GenerateOutputName (const std::string& baseFileName, // g_imgFileName
                                const std::string& outTypeStr, 
                                const int outnum, // g_outnum
                                const std::string& outExtStr)
{
  char charBuffer [1024];
  sprintf(charBuffer,"%s_%s_%d%s",baseFileName.c_str(), outTypeStr.c_str(), outnum, outExtStr.c_str());
  return std::string(charBuffer);
}

bool IsFixTextMode ()
{
  // TODO: CAUTION: Depends on arguments.
  return g_outnum > 0;
}

void DetectMultiTemplate (vector<Mat>& vecTemplateMats,
                          Mat& img, 
                          Mat& imgOriginal,
                          vector<DetectionResult>& vecDetResults,
                          vector<Rect>& vecROIsFirstTpl)
{
    // Iterate over all templates and use chamfer matching to 
    // locate each template in the image    
    vector<double> vecProcTimes;
    vecDetResults.reserve(vecTemplateMats.size());
    vecProcTimes.reserve(vecTemplateMats.size());
    
    Rect fullImageRect (0,0,img.cols, img.rows);
    DetectionResult detResFirstTpl;    
    vector<string> vecImnamesFirstTpl;
    
    ofstream ofsFixes;
    ofstream ofsFixTxts;
    
    for (int i = 0; i < vecTemplateMats.size(); i++)
    {
      if (g_verbose) cout << "Match template #: " << i+1 << " of " << vecTemplateMats.size() << endl;
      DetectionResult detResult;
      double procTime;
      
      if (i == 0)
      {
        // Assuming 0th template is for the stable target (fixes)
        DetectTemplateChamfer (img, vecTemplateMats[i], detResFirstTpl, procTime, g_MaxMatches );
        if (!detResFirstTpl.mResultRectsGrouped.empty())
          vecDetResults.push_back(detResFirstTpl);
        
        vecProcTimes.push_back(procTime);

        // Generate ROI's based on first template detection
        vecROIsFirstTpl.reserve (detResFirstTpl.mResultRectsGrouped.size());
        vecImnamesFirstTpl.reserve (detResFirstTpl.mResultRectsGrouped.size());

        if (g_TxtOut && // If text output is requested AND
            !detResFirstTpl.mResultRectsGrouped.empty()) // We have some detection(s)
        {
          // Generate _fixes.txt file
          //Write out in txt file as well

          std::string txtOutFileName = GenerateOutputName (g_imgFileName, "fixes", g_outnum, ".txt");
          
          if (g_verbose) cout << "Writing txt: " << txtOutFileName << endl;
          ofsFixes.open(txtOutFileName.c_str(), ios_base::trunc);
          
          // Number of fixes detected
          ofsFixes << detResFirstTpl.mResultRectsGrouped.size() << endl;
          
          if (g_savefiximages)
          {
            // Generate _fixtexts.txt file
            // This will have the names of ROI images for fix type text detection
            std::string txtOutFileName = GenerateOutputName (g_imgFileName, "fixtexts", g_outnum, ".txt");
            if (g_verbose) cout << "Writing fixes txt: " << txtOutFileName << endl;
            
            ofsFixTxts.open(txtOutFileName.c_str(), ios_base::trunc);
            
            // Number of fixes detected
            ofsFixTxts << detResFirstTpl.mResultRectsGrouped.size() << endl;
          }
        }
        
        int t(0);
        for( vector<Rect>::const_iterator r = detResFirstTpl.mResultRectsGrouped.begin(); 
         r != detResFirstTpl.mResultRectsGrouped.end(); 
         r++, t++)
        {
          if (g_verbose) cout << "  inner template #: " << t+1 << " of " << detResFirstTpl.mResultRectsGrouped.size() << endl;
          
          // Expand the rect to form ROI
          Rect roi = *r;
          if (g_fixIsFixText)
          {
            // In this case, the detection is one of the fix-text (level-2)
            // detections. 
            roi.x -= (r->width*g_FixTextRect2ROIExpX);
            roi.y -= (r->height*g_FixTextRect2ROIExpY);
            roi.width += (r->width*g_FixTextRect2ROIExpX)*2;
            roi.height += (r->height*g_FixTextRect2ROIExpY)*2;            
          }
          else
          {
            roi.x -= (r->width*g_Rect2ROIExpX);
            roi.y -= (r->height*g_Rect2ROIExpY);
            roi.width += (r->width*g_Rect2ROIExpX)*2;
            roi.height += (r->height*g_Rect2ROIExpY)*2;            
          }
          
          if (g_savefiximages)
          {            
            Mat roiImg;
            if (g_cropOutFromOriginal)
            {
              // Also, if input ROI is provided inside the original image,
              // crop the image from that
              if (g_inputROIX >= 0 && g_inputROIY >= 0)
              {
                roi.x += g_inputROIX;
                roi.y += g_inputROIY;
              }
              fullImageRect = Rect (0,0,imgOriginal.cols, imgOriginal.rows);
              roi &= fullImageRect;
              roiImg = Mat (imgOriginal, roi);
            }
            else
            {
              fullImageRect = Rect (0,0,img.cols, img.rows);
              roi &= fullImageRect;
              roiImg = Mat (img, roi);
            }
            std::string imROIFName;
            imROIFName = GenerateOutputName (g_imgFileName, "fix", t, ".png");                          
            if (g_verbose) cout << "saving image: " << imROIFName << endl;
            imwrite (imROIFName.c_str(), roiImg);
            vecImnamesFirstTpl.push_back(imROIFName);            
            
            if (g_TxtOut)
            {
              // ROI image file name in _fixtexts.txt
              ofsFixTxts << imROIFName.c_str() << endl;
            }
          }
          if (g_TxtOut)
          {
            // x y location of centroid of detected fix in _fixes.txt
            ofsFixes << cvRound(r->x + 0.5f*r->width) << " " << cvRound(r->y + 0.5f*r->height) << " ";
            // ROI in format: x y width heigh in _fixes.txt on the same line
            ofsFixes << roi.x << " " << roi.y << " " << roi.width << " " << roi.height;
            // new line
            ofsFixes << endl;
          }

          roi &= fullImageRect;
          vecROIsFirstTpl.push_back(roi);

        }
        
        if (g_TxtOut)
        {
          ofsFixes.close();
          if (g_savefiximages)
            ofsFixTxts.close();
        }
      }
      else
      {
        // Iterate over all ROI's ...
        int t(0);
        for( vector<Rect>::const_iterator r = vecROIsFirstTpl.begin(); 
             r != vecROIsFirstTpl.end(); 
             r++, t++)
        {
          if (g_roiDetect)
          {
            // ROI-based detection
            // Genearte image with roi
            Mat imgcl = img.clone();
            Mat roiImage;
            
            if (g_savefiximages)
            {
              roiImage = imread(vecImnamesFirstTpl[t].c_str(), 0);  
            }
            else
            {
              roiImage = imgcl(*r);//img(*r);
            }
            DetectionResult detResult;
            DetectTemplateChamfer (roiImage, vecTemplateMats[i], detResult, procTime, 3/*g_MaxMatches*/, *r );
            if (g_ImageShow)
            {
              if (g_verbose) cout << "Showimg roiImage: " << i << endl;
              imshow("imgROI", roiImage);
              waitKey(-1);
            }
          }
          else
          {
            // First detect, then reject
            if (-1 != DetectTemplateChamfer (img, vecTemplateMats[i], detResult, procTime, g_MaxMatches ))
            {
              // Then reject detections that dont intersect with any of the ROI's
              IntersectDetectionGroups (detResult, vecROIsFirstTpl);
            }
          }
          if (!detResult.mResultRectsGrouped.empty())
            vecDetResults.push_back (detResult);
          vecProcTimes.push_back (procTime);          
        }
      }
    }
}

void DrawResults (const vector<DetectionResult>& vecDetResults,
                  const vector<Rect>& vecROIsFirstTpl,
                  Mat& imgSmall)
{

    ///////////////////////////
    // Draw all results
    ///////////////////
    
    for (int i = 0; i < vecDetResults.size(); i++)
    {
      if (g_verbose) cout << "Display result#: " << i+1 << " of " << vecDetResults.size() << endl;
      Scalar color = Scalar( rng.uniform(0, 255), rng.uniform(0,255), rng.uniform(0,255) );
      int lineThickness = (vecDetResults.size()-i)*3;
      DrawResults (imgSmall, g_smallFactorForDisplay, vecDetResults[i], color, lineThickness);
    }
    // Draw all first template detections as rects
    int t(0);
    for( vector<Rect>::const_iterator r = vecROIsFirstTpl.begin(); 
             r != vecROIsFirstTpl.end(); 
             r++, t++)
    {
      Scalar color = Scalar( rng.uniform(0, 255), rng.uniform(0,255), rng.uniform(0,255) );
      int lineThickness = 2;
      rectangle( imgSmall, *r, color, lineThickness, 8, 0 );
    }
}


int main( int argc, char** argv )
{
  // Memory leaks check
  //_CrtSetDbgFlag ( _CRTDBG_ALLOC_MEM_DF | _CRTDBG_LEAK_CHECK_DF );
  //_CrtSetBreakAlloc(466);

  if (argc < 2)
  {
    help();
    return 0;
  }  
  else
    g_imgFileName = string (argv[1]);
  
  vector<string> vecTemplateNames;
  vector<Mat> vecTemplateMats;
  
  int retVal = ProcessCLArgs (argc, argv, vecTemplateNames);
  if ( 0 != retVal )
    return retVal;
  
  if (0 == g_AppMode || 1 == g_AppMode)
  {
    try
    {
      ProcessTemplates (vecTemplateNames, vecTemplateMats);
    }
    catch (std::exception& e)
    {
      std::cout << "Error in reading template(s): " << e.what() << std::endl;
      return -1;
    }

    string imgOutFileName;
    Mat img;
    Mat imgSmall;
    Mat imgOriginal;
    try
    {
    ReadAndProcessImage (imgOutFileName, // Name of output image gets filled in
                         img, // img filled in from g_imgFileName
                         imgSmall,  // imgSmall filled in if needed for display
                         imgOriginal); // imgOriginal filled in if needed to crop out final images
    }
    catch (std::exception& e)
    {
      std::cout << "Error in reading images: " << e.what() << std::endl;
      return -1;
    }

    //// 
    // Generate derived parameters
    g_fixIsFixText = IsFixTextMode ();
    g_cropOutFromOriginal = imgOriginal.cols > 0 && imgOriginal.rows > 0;
    
    vector<DetectionResult> vecDetResults;
    vector<Rect> vecROIsFirstTpl;
    DetectMultiTemplate (vecTemplateMats, img, imgOriginal, vecDetResults, vecROIsFirstTpl);

    DrawResults (vecDetResults, vecROIsFirstTpl, imgSmall);
    
    if (g_ImageOut && // If output image is requested AND
        !vecDetResults.empty()) // we have some detection results
    {
      imwrite (imgOutFileName, imgSmall);
    }

    if (g_ImageShow)
    {
      imshow("imgSmall", imgSmall);
      waitKey();
    }
  }
  else if (2 == g_AppMode)
  {
    string imgOutFileNameBase;
    char imROIFNameBuff [1024];
    sprintf(imROIFNameBuff,"%s_out_text%d_",g_imgFileName.c_str(), g_outnum);
    imgOutFileNameBase = string(imROIFNameBuff);

    mainTextDetection (g_imgFileName.c_str(), imgOutFileNameBase.c_str(), g_DarkOnLight);
  }
  else
  {
    cout << "Unrecognized app mode param: " << g_AppMode << endl;
    help ();
    return -1;
  }

  if (g_ocr)
  {
    // OCR Engine
    OCREngine ocrEngine (g_OCRLibPath);
    if (!ocrEngine.InitStatus())
    {
      cout << "OCR init failed from path: " << g_OCRLibPath << endl;
    }
    else
    {
      cout << "OCR inited from path: " << g_OCRLibPath << endl;
    }
    
    // Image
    string imgOutFileName;
    Mat img;
    Mat imgSmall;
    Mat imgOriginal;
    ReadAndProcessImage (imgOutFileName, // Name of output image gets filled in
                         img, // img filled in from g_imgFileName
                         imgSmall,  // imgSmall filled in if needed for display
                         imgOriginal); // imgOriginal filled in if needed to crop out final images
    
    string ocrOutFileName;
    char ocrOutFileNameBuff [1024];
    sprintf(ocrOutFileNameBuff,"%s_out_ocr%d.txt",g_imgFileName.c_str(), g_outnum);
    ocrOutFileName = string(ocrOutFileNameBuff);

    cout << "ocrOutFileName: " << ocrOutFileName << endl;
    //ocrEngine.OCRImage (ocrOutFileName, img);
  }
  
  // Mem leak report
  //_CrtDumpMemoryLeaks();

  return 0;
}
