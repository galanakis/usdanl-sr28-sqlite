#USDA nutritional database to SQLite


This script downloads and import the ASCII file version of the USDA National Nutrient Database (Release SR-28) into an sqlite3 database.

The schema strictly followss the USDA reference documentation. The input data are freely available and can be downloaded in <https://www.ars.usda.gov/northeast-area/beltsville-md/beltsville-human-nutrition-research-center/nutrient-data-laboratory/docs/sr28-download-files/>

## Usage
Just run the script

```sh
$ ./import_usdanlsr28.sh
```
After the script (quietly) finishes, you will have the file usdanlrs28.sql3 in the working
directory.

## Future plans

I plan to introduce a simple web interface to present the nutritional information in a pretty way.

## License

The project is covered by the MIT license.

## Attribution
I started adapting <https://github.com/alyssaq/usda-sqlite>, but eventually I rewrote everything in order to follow the documentation. I also got some ideas from <https://github.com/nmaster/usdanl-sr28-mysql> (mostly the name of the project).
