# ベースイメージを指定
FROM ubuntu:latest

# 作業ディレクトリを設定
WORKDIR /app

# 必要なファイルをコピー
COPY . .

# パッケージをインストール
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip

# アプリケーションを実行
CMD ["python3", "app.py"]
