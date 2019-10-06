from admitad import api, items
import argparse, pdb, mongo

parser = argparse.ArgumentParser()
parser.add_argument("-u", "--client_id", required=True, help="admitad client_id get it on https://developers.admitad.com/ru/apps/")
parser.add_argument("-p", "--client_secret", required=True, help="admitad client_secret get it on https://developers.admitad.com/ru/apps/")
parser.add_argument("-w", "--website", type=int, required=True, help="https://developers.admitad.com/ru/doc/api_ru/methods/advcampaigns/advcampaigns-website-list/")
args = parser.parse_args()

scope = ' '.join(set([items.CampaignsForWebsite.SCOPE]))
admitad = api.get_oauth_client_client(args.client_id, args.client_secret, scope)

col = mongo.db().advcampaigns_for_website
col.remove({})

offset = 0
limit = 100

while True:
    print(f"offset: {offset}, limit: {limit}")
    response = admitad.CampaignsForWebsite.get(args.website, has_tool=['products'], limit=limit, offset=offset)
    campaigns = response['results']
    if len(campaigns) == 0:
        break
    for campaign in campaigns:
        col.insert_one(campaign)
    offset += limit
