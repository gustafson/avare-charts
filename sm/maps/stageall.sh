#!/bin/bash

J=`qsub stagesec.pbs`
J=`qsub -W depend=afterok:${J} stagetac.pbs`
J=`qsub -W depend=afterok:${J} stageifr.pbs`
J=`qsub -W depend=afterok:${J} stageifh.pbs`
J=`qsub -W depend=afterok:${J} pyramids.pbs`
J=`qsub -W depend=afterok:${J} databases.pbs`
