# Avare Chart Creation Scripts

This repo is used to create charts for [Avare](https://play.google.com/store/apps/details?id=com.ds.Avare&hl=en_US).

Additional details can be found at the [Avare homepage](https://apps4av.net/site/).

Questions should be addressed to the Avare mailing list: apps4av-forum@googlegroups.com.  Pete Gustafson is the primary contact from Apps4Av.

## Building the charts

Currently the build process is not well documented.  We are working to improve that.  If you want to try to build charts, start with this:

```console
cd charts
make
```

And follow the instructions.

Note the chart build system is optimized for speed to be run on a modern Linux workstation with lots of RAM.  Whenever possible, RAM is used to minimize disk writes.  The charts are currently assembled for Avare on a cluster of three machines which each have 128GB RAM each.  The lower limit of the machine capabilities has not recently been examined, but at least 32 GB RAM is suggested.  The disk space required for a complete build is approximately 300GB.  Individual charts can be built with much less disk space.

## Dependencies

Assembling proper charts requires at least the following dependencies:

* [gdal](gdal.org) version 2.4 
    * (gdal 3.0 is currently not assembling the charts correctly, hence is not supported)
* [Imagemagick](https://imagemagick.org/index.php) linked to libwebp
* libwebp
* optipng
* python
* [Slurm](https://slurm.schedmd.com/documentation.html) (for job submission/management)

Building charts without slurm workload management is likely possible but is not supported.

## Things to know

* As of the writing of this README file, there are known absolute pathnames which are in place due to problems with gdal 3.0 (which is default on many/most Linux distros at this time).  Hence, a local copy of gdal 2.4 is used on our build cluster. gdal is currently called by absolute path.  **This will break your attempt at building charts.** You will need to update the path to your own install of gdal 2.4.
* **Building all charts from scratch is not yet supported.**  
	* Each cycle build relies on successful completion of the prior build cycle.
	* Building all VFR charts from scratch requires manual download of all charts from the FAA site.  Building subsequent cycles should update properly with less manual intervention.
	* **This issue will not be fixed until the FAA moves sectional charts to a 56 day cycle on [February 25, 2021](https://www.aopa.org/news-and-media/all-news/2020/april/16/vfr-charts-to-go-on-56-day-publication-cycle-in-2021).  It is likely to take an additional cycle past then before support for build-from-scratch will be contemplated.
	* IFR charts can likely be built from scratch in any 56 day IFR cycle (assuming you overcome the issues mentioned above)
