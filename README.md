# Avare Chart Creation Scripts

This repo is used to create charts for
[Avare](https://play.google.com/store/apps/details?id=com.ds.Avare&hl=en_US).

Additional details can be found at the [Avare homepage](https://www.apps4av.com/).

Questions should be addressed to the Avare mailing list:
apps4av-forum@googlegroups.com.  Pete Gustafson is the primary contact
from Apps4Av.

## Building the charts

Currently the build process is not well documented.  We are working to
 improve that.  If you want to try to build charts, start with this:

```console
cd charts
make
```

And follow the instructions.

Note the chart build system is optimized for speed to be run on a
modern Linux workstation with lots of RAM.  Whenever possible, RAM is
used to minimize disk writes.  The charts are currently assembled for
Avare on a cluster of five machines which each have 128GB RAM each.
The lower limit of the machine capabilities has not recently been
examined, but at least 32 GB RAM is suggested.  The disk space
required for a complete build is approximately 300GB.  Individual
charts can be built with much less disk space.

## Dependencies

Assembling proper charts requires at least the following dependencies:

-   [gdal](gdal.org)
-   [Imagemagick](https://imagemagick.org/index.php) linked to libwebp
-   libwebp
-   optipng
-   python
-   [Slurm](https://slurm.schedmd.com/documentation.html) (for job submission/management)

Building charts without slurm workload management is likely possible but is not supported.

## Things to know

-   There are likely issues with building from scratch as this is not frequently done
    -   Please report issues so that they may be fixed

## Bugs

-   Please report bugs at https://github.com/gustafson/avare-charts/issues
