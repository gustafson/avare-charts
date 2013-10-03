// Avare - this code is not to be open sourced on request from the author (Faisal Bashir)

/////////////////////////////////////////////////////////////////////////////////
// PlateProcessor.h
/* Copyright 2013 Vision Tech Systems, Inc.
*/
//
// FILENAME : PlateProcessor.h
// AUTHORS  : Faisal Bashir.
//
// DATE     : April 17, 2013
/////////////////////////////////////////////////////////////////////////////////

#ifndef _PLATEPROCESSOR_H
#define _PLATEPROCESSOR_H

#pragma once

// OpenCV
#include <opencv2/imgproc/imgproc.hpp>
#include <opencv2/highgui/highgui.hpp>
#include <opencv2/contrib/contrib.hpp>

// STL
#include <iostream>
#include <fstream>
#include <algorithm>

// TextDetection using Stroke Width Transform
#include "TextDetection.h"

// OCR using Tesseract
#include "OCREngine.h"

//// Part of re-factor. Not done yet.
//// vision
//#include "Image.h"
//#include "BoundingBox.h"
//#include "Region.h"
//#include "Detector.h"
//#include "FixDetector.h"

#endif
