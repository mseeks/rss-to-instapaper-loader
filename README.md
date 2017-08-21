# rss-to-instapaper-loader
This watches a list of comma-separated RSS feed URLs and uploads them to Instapaper. See [article](http://msull92.com/posts/rss-to-instapaper-loader/) for reasoning.

The way it works is pretty basic.
You configure it by giving it some environment variables.

- `INSTAPAPER_USERNAME` - is your unique Instapaper username
- `INSTAPAPER_PASSWORD` - is your Instapaper password
- `RSS_FEED_URLS` - is a comma-separated list of RSS/atom feed urls for it to watch

Once booted with these environment variables it will watch your list of feed urls and when it sees an entry it will post to the Instapaper API.
This process happens every five minutes.
**Viola!** you have a RSS feed loader.

Finally, to make sure that it isn't loading the same url into your Instapaper account multiple times it will log the URL to a `urls.log` file that gets checked before sending to Instapaper.

**Note:** The easiest way to launch this tool is to use the `Dockerfile` and `docker-compose.yml` files that are included in this repository.
I host this script on a server that I have on DigitalOcean. It's not necessary to mount the `urls.log` file to the container, but it is recommended so that state is maintained between containers so in case you need to reboot, redeploy, etc. then your Instapaper account won't be flooded with old articles.

*If you have any changes that would be helpful for others, please feel free to fork the repository and make a pull-request so we all get the goodness!*
