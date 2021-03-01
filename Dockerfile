FROM python:3.9-slim

# Set global configs
WORKDIR /
RUN export LC_ALL=C
RUN export LC_CTYPE=C
RUN export LC_NUMERIC=C

# Install system dependencies
RUN apt-get update
RUN apt-get install --no-install-recommends -y \
                    build-essential \
                    ffmpeg \
                    libleptonica-dev \
                    libtesseract-dev \
                    libzbar-dev \
                    python3-dev \
                    && \
    apt-get clean

# Install Python dependencies
COPY requirements.txt .
RUN pip install --no-cache-dir -U pip && \
    pip install --no-cache-dir -r requirements.txt

# Copy code and define default command
RUN mkdir /transcriber
COPY src/ /transcriber/src/
RUN mkdir /transcriber/data
RUN mkdir /transcriber/config
RUN mkdir /transcriber/values
RUN mkdir /transcriber/media

RUN useradd -m transcriber
RUN chown -R transcriber /transcriber

USER transcriber
WORKDIR /transcriber
CMD [ "python", "src/main.py" ]
