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

## Endpoints, requests and responses

The most useful API endpoint for scraping is located at `https://rccm.cd/rccm/rest/entities/`. When followed by an entity ID (see below), it returns a single 'entity' from the RCCM database in JSON format.

## Entity ID format

The API serves up two distinct entity types: *acteurs économiques* (code `act`) and *personnes naturelles* (`pna`). Entities are also divided among RCCM offices: Kinshasa/Gombe (`kng`), Kinshasa/Matete (`knm`), Lubumbashi (`lsh`) and Kisangani (`kis`). Together with an ID number, these attributes form a unique ID of the form `ent.[office code].[entity code].[ID number]`; for example, `ent.kng.act.45403`. ID numbers are roughly but not strictly sequential: iterating through them seems to result in all entities being captured, but there are small gaps. As of 16 March 2021, the highest valid ID numbers for each entity type and office appeared to be as follows.

| Entity type | Office | Highest ID number |
|-------------|--------|-------------------|
| act         | kng    | TBD               |
| act         | knm    | TBD               |
| act         | lsh    | TBD               |
| act         | kis    | TBD               |
| pna         | kng    | TBD               |
| pna         | knm    | TBD               |
| pna         | lsh    | TBD               |
| pna         | kis    | TBD               |

## Authentication

Basic details about entities can be accessed through the API without authentication, but in order to retrieve all the information available it's necessary to include a bearer token from a registered and logged-in RCCM user in the `Authorization` header for each request; for example, `Authorization: Bearer YjpDDhXfUvylwBOliCMz`. This token can be found by monitoring requests using your browser's developer tools when logged in.