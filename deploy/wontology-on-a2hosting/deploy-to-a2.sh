
scp -P 7822 deploy/wontology-on-a2hosting/install-wontomedia.rb    \
            pkg/wontomedia-*.gem                                   \
                glenivey@www.wontology.org:/home/glenivey
# still valid, just don't need to do every time:
#scp -P 7822 config/initializers/wontomedia.rb                      \
#                glenivey@www.wontology.org:/home/glenivey/SiteConfigs/wm.wontomedia.rb
