# ---------- BUILD STAGE ----------
FROM ubuntu:22.04 AS build

# Cài đặt các gói cần thiết
RUN apt-get update && apt-get install -y git curl unzip xz-utils zip libglu1-mesa

# Tải Flutter bản main (dev)
RUN git clone https://github.com/flutter/flutter.git -b main /usr/local/flutter
ENV PATH="/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Kiểm tra phiên bản
RUN flutter --version

WORKDIR /app
COPY pubspec.* ./
RUN flutter pub get

COPY . .
RUN flutter build web --release

# ---------- RUN STAGE ----------
FROM nginx:alpine
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
