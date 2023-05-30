# Specify a base image
FROM node:20

# Specify a working directory in the Docker image
WORKDIR /usr/src/app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install the dependencies in the package.json
RUN npm install

# Copy the rest of the application to the working directory
COPY . .

# Expose port 3000 to the outside
EXPOSE 3000

# Specify the command to run the application
CMD [ "node", "app.js" ]
