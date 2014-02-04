# charts are prepared by finding px, py on gimp, then running geo program on it, then converting to rgb, then warp to WG84, then convert back to pct, then rectify with grass gis, then converting to rgb then regular tiling, and database

for file in BaltimoreWashingtonHeli9Front BostonHeli6Front ChicagoHeli6Front Dallas-FtWorthHeli5Front DetroitHeli1 GulfCoastHel-WAC27 HoustonHeli7 LosAngelesHeli9 NewYorkHeli10Front GrandCanyon; do
    sqlite3 maps.oth.db "update files set info=\"$file\" where name like \"%$file%\""
    if [[ -f final/$file.zip ]]; then rm final/$file.zip; fi
    zip -T -q -1 final/$file.zip `sqlite3 maps.oth.db "select name from files where name like \"%$file%\""`
done
