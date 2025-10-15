# JSONConvert

This simple program is just a demo that converts a sample database into a JSON structure and saves it to a file. It uses multiple JSON libraries to compare how they're used and was built to add to the discussion on JSON at the October 2025 meeting of the Oregon Delphi User Group.

## Project

This was built with Delphi 13 using the VCL framework but could likely be compiled in Delphi 11 or 12.

## Database

The included SQLite database is a copy of the Chinook sample database that can be found many places around the web.

## Dependency

There are two JSON libraries used (initially, more later perhaps); the first one is the built in one to modern versions of delphi: System.JSON. The second is [EasyJson](https://github.com/tinyBigGAMES/EasyJson) from [tinyBigGAMES](https://tinybiggames.com/). You will need to add this repository in a subfolder named, `EasyJson`, of the project directory.
