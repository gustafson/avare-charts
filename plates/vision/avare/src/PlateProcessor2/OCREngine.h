// Avare - this code is not to be open sourced on request from the author (Faisal Bashir)



/////////////////////////////////////////////////////////////////////////////////
// OCREngine.h
/* Copyright 2013 Vision Tech Systems, Inc.
*/
//
// FILENAME : OCREngine.h
// AUTHORS  : Faisal Bashir.
//
// DATE     : July 3, 2013
/////////////////////////////////////////////////////////////////////////////////

#ifndef _OCRENGINE_H
#define _OCRENGINE_H

#pragma once

#include <tesseract/baseapi.h>
#include <leptonica/allheaders.h>

// OpenCV
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/contrib/contrib.hpp>

class OCREngine
{
public:

                    OCREngine       ()
                                    :mAPIInit(false),
                                    mOCRLibPath ("/usr/src/tesseract-ocr/")
                                    {
                                      Init (mOCRLibPath);
                                    };

                    OCREngine       (const std::string& ocrLibPath)
                                    : mAPIInit(false),
                                    mOCRLibPath (ocrLibPath)
                                    {
                                      Init (mOCRLibPath);
                                    };

                    ~OCREngine      ()
                                    {
                                      ClearAll();
                                    };
  
  int              Init            (const std::string& ocrLibPath)
                                    {
                                      mOCRAPI = new tesseract::TessBaseAPI();
                                      if (NULL == mOCRAPI)
                                      {
                                        fprintf(stderr, "API instance creation failure.\n");
                                        return -1;
                                      }
                                      if (mOCRAPI->Init(ocrLibPath.c_str(), "eng")) // ocrLibPath = "/usr/src/tesseract-ocr/"
                                      {
                                        fprintf(stderr, "API initialization failure.\n");
                                        return -2;
                                      }
                                      mAPIInit = true;
                                      return 0;
                                    };
  
  int               OCRImage        (std::string& outputText,
                                     const cv::Mat& img,                         
                                     cv::Rect& roi = cv::Rect(0,0,0,0),
                                     cv::Mat& outThresholdedImage = cv::Mat());
  
  bool              InitStatus      () const { return mAPIInit; };
  
  std::string       GetOCRLibPath   () const { return mOCRLibPath; };
  void              SetOCRLibPath   (const std::string& ocrLibPath) { mOCRLibPath = ocrLibPath; };
  
protected:
  
  void              ClearAll        ()
                                    {
                                      //if (NULL != mOCRAPI)
                                      {
                                        mOCRAPI->Clear();
                                        mOCRAPI->End();
                                      //  delete mOCRAPI;
                                      }
                                      //mOCRAPI = NULL;
                                    };
  
protected:
  
  // The API object
  tesseract::TessBaseAPI            *mOCRAPI;
  // API init status
  bool                              mAPIInit;
  // OCR lib location ... the parent directory of tessdata
  std::string                       mOCRLibPath;
  

};

int OCREngine::OCRImage (std::string& outputText,
                         const cv::Mat& img,                         
                         cv::Rect& roi,
                         cv::Mat& outThresholdedImage)
{
  if (img.empty())
    return -1;
  
  // TODO: Error check that input image is single channel
  
  if (!InitStatus())
  {
    Init (mOCRLibPath);
    if (!InitStatus())
      return -2;
  }
  
  mOCRAPI->SetImage((unsigned char*)img.data, 
                    img.cols,
                    img.rows, 
                    1, // single channel image only
                    img.step1());
  
  // be aware of tesseract coord systems starting at left top corner!
  if (roi.area() <= 1)
    roi = cv::Rect (0,0,img.cols,img.rows);
  // void 	SetRectangle (int left, int top, int width, int height)
  mOCRAPI->SetRectangle(roi.x, roi.y, roi.width, roi.height);

  // Optional ... Get the internal thresholded image from tesseract
  if (!outThresholdedImage.empty())
  {
    Pix* tessThImage = mOCRAPI->GetThresholdedImage ();
    // Create cv::mat from Pix
    outThresholdedImage = cv::Mat (tessThImage->h, 
                                   tessThImage->w, 
                                   CV_8UC1, // Type should be tied to Pix::channels and Pix::depth
                                   tessThImage->data);
    pixDestroy(&tessThImage);
  }
  
  const char* outText = mOCRAPI->GetUTF8Text();
  //outputText = std::string(outText);

  std::cout << "outputText: " << outText << std::endl;
  
  delete [] outText;
  
  return 0;
}

#endif
