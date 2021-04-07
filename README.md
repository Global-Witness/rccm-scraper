# RCCM scraper

This is a scraper for the Democratic Republic of Congo's (DRC) *Registre de Commerce et du Crédit Mobilier* (RCCM). It makes use of the undocumented API that enables the RCCM website's search interface, which appears to be running on [WildFly](https://www.wildfly.org/).


## Scraper

The scraper is written using the [Scrapy](https://scrapy.org/) framework and is located in the `rccm_scraper` directory. It consists of one very simple 'spider', `rccm`. The following custom Scrapy settings can be used to control it—see below for more details on entity ID formats.

| Setting name     | Description                                    |
|------------------|------------------------------------------------|
| MIN_ENTITY_ID    | The ID number to start requests at             |
| MAX_ENTITY_ID    | The ID number to end requests at               |
| OFFICE_CODE      | The code for the relevant RCCM office          |
| ENTITY_TYPE_CODE | The code for the relevant entity type          |
| BEARER_TOKEN     | A valid bearer token for a logged-in RCCM user |

An even simpler script, `test-ids.sh`, can be used for determining the likely ranges of different ID numbers (see below)—it just submits a series of three-letter search terms to the RCCM website and returns the matching entity IDs.


## Extraction/processing scripts

The shells scripts in this repository beginning with `extract-` can be used to generate CSV files from the scraped JSON data. Each one takes the full set of JSON as standard input (e.g. from `cat data/act/*.jsonl`) and writes a CSV to standard output. They produce files for companies, owners, directors and `personnes physiques`, the latter being a special type of owner (something like a sole trader in UK terminology).


## Follow the Money/Aleph mappings

The `mappings` directory contains four YAML files specifying mappings between the CSV files produced using the `extract-` scripts and the [Follow the Money](https://docs.alephdata.org/developers/followthemoney) entity/relationship schema. These can be used to import the data into [Aleph](https://docs.alephdata.org/).


## Endpoints, requests and responses

The most useful API endpoint for scraping is located at `https://rccm.cd/rccm/rest/entities/`. When followed by an entity ID (see below), it returns a single 'entity' from the RCCM database in JSON format.

Counts of the total numbers of entities of different types in the underlying database can be obtained using the `https://rccm.cd/rccm/rest/entities/dictionaries/stats` endpoint—these can be useful for validating the completeness of any scraped data.


## Authentication

Basic details about entities can be accessed through the API without authentication, but in order to retrieve all the information available it's necessary to include a bearer token from a registered and logged-in RCCM user in the `Authorization` header for each request; for example, `Authorization: Bearer YjpDDhXfUvylwBOliCMz`. This token can be found by monitoring requests using your browser's developer tools when logged in.


## Entity ID format

The API serves up several distinct entity types: *acteurs économiques* (code `act`), *personnes naturelles* (`pna`), *comptes annuels* (`can`), ??? (`sur`) and ??? (`ept`). Entities are also divided among RCCM offices: Kinshasa/Gombe (`kng`), Kinshasa/Matete (`knm`), Lubumbashi (`lsh`), Bukavu (`bkv`), Goma (`gom`), Kisangani (`kis`), Kolwezi (`kwz`), Isiro (`irp`), Mbuji-Mayi (`mjm`) and Kananga (`kga`) at least—there may be others, too. Together with an ID number, these attributes form a unique ID of the form `ent.[office code].[entity code].[ID number]`; for example, `ent.kng.act.45403`. ID numbers are roughly but not strictly sequential: iterating through them seems to result in all entities being captured, but there are small gaps.


## Mapping ID numbers in use

These are the results of an attempt to 'feel out' the ranges of ID numbers currently (March 2021) in use by the RCCM API.


### General principles

* ID numbers are not unique—they can be duplicated between different offices and entity types.
* They seem to start near zero and increase in relatively small increments.

### Approximate ranges

For some offices and types, numbering appears to have jumped forward to start again at 500,000 in late 2020. This is indicated in the table below by dividing the ranges into two 'sequences'.

#### act

| Office | Seq. 1 start | Seq. 1 end | Seq. 2 start | Seq. 2 end |
|--------|--------------|------------|--------------|------------|
| kng    | 0            | 307,131    | 500,000      | ~503k      |
| knm    | 0            | 99,682     | 500,000      | ~501k      |
| lsh    | 0            | ~62k       | 500,000      | ~501k      |
| bkv    | 0            | ~11k       | 500,000      | ~501k      |
| gom    | 0            | ~4k        | 500,000      | ~501k      |
| irp    | 0            | <1k        | 500,000      | ~501k      |
| kis    | 0            | ~3k        | N/A          | N/A        |
| kwz    | ~292k        | ~295k      | 500,000      | ~501k      |
| mjm    | ~97k         | ~98k       | N/A          | N/A        |
| kga    | <1k          | <1k        | 500,000      | <501k      |