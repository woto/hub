FROM python:3.6.4-stretch

ENV HOME /app
WORKDIR $HOME

COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

COPY . $HOME
ENTRYPOINT ["python"]