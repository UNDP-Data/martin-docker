import mapbox_vector_tile
import httpx
index_url = 'http://localhost:3000/index.json'

if __name__ == '__main__':
    with httpx.Client() as client:
        r = client.get(index_url)
        if not r.status_code == 200:
            print(f'failed to fetch index.json from {index_url}')
            exit(1)
        index_content = r.json()
        for k, v in index_content.items():
            tjson_url = index_url.replace('index', k)
            tjson_r = client.get(tjson_url)
            if not tjson_r.status_code == 200:
                print(f'failed to fetch tilejson from {tjson_url}')
                exit(1)
            tjson_content = tjson_r.json()
            tile_url = tjson_content['tiles'][0]
            root_mvt_url = tile_url.format(z=0, x=0, y=0)
            mvt_r = client.get(root_mvt_url)
            if not mvt_r.status_code == 200:
                print(f'failed to fetch root tile from {root_mvt_url}')
                exit(1)
            decoded_data = mapbox_vector_tile.decode(mvt_r.content)
            for lname, l in decoded_data.items():
                for feat in l['features']:
                    print(feat['id'], feat['properties'])
                    break



