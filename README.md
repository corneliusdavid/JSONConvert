# JSONConvert

This simple program is just a demo that converts a sample database into a JSON structure and saves it to a file. It uses multiple JSON libraries to compare how they're used and was built to add to the discussion on JSON at the [October 2025 ODUG meeting](https://odug.org/events/2025-10/).

## Project

This was built with Delphi 13 using the VCL framework but could likely be compiled in Delphi 11 or 12.

## Database

The included SQLite database is a copy of the Chinook sample database that can be found many places around the web.

## Dependency

There are four JSON libraries used:

- [System.JSON](https://docwiki.embarcadero.com/Libraries/Florence/en/System.JSON): this is built into the modern versions of Delphi.
- [EasyJson](https://github.com/tinyBigGAMES/EasyJson) from [tinyBigGAMES](https://tinybiggames.com/)
- [McJson](https://github.com/hydrobyte/McJSON) from [HydroByte](https://hydrobyte.com.br/site/)
- [VSoft.YAML](https://github.com/VSoftTechnologies/VSoft.YAML) from [VSoft Technologies](https://www.finalbuilder.com/) _(builds YAML, outputs to JSON)_
- [SuperObject](https://github.com/pult/SuperObject.Delphi) from [Vadim Lou](https://github.com/pult) _(puts objects in strange order)_

All except for the first one will be needed to be downloaded (cloned from Github) separately as sub-folders under the main project; use the default name of the repository as the folder name (i.e "EasyJson" for the EasyJson project).

## Note ##

The following JSON libraries are not be supported in this project:

- [JsonTools](https://github.com/sysrpl/JsonTools): designed for Lazarus, generates compiler errors and several warnings when compiling in Delphi 13.
- [jLkJson](https://sourceforge.net/projects/lkjson/): I do not want to deal with manually downloading zip files from SourceForge.
- [JsonDataObjects](https://github.com/ahausladen/JsonDataObjects): class name conflicts with Delphi's System.JSON.
- [Json4Delphi](https://github.com/MaiconSoft/json4delphi): class name conflicts with Delphi's REST.JSON.
- [Grijjy.Bson](https://github.com/grijjy/GrijjyFoundation): over-complicated; documentation missing parts, doesn't handle Unicode characters by default.
- [Neslib.Json](https://github.com/neslib/Neslib.Json): class name conflicts with Delphi's System.JSON.
- [Chimera](https://bitbucket.org/sivv/chimera/src/develop/): class name conflicts with Delphi's REST.JSON.

_While it's true that by simply putting the various "Export" procedures into their own units I could quite easily avoid name conflicts and include more libraries, this was intended to be a quick and simple project to demonstrate differences between various libraries, not an exhaustive comparison of all available. For that, see the [TestJSON](https://github.com/hydrobyte/TestJSON) repository._

## Observations ##

It was interesting learning about the various JSON libraries and their different approaches to building a JSON structure with a variety of data types. They all accomplished the same end result (or nearly the same), but while each of the generated files contained the same raw data, viewing the files in a text editor showed several differences:

- Accented characters were shown as true Unicode characters in most but were "escaped" in the SuperObject library.
- Dates were are quite varied in how they're assigned: 
  - System.JSON assigns dates to Double
  - McJson and EasyJson assign dates to Integer
  - SuperObject uses Long Integer for dates
  - EasyJson creates a standard U.S.-style string with month/day/year.
  - VSoft.YAML treats dates differently depending on how it's assigned; using the generic `AddOrSetValue` method with default parameters, it assigns the date value to Integer but using the `D` property, it creates a string with an ISO8601-formatted string.
- All the generated JSON files had the same order of elements except for SuperObject which, while consistent in it's placement of fields from record to record, was seemingly random in how it decided that order.

Other differences were seen in the actual code needed to build and output the JSON. All but Delphi's System.JSON include their own `SaveToFile` (or similarly named) method for saving the structure to a file.

The amount of code differed a little between the libraries;

- The shortest was VSoft.YAML at 42 lines; it uses Interfaces, eliminating the need for freeing objects manually in try-finally blocks plus it has its own file writer. 
- Next was McJson at 47 lines, freeing only the outer-most object.
- SuperObject and System.JSON were a close match with the former at 52 lines and the latter at 53, both needing a little extra scaffolding for managing objects.
- By far the longest procedure of these tested was EasyJson coming in at 70 lines. This library required me to not only create and free each intermediary object but also to use indexes when adding elements to an array (which I found to be odd; perhaps there's an option I missed...).
    
