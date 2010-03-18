
scp -P 7822 deploy/wontology-on-a2hosting/install-wontomedia.rb    \
            pkg/wontomedia-*.gem                                   \
                glenivey@www.wontology.org:/home/glenivey
# still valid, if commented out, just because we don't need to do every time:
### for deploying adasdaughters.org
#scp -P 7822 -r ../wontology-website-configs/SiteConfigs/ad.*           \
#            ../wontology-website-configs/SiteConfigs/adasdaughters.org \
#                glenivey@www.wontology.org:/home/glenivey/SiteConfigs
### for deploying wontology.org
#scp -P 7822 -r ../wontology-website-configs/SiteConfigs/wm.*           \
#            ../wontology-website-configs/SiteConfigs/wontology.org \
#                glenivey@www.wontology.org:/home/glenivey/SiteConfigs
