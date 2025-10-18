# JSONConvert

This simple program is just a demo that converts a sample database into a JSON structure and saves it to a file. It uses multiple JSON libraries to compare how they're used and was built to add to the discussion on JSON at the [October 2025 ODUG meeting](https://odug.org/events/2025-10/).

## Project

This was built with Delphi 13 using the VCL framework but could likely be compiled in Delphi 11 or 12.

## Database

The included SQLite database is a copy of the Chinook sample database that can be found many places around the web.

## Dependency

There are four JSON libraries used (more might be added later):

- System.JSON: this is built in the modern versions of Delphi. 
- [EasyJson](https://github.com/tinyBigGAMES/EasyJson) from [tinyBigGAMES](https://tinybiggames.com/)
- [McJson](https://github.com/hydrobyte/McJSON) from [HydroByte](https://hydrobyte.com.br/site/)
- [VSoft.YAML](https://github.com/VSoftTechnologies/VSoft.YAML) from [VSoft Technologies](https://www.finalbuilder.com/)

All except for the first one will be needed to be downloaded (cloned from Github) separately as sub-folders under the main project; use the default name of the repository as the folder name (i.e "EasyJson" for the EasyJson project).

## Note ##

The following JSON libraries will not be supported in this project:

- [JsonTools](https://github.com/sysrpl/JsonTools): designed for Lazarus, generates compiler errors and several warnings when compiling in Delphi 13.
- [jLkJson](https://sourceforge.net/projects/lkjson/): I do not want to deal with manually downloading zip files from SourceForge.
- [JsonDataObjects](https://github.com/ahausladen/JsonDataObjects): class name conflicts with Delphi's System.JSON.
- [Json4Delphi](https://github.com/MaiconSoft/json4delphi): class name conflicts with Delphi's REST.JSON.
- [Grijjy.Bson](https://github.com/grijjy/GrijjyFoundation): over-complicated; documentation missing parts, doesn't handle Unicode characters by default.
- [Neslib.Json](https://github.com/neslib/Neslib.Json): class name conflicts with Delphi's System.JSON.

_While it's true that by simply putting the various "Export" procedures into their own units I could quite easily avoid name conflicts and include more libraries, this was intended to be a quick and simple project to demonstrate differences between various libraries, not an exhaustive comparison of all available. For that, see the [TestJSON](https://github.com/hydrobyte/TestJSON) repository._