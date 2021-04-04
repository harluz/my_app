FROM ruby:2.6.3

# リポジトリを更新し依存モジュールをインストール
# RUN apt-get update -qq && \
#     apt-get install -y build-essential \
#                        nodejs
RUN curl https://deb.nodesource.com/setup_12.x | bash
RUN curl https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update \
    && apt-get install -y --no-install-recommends nodejs yarn mariadb-client build-essential \
    && apt-get clean && rm -rf /var/lib/apt/lists/*


# ルート直下にmy_appという名前で作業ディレクトリを作成（コンテナ内のアプリケーションディレクトリ）
RUN mkdir /my_app
WORKDIR /my_app

# ホストのGemfileとGemfile.lockをコンテナにコピー
ADD Gemfile /my_app/Gemfile
ADD Gemfile.lock /my_app/Gemfile.lock

# bundle installの実行
RUN bundle install

# ホストのアプリケーションディレクトリ内をすべてコンテナにコピー
ADD . /my_app

# puma.sockを配置するディレクトリを作成
RUN mkdir -p tmp/sockets
