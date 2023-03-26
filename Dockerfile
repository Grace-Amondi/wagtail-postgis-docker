FROM python:3.9-slim-buster
USER root

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Install system dependencies
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
       binutils \
       libproj-dev \
       gdal-bin \
       postgresql-client \
       build-essential \
    && rm -rf /var/lib/apt/lists/*

# create directory for the app user
RUN mkdir -p /home/app

# create the app user
# RUN useradd app
# Set up a working directory
# create the appropriate directories
ENV HOME=/home/app
ENV APP_HOME=/home/app/web
RUN mkdir $APP_HOME
WORKDIR $APP_HOME

# Install Python dependencies
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt

# Copy the application code
COPY . $APP_HOME

# copy entrypoint.sh
COPY entrypoint.sh .

# change to the app user

# # Port used by this container to serve HTTP.
EXPOSE 8000

ENTRYPOINT ["/home/app/web/entrypoint.sh"]