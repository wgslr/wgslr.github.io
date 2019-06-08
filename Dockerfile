FROM jekyll/jekyll

WORKDIR /workdir
COPY . .

RUN jekyll build
