## Custom Workshop Content (maps etc)

Adding workshop content is easy. Just add an environment variable called `WORKSHOP_IDS`. Workshop Id's can be found by viewing the steam content in a browser and taking the end part of the url IE for the following workshop content [https://steamcommunity.com/sharedfiles/filedetails/?id=557591894](https://steamcommunity.com/sharedfiles/filedetails/?id=557591894) the workshop id is 557591894.

### To run it 

1. Ensure the docker-compose.yaml from this example exists on your server.

2. Run it:

```bash
docker-compose up
```
