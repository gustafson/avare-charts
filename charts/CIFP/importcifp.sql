create table procedures(Airport varchar(4), AppType varchar(8), Runway varchar (5), ChangeCycle int, InitialCourse varchar(128), InitialAltitude varchar(128), FinalCourse varchar(128), FinalAltitude varchar(128), MissedCourse varchar(128), MissedAltitude varchar(128));

.separator "|"
.import approaches.txt procedures
