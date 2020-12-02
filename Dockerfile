FROM python:3.7-slim
RUN echo "deb http://ftp.us.debian.org/debian/ jessie main" >>/etc/apt/sources.list
RUN apt-get update && apt-get install -y libicu63 libssl1.0.0 libffi-dev libunwind8 python3-dev && pip install --upgrade pip && pip install mssql-scripter
ENTRYPOINT ["mssql-scripter"]
