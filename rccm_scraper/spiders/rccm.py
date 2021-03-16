import scrapy

class RccmSpider(scrapy.Spider):
    name = 'rccm'

    def start_requests(self):
        for id_number in list(range(
            self.settings.getint('MIN_ENTITY_ID'), self.settings.getint('MAX_ENTITY_ID') + 1)):
            yield scrapy.Request(
                url = 'https://rccm.cd/rccm/rest/entities/ent.{office_code}.{entity_type_code}.{id_number}' \
                    .format(
                        office_code = self.settings.get('OFFICE_CODE'),
                        entity_type_code = self.settings.get('ENTITY_TYPE_CODE'),
                        id_number = id_number),
                headers = {'Authorization': 'Bearer {bearer_token}' \
                    .format(bearer_token = self.settings.get('BEARER_TOKEN'))})
    
    def parse(self, response):
        if response.json()['details']:
            response.json()['sourceUrl'] = response.url
            yield response.json()