#!/bin/bash

[[ -d tiles ]] && rm -fr tiles

## Do TAC separately since it takes the longest by a substantial margin
J1=`qsub stagetac.pbs`
J1=`qsub -W depend=afterok:${J1} pyramids-tac.pbs`

## Do the rest
J1=`qsub stagesec.pbs`
J2=`qsub stageifr.pbs`
J3=`qsub stageifh.pbs`
J4=`qsub stageifal.pbs`
J5=`qsub stageifah.pbs`
J6=`qsub -W depend=afterok:${J1} -W depend=afterok:${J2} -W depend=afterok:${J3} -W depend=afterok:${J4} -W depend=afterok:${J5} pyramids.pbs`
J7=`qsub -W depend=afterok:${J6} databases.pbs`
