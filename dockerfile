FROM ubuntu:22.04
RUN apt update -y
RUN apt install curl systemctl sudo nodejs npm -y
RUN curl -fsSL https://pgp.mongodb.com/server-6.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-6.0.gpg --dearmor
RUN echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-6.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/6.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-6.0.list
RUN apt-get update -y
RUN apt-get install -y mongodb-org
WORKDIR /app
COPY package.json package-lock.json /app
RUN npm install 
COPY . /app
EXPOSE 8080
CMD systemctl start mongod && moongorestore --host=localhost:27017 --db=rickmorty --drop /appqtest/data && npm start