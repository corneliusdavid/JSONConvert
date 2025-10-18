# JSONConvert

This simple program is just a demo that converts a sample database into a JSON structure and saves it to a file. It uses multiple JSON libraries to compare how they're used and was built to add to the discussion on JSON at the [October 2025 ODUG meeting](https://odug.org/events/2025-10/).

## Project

This was built with Delphi 13 using the VCL framework but could likely be compiled in Delphi 11 or 12.

## Database

The included SQLite database is a copy of the Chinook sample database that can be found many places around the web.

## Dependency

There are three JSON libraries used (more might be added later):

- System.JSON: this is built in the modern versions of Delphi. 
- [EasyJson](https://github.com/tinyBigGAMES/EasyJson) from [tinyBigGAMES](https://tinybiggames.com/)
- [McJson](https://github.com/hydrobyte/McJSON) from [HydroByte](https://hydrobyte.com.br/site/)

All except for the first one will be needed to be downloaded (cloned from Github) separately as sub-folders under the main project; use the default name of the repository as the folder name (i.e "EasyJson" for the EasyJson project).
