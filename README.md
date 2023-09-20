# 1. Phiên bản cài đặt để chạy được dự án:

- Ruby: 3.2.2
- Rails: 7.0.7
- MySQL
- Docker compose v3
# 2. Hướng dẫn cài dự án:

## 2.1 Cài đặt config(chỉ chạy lần đầu)

- Tạo config database cho dự án: cp config/database.yml.example config/database.yml
- Chạy lệnh để tạo database: rails db:create
- Bật server: rails s
  Truy cập đường dẫn http://localhost:3000/ hiển thị Rails là thành công

## Sử dụng template: https://dashly-theme.com/task-details.html

## 2.2 sử dụng docker
### 1. Install docker and docker-compose
https://docs.docker.com/engine/installation 
https://docs.docker.com/compose/install
### 2. Setup docker on project
2.1. Copy .env file from source. Then replace the corresponding variables environment to .env file
```cmd
 $ cp .env.example .env
```
2.2. Change content database.yml
```cmd
default: &default
  adapter: mysql2
  encoding: utf8mb4
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: <%= ENV["PROJECT_MANAGEMENT_DATABASE_USER"] %>
  password: <%= ENV["PROJECT_MANAGEMENT_DATABASE_PASSWORD"] %>
  host: <%= ENV["DATABASE_HOST"] %>
  socket: /var/run/mysqld/mysqld.sock

development:
  <<: *default
  database: <%= ENV["PROJECT_MANAGEMENT_DATABASE_NAME"] %>
test:
  <<: *default
  database: project_management_test
production:
  <<: *default
  database: rails_tutorial_production
  username: rails_tutorial
  password: <%= ENV["RAILS_TUTORIAL_DATABASE_PASSWORD"] %>
```
2.2. Build
```cmd
  $ docker-compose build
```
2.3. Start docker
```cmd
$ docker-compose up -d
```
### 3. docker-compose up & docker-compose down
 ```cmd
 $ docker-compose up -d
 $ docker-compose down
 ```
### 4. Access to docker container
4.1. List docker containers
```cmd 
    $ docker ps
```
4.2. Exec a container
  ```cmd
    $ docker exec -it <container_name> bash
  ```
4.3. When change environments in docker-compose.yml file. Run the 2rd command at Step 3. or run the commands as below
```cmd
  # List all volumes
  $ docker volume ls
  # Delete a volume
  $ docker volume rm <volume_name>
```
4.4. To debug
```cmd
  $ docker attach project_web
```