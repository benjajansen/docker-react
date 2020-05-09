# create the builder phase
FROM node:alpine as builder
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
RUN npm run build

# after this, our code has been built and the
# build folder can be found in /app/build.
# this is where our production goodies are

# Now for the run phase
# By just putting in the FROM here, we are terminating
# the previous phase
#
# The copy command does the following:
# copy from the /app/build directory in the builder image
# into the /usr/share/nginx/html folder on the new phase
# If we put our build stuff in this folder on the nginx
# image, it will automatically serve it up for us
FROM nginx
COPY --from=builder /app/build /usr/share/nginx/html

# To run this locally, I first had to run:
# docker build -t benjajansen/docker-react .

# Modified the build command to have a label so I don't have to
# keep copying the id

# This built the image and produced an ID.
# I then used the ID to run:
# docker run -p 8080:80 <image_ID>
# after running this command I went to localhost:8080