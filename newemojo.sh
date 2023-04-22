#!/bin/sh

URL="$2"
FILENAME="$1.$3"

wget -O client/src/assets/images/emote/$FILENAME "$URL"
sed -i '$d' client/src/assets/styles/vendor/_emote.scss
echo "&.$1 {
     background-image: url('../images/emote/$FILENAME');
   }
}" >> client/src/assets/styles/vendor/_emote.scss
LNUM=$(grep -n '].filter((v) => !this.recent.includes(v))' client/src/components/emotes.vue | cut -f1 -d:)
sed -i "${LNUM}i \\\t'$1'," client/src/components/emotes.vue
cd client
npm install
npm run build

su - -c "mv /usr/local/share/neko/dist /usr/local/share/neko/dist_$(date +%Y%m%d%H%M); mv $(pwd)/dist /usr/local/share/neko/dist; chown -R root:root /usr/local/share/neko/dist"
