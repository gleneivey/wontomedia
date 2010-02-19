
scp -P 7822 deploy/wontology-on-a2hosting/install-wontomedia.sh    \
            pkg/wontomedia-*.gem                                   \
                glenivey@www.wontology.org:/home/glenivey
scp -P 7822 config/initializers/wontomedia.rb                      \
                glenivey@www.wontology.org:/home/glenivey/wm.wontomedia.rb
